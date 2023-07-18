class Record {
  final Map<String, dynamic> fields;
  // final List<String> key;
  bool selected = false;

  Record(this.fields);

  Record.fromMap(Map<String, dynamic> data) : fields = data;

  Map<String, dynamic> toMap() {
    return fields;
  }

  List<Filter> getKeyFilters(List<String> key) {
    List<Filter> filters = [];
    for (String k in key) {
      filters.add(Filter(k, fields[k], FilterType.equalTo));
    }
    return filters;
  }
}

// class Field {
//   final String id;
//   final dynamic value;
//   final bool key;

//   Field(this.id, this.value, this.key);

//   Field.fromMap(Map<String, dynamic> data)
//       : id = data['id'],
//         value = data['value'],
//         key = data['key'];

//   Map<String, dynamic> toMap() => {
//         'id': id,
//         'value': value,
//         'key': key,
//       };
// }

enum FilterType {
  equalTo,
  notEqualTo,
  greaterThan,
  lessThen,
  greaterEqThan,
  lessEqThen
}

class Filter {
  final String id;
  final dynamic value;
  final FilterType type;

  Filter(this.id, this.value, this.type);

  Filter.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        value = data['value'],
        type = FilterType.values[data['type']];

  Map<String, dynamic> toMap() => {
        'id': id,
        'value': value,
        'type': type.index,
      };

  bool checkFilter(Record record) {
    var value = record.fields[id];
    switch (type) {
      case FilterType.equalTo:
        return value == this.value;
      case FilterType.notEqualTo:
        return value != this.value;
      case FilterType.greaterThan:
        return value > this.value;
      case FilterType.greaterEqThan:
        return value >= this.value;
      case FilterType.lessThen:
        return value < this.value;
      case FilterType.lessEqThen:
        return value <= this.value;
      default:
        return false;
    }
  }
}
