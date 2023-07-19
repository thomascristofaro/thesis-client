import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/controller/page_controller.dart';
import '../controller/layout.dart';

class ButtonHeader extends StatefulWidget {
  final List<Button> buttons;
  final PageType pageType;

  const ButtonHeader(
      {super.key, required this.pageType, required this.buttons});

  @override
  State<ButtonHeader> createState() => _ButtonHeaderState();
}

class _ButtonHeaderState extends State<ButtonHeader> {
  void sendSnackBar(String string) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 400.0,
      content: Text(string),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void unimplementedSnackbar(Button button) {
    sendSnackBar('${button.caption} not implemented');
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

  Widget insertButton() {
    return createButton(Button("default_insert", "Insert", 0xe404, []), () {
      Provider.of<PageAppController>(context, listen: false).addRecord();
      sendSnackBar('Inserted');
    });
  }

  Widget modifyButton() {
    return createButton(Button("default_modify", "Modify", 0xe404, []), () {
      Provider.of<PageAppController>(context, listen: false).modifyRecord();
      sendSnackBar('Modified');
    });
  }

  Widget deleteButton() {
    return createButton(Button("default_delete", "Delete", 0xe404, []), () {
      Provider.of<PageAppController>(context, listen: false).removeRecord();
      Navigator.pop(context); // dovrebbe chiudere la pagina
    });
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
                children: [
                  if (widget.pageType == PageType.list) insertButton(),
                  if (widget.pageType == PageType.card) modifyButton(),
                  if (widget.pageType == PageType.card) deleteButton(),
                  ...widget.buttons.map((button) => createMenu(button)).toList()
                ]),
          )),
    );
  }
}
