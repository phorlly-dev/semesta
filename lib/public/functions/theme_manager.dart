import 'package:flutter/material.dart';
import 'package:semesta/public/utils/share_storage.dart';

class ThemeManager with ChangeNotifier {
  static const _key = "app_theme_mode";
  final _prefs = ShareStorage();

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final stored = _prefs.getStorage(_key);

    if (stored == 'light') {
      _themeMode = ThemeMode.light;
    } else if (stored == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  void toggleTheme(BuildContext context) async {
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

    // SAVE to prefs
    await _prefs.setStorage(_key, _themeMode.name); // "light" / "dark"

    notifyListeners();
  }
}
