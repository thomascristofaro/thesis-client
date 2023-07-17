import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/repeater_data_source.dart';
import 'package:data_table_2/data_table_2.dart';

class Repeater extends StatefulWidget {
  final AreaComponent repeater;
  // final Function openCard;

  const Repeater({super.key, required this.repeater});

  @override
  State<Repeater> createState() => _RepeaterState();
}

class _RepeaterState extends State<Repeater> {
  late RepeaterDataSource _dataSource;
  late List<DataColumn> _columns;
  late PageAppController pageCtrl;

  void openCard(List<Filter> filters) {
    if (pageCtrl.layout.cardPageId == '') throw Exception('Card not available');
    context.pushNamed(pageCtrl.layout.cardPageId, extra: filters);
  }

  @override
  void initState() {
    dataTableShowLogs = false;
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
    _dataSource = RepeaterDataSource(
        fields: widget.repeater.fields, onDoubleTap: openCard);

    _columns = widget.repeater.fields
        .map((field) => DataColumn(
              label: Text(field.caption),
            ))
        .toList();

    // TODO da capire se disaccoppiare oppure integrare il controller in datasource
    _dataSource.loadData(pageCtrl);
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
