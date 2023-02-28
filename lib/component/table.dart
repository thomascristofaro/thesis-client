import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repeater extends StatefulWidget {
  final List<String> columns;

  const Repeater({
    Key? key,
    required this.columns,
  }) : super(key: key);

  @override
  State<Repeater> createState() => _RepeaterState();
}

class _RepeaterState extends State<Repeater> {
  final _TableDataSource _dataSource = _TableDataSource();
  late List<DataColumn> _columns;

  @override
  void initState() {
    super.initState();
    _dataSource.loadData();
    _columns = widget.columns
        .map((column) => DataColumn(
              label: Text(column),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: PaginatedDataTable(
        columns: _columns,
        source: _dataSource,
        rowsPerPage: 10,
      ),
    );
  }
}

class _TableDataSource extends DataTableSource {
  List<_Row> _rows = [];
  int _selectedRowCount = 0;

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) {
      return null;
    }
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (value != null && row.selected != value) {
          _selectedRowCount += value ? 1 : -1;
          assert(_selectedRowCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: row.toDataCell(),
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedRowCount;

  void selectAll(bool? isAllChecked) {
    _selectedRowCount = isAllChecked! ? rowCount : 0;
    notifyListeners();
  }

  Future<void> loadData() async {
    final response = await http.get(Uri.parse('https://api.example.com/data'));
    if (response.statusCode == 200) {
      _rows = (jsonDecode(response.body) as List<dynamic>)
          .map((dynamic row) => _Row(row as List<dynamic>))
          .toList();
    }
  }
}

class _Row {
  final List<dynamic> fields;
  bool selected = false;

  _Row(this.fields);

  List<DataCell> toDataCell() {
    return fields.map((element) => DataCell(Text(element.toString()))).toList();
  }
}
