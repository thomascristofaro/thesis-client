import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:thesis_client/constants.dart';
import 'package:thesis_client/controller/navigation_model.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/pages/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/pages/page.dart' as page;

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  late PageAppController pageCtrl;
  late Future<List<Record>> futureRecords;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return SchedulerBinding.instance.window.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = ColorSeed.values[value];
    });
  }

  GoRouter createRouter(List<Record> records) {
    List<NavigationModel> navigation = records
        .map((record) => NavigationModel.fromMap(record.fields))
        .toList();

    return GoRouter(initialLocation: "/${navigation[0].pageId}", routes: [
      ShellRoute(
        // navigatorKey: mainNavigatorKey,
        builder: (context, state, child) {
          return Navigation(
            useLightMode: useLightMode,
            useMaterial3: useMaterial3,
            colorSelected: colorSelected,
            handleBrightnessChange: handleBrightnessChange,
            handleMaterialVersionChange: handleMaterialVersionChange,
            handleColorSelect: handleColorSelect,
            navigationList: navigation,
            child: child,
          );
        },
        routes: navigation
            .map((element) => GoRoute(
                name: element.caption,
                path: "/${element.pageId}",
                // server solo per le transizioni
                pageBuilder: (context, state) => NoTransitionPage<void>(
                      key: state.pageKey,
                      child: page.Page(pageId: element.pageId),
                    )))
            .toList(),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    pageCtrl = PageAppController('navigationlist');
    futureRecords = pageCtrl.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Record>>(
        future: futureRecords,
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.hasData) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Material 3',
              themeMode: themeMode,
              theme: ThemeData(
                colorSchemeSeed: colorSelected.color,
                useMaterial3: useMaterial3,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                colorSchemeSeed: colorSelected.color,
                useMaterial3: useMaterial3,
                brightness: Brightness.dark,
              ),
              routerConfig: createRouter(snapshot.data as List<Record>),
            );
          } else {
            return Container();
          }
        });
  }
}
