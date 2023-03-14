import 'package:flutter/material.dart';
import 'package:thesis_client/demo/data_sources.dart';

class PaginatedDataTableDemo extends StatefulWidget {
  const PaginatedDataTableDemo({super.key});

  @override
  PaginatedDataTableDemoState createState() => PaginatedDataTableDemoState();
}

class PaginatedDataTableDemoState extends State<PaginatedDataTableDemo> {
  late DessertDataSource _dessertsDataSource;
  late List<DataColumn> _columns;

  @override
  void initState() {
    super.initState();
    _dessertsDataSource = DessertDataSource(context);
    _columns = List.generate(
      8,
      (index) => DataColumn(
        label: Text("Col $index"),
      ),
    );
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
      columns: _columns,
      source: _dessertsDataSource,
    );
  }
}
