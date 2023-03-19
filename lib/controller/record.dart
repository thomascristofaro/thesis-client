class Record {
  final Map<String, dynamic> fields;
  bool selected = false;

  Record(this.fields);

  Record.fromMap(Map<String, dynamic> data) : fields = data;

  Map<String, dynamic> toMap() {
    return fields;
  }
}
