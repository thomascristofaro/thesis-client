import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';

class PageList extends StatefulWidget {
  final String pageId;
  const PageList({super.key, required this.pageId});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  // questi mi arrivano dallo schema della pagina
  final String _title = "Page list test";
  late PageAppController _pageController;
  Future<Layout>? layout;
  List<String> columns = [];
  List<String> buttons = [];

  @override
  void initState() {
    _pageController = PageAppController(widget.pageId);
    layout =
        _pageController.getLayout(); // utilizzare questo nel future builder
    columns = List.generate(10, (index) => "Column $index");
    buttons = List.generate(10, (index) => "Button $index");
    super.initState();
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
    return Expanded(
        child: FutureBuilder<Layout>(
      future: layout,
      builder: (BuildContext context, AsyncSnapshot<Layout> snapshot) {
        if (snapshot.hasData) {
          return Column(children: [
            TitleText(name: _title),
            ButtonHeader(buttons: snapshot.data!.buttons),
            Repeater(columns: snapshot.data.buttons),
          ]);
        } else {
          return Column(
            children: const [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ],
          );
        }
      },
    ));
  }
}
