enum PageType { list, card }

enum AreaComponentType { repeater, group }

enum FieldType { text, number, boolean, date, time, datetime }

class Layout {
  final String id;
  final PageType type;
  final String caption;
  final List<Button> buttons;
  final List<AreaComponent> area;

  Layout(this.id, this.type, this.caption, this.buttons, this.area);

  Layout.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        caption = data['caption'],
        buttons =
            data['buttons'].map((button) => Button.fromMap(button)).toList(),
        area = data['area'].map((area) => AreaComponent.fromMap(area)).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'caption': caption,
        'buttons': buttons.map((button) => button.toMap()).toList(),
        'area': area.map((area) => area.toMap()).toList(),
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

class Field {
  final String id;
  final String caption;
  final FieldType type;

  Field(this.id, this.caption, this.type);

  Field.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        type = data['type'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'type': type,
      };
}

class AreaComponent {
  final String id;
  final String caption;
  final AreaComponentType type;
  final List<Field> fields;

  AreaComponent(this.id, this.caption, this.type, this.fields);

  AreaComponent.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        caption = data['caption'],
        type = data['type'],
        fields = data['fields'].map((field) => Field.fromMap(field)).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'type': type,
        'fields': fields.map((field) => field.toMap()).toList()
      };
}
