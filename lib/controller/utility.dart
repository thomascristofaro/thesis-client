import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thesis_client/controller/record.dart';

class Utility {
  static goPage(BuildContext context, String pageId, String url,
      {Object? filters}) {
    context.goNamed('page',
        pathParameters: {"pageId": pageId},
        extra: {"url": url, "filters": filters});
  }

  static pushPage(BuildContext context, String pageId, String url,
      {List<Filter> filters = const []}) {
    context.pushNamed('page',
        pathParameters: {"pageId": pageId},
        extra: {"url": url, "filters": filters});
  }

  static void showSnackBar(BuildContext context, String string) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 400.0,
      content: Text(string),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isDesktop() {
    return defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows;
  }
}
