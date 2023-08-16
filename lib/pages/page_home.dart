import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/future_progress.dart';
import 'package:thesis_client/widgets/line_chart.dart';
import 'package:thesis_client/widgets/pie_chart.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  late PageAppController pageCtrl;
  Future<List<Record>> recordList = Future.value([]);

  @override
  void initState() {
    super.initState();
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
    recordList = pageCtrl.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureProgress<List<Record>>(
          future: recordList,
          builder: (List<Record> data) {
            return Column(
                children: pageCtrl.layout.area.map(
              (component) {
                switch (component.type) {
                  case AreaComponentType.piechart:
                    return SizedBox(
                      height: 400,
                      child: PieChartBuilder(
                        component: component,
                        records: data,
                      ),
                    );
                  case AreaComponentType.linechart:
                    return Container(
                      height: 400,
                      child: LineChartBuilder(),
                    );
                  default:
                    return Container();
                }
              },
            ).toList());
          }),
    );
  }
}
