import 'package:thesis_client/controller/layout.dart';

abstract class IPageRepository {
  Future<Layout> getLayout(String pageId);
}
