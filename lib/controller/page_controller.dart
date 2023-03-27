import 'package:thesis_client/controller/page_interface.dart';
import 'package:thesis_client/controller/page_fake_repository.dart';

import 'layout.dart';

class PageController {
  final String pageId;
  late IPageRepository _pageRepo;

  PageController(this.pageId) {
    _pageRepo = PageFakeRepository();
  }

  Future<Layout> getLayout() {
    return _pageRepo.getLayout(pageId);
  }
}
