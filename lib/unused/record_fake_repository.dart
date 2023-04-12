import 'package:thesis_client/unused/record_interface.dart';
import 'package:thesis_client/controller/record.dart';

class RecordFakeRepository extends IRecordRepository {
  final List<String> _columns;
  RecordFakeRepository(this._columns);

  @override
  Future<void> delete(Map<String, dynamic> filter) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Record>> get(Map<String, dynamic> filter) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<Record>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return List.generate(
        200,
        (index) => Record(_columns
            .asMap()
            .map((key, value) => MapEntry(value, "Cell $index"))));
  }

  @override
  Future<Record?> getOne(Map<String, dynamic> filter) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Record record) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<void> update(Record record) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
