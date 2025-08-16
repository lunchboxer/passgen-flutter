import 'package:flutter/material.dart';
import 'package:passgen/models/app_theme.dart';

class MockThemeProvider {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    // Don't call notifyListeners in tests to avoid issues
  }

  ThemeData getThemeData() {
    switch (_currentTheme) {
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.black:
        return ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black);
      default:
        // Handle AppTheme.light and any other cases
        return ThemeData.light();
    }
  }
}
