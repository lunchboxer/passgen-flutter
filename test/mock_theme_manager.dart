import 'package:flutter/material.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/core/theme_provider.dart';
import 'package:passgen/models/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockThemeProvider extends ThemeProvider {
  MockThemeProvider() : super(_createMockSettingsManager());
  AppTheme _currentTheme = AppTheme.light;

  static SettingsManager _createMockSettingsManager() {
    // This is a simplified version for testing purposes
    final settingsManager = SettingsManager();
    // We'll manually set the SharedPreferences for testing
    // This is just for compilation, the actual implementation will be mocked
    SharedPreferences.setMockInitialValues({});
    return settingsManager;
  }

  @override
  AppTheme get currentTheme => _currentTheme;

  @override
  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    // Don't call notifyListeners in tests to avoid issues
  }

  @override
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
