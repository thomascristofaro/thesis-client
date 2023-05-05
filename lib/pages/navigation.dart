import 'package:flutter/material.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/pages/home.dart';
import 'package:thesis_client/pages/page.dart' as page;

import 'package:thesis_client/widgets/brightness_button.dart';
import 'package:thesis_client/widgets/future_progress.dart';
import 'package:thesis_client/widgets/material_3_button.dart';
import 'package:thesis_client/widgets/color_seed_button.dart';
import 'package:thesis_client/widgets/trailing_actions.dart';
import 'package:thesis_client/widgets/expanded_trailing_actions.dart';

import 'package:thesis_client/constants.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
  });

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;

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
  late PageAppController pageCtrl;
  late Future<List<Record>> records;

  int pageIndex = PageSelected.list.value;

  @override
  void initState() {
    super.initState();
    pageCtrl = PageAppController('NavigationInfo');
    records = pageCtrl.getAllRecords();
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
  }

  void handleRailChanged() {
    setState(() {
      extendedRail = !extendedRail;
    });
  }

  // Replace with:
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => AboutUs()),
  // );
  // https://medium.com/codechai/navigation-drawer-using-flutter-cc8a5cfcab90

  Widget createPageFor(List<NavigationInfo> navInfoList) {
    switch (pageIndex) {
      case 0:
        return const Home();
      default:
        return page.Page(pageId: navInfoList[pageIndex].pageId);
      // case PageSelected.component:
      //   return FirstComponentList(scaffoldKey: scaffoldKey);
      // case PageSelected.color:
      //   return const ColorPalettesScreen();
      // case PageSelected.typography:
      //   return const TypographyScreen();
      // case PageSelected.elevation:
      //   return const ElevationScreen();
      // case PageSelected.list:
      //   return const page.Page(
      //     pageId: 'TEST',
      //   );
      // case PageSelected.demo1:
      //   return const DemoPage(internal: TableButton());
      // case PageSelected.demo2:
      //   return const DemoPage(internal: PaginatedDataTableDemo());
      // case PageSelected.demo3:
      //   return const DemoPage(internal: PaginatedDataTable2Demo());
      // case PageSelected.demo4:
      //   return const DemoPage(internal: AsyncPaginatedDataTable2Demo());
      // default:
      //   return FirstComponentList(scaffoldKey: scaffoldKey);
    }
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
      actions: showSmallSizeLayout
          ? [
              BrightnessButton(
                handleBrightnessChange: widget.handleBrightnessChange,
              ),
              Material3Button(
                handleMaterialVersionChange: widget.handleMaterialVersionChange,
              ),
              ColorSeedButton(
                handleColorSelect: widget.handleColorSelect,
                colorSelected: widget.colorSelected,
              ),
            ]
          : [Container()],
    );
  }

  NavigationDrawer buildNavigationDrawer(List<NavigationInfo> navInfoList) {
    return NavigationDrawer(
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          handlePageChanged(index);
          Navigator.pop(context);
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...(navInfoList
              .map(
                (navInfo) => NavigationDrawerDestination(
                  icon: Tooltip(
                    message: navInfo.caption,
                    child: navInfo.getIconWidget(),
                  ),
                  selectedIcon: Tooltip(
                    message: navInfo.caption,
                    child: navInfo.getIconSelectedWidget(),
                  ),
                  label: Text(navInfo.caption),
                ),
              )
              .toList())
        ]);
  }

  NavigationRail buildNavigationRail(List<NavigationInfo> navInfoList) {
    final List<NavigationRailDestination> railDestinations = navInfoList
        .map(
          (navInfo) => NavigationRailDestination(
              icon: Tooltip(
                message: navInfo.caption,
                child: navInfo.getIconWidget(),
              ),
              selectedIcon: Tooltip(
                message: navInfo.caption,
                child: navInfo.getIconSelectedWidget(),
              ),
              label: Text(navInfo.caption)),
        )
        .toList();

    return NavigationRail(
      extended: extendedRail,
      destinations: railDestinations,
      selectedIndex: pageIndex,
      onDestinationSelected: (index) {
        handlePageChanged(index);
      },
      trailing: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: extendedRail
              ? ExpandedTrailingActions(
                  useLightMode: widget.useLightMode,
                  useMaterial3: widget.useMaterial3,
                  colorSelected: widget.colorSelected,
                  handleBrightnessChange: widget.handleBrightnessChange,
                  handleMaterialVersionChange:
                      widget.handleMaterialVersionChange,
                  handleColorSelect: widget.handleColorSelect)
              : TrailingActions(
                  colorSelected: widget.colorSelected,
                  handleBrightnessChange: widget.handleBrightnessChange,
                  handleMaterialVersionChange:
                      widget.handleMaterialVersionChange,
                  handleColorSelect: widget.handleColorSelect),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: buildAppBar(),
        body: FutureProgress<List<Record>>(
            future: records,
            builder: (records) {
              // List<NavigationInfo> navInfoList = records
              //     .map((record) => NavigationInfo.fromMap(record.fields))
              //     .toList();
              var navInfoList = NavigationInfo.createFromList(records);
              return Row(
                children: <Widget>[
                  if (!showSmallSizeLayout) buildNavigationRail(navInfoList),
                  // const Home()
                  createPageFor(navInfoList),
                ],
              );
            }),
        drawer: FutureBuilder<List<Record>>(
            future: records,
            builder:
                (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
              if (snapshot.hasData) {
                var navInfoList = NavigationInfo.createFromList(snapshot.data!);
                return showSmallSizeLayout
                    ? buildNavigationDrawer(navInfoList)
                    : Container();
              }
              return Container();
            }));
  }
}

