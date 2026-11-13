import 'package:flutter/material.dart';
import 'package:product_app/storage/theme_storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._storage) : _themeMode = _storage.read();

  final ThemeStorage _storage;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _storage.write(mode);
  }

  Future<void> toggleTheme() =>
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
}