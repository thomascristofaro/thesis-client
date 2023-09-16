import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesis_client/base_setup.dart';
import 'package:thesis_client/controller/firebase_controller.dart';
import 'package:thesis_client/controller/login_controller.dart';
import 'package:thesis_client/controller/page_controller.dart';
import 'package:thesis_client/controller/record.dart';
import 'package:thesis_client/pages/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/pages/page.dart' as page;
import 'package:thesis_client/pages/page_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FireBaseController().initToken();
  runApp(
    ChangeNotifierProvider(
      create: (context) => BaseSetup(),
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  GoRouter createRouter() {
    return GoRouter(
        initialLocation: LoginController().isLogged() ? "/page/home" : "/login",
        routes: [
          ShellRoute(
              // navigatorKey: mainNavigatorKey,
              builder: (context, state, child) {
                return Navigation(
                  pageStartIndex: LoginController().isLogged() ? 1 : 0,
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  name: 'login',
                  path: "/login",
                  // builder: (context, state) => const PageLogin(),
                  pageBuilder: (context, state) => NoTransitionPage<void>(
                    key: UniqueKey(),
                    child: const PageLogin(),
                  ),
                ),
                // GoRoute(
                //   name: 'user',
                //   path: "/user",
                //   builder: (context, state) => const PageLogin(),
                // ),
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

  // da capire come gestire il login all'apertura dell'applicazione
  // mettere il file html per quello web

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseSetup>(builder: (context, baseSetup, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Material 3',
        themeMode: baseSetup.themeMode,
        theme: baseSetup.getThemeLight(),
        darkTheme: baseSetup.getThemeDark(),
        routerConfig: createRouter(),
      );
    });
  }
}
