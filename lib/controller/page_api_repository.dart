import 'dart:convert';

import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:http/http.dart' as http;

class PageAPIRepository implements IPageRepository {
  static const String URL =
      'https://ngb197hjce.execute-api.us-east-1.amazonaws.com/';
  final String _pageId;

  PageAPIRepository(this._pageId);

  @override
  Future<Layout> getLayout() async {
    var pageIdLower = _pageId.toLowerCase();
    final response = await http.get(Uri.parse('$URL$pageIdLower/schema'));

    if (response.statusCode == 200) {
      return Layout.fromMap(await jsonDecode(response.body));
    } else {
      throw Exception('Failed to load API');
    }
  }

  @override
  Future<List<Record>> get(List<Filter> filters) async {
    var pageIdLower = _pageId.toLowerCase();
    var address = Uri.https("ngb197hjce.execute-api.us-east-1.amazonaws.com",
        "/$pageIdLower", {for (var filter in filters) filter.id: filter.value});
    final response = await http.get(address);

    if (response.statusCode == 200) {
      final Map<String, dynamic> map = await jsonDecode(response.body);
      List<dynamic> recordset = map['recordset'];
      return recordset.map((e) => Record.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load API');
    }
  }

  @override
  Future<List<Record>> getAll() async {
    return get([]);
  }

  @override
  Future<Record> getOne(List<Filter> filters) async {
    var recordset = await get(filters);
    return recordset.first;
  }

  @override
  Future<Record> insert(Record record) async {
    var pageIdLower = _pageId.toLowerCase();
    final response = await http.post(Uri.parse('$URL$pageIdLower'),
        body: jsonEncode(record.toMap()),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> map = await jsonDecode(response.body);
      return Record.fromMap(map);
    } else {
      throw Exception('Failed to write to API');
    }
  }

  @override
  Future<void> update(Record record) async {
    var pageIdLower = _pageId.toLowerCase();
    final response = await http.patch(Uri.parse('$URL$pageIdLower'),
        body: jsonEncode(record.toMap()),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Failed to write to API');
    }
  }

  @override
  Future<void> delete(List<Filter> filters) async {
    var pageIdLower = _pageId.toLowerCase();
    var address = Uri.https("ngb197hjce.execute-api.us-east-1.amazonaws.com",
        "/$pageIdLower", {for (var filter in filters) filter.id: filter.value});
    final response = await http.delete(address);

    if (response.statusCode != 200) {
      throw Exception('Failed to write to API');
    }
  }
}
