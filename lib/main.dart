import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/base_setup.dart';
import 'package:thesis_client/controller/navigation_model.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/pages/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/pages/page.dart' as page;

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => BaseSetup(),
        child: const App(),
      ),
    );

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late PageAppController pageCtrl;
  late Future<List<Record>> futureRecords;

  GoRouter createRouter(BaseSetup baseSetup, List<Record> records) {
    List<NavigationModel> navigation = records
        .map((record) => NavigationModel.fromMap(record.fields))
        .toList();

    return GoRouter(initialLocation: "/${navigation[0].pageId}", routes: [
      ShellRoute(
        // navigatorKey: mainNavigatorKey,
        builder: (context, state, child) {
          return Navigation(
            baseSetup: baseSetup,
            navigationList: navigation,
            child: child,
          );
        },
        // sarebbe da fare i sottoroutes, al momento è gestito con un show menu
        routes: navigation
            .map((element) => GoRoute(
                name: element.pageId,
                path: "/${element.pageId}",
                // server solo per le transizioni
                pageBuilder: (context, state) => NoTransitionPage<void>(
                      key: UniqueKey(),
                      child: ChangeNotifierProvider(
                        create: (context) => PageAppController(
                          pageId: element.pageId,
                          currentFilters: state.extra == null
                              ? []
                              : state.extra as List<Filter>,
                        ),
                        child: const page.Page(),
                      ),
                    )))
            .toList(),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    pageCtrl = PageAppController(pageId: 'navigationlist');
    futureRecords = pageCtrl.getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Record>>(
        future: futureRecords,
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.hasData) {
            return Consumer<BaseSetup>(builder: (context, baseSetup, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Material 3',
                themeMode: baseSetup.themeMode,
                theme: baseSetup.getThemeLight(),
                darkTheme: baseSetup.getThemeDark(),
                routerConfig:
                    createRouter(baseSetup, snapshot.data as List<Record>),
              );
            });
          } else {
            return Container();
          }
        });
  }
}
