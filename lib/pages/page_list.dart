import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PageList extends StatefulWidget {
  final List<String> columns;

  const PageList({
    Key? key,
    required this.columns,
  }) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  late List<DataColumn> _columns;
  late MyData _data;

  @override
  void initState() {
    super.initState();
    _columns = widget.columns
        .map((column) => DataColumn(
              label: Text(column),
            ))
        .toList();
    _data = MyData(widget.columns);
    _data.loadStaticData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginatedDataTable(
        // header: const Text('My Table'),
        columns: _columns,
        source: _data,
        rowsPerPage: 5,
        showCheckboxColumn: false,
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<String> _columns;
  List<_Row> _data = [];
  int _selectedRowCount = 0;

  MyData(this._columns);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => _selectedRowCount;
  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final _Row row = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (value != null && row.selected != value) {
          _selectedRowCount += value ? 1 : -1;
          assert(_selectedRowCount >= 0);
          row.selected = value;
          // notifyListeners();
          // call handleDataSourceChanged of PaginatedDataTable:
          // void _handleDataSourceChanged() {
          //   setState(() {
          //     _rowCount = widget.source.rowCount;
          //     _rowCountApproximate = widget.source.isRowCountApproximate;
          //     _selectedRowCount = widget.source.selectedRowCount;
          //     _rows.clear();
          //   });
          // }
        }
      },
      cells: row.toDataCell(_columns),
    );
  }

  void loadStaticData() {
    _data = List.generate(
        200,
        (index) => _Row({
              _columns[0]: index,
              _columns[1]: "Item $index",
              _columns[2]: 10000 + index,
            }));
  }
  // Future<void> loadData() async {
  //   final response = await http.get(Uri.parse('https://api.example.com/data'));
  //   if (response.statusCode == 200) {
  //     _data = (jsonDecode(response.body) as List<dynamic>)
  //         .map((dynamic row) => _Row(row as List<dynamic>))
  //         .toList();
  //   }
  // }
}

class _Row {
  final Map<String, dynamic> fields;
  bool selected = false;

  _Row(this.fields);

  List<DataCell> toDataCell(List<String> columns) {
    return columns
        .map((column) => DataCell(Text(fields[column].toString())))
        .toList();
  }
}
