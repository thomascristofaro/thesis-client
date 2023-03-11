import 'package:flutter/widgets.dart';

class InfiniteScrollController extends ScrollController {
  final VoidCallback? onLoadMore;

  InfiniteScrollController({required this.onLoadMore}) {
    if (onLoadMore != null) addListener(_endListener);
  }

  void _endListener() {
    // if (position.extentAfter < 500) {
    if (position.pixels == position.maxScrollExtent) {
      onLoadMore?.call();
    }
  }

  @override
  void dispose() {
    if (onLoadMore != null) removeListener(_endListener);
    super.dispose();
  }
}
