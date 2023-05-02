import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:thesis_client/controller/record.dart';

class VirtualDB {
  Map<String, List<Record>> _database;
  Map<String, int> _id;
  Map<String, List<String>> _keys;
  static final VirtualDB _db = VirtualDB._privateConstructor();

  VirtualDB._privateConstructor()
      : _database = {},
        _id = {},
        _keys = {};

  factory VirtualDB() {
    return _db;
  }

  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> jsonRec) async {
    if (!_database.containsKey(table)) _database.addAll({table: []});
    if (!_id.containsKey(table)) _id.addAll({table: 0});
    Record record = Record.fromMap(jsonRec);
    _id[table] = _id[table]! + 1;
    record.fields['id'] = _id[table];
    _database[table]!.add(record);
    return record.toMap();
  }

  Future<void> remove(
      String table, List<Map<String, dynamic>> jsonFilters) async {
    if (!_database.containsKey(table)) throw 'Missing Table';
    List<Filter> filters = jsonFilters.map((e) => Filter.fromMap(e)).toList();
    _database[table]!.removeWhere((record) => checkFilters(record, filters));
  }

  Future<void> update(String table, Map<String, dynamic> jsonRec) async {
    if (!_database.containsKey(table)) throw 'Missing Table';
    Record updatedRecord = Record.fromMap(jsonRec);
    int i = _database[table]!.indexWhere((record) =>
        record.fields['id'] ==
        updatedRecord.fields['id']); // da cambiare con le chiavi
    _database[table]![i] = updatedRecord;
  }

  Future<List<Map<String, dynamic>>> list(String table) async {
    if (!_database.containsKey(table)) throw 'Missing Table';
    return _database[table]!.map((e) => e.toMap()).toList();
  }

  Future<Map<String, dynamic>> findOne(
      String table, List<Map<String, dynamic>> jsonFilters) async {
    if (!_database.containsKey(table)) throw 'Missing Table';
    List<Filter> filters = jsonFilters.map((e) => Filter.fromMap(e)).toList();
    return _database[table]!
        .firstWhere((record) => checkFilters(record, filters),
            orElse: () => throw 'Record not found')
        .toMap();
  }

  Future<List<Map<String, dynamic>>> find(
      String table, List<Map<String, dynamic>> jsonFilters) async {
    if (!_database.containsKey(table)) throw 'Missing Table';
    List<Filter> filters = jsonFilters.map((e) => Filter.fromMap(e)).toList();
    return _database[table]!
        .where((record) => checkFilters(record, filters))
        .map((e) => e.toMap())
        .toList();
  }

  bool checkFilters(Record record, List<Filter> filters) {
    for (var filter in filters) {
      if (!filter.checkFilter(record)) return false;
    }
    return true;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}
