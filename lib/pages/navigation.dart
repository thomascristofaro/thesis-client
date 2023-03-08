import 'package:flutter/material.dart';

import 'package:thesis_client/widgets/brightness_button.dart';
import 'package:thesis_client/widgets/material_3_button.dart';
import 'package:thesis_client/widgets/color_seed_button.dart';
import 'package:thesis_client/widgets/trailing_actions.dart';
import 'package:thesis_client/widgets/expanded_trailing_actions.dart';
import 'package:thesis_client/widgets/navigation_bars.dart';

import 'package:thesis_client/pages/color_palettes_screen.dart';
import 'package:thesis_client/pages/component_screen.dart';
import 'package:thesis_client/pages/elevation_screen.dart';
import 'package:thesis_client/pages/typography_screen.dart';

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

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;
  bool extendedRail = false;

  int pageIndex = PageSelected.component.value;

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

  Widget createPageFor(PageSelected pageSelected) {
    switch (pageSelected) {
      case PageSelected.component:
        return FirstComponentList(
            scaffoldKey: scaffoldKey
        );
      case PageSelected.color:
        return const ColorPalettesScreen();
      case PageSelected.typography:
        return const TypographyScreen();
      case PageSelected.elevation:
        return const ElevationScreen();
      default:
        return FirstComponentList(
            scaffoldKey: scaffoldKey
        );
    }
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: widget.useMaterial3
          ? const Text('Material 3')
          : const Text('Material 2'),
      leading: showMediumSizeLayout || showLargeSizeLayout
        ? IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Open navigation menu',
          onPressed: () => handleRailChanged(),
        ) : null,
      actions: !showMediumSizeLayout && !showLargeSizeLayout
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

  Widget _trailingActions() => extendedRail
      ? ExpandedTrailingActions(useLightMode: widget.useLightMode,
          useMaterial3: widget.useMaterial3,
          colorSelected: widget.colorSelected,
          handleBrightnessChange: widget.handleBrightnessChange,
          handleMaterialVersionChange: widget.handleMaterialVersionChange,
          handleColorSelect: widget.handleColorSelect,
      )
      : TrailingActions(colorSelected: widget.colorSelected,
          handleBrightnessChange: widget.handleBrightnessChange,
          handleMaterialVersionChange: widget.handleMaterialVersionChange,
          handleColorSelect: widget.handleColorSelect,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: createAppBar(),
      body: Row(
        children: <Widget>[
          if (showLargeSizeLayout || showMediumSizeLayout)
            NavigationRail(
              extended: extendedRail,
              destinations: navRailDestinations,
              selectedIndex: pageIndex,
              onDestinationSelected: (index) {
                handlePageChanged(index);
              },
              trailing: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _trailingActions(),
                ),
              ),
            ),
          createPageFor(PageSelected.values[pageIndex]),
        ],
      ),
      drawer: (!showLargeSizeLayout && !showMediumSizeLayout)
          ? NavigationDrawer(
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
              ...navDrawerDestinations
            ]
          ) : null
    );
  }
}

final List<NavigationRailDestination> navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList();

final List<NavigationDrawerDestination> navDrawerDestinations = appBarDestinations
    .map(
      (destination) => NavigationDrawerDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
     ),
    ).toList();




