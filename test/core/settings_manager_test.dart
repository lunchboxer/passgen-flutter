import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/models/password_params.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsManager', () {
    late SettingsManager settingsManager;

    setUp(() async {
      // Clear preferences before each test
      SharedPreferences.setMockInitialValues({});
      settingsManager = SettingsManager();
      await settingsManager.initialize();
    });

    test('should load default settings when no saved settings exist', () async {
      final params = await settingsManager.loadSettings();

      expect(params.wordCount, 3);
      expect(params.capitalize, true);
      expect(params.separator, '-');
      expect(params.appendNumber, false);
      expect(params.appendSymbol, false);
      expect(params.lengthConstraint, null);
    });

    test('should save and load settings', () async {
      final originalParams = PasswordParams(
        wordCount: 5,
        capitalize: false,
        separator: '_',
        appendNumber: true,
        appendSymbol: true,
        lengthConstraint: 20,
      );

      await settingsManager.saveSettings(originalParams);
      final loadedParams = await settingsManager.loadSettings();

      expect(loadedParams, equals(originalParams));
    });

    test('should handle null length constraint', () async {
      final params = PasswordParams();

      await settingsManager.saveSettings(params);
      final loadedParams = await settingsManager.loadSettings();

      expect(loadedParams.lengthConstraint, null);
    });

    test('should reset to default settings', () async {
      // First save custom settings
      final customParams = PasswordParams(
        wordCount: 5,
        capitalize: false,
        separator: '_',
      );
      await settingsManager.saveSettings(customParams);

      // Then reset to defaults
      await settingsManager.resetToDefaults();
      final defaultParams = await settingsManager.loadSettings();

      expect(defaultParams.wordCount, 3);
      expect(defaultParams.capitalize, true);
      expect(defaultParams.separator, '-');
      expect(defaultParams.appendNumber, false);
      expect(defaultParams.appendSymbol, false);
      expect(defaultParams.lengthConstraint, null);
    });
  });
}
