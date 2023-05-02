import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/virtual_db.dart';

class PageFakeRepository implements IPageRepository {
  final VirtualDB _db;
  final String _pageId;

  PageFakeRepository(this._db, this._pageId);

  Future<void> loadPageFromFile() async {}

  Future<void> loadDataFromFile() async {
    final String file =
        await rootBundle.loadString('assets/page/$_pageId/page_data.json');
    final Map<String, dynamic> map = await json.decode(file);
    List<Map<String, dynamic>> list = map['recordset'];
    list.map((e) async {
      await _db.insert(_pageId, e);
    });
  }

  @override
  Future<Layout> getLayout() async {
    final String file =
        await rootBundle.loadString('assets/page/$_pageId/page_layout.json');
    final Map<String, dynamic> map = await json.decode(file);
    return Layout.fromMap(map);
  }

  @override
  Future<List<Record>> get(List<Filter> filters) async {
    var founded =
        await _db.find(_pageId, filters.map((e) => e.toMap()).toList());
    return founded.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<List<Record>> getAll() async {
    var founded = await _db.list(_pageId);
    return founded.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<Record> getOne(List<Filter> filters) async {
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
