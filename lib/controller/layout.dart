import 'record.dart';

enum PageType { list, card, home, partlist }

enum AreaComponentType { repeater, group, piechart, linechart, subpage }

enum FieldType { text, int, decimal, boolean, date, time, datetime }

class Layout {
  final String id;
  final PageType type;
  final String caption;
  final String cardPageId;
  late List<Button> buttons;
  late List<AreaComponent> area;
  final List<String> key;

  Layout(this.id, this.type, this.caption, this.cardPageId, this.buttons,
      this.area, this.key);

  Layout.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        type = PageType.values[data['type']],
        caption = data['caption'],
        cardPageId =
            data.containsKey('card_page_id') ? data['card_page_id'] : '',
        key = List<String>.from(data['key']) {
    // Questo va in errore da chiedere su stack overflow
    // area = data['area'].map((e) => AreaComponent.fromMap(e)).toList();
    List<dynamic> jsonarea = data['area'];
    area = jsonarea
        .map((jcomponent) => AreaComponent.fromMap(jcomponent))
        .toList();

    if (type != PageType.home) {
      // data['buttons'].map((button) => Button.fromMap(button)).toList(),
      List<dynamic> jsonbuttons = data['buttons'];
      buttons = jsonbuttons.map((jbutton) => Button.fromMap(jbutton)).toList();
    }
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'caption': caption,
        'buttons': buttons.map((button) => button.toMap()).toList(),
        'area': area.map((area) => area.toMap()).toList(),
        'keys': key,
      };

  AreaComponent getRepeaterComponent() {
    return area
        .firstWhere((element) => element.type == AreaComponentType.repeater);
  }

  List<PageField> getAllFields() {
    List<PageField> allFields = [];
    for (var a in area) {
      allFields.addAll(a.fields);
    }
    return allFields;
  }
}

class Button {
  final String id;
  final String caption;
  final int icon;
  List<Button> buttons = [];

  Button(this.id, this.caption, this.icon, this.buttons);

  Button.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        icon = data['icon'] {
    if (data.containsKey('buttons')) {
      List<dynamic> jsonbuttons = data['buttons'];
      buttons = jsonbuttons.map((jbutton) => Button.fromMap(jbutton)).toList();
    }
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'icon': icon,
        'buttons': buttons.map((button) => button.toMap()).toList()
      };
}

class PageField {
  final String id;
  final String caption;
  final FieldType type;

  PageField(this.id, this.caption, this.type);

  PageField.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        type = FieldType.values[data['type']];

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'type': type.index,
      };

  dynamic getInitValue() {
    switch (type) {
      case FieldType.text:
        return '';
      case FieldType.int:
        return 0;
      case FieldType.decimal:
        return 0.0;
      case FieldType.boolean:
        return false;
      case FieldType.date:
        return DateTime.now();
      case FieldType.datetime:
        return DateTime.now();
      default:
        return '';
    }
  }
}

class AreaComponent {
  final String id;
  final String caption;
  final AreaComponentType type;
  late List<PageField> fields;
  final Map<String, dynamic> options;

  AreaComponent(this.id, this.caption, this.type, this.fields,
      {this.options = const {}});

  AreaComponent.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        type = AreaComponentType.values[data['type']],
        options = data.containsKey('options') ? data['options'] : const {} {
    List<dynamic> jsonfields = data['fields'];
    fields = jsonfields.map((jfield) => PageField.fromMap(jfield)).toList();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'type': type.index,
        'fields': fields.map((field) => field.toMap()).toList(),
        'options': options,
      };

  List<Filter> createSubpageFilters(Record record) {
    if (type != AreaComponentType.subpage || !options.containsKey('filters')) {
      return [];
    }
    List<dynamic> jsonfilters = options['filters'];
    List<Map<String, dynamic>> filtersMap = jsonfilters
        .map((jfilter) => Map<String, dynamic>.from(jfilter))
        .toList();
    return filtersMap.map((filterMap) {
      if (filterMap.containsKey('field') &&
          record.fields.containsKey(filterMap['field'])) {
        return Filter(filterMap['id'], record.fields[filterMap['field']],
            FilterType.equalTo);
      }
      return Filter(filterMap['id'], filterMap['value'], FilterType.equalTo);
    }).toList();
  }
}
