import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/constants.dart';

class PageCard extends StatefulWidget {
  const PageCard({super.key});

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  late PageAppController pageCtrl;
  Future<Record?> record = Future.value(null);
  // questo sarà da spostare dentro il record
  Map<String, TextEditingController> editCtrlMap = {};

  // se fosse un altro tipo di variabile e non solo testo?
  void fromFieldsToEditCtrl(Record record) {
    record.fields.forEach((key, value) {
      var editCtrl = TextEditingController(text: value.toString());
      editCtrl.addListener(() => record.fields[key] = editCtrl.text);
      editCtrlMap[key] = editCtrl;
    });
  }

  @override
  void initState() {
    super.initState();
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
    record = pageCtrl.getOneRecord();
  }

  @override
  Widget build(BuildContext context) {
    // Con questo muore tutto, ma mi piace il suo stile
    // return ComponentGroupDecoration(label: 'Actions', children: <Widget>[
    return Column(children: [
      TitleText(name: pageCtrl.layout.caption),
      ButtonHeader(pageType: PageType.card, buttons: pageCtrl.layout.buttons),
      FutureBuilder<Record?>(
          future: record,
          builder: (BuildContext context, AsyncSnapshot<Record?> snapshot) {
            if (snapshot.hasData) {
              fromFieldsToEditCtrl(snapshot.data as Record);
            }
            return Column(
              children: [
                for (var component in pageCtrl.layout.area)
                  if (component.type == AreaComponentType.group)
                    ComponentGroup(
                      component: component,
                      editCtrlMap: editCtrlMap,
                    )
              ],
            );
          }),
      // component.components
      //     .map((e) =>
      //         ComponentFactory(component: e, pageCtrl: widget.pageCtrl))
      //     .toList()),
    ]);
  }
}

class ComponentGroup extends StatelessWidget {
  const ComponentGroup(
      {super.key, required this.component, required this.editCtrlMap});

  final AreaComponent component;
  final Map<String, TextEditingController> editCtrlMap;

  @override
  Widget build(BuildContext context) {
    // Fully traverse this component group before moving on
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(component.caption,
                style: Theme.of(context).textTheme.titleLarge),
            colDivider,
            for (var field in component.fields)
              TextField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: field.caption,
                ),
                controller: editCtrlMap[field.id],
              )
          ],
        ),
      ),
    );
  }
}
