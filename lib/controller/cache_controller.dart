class CacheController {
  static final CacheController _instance = CacheController._internal();
  late Map<String, String> _cache;

  factory CacheController() {
    return _instance;
  }

  CacheController._internal() {
    _cache = {};
  }

  String get(String key) {
    return _cache[key] ?? '';
  }

  void set(String key, String value) {
    _cache[key] = value;
  }
}
