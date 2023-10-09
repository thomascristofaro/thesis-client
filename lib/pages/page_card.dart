import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/edit_field_dec.dart';
import 'package:thesis_client/widgets/edit_field_int.dart';
import 'package:thesis_client/widgets/button_header.dart';
import 'package:thesis_client/widgets/edit_field_text.dart';
import 'package:thesis_client/widgets/title_text.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/pages/page.dart' as page;

class PageCard extends StatefulWidget {
  const PageCard({super.key});

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  late PageAppController pageCtrl;
  Future<Record?> record = Future.value(null);

  void refreshPage() {
    setState(() {
      record = pageCtrl.getOneRecord();
    });
  }

  @override
  void initState() {
    super.initState();
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
    pageCtrl.setRefreshCallback(refreshPage);
    record = pageCtrl.getOneRecord();
  }

  @override
  Widget build(BuildContext context) {
    // Con questo muore tutto, ma mi piace il suo stile
    // return ComponentGroupDecoration(label: 'Actions', children: <Widget>[
    return Column(children: [
      TitleText(name: pageCtrl.layout.caption),
      ButtonHeader(
        pageType: PageType.card,
        buttons: pageCtrl.layout.buttons,
        insertBtn: pageCtrl.currentFilters.isEmpty,
      ),
      FutureBuilder<Record?>(
          future: record,
          builder: (BuildContext context, AsyncSnapshot<Record?> snapshot) {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var component in pageCtrl.layout.area)
                      if (component.type == AreaComponentType.group)
                        ComponentGroup(
                          component: component,
                          record: snapshot.hasData ? snapshot.data : null,
                        )
                      else if (component.type == AreaComponentType.subpage)
                        if (snapshot.hasData)
                          SizedBox(
                            height: component.options['height'].toDouble(),
                            child: ChangeNotifierProvider(
                              create: (context) => PageAppController(
                                pageId: component.options['page_id'] as String,
                                url: pageCtrl.url,
                                currentFilters: component.createSubpageFilters(
                                    snapshot.data as Record),
                              ),
                              child: const page.Page(),
                            ),
                          )
                  ],
                ),
              ),
            );
          }),
    ]);
  }
}

class ComponentGroup extends StatelessWidget {
  const ComponentGroup({super.key, required this.component, this.record});

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
              if (field.type == FieldType.int)
                EditFieldInt(
                    label: field.caption,
                    value: record != null ? record!.fields[field.id] : 0,
                    onChange: (value) {
                      if (record != null) {
                        record!.fields[field.id] = value;
                      }
                    })
              else if (field.type == FieldType.text)
                EditFieldText(
                    label: field.caption,
                    value: record != null ? record!.fields[field.id] : "",
                    onChange: (value) {
                      if (record != null) {
                        record!.fields[field.id] = value;
                      }
                    })
              else if (field.type == FieldType.decimal)
                EditFieldDec(
                    label: field.caption,
                    value: record != null ? record!.fields[field.id] : 0,
                    onChange: (value) {
                      if (record != null) {
                        record!.fields[field.id] = value;
                      }
                    })
          ],
        ),
      ),
    );
  }
}
