import 'package:flutter/material.dart';

import '../models/app_theme.dart';
import 'settings_manager.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(SettingsManager settingsManager)
    : _settingsManager = settingsManager {
    // Load the initial theme from settings
    final themeString = _settingsManager.getSetting('theme', 'light');
    _currentTheme = _stringToAppTheme(themeString);
  }
  late final SettingsManager _settingsManager;
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  ThemeData getThemeData() {
    switch (_currentTheme) {
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
      case AppTheme.light:
      default:
        return ThemeData.light();
    }
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    final themeString = theme.toString().split('.').last;
    _settingsManager.setSetting('theme', themeString);
    notifyListeners(); // This will rebuild the widgets that listen to this provider
  }

  AppTheme _stringToAppTheme(String themeString) {
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
}
