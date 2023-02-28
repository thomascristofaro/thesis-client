import 'package:flutter/material.dart';
// import 'package:first_dynamic_app/json_widget_page.dart';
import 'package:thesis_client/component/table.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Dynamic',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Data Tables'),
          ),
          body: const Repeater(columns: ["Col1", "Col2"])),
      // home: JsonWidgetPage(),
    );
  }
}
