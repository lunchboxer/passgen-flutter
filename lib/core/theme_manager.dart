import 'package:flutter/material.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/models/app_theme.dart';

/// Manages the application theme state and provides theme data
class ThemeManager {
  final SettingsManager _settingsManager;

  ThemeManager(this._settingsManager);

  /// Gets the current theme from settings
  AppTheme getCurrentTheme() {
    final themeString = _settingsManager.getSetting('theme', 'light');
    switch (themeString) {
      case 'dark':
        return AppTheme.dark;
      case 'black':
        return AppTheme.black;
      case 'light':
      default:
        return AppTheme.light;
    }
  }

  /// Sets the current theme in settings
  void setTheme(AppTheme theme) {
    final themeString = theme.toString().split('.').last;
    _settingsManager.setSetting('theme', themeString);
  }

  /// Gets the ThemeData for the current theme
  ThemeData getThemeData() {
    switch (getCurrentTheme()) {
      case AppTheme.dark:
        return ThemeData.dark().copyWith(
          // Custom dark theme properties can be added here
        );
      case AppTheme.black:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.grey[900],
          dialogBackgroundColor: Colors.grey[900],
        );
      case AppTheme.light:
      default:
        return ThemeData.light();
    }
  }
}