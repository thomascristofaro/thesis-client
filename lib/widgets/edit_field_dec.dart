import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFieldDec extends StatefulWidget {
  final String label;
  final double value;
  final Function(double)? onChange;
  const EditFieldDec(
      {super.key, required this.label, this.value = 0, this.onChange});

  @override
  State<EditFieldDec> createState() => _EditFieldDecState();
}

class _EditFieldDecState extends State<EditFieldDec> {
  late TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
    ctrl.addListener(() {
      widget.onChange!(double.parse(ctrl.text));
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        // FilteringTextInputFormatter.allow('.')
      ],
      controller: ctrl,
    );
  }
}
