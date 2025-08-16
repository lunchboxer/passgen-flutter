import 'package:flutter/material.dart';

import '../models/app_theme.dart';
import 'settings_manager.dart';
import 'theme_manager_interface.dart';

/// Manages the application theme state and provides theme data
class ThemeManager implements IThemeManager {
  ThemeManager(this._settingsManager);
  final SettingsManager _settingsManager;

  @override
  AppTheme getCurrentTheme() {
    final themeString = _settingsManager.getSetting('theme', 'light');
    switch (themeString) {
      case 'dark':
        return AppTheme.dark;
      case 'black':
        return AppTheme.black;
      default:
        // Handle 'light' and unexpected theme values by returning light theme
        return AppTheme.light;
    }
  }

  @override
  void setTheme(AppTheme theme) {
    final themeString = theme.toString().split('.').last;
    _settingsManager.setSetting('theme', themeString);
  }

  @override
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
          dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),
        );
      default:
        // Handle AppTheme.light and any other cases
        return ThemeData.light();
    }
  }
}
