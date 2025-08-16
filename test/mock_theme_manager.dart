import 'package:flutter/material.dart';
import 'package:passgen/core/theme_manager_interface.dart';
import 'package:passgen/models/app_theme.dart';

class MockThemeManager implements IThemeManager {
  AppTheme _currentTheme = AppTheme.light;

  @override
  AppTheme getCurrentTheme() => _currentTheme;

  @override
  void setTheme(AppTheme theme) {
    _currentTheme = theme;
  }

  @override
  ThemeData getThemeData() {
    switch (_currentTheme) {
      case AppTheme.dark:
        return ThemeData.dark();
      case AppTheme.black:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        );
      default:
        // Handle AppTheme.light and any other cases
        return ThemeData.light();
    }
  }
}