import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:thesis_client/page/error_page.dart';
import 'package:thesis_client/page/progress_page.dart';

/* 
Devi caricare il JSON da API passata da costruttore
*/

class JsonWidgetPage extends StatefulWidget {
  const JsonWidgetPage({super.key});

  @override
  State<JsonWidgetPage> createState() => _JsonWidgetPageState();
}

class _JsonWidgetPageState extends State<JsonWidgetPage> {
  Future<Map> loadJson() async {
    final String response =
        await rootBundle.loadString('assets/pages/sample.json');
    final data = await json.decode(response);
    return data;
  }

  late dynamic _future;
  var registry = JsonWidgetRegistry.instance;

  @override
  void initState() {
    super.initState();
    // _future = Future.delayed(const Duration(seconds: 2), loadJson);
    _future = loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          var widget =
              JsonWidgetData.fromDynamic(snapshot.data, registry: registry);
          return widget!.build(context: context);
        } else if (snapshot.hasError) {
          return ErrorPage(
            error: snapshot.error.toString(),
          );
        } else {
          return const ProgressPage();
        }
      },
    );
  }
}
