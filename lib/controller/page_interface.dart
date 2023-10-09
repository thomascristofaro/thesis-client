import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/record.dart';

abstract class IPageRepository {
  Future<Layout> getLayout();
  Future<List<Record>> getAll();
  Future<List<Record>> get(List<Filter> filters);
  Future<Record> getOne(List<Filter> filters);
  // TODO come gestire il valore di ritorno dell'API
  Future<Record> insert(Record record);
  Future<void> update(Record record);
  Future<void> delete(List<Filter> filters);
  Future<void> button(String buttonId, String? devideId, List<Filter> filters);
}
