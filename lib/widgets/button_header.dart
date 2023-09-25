import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/utility.dart';
import '../controller/layout.dart';

class ButtonHeader extends StatefulWidget {
  final List<Button> buttons;
  final PageType pageType;
  final bool insertBtn;

  const ButtonHeader(
      {super.key,
      required this.pageType,
      required this.buttons,
      this.insertBtn = false});

  @override
  State<ButtonHeader> createState() => _ButtonHeaderState();
}

class _ButtonHeaderState extends State<ButtonHeader> {
  List<Widget> buttonsWidget = [];

  void unimplementedSnackbar(Button button) {
    Utility.showSnackBar(context, '${button.caption} not implemented');
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
    return createButton(Button("default_new", "New", 0xe047, []), () {
      var pageCtrl = Provider.of<PageAppController>(context, listen: false);
      if (pageCtrl.layout.cardPageId.isEmpty) {
        Utility.showSnackBar(context, 'Card not available');
      } else {
        Utility.pushPage(context, pageCtrl.layout.cardPageId);
      }
    });
  }

  Widget insertButton() {
    return createButton(Button("default_insert", "Insert", 0xe047, []),
        () async {
      try {
        await Provider.of<PageAppController>(context, listen: false)
            .addRecord();
        Utility.showSnackBar(context, 'Inserted');
      } catch (e) {
        Utility.showSnackBar(context, e.toString());
      }
    });
  }

  Widget modifyButton() {
    return createButton(Button("default_modify", "Modify", 0xe21a, []),
        () async {
      try {
        await Provider.of<PageAppController>(context, listen: false)
            .modifyRecord();
        Utility.showSnackBar(context, 'Modified');
      } catch (e) {
        Utility.showSnackBar(context, e.toString());
      }
    });
  }

  Widget deleteButton() {
    return createButton(Button("default_delete", "Delete", 0xe1b9, []),
        () async {
      // TODO qui arrivo senza filtri se faccio un insert
      // quindi o tolgo il delete dal new o capisco come gestirlo
      try {
        await Provider.of<PageAppController>(context, listen: false)
            .removeRecord();
        if (!context.mounted) return;
        Navigator.pop(context); // chiude la pagina
      } catch (e) {
        Utility.showSnackBar(context, e.toString());
      }
    });
  }

  Widget closeButton() {
    return createButton(Button("default_close", "Close", 0xe16a, []), () {
      if (context.canPop()) context.pop();
    });
  }

  // Widget refreshButton() {
  //   return createButton(Button("default_close", "Refresh", 0xe514, []), () {
  //     if (context.canPop()) context.pop();
  //     Utility.
  //   });
  // }

  void createButtonList() {
    buttonsWidget = [
      if (widget.pageType == PageType.list) newButton(),
      if (widget.pageType == PageType.card) closeButton(),
      if (widget.pageType == PageType.card && widget.insertBtn) insertButton(),
      if (widget.pageType == PageType.card && !widget.insertBtn) modifyButton(),
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
