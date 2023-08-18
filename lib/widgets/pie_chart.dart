import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/widgets/title_text.dart';

class PieChartModel {
  final String label;
  final double value;
  late Color? color;
  static const List<Color> colorSections = [
    Color(0xFF2196F3),
    Color(0xFFFFC300),
    Color(0xFFFF683B),
    Color(0xFF3BFF49),
    Color(0xFF6E1BFF),
    Color(0xFFFF3AF2),
    Color(0xFFE80054),
    Color(0xFF50E4FF)
  ];
  static int colorCounter = 0;

  PieChartModel(this.label, this.value, {this.color}) {
    color ??= colorSections[colorCounter++];
  }
}

class PieChartBuilder extends StatefulWidget {
  final AreaComponent component;
  final List<Record> records;

  const PieChartBuilder(
      {super.key, required this.component, required this.records});

  @override
  State<PieChartBuilder> createState() => _PieChartBuilderState();
}

class _PieChartBuilderState extends State<PieChartBuilder> {
  int touchedIndex = -1;
  List<PieChartModel> pieChartModel = [];

  @override
  void initState() {
    super.initState();
    PieChartModel.colorCounter = 0;
    pieChartModel = widget.records
        .where((record) =>
            record.fields.containsKey('label') &&
            record.fields.containsKey('value'))
        .map((record) => PieChartModel(
            record.fields['label'], record.fields['value'].toDouble()))
        .toList();
  }

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
              child: Row(children: [
            Expanded(
              child: PieChart(
                mainData(),
              ),
            ),
            buildLegend(),
          ])),
        ],
      ),
    ));
  }

  PieChartData mainData() {
    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      borderData: FlBorderData(
        show: false,
      ),
      sectionsSpace: 0,
      centerSpaceRadius: 40,
      sections: buildSections(),
    );
  }

  List<PieChartSectionData> buildSections() {
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    return pieChartModel.asMap().entries.map((e) {
      final isTouched = e.key == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: e.value.color,
        value: e.value.value,
        title: '${e.value.value}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: shadows,
        ),
      );
    }).toList();
  }

  Column buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var model in pieChartModel)
          Indicator(
            color: model.color!,
            text: model.label,
            isSquare: true,
          ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
