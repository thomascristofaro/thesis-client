import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFieldInt extends StatefulWidget {
  final String label;
  final int value;
  final Function(int)? onChange;
  const EditFieldInt(
      {super.key, required this.label, this.value = 0, this.onChange});

  @override
  State<EditFieldInt> createState() => _EditFieldIntState();
}

class _EditFieldIntState extends State<EditFieldInt> {
  late TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
    ctrl.addListener(() {
      widget.onChange!(int.parse(ctrl.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    ctrl.text = widget.value.toString();
    return TextField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: widget.label,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      controller: ctrl,
    );
  }
}
