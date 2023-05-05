import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/page_fake_repository.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/virtual_db.dart';

import 'layout.dart';

class PageAppController {
  final String _pageId;
  List<Filter> currentFilters = [];
  late IPageRepository _pageRepo;

  PageAppController(this._pageId) {
    _pageRepo = PageFakeRepository(VirtualDB(), _pageId);
  }

  Future<Layout> getLayout() {
    return _pageRepo.getLayout();
  }

  Future<List<Record>> getAllRecords() {
    Future.delayed(const Duration(seconds: 3));
    return _pageRepo.getAll();
  }

  Future<Record?> getOneRecord() {
    return _pageRepo.getOne(currentFilters);
  }

  Future<void> addRecord(Record record) {
    return _pageRepo.insert(record);
  }

  Future<void> removeRecord() {
    return _pageRepo.delete(currentFilters);
  }
}
