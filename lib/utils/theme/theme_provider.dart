import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple Theme provider to toggle between light and dark mode across the app.
class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'is_dark_mode';

  bool _isDarkMode = false;
  bool _initialized = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Ensures widgets can listen for the first value once the async load finishes.
  bool get isInitialized => _initialized;

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_prefKey) ?? false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isDarkMode);
  }
}
