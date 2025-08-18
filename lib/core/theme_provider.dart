import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/app_theme.dart';
import 'settings_manager.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(SettingsManager settingsManager)
    : _settingsManager = settingsManager {
    // Load the initial theme from settings
    final themeString = _settingsManager.getSetting('theme', 'system');
    _currentTheme = _stringToAppTheme(themeString);
  }
  late final SettingsManager _settingsManager;
  AppTheme _currentTheme = AppTheme.system;

  AppTheme get currentTheme => _currentTheme;

  ThemeData getThemeData() {
    // For system theme, we need to check the platform brightness
    if (_currentTheme == AppTheme.system) {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        return ThemeData.dark().copyWith(
          // Custom dark theme properties can be added here
        );
      } else {
        return ThemeData.light();
      }
    }

    switch (_currentTheme) {
      case AppTheme.dark:
        return ThemeData.dark().copyWith(
          // Custom dark theme properties can be added here
        );
      case AppTheme.black:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.grey[900],
          dialogTheme: const DialogThemeData(backgroundColor: Colors.grey),
        );
      case AppTheme.light:
        return ThemeData.light();
      default:
        // This case should not be reached, but providing a fallback
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
        return AppTheme.light;
      case 'system':
        return AppTheme.system;
      default:
        // Return default theme for unknown values
        return AppTheme.system;
    }
  }
}
