import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';

class PageFakeRepository implements IPageRepository {
  @override
  Future<Layout> getLayout(String pageId) async {
    final String file =
        await rootBundle.loadString('assets/page/$pageId/page_layout.json');
    final Map<String, dynamic> map = await json.decode(file);
    return Layout.fromMap(map);
  }

  @override
  Future<void> delete(String pageId, Map<String, dynamic> filter) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Record>> get(String pageId, Map<String, dynamic> filter) async {
    // implementare il filtro
    final String file =
        await rootBundle.loadString('assets/page/$pageId/page_data.json');
    final Map<String, dynamic> map = await json.decode(file);
    List<Map<String, dynamic>> list = map['recordset'];
    return list.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<List<Record>> getAll(String pageId) async {
    final String file =
        await rootBundle.loadString('assets/page/$pageId/page_data.json');
    final Map<String, dynamic> map = await json.decode(file);
    List<Map<String, dynamic>> list = map['recordset'];
    return list.map((e) => Record.fromMap(e)).toList();
  }

  @override
  Future<Record?> getOne(String pageId, Map<String, dynamic> filter) async {
    // implementare il filtro e prendere quello che trovi
    final String file =
        await rootBundle.loadString('assets/page/$pageId/page_data.json');
    final Map<String, dynamic> map = await json.decode(file);
    List<Map<String, dynamic>> list = map['recordset'];
    return list
        .map((e) => Record.fromMap(e))
        .toList()
        .first; // da prendere quello giusto
  }

  @override
  Future<void> insert(String pageId, Record record) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<void> update(String pageId, Record record) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
