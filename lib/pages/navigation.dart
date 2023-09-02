import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/base_setup.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/controller/navigation_model.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/utility.dart';

import 'package:thesis_client/widgets/brightness_button.dart';
import 'package:thesis_client/widgets/material_3_button.dart';
import 'package:thesis_client/widgets/color_seed_button.dart';

import 'package:thesis_client/constants.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.baseSetup,
    required this.child,
  });

  final BaseSetup baseSetup;
  final Widget child;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSmallSizeLayout = true;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;
  bool extendedRail = false;
  int pageIndex = 0;

  late PageAppController pageCtrl;
  late Future<List<Record>> futureRecords;
  List<NavigationModel> navigationList = [];

  @override
  void initState() {
    super.initState();
    pageCtrl = PageAppController(pageId: 'navigationlist');
    futureRecords = pageCtrl.getAllRecords();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    if (width > mediumWidthBreakpoint) {
      showLargeSizeLayout = width > largeWidthBreakpoint;
      showMediumSizeLayout = !showLargeSizeLayout;
    } else {
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
    }
    showSmallSizeLayout = !showMediumSizeLayout && !showLargeSizeLayout;
  }

  void handlePageChanged(int pageSelected) {
    setState(() {
      pageIndex = pageSelected;
    });
    while (context.canPop()) {
      context.pop();
    }
    Utility.goPage(context,
        navigationList.where((e) => e.show).elementAt(pageSelected).pageId);
  }

  void handleRailChanged() {
    setState(() {
      extendedRail = !extendedRail;
    });
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: const Text('BLOX'),
      leading: !showSmallSizeLayout
          ? IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Open navigation menu',
              onPressed: () => handleRailChanged(),
            )
          : null,
      actions: [
        BrightnessButton(
          handleBrightnessChange: widget.baseSetup.handleBrightnessChange,
        ),
        Material3Button(
          handleMaterialVersionChange:
              widget.baseSetup.handleMaterialVersionChange,
        ),
        ColorSeedButton(
          handleColorSelect: widget.baseSetup.handleColorSelect,
          colorSelected: widget.baseSetup.colorSelected,
        ),
      ],
    );
  }

  NavigationDrawer buildNavigationDrawer() {
    return NavigationDrawer(
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          handlePageChanged(index);
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...(navigationList
              .where((e) => e.show)
              .map(
                (element) => NavigationDrawerDestination(
                  icon: Tooltip(
                    message: element.caption,
                    child: element.getIconWidget(),
                  ),
                  selectedIcon: Tooltip(
                    message: element.caption,
                    child: element.getIconSelectedWidget(),
                  ),
                  label: Text(element.caption),
                ),
              )
              .toList()),
        ]);
  }

  Widget navigationRailLeading(UserModel user) {
    return extendedRail
        ? Container(
            constraints: const BoxConstraints.tightFor(width: 200),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        child: const Icon(
                          Icons.person,
                        ),
                      ),
                      Text(user.username)
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Material 3'),
                      Expanded(child: Container()),
                      Switch(value: true, onChanged: (_) {})
                    ],
                  ),
                ]))
        : CircleAvatar(
            child: Icon(
              Icons.person,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          );
  }

  Widget buildScrollNavigationRail() {
    final UserModel user = LoginController().user!;
    final List<NavigationRailDestination> railDestinations = navigationList
        .where((e) => e.show)
        .map(
          (element) => NavigationRailDestination(
              icon: Tooltip(
                message: element.caption,
                child: element.getIconWidget(),
              ),
              selectedIcon: Tooltip(
                message: element.caption,
                child: element.getIconSelectedWidget(),
              ),
              label: Text(element.caption)),
        )
        .toList();

    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).padding.top + kToolbarHeight)),
            child: IntrinsicHeight(
                child: NavigationRail(
              leading: navigationRailLeading(user),
              extended: extendedRail,
              destinations: railDestinations,
              selectedIndex: pageIndex,
              onDestinationSelected: (index) {
                handlePageChanged(index);
              },
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Record>>(
        future: futureRecords,
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.hasData) {
            navigationList = (snapshot.data as List<Record>)
                .map((record) => NavigationModel.fromMap(record.fields))
                .toList();
            return Scaffold(
              key: scaffoldKey,
              appBar: buildAppBar(),
              body: Row(
                children: <Widget>[
                  if (!showSmallSizeLayout) buildScrollNavigationRail(),
                  if (!showSmallSizeLayout)
                    const VerticalDivider(thickness: 1, width: 1),
                  // This is the main content.
                  Expanded(
                    child: widget.child,
                  ),
                ],
              ),
              drawer: showSmallSizeLayout ? buildNavigationDrawer() : null,
            );
          } else {
            return Container();
          }
        });
  }
}
