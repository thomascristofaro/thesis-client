import 'dart:convert';

import 'package:thesis_client/controller/cache_controller.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:oauth2/oauth2.dart';

class PageAPIRepository implements IPageRepository {
  final String _pageId;
  String url;

  PageAPIRepository(this._pageId, this.url);
  @override
  Future<Layout> getLayout() async {
    LoginController().checkLogged();
    String body = CacheController().get('SCHEMA_$_pageId');

    if (body.isEmpty) {
      var client = Client(LoginController().credentials!);
      final response =
          await client.get(Uri.https(url, '/${_pageId.toLowerCase()}/schema'));

      if (response.statusCode != 200) {
        throw Exception(getErrorMessage(response.body));
      }
      body = response.body;
      CacheController().set('SCHEMA_$_pageId', body);
    }

    return Layout.fromMap(await jsonDecode(body));
  }

  @override
  Future<List<Record>> get(List<Filter> filters) async {
    LoginController().checkLogged();
    var client = Client(LoginController().credentials!);
    Map<String, dynamic> queryParameters = {};
    for (var filter in filters) {
      queryParameters[filter.id] = filter.value.toString();
    }
    // parameters must be string
    var address = Uri.https(url, "/${_pageId.toLowerCase()}/", queryParameters);
    final response = await client.get(address);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> map = await jsonDecode(response.body);
        if (map['recordset'] == null) {
          return [];
        }
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
        Uri.https(url, '/${_pageId.toLowerCase()}'),
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
        Uri.https(url, '/${_pageId.toLowerCase()}'),
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
    var address = Uri.https(url, '/${_pageId.toLowerCase()}',
        {for (var filter in filters) filter.id: filter.value.toString()});
    final response = await client.delete(address);

    if (response.statusCode != 200) {
      throw Exception(getErrorMessage(response.body));
    }
  }

  @override
  Future<void> button(
      String buttonId, String? devideId, List<Filter> filters) async {
    LoginController().checkLogged();

    Map<String, dynamic> queryParameters = {
      "button_id": buttonId,
      "device_id": devideId ?? ""
    };
    for (var filter in filters) {
      queryParameters[filter.id] = filter.value.toString();
    }

    var client = Client(LoginController().credentials!);
    var address =
        Uri.https(url, '/${_pageId.toLowerCase()}/button', queryParameters);
    final response = await client.get(address);

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
