enum PageType { list, card, home }

enum AreaComponentType { repeater, group }

enum FieldType { text, number, boolean, date, time, datetime }

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
    if (type != PageType.home) {
      // Questo va in errore da chiedere su stack overflow
      // area = data['area'].map((e) => AreaComponent.fromMap(e)).toList();
      List<dynamic> jsonarea = data['area'];
      area = jsonarea
          .map((jcomponent) => AreaComponent.fromMap(jcomponent))
          .toList();

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
}

class AreaComponent {
  final String id;
  final String caption;
  final AreaComponentType type;
  late List<PageField> fields;

  AreaComponent(this.id, this.caption, this.type, this.fields);

  AreaComponent.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        type = AreaComponentType.values[data['type']] {
    List<dynamic> jsonfields = data['fields'];
    fields = jsonfields.map((jfield) => PageField.fromMap(jfield)).toList();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'type': type.index,
        'fields': fields.map((field) => field.toMap()).toList()
      };
}
