import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(BuildContext context) {
    // What is currently rendered?
    final isDarkNow = Theme.of(context).brightness == Brightness.dark;

    if (_themeMode == ThemeMode.system) {
      // Switch to the opposite of what you see now
      _themeMode = isDarkNow ? ThemeMode.light : ThemeMode.dark;
    } else {
      // Flip between explicit light/dark
      _themeMode = (_themeMode == ThemeMode.dark)
          ? ThemeMode.light
          : ThemeMode.dark;
    }

    notifyListeners();
  }
}
