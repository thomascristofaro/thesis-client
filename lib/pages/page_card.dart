import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/constants.dart';

class PageCard extends StatefulWidget {
  final Layout layout;
  final PageAppController pageCtrl;
  const PageCard({super.key, required this.layout, required this.pageCtrl});

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  Future<Record?> record = Future.value(null);
  // questo sarà da spostare dentro il record
  Map<String, TextEditingController> editCtrl = {};

  // se fosse un altro tipo di variabile e non solo testo?
  void fromFieldsToEditCtrl(Record record) {
    record.fields.forEach((key, value) {
      editCtrl[key] = TextEditingController(text: value.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    record = widget.pageCtrl.getOneRecord();
  }

  @override
  Widget build(BuildContext context) {
    // Con questo muore tutto, ma mi piace il suo stile
    // return ComponentGroupDecoration(label: 'Actions', children: <Widget>[
    return Column(children: [
      TitleText(name: widget.layout.caption),
      ButtonHeader(buttons: widget.layout.buttons),
      FutureBuilder<Record?>(
          future: record,
          builder: (BuildContext context, AsyncSnapshot<Record?> snapshot) {
            if (snapshot.hasData) {
              fromFieldsToEditCtrl(snapshot.data as Record);
            }
            return Column(
              children: [
                for (var component in widget.layout.area)
                  if (component.type == AreaComponentType.group)
                    if (snapshot.hasData)
                      ComponentGroup(
                          component: component, record: snapshot.data as Record)
                    else
                      ComponentGroup(component: component, record: null)
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
      {super.key, required this.component, required this.record});

  final AreaComponent component;
  final Record? record;

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
                controller: record != null
                    ? TextEditingController(text: record!.fields[field.id])
                    : null,
              )
          ],
        ),
      ),
    );
  }
}
