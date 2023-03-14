import 'package:flutter/material.dart';
import 'package:thesis_client/demo/data_sources.dart';
import 'package:data_table_2/data_table_2.dart';

class PaginatedDataTable2Demo extends StatefulWidget {
  const PaginatedDataTable2Demo({super.key});

  @override
  PaginatedDataTable2DemoState createState() => PaginatedDataTable2DemoState();
}

class PaginatedDataTable2DemoState extends State<PaginatedDataTable2Demo> {
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
    return PaginatedDataTable2(
      onSelectAll: (val) => setState(() => _dessertsDataSource.selectAll(val)),
      columns: _columns,
      source: _dessertsDataSource,
    );
  }
}
