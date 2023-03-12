import 'package:flutter/material.dart';
import 'package:thesis_client/demo/data_sources.dart';

class PaginatedDataTableDemo extends StatefulWidget {
  const PaginatedDataTableDemo({super.key});

  @override
  PaginatedDataTableDemoState createState() => PaginatedDataTableDemoState();
}

class PaginatedDataTableDemoState extends State<PaginatedDataTableDemo> {
  late DessertDataSource _dessertsDataSource;

  @override
  void initState() {
    super.initState();
    _dessertsDataSource = DessertDataSource(context);
  }

  @override
  void dispose() {
    _dessertsDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      onSelectAll: (val) => setState(() => _dessertsDataSource.selectAll(val)),
      columns: const [
        DataColumn(
          label: Text('Desert'),
        ),
        DataColumn(
          label: Text('Calories'),
        ),
        DataColumn(
          label: Text('Fat (gm)'),
        ),
        DataColumn(
          label: Text('Carbs (gm)'),
        ),
        DataColumn(
          label: Text('Protein (gm)'),
        ),
        DataColumn(
          label: Text('Sodium (mg)'),
        ),
        DataColumn(
          label: Text('Calcium (%)'),
        ),
        DataColumn(
          label: Text('Iron (%)'),
        ),
      ],
      source: _dessertsDataSource,
    );
  }
}
