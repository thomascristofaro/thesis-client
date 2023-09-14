import 'dart:convert';

import 'package:thesis_client/controller/cache_controller.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:oauth2/oauth2.dart';

class PageAPIRepository implements IPageRepository {
  static const String URL = 'ngb197hjce.execute-api.us-east-1.amazonaws.com';
  final String _pageId;

  PageAPIRepository(this._pageId);

  @override
  Future<Layout> getLayout() async {
    LoginController().checkLogged();
    String body = CacheController().get(_pageId);

    if (body.isEmpty) {
      var client = Client(LoginController().credentials!);
      final response =
          await client.get(Uri.https(URL, '/${_pageId.toLowerCase()}/schema'));

      if (response.statusCode != 200) {
        throw Exception(getErrorMessage(response.body));
      }
      body = response.body;
      CacheController().set(_pageId, body);
    }

    return Layout.fromMap(await jsonDecode(body));
  }

  @override
  Future<List<Record>> get(List<Filter> filters) async {
    LoginController().checkLogged();
    var client = Client(LoginController().credentials!);
    var address = Uri.https(URL, "/${_pageId.toLowerCase()}/",
        {for (var filter in filters) filter.id: filter.value});
    final response = await client.get(address);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> map = await jsonDecode(response.body);
        List<dynamic> recordset = map['recordset'];
        return recordset.map((e) => Record.fromMap(e)).toList();
      } catch (e) {
        throw Exception("Failed to read body response from API");
      }
    } else {
      throw Exception(getErrorMessage(response.body));
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
    LoginController().checkLogged();
    var client = Client(LoginController().credentials!);
    final response = await client.post(
        Uri.https(URL, '/${_pageId.toLowerCase()}'),
        body: jsonEncode(record.toMap()),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> map = await jsonDecode(response.body);
      return Record.fromMap(map);
    } else {
      throw Exception(getErrorMessage(response.body));
    }
  }

  @override
  Future<void> update(Record record) async {
    LoginController().checkLogged();
    var client = Client(LoginController().credentials!);
    final response = await client.patch(
        Uri.https(URL, '/${_pageId.toLowerCase()}'),
        body: jsonEncode(record.toMap()),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception(getErrorMessage(response.body));
    }
  }

  @override
  Future<void> delete(List<Filter> filters) async {
    LoginController().checkLogged();
    var client = Client(LoginController().credentials!);
    var address = Uri.https(URL, '/${_pageId.toLowerCase()}',
        {for (var filter in filters) filter.id: filter.value});
    final response = await client.delete(address);

    if (response.statusCode != 200) {
      throw Exception(getErrorMessage(response.body));
    }
  }

  String getErrorMessage(String body) {
    try {
      final Map<String, dynamic> map = jsonDecode(body);
      return map['message'];
    } catch (e) {
      return "Failed to read body response from API";
    }
  }
}
