import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';

class PageList extends StatefulWidget {
  final Layout layout;
  final PageAppController pageCtrl;
  const PageList({super.key, required this.layout, required this.pageCtrl});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  @override
  Widget build(BuildContext context) {
    // Con questo muore tutto, ma mi piace il suo stile
    // return ComponentGroupDecoration(label: 'Actions', children: <Widget>[
    return Expanded(
        child: Column(children: [
      TitleText(name: widget.layout.caption),
      ButtonHeader(buttons: widget.layout.buttons),
      Repeater(
          repeater: widget.layout.area.firstWhere(
              (element) => element.type == AreaComponentType.repeater),
          pageCtrl: widget.pageCtrl),
    ]));
  }
}
