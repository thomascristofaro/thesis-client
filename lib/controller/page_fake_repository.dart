import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:thesis_client/controller/layout.dart';
import 'package:thesis_client/controller/page_interface.dart';

class PageFakeRepository implements IPageRepository {
  @override
  Future<Layout> getLayout(String pageId) async {
    final String file =
        await rootBundle.loadString('assets/page/$pageId/page_layout.json');
    final Map<String, dynamic> map = await json.decode(file);
    return Layout.fromMap(map);
  }
}
