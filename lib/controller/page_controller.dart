import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/page_fake_repository.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/virtual_db.dart';

import 'layout.dart';

class PageAppController {
  final String _pageId;
  late IPageRepository _pageRepo;

  PageAppController(this._pageId) {
    _pageRepo = PageFakeRepository(VirtualDB(), _pageId);
  }

  Future<Layout> getLayout() {
    return _pageRepo.getLayout();
  }

  Future<List<Record>> getAllRecords() {
    return _pageRepo.getAll();
  }

  Future<Record?> getOneRecord(Map<String, dynamic> filter) {
    return _pageRepo.getOne(filter);
  }

  Future<void> addRecord(Record record) {
    return _pageRepo.insert(record);
  }

  Future<void> removeRecord(Map<String, dynamic> filter) {
    return _pageRepo.delete(filter);
  }
}