class NavigationInfo {
  final String caption;
  final String tooltip;
  final String icon;
  final String selectedIcon;
  final String pageId;

  const NavigationInfo({
    required this.icon,
    required this.caption,
    required this.tooltip,
    required this.selectedIcon,
    required this.pageId,
  });

  NavigationInfo.fromMap(Map<String, dynamic> data)
      : icon = data['icon'], // TODO da capire come prendere l'icon
        caption = data['caption'],
        tooltip = data['tooltip'],
        selectedIcon = data['selected_icon'],
        pageId = data['page_id'];

  Icon getIconWidget() {
    return const Icon(Icons.table_chart_outlined);
  }

  Icon getIconSelectedWidget() {
    return const Icon(Icons.table_chart);
  }

  static List<NavigationInfo> createFromList(List<Record> records) {
    List<NavigationInfo> navInfoList =
        records.map((record) => NavigationInfo.fromMap(record.fields)).toList();
    navInfoList.insert(
        0,
        const NavigationInfo(
            icon: 'home',
            caption: 'Home',
            tooltip: 'test Home',
            selectedIcon: 'home',
            pageId: 'Home'));
    return navInfoList;
  }
}

enum PageSelected {
  list(0),
  component(1),
  color(2),
  typography(3),
  elevation(4),
  demo1(5),
  demo2(6),
  demo3(7),
  demo4(7);

  const PageSelected(this.value);
  final int value;
}

const List<NavigationDestination> navDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.table_chart_outlined),
    label: 'Table',
    selectedIcon: Icon(Icons.table_chart),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.widgets_outlined),
    label: 'Components',
    selectedIcon: Icon(Icons.widgets),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.format_paint_outlined),
    label: 'Color',
    selectedIcon: Icon(Icons.format_paint),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.text_snippet_outlined),
    label: 'Typography',
    selectedIcon: Icon(Icons.text_snippet),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.invert_colors_on_outlined),
    label: 'Elevation',
    selectedIcon: Icon(Icons.opacity),
  ),
  // NavigationDestination(
  //   tooltip: '',
  //   icon: Icon(Icons.developer_mode_outlined),
  //   label: 'Demo 1',
  //   selectedIcon: Icon(Icons.developer_mode),
  // ),
  // NavigationDestination(
  //   tooltip: '',
  //   icon: Icon(Icons.developer_mode_outlined),
  //   label: 'Demo 2',
  //   selectedIcon: Icon(Icons.developer_mode),
  // ),
  // NavigationDestination(
  //   tooltip: '',
  //   icon: Icon(Icons.developer_mode_outlined),
  //   label: 'Demo 3',
  //   selectedIcon: Icon(Icons.developer_mode),
  // ),
  // NavigationDestination(
  //   tooltip: '',
  //   icon: Icon(Icons.developer_mode_outlined),
  //   label: 'Demo 4',
  //   selectedIcon: Icon(Icons.developer_mode),
  // )
];
