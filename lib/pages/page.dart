import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/pages/page_list.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/widgets/future_progress.dart';

class Page extends StatefulWidget {
  final String pageId;
  const Page({super.key, required this.pageId});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late PageAppController _pageController;
  Future<Layout>? layout;

  @override
  void initState() {
    super.initState();
    _pageController = PageAppController(widget.pageId);
    layout = _pageController.getLayout();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProgress<Layout>(
      future: layout,
      builder: (Layout layout) {
        if (layout.type == PageType.list) {
          return PageList(layout: layout, pageCtrl: _pageController);
        }
        if (layout.type == PageType.card) {
          return PageCard(layout: layout, pageCtrl: _pageController);
        }
        throw Exception('Page type not supported');
      },
    );
  }
}
