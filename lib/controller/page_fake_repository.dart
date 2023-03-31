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

  Future<void> loadDataFromFile() async {
    final String file =
        await rootBundle.loadString('assets/page/$_pageId/page_data.json');
    final Map<String, dynamic> map = await json.decode(file);
    List<Map<String, dynamic>> list = map['recordset'];
    list.map((e) async {
      await _db.insert(e);
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
  Future<List<Record>> get(Map<String, dynamic> filter) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Record>> getAll() async {
    var list = await _db.list();
    return list.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<Record?> getOne(Map<String, dynamic> filter) async {
    var record = await _db.findOne(filter);
    return record != null ? Record.fromMap(record) : null;
  }

  @override
  Future<void> insert(Record record) async {
    await _db.insert(record.toMap());
  }

  @override
  Future<void> update(Record record) async {
    await _db.update(record.toMap());
  }

  @override
  Future<void> delete(Map<String, dynamic> filter) async {
    await _db.remove(filter);
  }
}
