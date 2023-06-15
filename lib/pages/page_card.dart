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
            return Column(
              children: [
                for (var component in widget.layout.area)
                  if (component.type == AreaComponentType.group)
                    if (snapshot.hasData)
                      ComponentGroup(
                          label: component.caption,
                          record: snapshot.data as Record,
                          children: [])
                    else
                      ComponentGroup(
                          label: component.caption, record: null, children: [])
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
      {super.key,
      required this.label,
      required this.record,
      required this.children});

  final String label;
  final Record? record;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Fully traverse this component group before moving on
    return FocusTraversalGroup(
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              children: [
                Text(label, style: Theme.of(context).textTheme.titleLarge),
                colDivider,
                ...children
              ],
            ),
          ),
        ),
      ),
    );
  }
}
