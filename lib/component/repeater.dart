import 'package:flutter/material.dart';
import 'package:thesis_client/controller/infinite_scroll_controller.dart';
import 'package:data_table_2/data_table_2.dart';

class Repeater extends StatefulWidget {
  final List<String> columns;

  const Repeater({super.key, required this.columns});

  @override
  State<Repeater> createState() => _RepeaterState();
}

class _RepeaterState extends State<Repeater> {
  late _RepeaterDataSource _dataSource;
  late ScrollController _scrollController;
  late List<DataColumn> _columns;

  @override
  void initState() {
    super.initState();
    dataTableShowLogs = false;
    _dataSource = _RepeaterDataSource(widget.columns);
    _scrollController = InfiniteScrollController(
        onLoadMore: () => _dataSource.loadIncrementalData());

    _dataSource.addListener(() {
      setState(() {});
    });
    // _dataSource.loadIncrementalData();
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable2(
        // scrollController: _scrollController,
        columnSpacing: 0,
        horizontalMargin: 12,
        bottomMargin: 10,
        minWidth: 1000,
        sortColumnIndex: 0,
        onSelectAll: (val) => setState(() => _dataSource.selectAll(val)),
        columns: _columns,
        rows: List<DataRow>.generate(
            _dataSource.rowCount, (index) => _dataSource.getRow(index)));
  }
}

class _RepeaterDataSource extends DataTableSource {
  final List<String> _columns;
  List<_Row> _data = [];
  int _selectedRowCount = 0;
  bool _hasMoreData = true;

  _RepeaterDataSource(this._columns);

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
    final _Row row = _data[index];
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

  List<_Row> generateFakeData(int nEntries) {
    return List.generate(
        nEntries,
        (index) => _Row(_columns
            .asMap()
            .map((key, value) => MapEntry(value, "Cell $index"))));
  }
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
