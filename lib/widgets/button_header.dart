import 'package:flutter/material.dart';
import '../controller/layout.dart';

class ButtonHeader extends StatefulWidget {
  final List<Button> buttons;

  const ButtonHeader({super.key, required this.buttons});

  @override
  State<ButtonHeader> createState() => _ButtonHeaderState();
}

class _ButtonHeaderState extends State<ButtonHeader> {
  void unimplementedSnackbar(Button button) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 400.0,
      content: Text('${button.caption} not implemented'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget createMenu(Button button) {
    return button.buttons.isEmpty
        ? createButton(button, () => unimplementedSnackbar(button))
        : MenuAnchor(
            builder: (context, controller, child) {
              return createButton(button, () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              });
            },
            menuChildren: createMenuItem(button.buttons));
  }

  List<Widget> createMenuItem(List<Button> buttons) {
    return buttons
        .map((button) => button.buttons.isEmpty
            ? MenuItemButton(
                leadingIcon: const Icon(Icons.more_vert),
                onPressed: () => unimplementedSnackbar(button),
                child: Text(button.caption),
              )
            : SubmenuButton(
                leadingIcon: const Icon(Icons.refresh),
                menuChildren: createMenuItem(button.buttons),
                child: Text(button.caption),
              ))
        .toList();
  }

  Widget createButton(Button button, void Function() onPressed) {
    return FilledButton.tonalIcon(
      label: Text(button.caption),
      icon: const Icon(Icons.more_vert),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    // bisogna mettere da qualche parte lo scroll orizzontale
    return Card(
      elevation: 1,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  widget.buttons.map((button) => createMenu(button)).toList(),
            ),
          )),
    );
  }
}
