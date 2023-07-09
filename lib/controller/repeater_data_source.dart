import 'package:flutter/material.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:thesis_client/pages/page.dart' as page;
import 'package:go_router/go_router.dart';

class RepeaterDataSource extends DataTableSource {
  final List<PageField> _fields;
  final PageAppController? pageCtrl;
  BuildContext? context;
  List<Record> _data = [];
  int _selectedRowCount = 0;
  bool hasMoreData = true;

  RepeaterDataSource(this._fields, this.pageCtrl);

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
    return DataRow2.byIndex(
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
      onDoubleTap: () {
        context!.pushNamed('CustomerCard');
        // Navigator.push(context!, MaterialPageRoute(builder: (context) {
        //   List<Filter> filters = [];
        //   String key = 'name';
        //   filters.add(Filter(key, record.fields[key], FilterType.equalTo));
        //   return page.Page(pageId: 'CustomerCard', filters: filters);
        // }));
      },
      cells: toDataCell(record),
    );
  }

  void addContext(BuildContext context) {
    this.context = context;
  }

  void selectAll(bool? checked) {
    for (final row in _data) {
      row.selected = checked ?? false;
    }
    _selectedRowCount = (checked ?? false) ? _data.length : 0;
    notifyListeners();
  }

  List<DataCell> toDataCell(Record record) {
    return _fields
        .map((field) => DataCell(Text(record.fields[field.id].toString())))
        .toList();
  }

  Future<void> loadData(PageAppController pageCtrl) async {
    if (hasMoreData) {
      _data.addAll(await pageCtrl.getAllRecords());
      hasMoreData = false;
      notifyListeners();
    }
  }

  // void syncLoadData() {
  //   _data = List.generate(
  //       200,
  //       (index) => Record(_columns
  //           .asMap()
  //           .map((key, value) => MapEntry(value, "Cell $index"))));
  // }

  // Future<void> loadNextPage(Future<List<Record>> Function() fetchData) async {
  //   if (hasMoreData) {
  //     _data.addAll(await fetchData());
  //     hasMoreData = false;
  //     notifyListeners();
  //   }
  // }
}
