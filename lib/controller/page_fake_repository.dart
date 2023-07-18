import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/virtual_db.dart';

class PageFakeRepository implements IPageRepository {
  final VirtualDB _db;
  final String _pageId;

  PageFakeRepository(this._db, this._pageId);

  Future<void> checkTable() async {
    if (!_db.tableLoaded(_pageId)) {
      String file = '';
      try {
        file = await rootBundle.loadString('assets/$_pageId/page.json');
      } on FlutterError catch (_) {
        file = '{"recordset":null}';
        _db.insertTable(_pageId);
      }
      final Map<String, dynamic> map = await json.decode(file);
      List<dynamic> recordset = map['recordset'];
      List<Map<String, dynamic>> list = [];
      for (var item in recordset) {
        list.add(item);
      }
      for (var l in list) {
        _db.insert(_pageId, l);
      }
    }
  }

  @override
  Future<Layout> getLayout() async {
    final String file =
        await rootBundle.loadString('assets/$_pageId/layout.json');
    final Map<String, dynamic> map = await json.decode(file);
    // await Future.delayed(const Duration(milliseconds: 2000));
    return Layout.fromMap(map);
  }

  @override
  Future<List<Record>> get(List<Filter> filters) async {
    await checkTable();
    var founded =
        await _db.find(_pageId, filters.map((e) => e.toMap()).toList());
    return founded.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<List<Record>> getAll() async {
    await checkTable();
    var founded = await _db.list(_pageId);
    return founded.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<Record> getOne(List<Filter> filters) async {
    await checkTable();
    var founded =
        await _db.findOne(_pageId, filters.map((e) => e.toMap()).toList());
    return Record.fromMap(founded);
  }

  @override
  Future<Record> insert(Record record) async {
    var inserted = await _db.insert(_pageId, record.toMap());
    return Record.fromMap(inserted);
  }

  @override
  Future<void> update(Record record) async {
    _db.update(_pageId, record.toMap());
  }

  @override
  Future<void> delete(List<Filter> filters) async {
    _db.remove(_pageId, filters.map((e) => e.toMap()).toList());
  }
}

class Test {}
