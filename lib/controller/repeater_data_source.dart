import 'package:flutter/material.dart';

class RepeaterDataSource extends DataTableSource {
  final List<String> _columns;
  List<Row> _data = [];
  int _selectedRowCount = 0;
  bool _hasMoreData = true;

  RepeaterDataSource(this._columns);

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => _selectedRowCount;
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _data.length) throw 'index > _data.length';
    final Row row = _data[index];
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
      cells: row.toDataCell(_columns),
    );
  }

  void selectAll(bool? checked) {
    for (final row in _data) {
      row.selected = checked ?? false;
    }
    _selectedRowCount = (checked ?? false) ? _data.length : 0;
    notifyListeners();
  }

  bool get hasMoreData => _hasMoreData;

  Future<void> loadIncrementalData() async {
    if (!hasMoreData) return;
    await Future.delayed(const Duration(milliseconds: 100));
    final newData = generateFakeData(20);

    if (newData.isNotEmpty && _data.length < 100) {
      _data.addAll(newData);
    } else {
      _hasMoreData = false;
    }
    notifyListeners();
  }

  Future<void> loadAllData(int nEntries) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _hasMoreData = false;
    _data = generateFakeData(nEntries);
    notifyListeners();
  }
// Future<void> loadData() async {
//   final response = await http.get(Uri.parse('https://api.example.com/data'));
//   if (response.statusCode == 200) {
//     _data = (jsonDecode(response.body) as List<dynamic>)
//         .map((dynamic row) => _Row(row as List<dynamic>))
//         .toList();
//   }
// }

  List<Row> generateFakeData(int nEntries) {
    return List.generate(
        nEntries,
        (index) => Row(_columns
            .asMap()
            .map((key, value) => MapEntry(value, "Cell $index"))));
  }
}

class Row {
  final Map<String, dynamic> fields;
  bool selected = false;

  Row(this.fields);

  List<DataCell> toDataCell(List<String> columns) {
    return columns
        .map((column) => DataCell(Text(fields[column].toString())))
        .toList();
  }
}
