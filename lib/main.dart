import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/base_setup.dart';
import 'package:thesis_client/controller/navigation_model.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/pages/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/pages/page.dart' as page;
import 'package:thesis_client/pages/page_login.dart';

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
  GoRouter createRouter(BaseSetup baseSetup) {
    return GoRouter(initialLocation: "/login", routes: [
      GoRoute(
        name: 'login',
        path: "/login",
        builder: (context, state) => const PageLogin(),
      ),
      ShellRoute(
          // navigatorKey: mainNavigatorKey,
          builder: (context, state, child) {
            return Navigation(
              baseSetup: baseSetup,
              child: child,
            );
          },
          // sarebbe da fare i sottoroutes, al momento è gestito con un show menu
          routes: [
            GoRoute(
                name: 'page',
                path: "/page/:pageId",
                // server solo per le transizioni
                pageBuilder: (context, state) => NoTransitionPage<void>(
                      key: UniqueKey(),
                      child: ChangeNotifierProvider(
                        create: (context) => PageAppController(
                          pageId: state.pathParameters['pageId']!,
                          currentFilters: state.extra == null
                              ? []
                              : state.extra as List<Filter>,
                        ),
                        child: const page.Page(),
                      ),
                    ))
          ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseSetup>(builder: (context, baseSetup, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Material 3',
        themeMode: baseSetup.themeMode,
        theme: baseSetup.getThemeLight(),
        darkTheme: baseSetup.getThemeDark(),
        routerConfig: createRouter(baseSetup),
      );
    });
  }
}
