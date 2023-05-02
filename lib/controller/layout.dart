enum PageType { list, card }

enum AreaComponentType { repeater, group }

enum FieldType { text, number, boolean, date, time, datetime }

class Layout {
  final String id;
  final PageType type;
  final String caption;
  final List<Button> buttons;
  final List<AreaComponent> area;
  final List<String> keys;

  Layout(this.id, this.type, this.caption, this.buttons, this.area, this.keys);

  Layout.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        caption = data['caption'],
        buttons =
            data['buttons'].map((button) => Button.fromMap(button)).toList(),
        area = data['area'].map((area) => AreaComponent.fromMap(area)).toList(),
        keys = data['keys'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'caption': caption,
        'buttons': buttons.map((button) => button.toMap()).toList(),
        'area': area.map((area) => area.toMap()).toList(),
        'keys': keys,
      };
}

class Button {
  final String id;
  final String caption;
  final String icon;
  final List<Button> buttons;

  Button(this.id, this.caption, this.icon, this.buttons);

  Button.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        icon = data['icon'],
        buttons = data.containsKey('buttons')
            ? data['buttons'].map((button) => Button.fromMap(button)).toList()
            : [];

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'icon': icon,
        'buttons': buttons.map((button) => button.toMap()).toList()
      };

  // inserire metodo build
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
  final List<PageField> fields;

  AreaComponent(this.id, this.caption, this.type, this.fields);

  AreaComponent.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        type = AreaComponentType.values[data['type']],
        fields =
            data['fields'].map((field) => PageField.fromMap(field)).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'type': type.index,
        'fields': fields.map((field) => field.toMap()).toList()
      };
}
