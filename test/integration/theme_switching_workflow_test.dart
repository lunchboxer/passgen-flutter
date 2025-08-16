// Integration tests for theme switching workflows
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/core/theme_manager.dart';
import 'package:passgen/models/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Theme Switching Workflows', () {
    late SettingsManager settingsManager;
    late ThemeManager themeManager;

    setUp(() async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      settingsManager = SettingsManager();
      await settingsManager.initialize();
      themeManager = ThemeManager(settingsManager);
    });

    testWidgets('Theme change propagation through theme manager', (
      tester,
    ) async {
      // Verify initial theme is light
      expect(themeManager.getCurrentTheme(), AppTheme.light);

      // Change theme to dark
      themeManager.setTheme(AppTheme.dark);

      // Verify theme changed to dark
      expect(themeManager.getCurrentTheme(), AppTheme.dark);

      // Change theme to black
      themeManager.setTheme(AppTheme.black);

      // Verify theme changed to black
      expect(themeManager.getCurrentTheme(), AppTheme.black);

      // Change theme back to light
      themeManager.setTheme(AppTheme.light);

      // Verify theme changed to light
      expect(themeManager.getCurrentTheme(), AppTheme.light);
    });

    testWidgets('Theme persistence across app sessions', (tester) async {
      // Set theme to dark
      themeManager.setTheme(AppTheme.dark);

      // Verify theme is dark
      expect(themeManager.getCurrentTheme(), AppTheme.dark);

      // Create a new ThemeManager instance (simulating app restart)
      final newSettingsManager = SettingsManager();
      await newSettingsManager.initialize();
      final newThemeManager = ThemeManager(newSettingsManager);

      // Verify the theme is still dark
      expect(newThemeManager.getCurrentTheme(), AppTheme.dark);
    });

    testWidgets('Theme switching performance', (tester) async {
      // Measure theme switching performance
      final stopwatch = Stopwatch()..start();

      // Switch theme multiple times
      themeManager.setTheme(AppTheme.dark);
      themeManager.setTheme(AppTheme.light);
      themeManager.setTheme(AppTheme.black);
      themeManager.setTheme(AppTheme.light);

      stopwatch.stop();

      // Verify theme switching is fast (less than 100ms for 4 switches)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    testWidgets('Theme data generation for all themes', (tester) async {
      // Test light theme data
      themeManager.setTheme(AppTheme.light);
      final lightThemeData = themeManager.getThemeData();
      expect(lightThemeData.brightness, Brightness.light);

      // Test dark theme data
      themeManager.setTheme(AppTheme.dark);
      final darkThemeData = themeManager.getThemeData();
      expect(darkThemeData.brightness, Brightness.dark);

      // Test black theme data
      themeManager.setTheme(AppTheme.black);
      final blackThemeData = themeManager.getThemeData();
      expect(blackThemeData.brightness, Brightness.dark);
      expect(blackThemeData.scaffoldBackgroundColor, Colors.black);
    });
  });
}
