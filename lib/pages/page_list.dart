import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/repeater.dart';

class PageList extends StatefulWidget {
  const PageList({Key? key}) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
            Repeater(columns: List.generate(10, (index) => "Column $index")));
  }
}
