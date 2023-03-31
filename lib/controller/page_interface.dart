import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';

abstract class IPageRepository {
  Future<Layout> getLayout();
  Future<List<Record>> getAll();
  Future<List<Record>> get(Map<String, dynamic> filter);
  Future<Record?> getOne(Map<String, dynamic> filter);
  // TODO come gestire il valore di ritorno dell'API
  Future<void> insert(Record record);
  Future<void> update(Record record);
  Future<void> delete(Map<String, dynamic> filter);
}
