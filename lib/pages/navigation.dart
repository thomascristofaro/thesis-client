import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/base_setup.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/controller/navigation_model.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/controller/utility.dart';

import 'package:thesis_client/widgets/brightness_button.dart';
import 'package:thesis_client/widgets/future_progress.dart';
import 'package:thesis_client/widgets/material_3_button.dart';
import 'package:thesis_client/widgets/color_seed_button.dart';

import 'package:thesis_client/constants.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    this.pageStartIndex = 0,
    required this.child,
  });

  final Widget child;
  final int pageStartIndex;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSmallSizeLayout = true;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;
  bool extendedRail = false;
  int pageIndex = 0;
  bool toHomePage = false;

  late PageAppController pageCtrl;
  late Future<List<Record>> futureRecords;
  List<NavigationModel> navigationList = [];

  Future<List<Record>> getList() async {
    if (LoginController().isLogged()) {
      return pageCtrl.getAllRecords();
    } else {
      return Future.value([]);
    }
  }

  void handleLogin() {
    setState(() {
      toHomePage = true;
      futureRecords = getList();
    });
  }

  @override
  void initState() {
    super.initState();
    pageIndex = widget.pageStartIndex;

    LoginController().addListener(handleLogin);

    pageCtrl = PageAppController(pageId: 'navigationlist');
    futureRecords = getList();
  }

  @override
  void dispose() {
    LoginController().removeListener(handleLogin);
    super.dispose();
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
    if (pageSelected == 0) {
      context.goNamed('user');
    } else {
      Utility.goPage(context,
          navigationList.where((e) => e.show).elementAt(pageSelected).pageId);
    }
  }

  void handleRailChanged() {
    setState(() {
      extendedRail = !extendedRail;
    });
  }

  PreferredSizeWidget buildAppBar() {
    BaseSetup baseSetup = Provider.of<BaseSetup>(context);
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
          handleBrightnessChange: baseSetup.handleBrightnessChange,
        ),
        Material3Button(
          handleMaterialVersionChange: baseSetup.handleMaterialVersionChange,
        ),
        ColorSeedButton(
          handleColorSelect: baseSetup.handleColorSelect,
          colorSelected: baseSetup.colorSelected,
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

  Widget buildScrollNavigationRail() {
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
              extended: extendedRail,
              destinations: railDestinations,
              selectedIndex: pageIndex,
              onDestinationSelected: (index) {
                handlePageChanged(index);
              },
            ))));
  }

  void buildNavigationList(List<Record> records) {
    String user = LoginController().isLogged()
        ? LoginController().user!.username
        : 'User';
    navigationList.clear();
    navigationList.add(NavigationModel(
        pageId: 'user',
        caption: user,
        tooltip: user,
        icon: 0xf27b,
        selectedIcon: 0xe491));
    navigationList.add(const NavigationModel(
        pageId: 'home',
        caption: 'Home Page',
        tooltip: 'Home Page',
        icon: 61703,
        selectedIcon: 58136));
    navigationList.addAll(records
        .map((record) => NavigationModel.fromMap(record.fields))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      appBar: buildAppBar(),
      body: FutureProgress<List<Record>>(
          future: futureRecords,
          builder: (List<Record> records) {
            buildNavigationList(records);
            if (toHomePage) {
              toHomePage = false;
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => handlePageChanged(1));
            }
            return Row(
              children: <Widget>[
                if (!showSmallSizeLayout) buildScrollNavigationRail(),
                if (!showSmallSizeLayout)
                  const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(
                  child: widget.child,
                ),
              ],
            );
          }),
      drawer: showSmallSizeLayout ? buildNavigationDrawer() : null,
    );
  }
}
