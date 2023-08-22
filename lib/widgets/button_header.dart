import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/constants.dart';
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
  List<Widget> buttonsWidget = [];

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

  Widget newButton() {
    return createButton(Button("default_new", "New", 0xe404, []), () {
      var pageCtrl = Provider.of<PageAppController>(context, listen: false);
      if (pageCtrl.layout.cardPageId.isEmpty) {
        sendSnackBar('Card not available');
      } else {
        context.pushNamed(pageCtrl.layout.cardPageId);
      }
    });
  }

  Widget insertButton() {
    return createButton(Button("default_insert", "Insert", 0xe404, []),
        () async {
      try {
        await Provider.of<PageAppController>(context, listen: false)
            .addRecord();
        sendSnackBar('Inserted');
      } catch (e) {
        sendSnackBar(e.toString());
      }
    });
  }

  Widget modifyButton() {
    return createButton(Button("default_modify", "Modify", 0xe404, []),
        () async {
      try {
        await Provider.of<PageAppController>(context, listen: false)
            .modifyRecord();
        sendSnackBar('Modified');
      } catch (e) {
        sendSnackBar(e.toString());
      }
    });
  }

  Widget deleteButton() {
    return createButton(Button("default_delete", "Delete", 0xe404, []),
        () async {
      // TODO qui arrivo senza filtri se faccio un insert
      // quindi o tolgo il delete dal new o capisco come gestirlo
      try {
        await Provider.of<PageAppController>(context, listen: false)
            .removeRecord();
        if (!context.mounted) return;
        Navigator.pop(context); // chiude la pagina
      } catch (e) {
        sendSnackBar(e.toString());
      }
    });
  }

  void createButtonList() {
    buttonsWidget = [
      if (widget.pageType == PageType.list) newButton(),
      if (widget.pageType == PageType.card) insertButton(),
      if (widget.pageType == PageType.card) modifyButton(),
      if (widget.pageType == PageType.card) deleteButton(),
      ...widget.buttons.map((button) => createMenu(button)).toList()
    ];
  }

  @override
  void initState() {
    super.initState();
    createButtonList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: smallSpacing / 2, vertical: smallSpacing),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: smallSpacing * 2),
                child: Row(
                    children: buttonsWidget
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(
                                  right: smallSpacing * 2),
                              child: e,
                            ))
                        .toList()),
              ),
            ),
          )),
    );
  }
}
