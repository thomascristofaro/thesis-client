import 'package:flutter/material.dart';
// import 'package:thesis_client/controller/page_api_repository.dart';
import 'package:thesis_client/controller/page_fake_repository.dart';
import 'package:thesis_client/controller/virtual_db.dart';
import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/record.dart';

import 'layout.dart';

class PageAppController extends ChangeNotifier {
  final String pageId;
  List<Filter> currentFilters;
  late IPageRepository _pageRepo;
  late Layout layout;
  late Record currentRecord;

  PageAppController({required this.pageId, this.currentFilters = const []}) {
    _pageRepo = PageFakeRepository(VirtualDB(), pageId);
    // _pageRepo = PageAPIRepository(_pageId);
  }

  Future<Layout> getLayout() async {
    var lateLayout = _pageRepo.getLayout();
    layout = await lateLayout;
    return lateLayout;
  }

  Future<List<Record>> getAllRecords() {
    Future.delayed(const Duration(seconds: 3));
    return _pageRepo.getAll();
  }

  Future<Record?> getOneRecord() async {
    // da capire, lui sta creando in automatico se non trovo filtri
    if (currentFilters.isEmpty) {
      currentRecord = createNewRecord();
      return currentRecord;
    }
    var lateRecord = _pageRepo.getOne(currentFilters);
    currentRecord = await lateRecord;
    return lateRecord;
  }

  Future<void> addRecord() {
    return _pageRepo.insert(currentRecord);
  }

  Future<void> modifyRecord() {
    return _pageRepo.update(currentRecord);
  }

  Future<void> removeRecord() {
    return _pageRepo.delete(currentFilters);
  }

  Record createNewRecord() {
    return Record({for (var e in layout.getAllFields()) e.id: ""});
  }

  void setCurrentRecord(Record record) {
    currentRecord = record;
  }

  Record getCurrentRecord() {
    return currentRecord;
  }

  void addFilter(Filter filter) {
    currentFilters.add(filter);
  }

  void addFilterFromList(List<Filter> filters) {
    for (var filter in filters) {
      currentFilters.add(filter);
    }
  }
}
