import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';

class PageList extends StatefulWidget {
  const PageList({super.key});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  // questi mi arrivano dallo schema della pagina
  final String _title = "Page list test";
  List<String> columns = [];
  List<String> buttons = [];

  @override
  void initState() {
    columns = List.generate(10, (index) => "Column $index");
    buttons = List.generate(10, (index) => "Button $index");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO prima del repeater devo mettere la barra dei button
    // NON DEVO METTERLI NEL REPEATER, sono collegati alla pagina
    // una pagina ha un solo repeater
    return Expanded(
        child: Column(children: [
      TitleText(name: _title),
      ButtonHeader(buttons: buttons),
      Repeater(columns: columns),
    ]));
  }
}
