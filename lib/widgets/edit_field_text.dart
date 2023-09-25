import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFieldText extends StatefulWidget {
  final String label;
  final String value;
  final Function(String)? onChange;
  const EditFieldText(
      {super.key, required this.label, this.value = "", this.onChange});

  @override
  State<EditFieldText> createState() => _EditFieldTextState();
}

class _EditFieldTextState extends State<EditFieldText> {
  late TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
    ctrl.addListener(() {
      widget.onChange!(ctrl.text);
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
      keyboardType: TextInputType.text,
      controller: ctrl,
    );
  }
}
