import 'package:flutter/material.dart';

import '../models/app_theme.dart';

/// Interface for theme management functionality
abstract class IThemeManager {
  /// Gets the current theme
  AppTheme getCurrentTheme();

  /// Sets the current theme
  void setTheme(AppTheme theme);

  /// Gets the ThemeData for the current theme
  ThemeData getThemeData();
}
