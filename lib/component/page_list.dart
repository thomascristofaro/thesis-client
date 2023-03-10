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
  final _TableDataSource _dataSource = _TableDataSource();
  late List<DataColumn> _columns;
  final DataTableSource _data = MyData();

  @override
  void initState() {
    super.initState();
    // _dataSource.loadData();
    _dataSource.loadStaticData();
    // _columns = widget.columns
    //     .map((column) => DataColumn(
    //           label: Text(column),
    //         ))
    //     .toList();
    _columns = [
      const DataColumn(
        label: Text('Nome'),
      ),
      const DataColumn(
        label: Text('Professione'),
      ),
      const DataColumn(
        label: Text('Età'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        // child: SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
          child: PaginatedDataTable(
            header: const Text('My Table'),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Price'))
            ],
            source: _data,
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 5,
            showCheckboxColumn: true,
          ),
        // ),
    );
  }
}

class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "id": index,
        "title": "Item $index",
        "price": 10000 + index,
      });

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]["title"])),
      DataCell(Text(_data[index]["price"].toString())),
    ]);
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

  void loadStaticData() {
    _rows = [
      _Row(['Thomas', 'Programmatore', '26']),
      _Row(['Domenico', 'Consulente', '28']),
      _Row(['Camilla', 'Programmatore', '25']),
    ];
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
