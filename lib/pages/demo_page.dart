import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  final Widget internal;
  const DemoPage({Key? key, required this.internal}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: widget.internal);
  }
}
