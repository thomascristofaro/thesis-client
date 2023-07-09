import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/pages/home.dart';
import 'package:thesis_client/pages/page_card.dart';
import 'package:thesis_client/pages/page_list.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/widgets/future_progress.dart';

class Page extends StatefulWidget {
  final String pageId;
  final List<Filter> filters;
  const Page({super.key, required this.pageId, this.filters = const []});

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
    _pageController.addFilterFromList(widget.filters);
    layout = _pageController.getLayout();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProgress<Layout>(
      future: layout,
      builder: (Layout layout) {
        switch (layout.type) {
          case PageType.home:
            // TODO prima o poi sarà da implementare come tipologia di pagina dal backend
            return const Home();
          case PageType.list:
            return PageList(layout: layout, pageCtrl: _pageController);
          case PageType.card:
            return PageCard(layout: layout, pageCtrl: _pageController);
          default:
            throw Exception('Page type not supported');
        }
      },
    );
  }
}
