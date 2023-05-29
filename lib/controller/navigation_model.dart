import 'package:flutter/material.dart';

class NavigationModel {
  final String pageId;
  final String caption;
  final String tooltip;
  final int icon;
  final int selectedIcon;

  const NavigationModel({
    required this.pageId,
    required this.caption,
    required this.tooltip,
    required this.icon,
    required this.selectedIcon,
  });

  NavigationModel.fromMap(Map<String, dynamic> data)
      : pageId = data['page_id'],
        caption = data['caption'],
        tooltip = data['tooltip'],
        icon = data['icon'],
        selectedIcon = data['selected_icon'];

  Icon getIconWidget() {
    return Icon(IconData(icon, fontFamily: 'MaterialIcons'));
    // return const Icon(Icons.table_chart_outlined);
  }

  Icon getIconSelectedWidget() {
    return Icon(IconData(selectedIcon, fontFamily: 'MaterialIcons'));
  }
}
