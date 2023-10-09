import 'package:flutter/material.dart';

class NavigationModel {
  final String pageId;
  final String caption;
  // aggiungere il menu
  final String tooltip;
  final int icon;
  final int selectedIcon;
  final String url;

  const NavigationModel(
      {required this.pageId,
      required this.caption,
      required this.tooltip,
      required this.icon,
      required this.selectedIcon,
      required this.url});

  NavigationModel.fromMap(Map<String, dynamic> data)
      : pageId = data['PageId'],
        caption = data['Caption'],
        tooltip = data['Tooltip'],
        icon = data['Icon'],
        selectedIcon = data['SelectedIcon'],
        url = data['URL'];

  Icon getIconWidget() {
    return Icon(IconData(icon, fontFamily: 'MaterialIcons'));
    // return const Icon(Icons.table_chart_outlined);
  }

  Icon getIconSelectedWidget() {
    return Icon(IconData(selectedIcon, fontFamily: 'MaterialIcons'));
  }
}
