import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/controller/navigation_model.dart';

import 'package:thesis_client/widgets/brightness_button.dart';
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
    required this.navigationList,
    required this.child,
  });

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;
  final List<NavigationModel> navigationList;
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
    context.go('/${widget.navigationList[pageSelected].pageId}');
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

  NavigationDrawer buildNavigationDrawer() {
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
          ...(widget.navigationList
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
              .toList())
        ]);
  }

  NavigationRail buildNavigationRail() {
    final List<NavigationRailDestination> railDestinations =
        widget.navigationList
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
      body: Row(
        children: <Widget>[
          // NavigationRail(
          //   selectedIndex: 0,
          //   groupAlignment: -1.0,
          //   onDestinationSelected: (int index) {},
          //   labelType: NavigationRailLabelType.all,
          //   destinations: const <NavigationRailDestination>[
          //     NavigationRailDestination(
          //       icon: Icon(Icons.favorite_border),
          //       selectedIcon: Icon(Icons.favorite),
          //       label: Text('First'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.bookmark_border),
          //       selectedIcon: Icon(Icons.book),
          //       label: Text('Second'),
          //     ),
          //     NavigationRailDestination(
          //       icon: Icon(Icons.star_border),
          //       selectedIcon: Icon(Icons.star),
          //       label: Text('Third'),
          //     ),
          //   ],
          // ),
          if (!showSmallSizeLayout) buildNavigationRail(),
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
  }
}
