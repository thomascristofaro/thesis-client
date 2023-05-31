import 'dart:convert';

import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:http/http.dart' as http;

class PageAPIRepository implements IPageRepository {
  static const String URL =
      'https://ir44yj26uh.execute-api.us-east-1.amazonaws.com/';
  final String _pageId;

  PageAPIRepository(this._pageId);

  @override
  Future<Layout> getLayout() async {
    final response = await http.get(Uri.parse('$URL$_pageId/schema'));

    if (response.statusCode == 200) {
      return Layout.fromMap(await jsonDecode(response.body));
    } else {
      throw Exception('Failed to load API');
    }
    // final Map<String, dynamic> map = await json.decode(file);
    // return Layout.fromMap(map);
  }

  @override
  Future<List<Record>> get(List<Filter> filters) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Record>> getAll() async {
    final response = await http.get(Uri.parse('$URL$_pageId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> map = await jsonDecode(response.body);
      List<dynamic> recordset = map['recordset'];
      return recordset.map((e) => Record.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Future<Record> getOne(List<Filter> filters) async {
    throw UnimplementedError();
  }

  @override
  Future<Record> insert(Record record) async {
    throw UnimplementedError();
  }

  @override
  Future<void> update(Record record) async {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(List<Filter> filters) async {
    throw UnimplementedError();
  }
}

class Test {}
