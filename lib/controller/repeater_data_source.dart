import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/repeater_controller.dart';

class RepeaterDataSource extends DataTableSource {
  final List<String> _columns;
  List<Record> _data = [];
  int _selectedRowCount = 0;
  bool hasMoreData = true;

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
    final Record record = _data[index];
    return DataRow.byIndex(
      index: index,
      selected: record.selected,
      onSelectChanged: (value) {
        if (value != null && record.selected != value) {
          _selectedRowCount += value ? 1 : -1;
          assert(_selectedRowCount >= 0);
          record.selected = value;
          notifyListeners();
        }
      },
      cells: toDataCell(record, _columns),
    );
  }

  void selectAll(bool? checked) {
    for (final row in _data) {
      row.selected = checked ?? false;
    }
    _selectedRowCount = (checked ?? false) ? _data.length : 0;
    notifyListeners();
  }

  List<DataCell> toDataCell(Record record, List<String> columns) {
    return columns
        .map((column) => DataCell(Text(record.fields[column].toString())))
        .toList();
  }

  Future<void> loadData(RepeaterController repeaterCtrl) async {
    if (hasMoreData) {
      _data.addAll(await repeaterCtrl.getAllRecords());
      hasMoreData = false;
      notifyListeners();
    }
  }

  void syncLoadData() {
    _data = List.generate(
        200,
        (index) => Record(_columns
            .asMap()
            .map((key, value) => MapEntry(value, "Cell $index"))));
  }

  // Future<void> loadNextPage(Future<List<Record>> Function() fetchData) async {
  //   if (hasMoreData) {
  //     _data.addAll(await fetchData());
  //     hasMoreData = false;
  //     notifyListeners();
  //   }
  // }
}
