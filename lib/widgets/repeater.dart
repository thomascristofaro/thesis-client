import 'package:flutter/material.dart';
import 'package:thesis_client/controller/repeater_controller.dart';
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
  late RepeaterController _repeaterCtrl;
  late List<DataColumn> _columns;

  @override
  void initState() {
    dataTableShowLogs = false;
    _dataSource = RepeaterDataSource(widget.columns);
    _repeaterCtrl = RepeaterController(widget.columns);

    _columns = widget.columns
        .map((column) => DataColumn(
              label: Text(column),
            ))
        .toList();

    // TODO da capire se disaccoppiare oppure integrare il controller in datasource
    // credo che integrerò dentro, perchè dataSource ha il controllo di data
    // eliminare il livello del repeater controller?
    _dataSource.loadData(_repeaterCtrl);
    super.initState();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      minWidth: 1000,
      onSelectAll: (val) => setState(() => _dataSource.selectAll(val)),
      columns: _columns,
      source: _dataSource,
      rowsPerPage: 10,
      // onPageChanged: (pageIndex) {
      //   _dataSource.loadNextPage(_repeaterCtrl.getAllRecords);
      // },
    );
  }
}
