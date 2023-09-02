import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/controller/utility.dart';
import 'package:thesis_client/widgets/repeater.dart';
import 'package:thesis_client/controller/page_controller.dart';

class PartList extends StatefulWidget {
  const PartList({super.key});

  @override
  State<PartList> createState() => _PartListState();
}

class _PartListState extends State<PartList> {
  late PageAppController pageCtrl;

  Widget createFloatingButton(IconData icon, void Function() onPressed) {
    return FloatingActionButton.small(
        onPressed: onPressed, child: Icon(icon, size: smallSpacing * 2));
  }

  Widget newFloating() {
    return createFloatingButton(Icons.add, () {
      var pageCtrl = Provider.of<PageAppController>(context, listen: false);
      if (pageCtrl.layout.cardPageId.isEmpty) {
        Utility.showSnackBar(context, 'Card not available');
      } else {
        Utility.pushPage(context, pageCtrl.layout.cardPageId);
      }
    });
  }

  @override
  void initState() {
    pageCtrl = Provider.of<PageAppController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Repeater(
          repeater: pageCtrl.layout.getRepeaterComponent(),
          header: true,
        )
      ]),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
            padding: const EdgeInsets.only(right: 30.0, top: 15.0),
            child: newFloating()),
      )
    ]);
  }
}
