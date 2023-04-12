import 'dart:math';

class VirtualDB {
  List<Map<String, dynamic>> _items = [];
  int _id = 0;
  static final VirtualDB _db = VirtualDB._privateConstructor();

  VirtualDB._privateConstructor();

  factory VirtualDB() {
    return _db;
  }

  Future<void> insert(Map<String, dynamic> item) async {
    item['id'] = ++_id;
    _items.add(item);
  }

  Future<void> remove(Map<String, dynamic> filter) async {
    // qua è da gestire proprio i filtri
    _items.removeWhere((item) => item['id'] == filter['id']);
  }

  Future<void> update(Map<String, dynamic> updatedItem) async {
    int i = _items.indexWhere((item) => item['id'] == updatedItem['id']);
    _items[i] = updatedItem;
  }

  Future<List<Map<String, dynamic>>> list() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _items;
  }

  Future<Map<String, dynamic>?> findOne(Map<String, dynamic> filter) async {
    return _items.firstWhere((item) => item['id'] == filter['id']);
  }
}
