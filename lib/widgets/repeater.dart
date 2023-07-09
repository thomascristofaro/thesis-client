import 'package:flutter/material.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/repeater_data_source.dart';
import 'package:data_table_2/data_table_2.dart';

class Repeater extends StatefulWidget {
  final AreaComponent repeater;
  final PageAppController pageCtrl;

  const Repeater({super.key, required this.repeater, required this.pageCtrl});

  @override
  State<Repeater> createState() => _RepeaterState();
}

class _RepeaterState extends State<Repeater> {
  late RepeaterDataSource _dataSource;
  late List<DataColumn> _columns;

  @override
  void initState() {
    dataTableShowLogs = false;
    _dataSource = RepeaterDataSource(widget.repeater.fields, widget.pageCtrl);

    _columns = widget.repeater.fields
        .map((field) => DataColumn(
              label: Text(field.caption),
            ))
        .toList();

    // TODO da capire se disaccoppiare oppure integrare il controller in datasource
    _dataSource.loadData(widget.pageCtrl);
    super.initState();
  }

  @override
  void dispose() {
    _dataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataSource.addContext(context);
    return Expanded(
      child: PaginatedDataTable2(
        minWidth: 1000,
        onSelectAll: (val) => setState(() => _dataSource.selectAll(val)),
        columns: _columns,
        source: _dataSource,
        rowsPerPage: 10,
        // onPageChanged: (pageIndex) {
        //   _dataSource.loadNextPage(_repeaterCtrl.getAllRecords);
        // },
      ),
    );
  }
}
