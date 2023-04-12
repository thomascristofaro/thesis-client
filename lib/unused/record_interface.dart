import 'package:flutter/foundation.dart';
import 'package:thesis_client/controller/record.dart';

abstract class IRecordRepository {
  Future<List<Record>> getAll();
  Future<List<Record>> get(Map<String, dynamic> filter);
  Future<Record?> getOne(Map<String, dynamic> filter);
  Future<void> insert(Record record);
  Future<void> update(Record record);
  Future<void> delete(Map<String, dynamic> filter);
}
