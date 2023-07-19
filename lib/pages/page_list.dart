import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';

class PageList extends StatefulWidget {
  const PageList({super.key});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  late PageAppController pageCtrl;

  @override
  void initState() {
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TitleText(name: pageCtrl.layout.caption),
      ButtonHeader(pageType: PageType.list, buttons: pageCtrl.layout.buttons),
      Repeater(repeater: pageCtrl.layout.getRepeaterComponent()),
    ]);
  }
}
