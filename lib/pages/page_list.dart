import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/repeater.dart';

class PageList extends StatefulWidget {
  const PageList({super.key});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  List<String> columns = [];

  @override
  void initState() {
    columns = List.generate(10, (index) => "Column $index");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO prima del repeater devo mettere la barra dei button
    // NON DEVO METTERLI NEL REPEATER, sono collegati alla pagina
    // una pagina ha un solo repeater
    return Expanded(
        child: Column(children: [
      ButtonHeader(),
      Expanded(
        child: Repeater(
          columns: columns,
        ),
      ),
    ]));
  }
}

class ButtonHeader extends StatefulWidget {
  const ButtonHeader({super.key});

  @override
  State<ButtonHeader> createState() => _ButtonHeaderState();
}

class _ButtonHeaderState extends State<ButtonHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text('Button 1'),
            onPressed: () {},
          ),
          TextButton(
            child: Text('Button 2'),
            onPressed: () {},
          ),
          TextButton(
            child: Text('Button 3'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
