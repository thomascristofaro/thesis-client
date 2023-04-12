class Layout {
  final String id;
  final String type; //TODO può diventare enum se servirà
  final String caption;
  final List<Button> buttons;
  final String repeater;

  Layout(this.id, this.type, this.caption, this.buttons, this.repeater);

  Layout.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        caption = data['caption'],
        buttons =
            data['buttons'].map((button) => Button.fromMap(button)).toList(),
        repeater = data['repeater'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'caption': caption,
        'buttons': buttons.map((button) => button.toMap()).toList()
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
        buttons =
            data['buttons'].map((button) => Button.fromMap(button)).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'caption': caption,
        'icon': icon,
        'buttons': buttons.map((button) => button.toMap()).toList()
      };

  // inserire metodo build
}
