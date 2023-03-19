import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/record_interface.dart';
import 'package:thesis_client/controller/record_fake_repository.dart';

class RepeaterController {
  late IRecordRepository _recordRepo;

  RepeaterController(List<String> columns) {
    _recordRepo = RecordFakeRepository(columns);
  }

  Future<List<Record>> getAllRecords() {
    return _recordRepo.getAll();
  }
}
