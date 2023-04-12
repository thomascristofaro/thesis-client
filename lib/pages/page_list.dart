import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/widgets/future_progress.dart';

class PageList extends StatefulWidget {
  final String pageId;
  const PageList({super.key, required this.pageId});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  late PageAppController _pageController;
  Future<Layout>? layout;

  @override
  void initState() {
    super.initState();
    _pageController = PageAppController(widget.pageId);
    layout =
        _pageController.getLayout(); // utilizzare questo nel future builder
  }

  @override
  Widget build(BuildContext context) {
    // TODO prima del repeater devo mettere la barra dei button
    // NON DEVO METTERLI NEL REPEATER, sono collegati alla pagina
    // una pagina ha un solo repeater

    // Con questo muore tutto, ma mi piace il suo stile
    // return ComponentGroupDecoration(label: 'Actions', children: <Widget>[
    //   TitleText(name: _title),
    //   ButtonHeader(buttons: buttons),
    //   Repeater(columns: columns),
    // ]);
    return FutureProgress<Layout>(
      future: layout,
      builder: (Layout layout) {
        return Expanded(
            child: Column(children: [
          TitleText(name: layout.caption),
          ButtonHeader(buttons: layout.buttons),
          for (var component in layout.area)
            if (component.type == AreaComponentType.repeater)
              Repeater(repeater: component, pageCtrl: _pageController)
          // else if (component.type == AreaComponentType.group)
          //   Group(component: component)
        ]));
      },
    );
  }
}
