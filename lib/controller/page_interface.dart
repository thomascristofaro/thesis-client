import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';

abstract class IPageRepository {
  Future<Layout> getLayout(String pageId);
  Future<List<Record>> getAll(String pageId);
  Future<List<Record>> get(String pageId, Map<String, dynamic> filter);
  Future<Record?> getOne(String pageId, Map<String, dynamic> filter);
  // TODO come gestire il valore di ritorno dell'API
  Future<void> insert(String pageId, Record record);
  Future<void> update(String pageId, Record record);
  Future<void> delete(String pageId, Map<String, dynamic> filter);
}
