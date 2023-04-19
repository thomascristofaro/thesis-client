import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';

class PageCard extends StatefulWidget {
  final Layout layout;
  final PageAppController pageCtrl;
  final Map<String, dynamic> filter;
  const PageCard(
      {super.key,
      required this.layout,
      required this.pageCtrl,
      this.filter = const {}});

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  Future<Record?> record = Future.value(null);

  @override
  void initState() {
    super.initState();
    record = widget.pageCtrl.getOneRecord(widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    // Con questo muore tutto, ma mi piace il suo stile
    // return ComponentGroupDecoration(label: 'Actions', children: <Widget>[
    return Expanded(
        child: Column(children: [
      TitleText(name: widget.layout.caption),
      ButtonHeader(buttons: widget.layout.buttons),
      for (var component in widget.layout.area)
        if (component.type == AreaComponentType.group)
          ComponentGroupDecoration(
              label: component.caption,
              children: component.components
                  .map((e) =>
                      ComponentFactory(component: e, pageCtrl: widget.pageCtrl))
                  .toList()),
    ]));
  }
}
