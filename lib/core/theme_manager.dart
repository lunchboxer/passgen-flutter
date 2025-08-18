import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/app_theme.dart';
import 'settings_manager.dart';
import 'theme_manager_interface.dart';

/// Manages the application theme state and provides theme data
class ThemeManager implements IThemeManager {
  ThemeManager(this._settingsManager);
  final SettingsManager _settingsManager;

  @override
  AppTheme getCurrentTheme() {
    final themeString = _settingsManager.getSetting('theme', 'system');
    switch (themeString) {
      case 'dark':
        return AppTheme.dark;
      case 'black':
        return AppTheme.black;
      case 'light':
        return AppTheme.light;
      default:
        // Handle 'system' and unexpected theme values
        return AppTheme.system;
    }
  }

  @override
  void setTheme(AppTheme theme) {
    final themeString = theme.toString().split('.').last;
    _settingsManager.setSetting('theme', themeString);
  }

  @override
  ThemeData getThemeData() {
    final currentTheme = getCurrentTheme();

    // For system theme, we need to check the platform brightness
    if (currentTheme == AppTheme.system) {
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

    switch (currentTheme) {
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
      default:
        // Handle AppTheme.light and any other cases
        return ThemeData.light();
    }
  }
}
