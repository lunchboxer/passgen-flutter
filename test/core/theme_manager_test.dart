import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/core/theme_manager.dart';
import 'package:passgen/models/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeManager', () {
    late SettingsManager settingsManager;
    late ThemeManager themeManager;

    setUp(() async {
      // Initialize the binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();

      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      settingsManager = SettingsManager();
      await settingsManager.initialize();
      themeManager = ThemeManager(settingsManager);
    });

    test('getCurrentTheme returns system theme by default', () {
      final theme = themeManager.getCurrentTheme();
      expect(theme, AppTheme.system);
    });

    test('setTheme updates the current theme', () {
      themeManager.setTheme(AppTheme.dark);
      expect(themeManager.getCurrentTheme(), AppTheme.dark);

      themeManager.setTheme(AppTheme.black);
      expect(themeManager.getCurrentTheme(), AppTheme.black);

      themeManager.setTheme(AppTheme.light);
      expect(themeManager.getCurrentTheme(), AppTheme.light);

      themeManager.setTheme(AppTheme.system);
      expect(themeManager.getCurrentTheme(), AppTheme.system);
    });

    test('getThemeData returns correct ThemeData for each theme', () {
      // Test system theme (will depend on platform brightness, but should return valid ThemeData)
      themeManager.setTheme(AppTheme.system);
      final systemTheme = themeManager.getThemeData();
      expect(systemTheme, isA<ThemeData>());

      // Test light theme
      themeManager.setTheme(AppTheme.light);
      final lightTheme = themeManager.getThemeData();
      expect(lightTheme.brightness, Brightness.light);

      // Test dark theme
      themeManager.setTheme(AppTheme.dark);
      final darkTheme = themeManager.getThemeData();
      expect(darkTheme.brightness, Brightness.dark);

      // Test black theme
      themeManager.setTheme(AppTheme.black);
      final blackTheme = themeManager.getThemeData();
      expect(blackTheme.brightness, Brightness.dark);
      expect(blackTheme.scaffoldBackgroundColor, const Color(0xFF000000));
    });

    test('theme persists across ThemeManager instances', () async {
      // Set theme to dark
      themeManager.setTheme(AppTheme.dark);

      // Create a new ThemeManager instance
      final newSettingsManager = SettingsManager();
      await newSettingsManager.initialize();
      final newThemeManager = ThemeManager(newSettingsManager);

      // Verify the theme is still dark
      expect(newThemeManager.getCurrentTheme(), AppTheme.dark);
    });
  });
}
