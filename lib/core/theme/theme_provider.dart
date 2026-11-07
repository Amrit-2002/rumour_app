import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themePreferenceKey = 'app_theme_mode';

  final StorageService? _storageService;
  ThemeMode _themeMode;

  ThemeProvider([this._storageService]) : _themeMode = ThemeMode.dark {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() {
    if (_storageService == null) return;
    final savedMode = _storageService.getString(themePreferenceKey);
    if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedMode == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.dark;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    if (_storageService != null) {
      String value;
      switch (mode) {
        case ThemeMode.light:
          value = 'light';
          break;
        case ThemeMode.dark:
          value = 'dark';
          break;
        case ThemeMode.system:
          value = 'system';
          break;
      }
      await _storageService.setString(themePreferenceKey, value);
    }
  }

  Future<void> toggleTheme(BuildContext context) async {
    final isDark = isDarkMode(context);
    await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
}
