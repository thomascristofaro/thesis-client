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
    super.initState();
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // return Stack(children: [
    return Column(children: [
      TitleText(name: pageCtrl.layout.caption),
      ButtonHeader(pageType: PageType.list, buttons: pageCtrl.layout.buttons),
      Repeater(repeater: pageCtrl.layout.getRepeaterComponent())
    ]);
    // Align(
    //   alignment: Alignment.bottomRight,
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(8.0, 8.0, 49.5, 13.0),
    //     child: FloatingActionButton(
    //       mini: true,
    //       onPressed: () {
    //         // Add your onPressed code here!
    //       },
    //       child: const Icon(Icons.add, size: 20),
    //     ),
    //   ),
    // ),
    // ]);
  }
}
