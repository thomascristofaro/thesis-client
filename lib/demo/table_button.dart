import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class TableButton extends StatefulWidget {
  const TableButton({super.key});

  @override
  State<TableButton> createState() => _TableButtonState();
}

class _TableButtonState extends State<TableButton> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableButtonHeader(),
      Expanded(
        child: TableButtonData(),
      ),
    ]);
  }
}

class TableButtonHeader extends StatefulWidget {
  const TableButtonHeader({super.key});

  @override
  State<TableButtonHeader> createState() => _TableButtonHeaderState();
}

class _TableButtonHeaderState extends State<TableButtonHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: Text('Button 1'),
            onPressed: () {},
          ),
          TextButton(
            child: Text('Button 2'),
            onPressed: () {},
          ),
          TextButton(
            child: Text('Button 3'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class TableButtonData extends StatefulWidget {
  const TableButtonData({super.key});

  @override
  State<TableButtonData> createState() => _TableButtonDataState();
}

class _TableButtonDataState extends State<TableButtonData> {
  final List<Map<String, dynamic>> _dataList = List.generate(
    100,
    (index) => {
      'name': 'name',
      'email': 'email',
      'phone': 'phoneNumber',
    },
  );

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      // header: Text('My Data'),
      columns: [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Phone')),
      ],
      source: _DataSource(_dataList),
      rowsPerPage: _rowsPerPage,
    );
  }
}

class _DataSource extends DataTableSource {
  final List<Map<String, dynamic>> _dataList;

  _DataSource(this._dataList);

  @override
  DataRow getRow(int index) {
    final data = _dataList[index];
    return DataRow(cells: [
      DataCell(Text(data['name'])),
      DataCell(Text(data['email'])),
      DataCell(Text(data['phone'])),
    ]);
  }

  @override
  int get rowCount => _dataList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
