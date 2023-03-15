import 'package:flutter/material.dart';
import 'package:thesis_client/controller/repeater_data_source.dart';
import 'package:data_table_2/data_table_2.dart';

class Repeater extends StatefulWidget {
  final List<String> columns;

  const Repeater({super.key, required this.columns});

  @override
  State<Repeater> createState() => _RepeaterState();
}

class _RepeaterState extends State<Repeater> {
  late RepeaterDataSource _dataSource;
  late List<DataColumn> _columns;

  @override
  void initState() {
    super.initState();
    dataTableShowLogs = false;
    _dataSource = RepeaterDataSource(widget.columns);
    _dataSource.addListener(() {
      setState(() {});
    });
    _dataSource.loadAllData(200);

    _columns = widget.columns
        .map((column) => DataColumn(
              label: Text(column),
            ))
        .toList();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      // scrollController: _scrollController,
      // columnSpacing: 0,
      // horizontalMargin: 12,
      // bottomMargin: 10,
      minWidth: 1000,
      // sortColumnIndex: 0,
      onSelectAll: (val) => setState(() => _dataSource.selectAll(val)),
      columns: _columns,
      source: _dataSource,
    );
  }
}
