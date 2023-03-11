import 'package:flutter/material.dart';
import 'package:thesis_client/controller/infinite_scroll_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:thesis_client/component/data_table2_scrollup.dart';

class ScrollableTable extends StatefulWidget {
  const ScrollableTable({super.key});

  @override
  State<ScrollableTable> createState() => _ScrollableTableState();
}

class _ScrollableTableState extends State<ScrollableTable> {
  final _ScrollableTableDataSource _dataSource = _ScrollableTableDataSource();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = InfiniteScrollController(onLoadMore: _loadData);
    _loadData();
  }

  Future<void> _loadData() async {
    if (!_dataSource.hasMoreData) {
      return;
    }
    await _dataSource.fetchData();
    setState(() {});
  }

  // negli esempi andare a vedere
  // scroll-up -> ha header fisso, selezionabile e ordinabile, e pulsante per tornare in alto
  @override
  Widget build(BuildContext context) {
    // da capire perchè esce nero, il DataTable2 usciva carino
    // passare il controller: _scrollController
    // quello che bisogna fare è prendere esempio da questa pagina e portarla qui dentro
    return Expanded(child: DataTable2ScrollupDemo());
  }
}

// prendi quello che sta dentro page_list e portalo qui dentro
// dentro page_list ci deve essere solo il riferimento alla tabella
// la sourcetable deve essere qui
class _ScrollableTableDataSource {
  final List<Map<String, dynamic>> data = [];
  int _nextRowIndex = 0;
  bool _hasMoreData = true;

  // Metodo che restituisce il numero di righe nella tabella
  int get rowCount => data.length;

  // Metodo che restituisce i dati per una riga specifica
  DataRow getRow(int index) {
    final row = data[index];
    return DataRow(
      cells: [
        DataCell(Text(row['name'])),
        DataCell(Text('${row['age']}')),
      ],
    );
  }

  // Metodo che carica i dati successivi in base alla posizione dello scroll
  Future<void> fetchData() async {
    await Future.delayed(
        const Duration(milliseconds: 100)); // Simula il caricamento dei dati
    final newData = List.generate(
        20,
        (index) => {
              'name': 'Name ${_nextRowIndex + index}',
              'age': _nextRowIndex + index
            });
    if (newData.isNotEmpty && data.length < 100) {
      data.addAll(newData);
      _nextRowIndex += newData.length;
    } else {
      _hasMoreData = false;
    }
  }

  // Metodo che restituisce true se ci sono ancora dati da caricare
  bool get hasMoreData => _hasMoreData;
}
