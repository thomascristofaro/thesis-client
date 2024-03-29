import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/pages/page_home.dart';
import 'package:thesis_client/pages/page_card.dart';
import 'package:thesis_client/pages/page_list.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/pages/part_list.dart';
import 'package:thesis_client/widgets/future_progress.dart';

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  Future<Layout>? layout;

  @override
  void initState() {
    super.initState();
    layout = Provider.of<PageAppController>(context, listen: false).getLayout();
  }

  @override
  Widget build(BuildContext context) {
    return FutureProgress<Layout>(
      future: layout,
      builder: (Layout layout) {
        switch (layout.type) {
          case PageType.home:
            return const PageHome();
          case PageType.list:
            return const PageList();
          case PageType.card:
            return const PageCard();
          case PageType.partlist:
            return const PartList();
          default:
            throw Exception('Page type not supported');
        }
      },
    );
  }
}
