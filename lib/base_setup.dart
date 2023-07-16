import 'package:flutter/material.dart';

import 'constants.dart';

class BaseSetup extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  bool useMaterial3 = true;

  ThemeData getThemeLight() {
    return ThemeData(
      colorSchemeSeed: colorSelected.color,
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
    );
  }

  ThemeData getThemeDark() {
    return ThemeData(
      colorSchemeSeed: colorSelected.color,
      useMaterial3: useMaterial3,
      brightness: Brightness.dark,
    );
  }

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void handleMaterialVersionChange() {
    useMaterial3 = !useMaterial3;
    notifyListeners();
  }

  void handleColorSelect(int value) {
    colorSelected = ColorSeed.values[value];
    notifyListeners();
  }
}
