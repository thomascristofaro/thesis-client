import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Utility {
  static goPage(BuildContext context, String pageId) {
    context.goNamed('page', pathParameters: {"pageId": pageId});
  }

  static pushPage(BuildContext context, String pageId, {Object? extra}) {
    context.pushNamed('page', pathParameters: {"pageId": pageId}, extra: extra);
  }

  static void sendSnackBar(BuildContext context, String string) {
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
}
