import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/title_text.dart';

class LineChartBuilder extends StatefulWidget {
  final AreaComponent component;
  final List<Record> records;

  const LineChartBuilder(
      {super.key, required this.component, required this.records});

  @override
  State<LineChartBuilder> createState() => _LineChartBuilderState();
}

class _LineChartBuilderState extends State<LineChartBuilder> {
  List<Color> gradientColors = [
    const Color(0xFF50E4FF),
    const Color(0xFF2196F3),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.only(
        right: smallSpacing,
        left: smallSpacing,
        bottom: smallSpacing,
      ),
      child: Column(
        children: [
          TitleText(name: widget.component.caption),
          Expanded(
            child: LineChart(
              mainData(),
            ),
          )
        ],
      ),
    ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    var data2 = widget.component.options['x']['data'] as List<dynamic>;
    List<Map<String, dynamic>> data =
        data2.map((element) => element as Map<String, dynamic>).toList();
    Widget text = Text(
        data.firstWhere((e) => e['value'].toDouble() == value,
            orElse: () => {'label': ''})['label'],
        style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    var data2 = widget.component.options['y']['data'] as List<dynamic>;
    List<Map<String, dynamic>> data =
        data2.map((element) => element as Map<String, dynamic>).toList();
    String text = data.firstWhere((e) => e['value'].toDouble() == value,
        orElse: () => {'label': ''})['label'];
    if (text == '') {
      return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: widget.component.options['x']['min'].toDouble(),
      maxX: widget.component.options['x']['max'].toDouble(),
      minY: widget.component.options['y']['min'].toDouble(),
      maxY: widget.component.options['y']['max'].toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (var record in widget.records.where((record) =>
                record.fields.containsKey('x') &&
                record.fields.containsKey('y')))
              FlSpot(
                  record.fields['x'].toDouble(), record.fields['y'].toDouble()),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
