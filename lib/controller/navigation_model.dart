import 'package:flutter/material.dart';
import 'package:thesis_client/controller/record.dart';

class NavigationModel {
  final String pageId;
  final String caption;
  final String tooltip;
  final String icon;
  final String selectedIcon;

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
        icon = data['icon'], // TODO da capire come prendere l'icon
        selectedIcon = data['selected_icon'];

  Icon getIconWidget() {
    return const Icon(Icons.table_chart_outlined);
  }

  Icon getIconSelectedWidget() {
    return const Icon(Icons.table_chart);
  }
}
