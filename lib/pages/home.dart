import 'package:flutter/material.dart';
import 'package:thesis_client/widgets/pie_chart.dart';
import 'package:thesis_client/widgets/line_chart.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // si deve comporre come le altre pagine ma per tipo home
    return const Column(
      children: [
        Expanded(
          child: PieChartSample2(),
        ),
        Expanded(
          child: LineChartSample2(),
        )
      ],
    );
  }
}
