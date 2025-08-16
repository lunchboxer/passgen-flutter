// Sort imports alphabetically
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/password_generator_model.dart';
import 'package:passgen/core/word_repository_interface.dart';
import 'package:passgen/main.dart';
import 'package:passgen/models/password_params.dart';
import 'package:passgen/ui/settings_screen.dart';
import 'package:provider/provider.dart';
import '../mock_theme_manager.dart';

// Relative imports should come after package imports

class TestApp extends StatelessWidget {
  const TestApp({required this.wordRepository, required this.model, super.key});
  final IWordRepository wordRepository;
  final PasswordGeneratorModel model;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Passgen',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: TestHome(wordRepository: wordRepository, model: model),
  );
}

class TestHome extends StatelessWidget {
  const TestHome({
    required this.wordRepository,
    required this.model,
    super.key,
  });
  final IWordRepository wordRepository;
  final PasswordGeneratorModel model;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider.value(value: model, child: const MainScreen());
}

void main() {
  group('Application Functionality', () {
    testWidgets('Settings screen can update parameters', (tester) async {
      final savedParams = ValueNotifier<PasswordParams?>(null);
      final mockThemeManager = MockThemeManager();

      await tester.pumpWidget(
        MaterialApp(
          home: SettingsScreen(
            currentParams: PasswordParams(),
            themeManager: mockThemeManager,
            onSave: (params) => savedParams.value = params,
          ),
        ),
      );

      // Change settings
      // Change separator
      final separatorField = find.byType(TextField).first;
      await tester.enterText(separatorField, '_');
      await tester.pump(const Duration(milliseconds: 100));

      // Save settings
      // Ignore the warning about the button being off-screen
      await tester.tap(find.byIcon(Icons.save), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));

      // Check that the onSave callback was called with updated params
      expect(savedParams.value, isNotNull);
      expect(savedParams.value!.separator, equals('_'));
    });

    testWidgets('Settings screen can toggle capitalize switch', (tester) async {
      final savedParams = ValueNotifier<PasswordParams?>(null);
      final mockThemeManager = MockThemeManager();

      await tester.pumpWidget(
        MaterialApp(
          home: SettingsScreen(
            currentParams: PasswordParams(),
            themeManager: mockThemeManager,
            onSave: (params) => savedParams.value = params,
          ),
        ),
      );

      // Change settings
      // Toggle capitalize switch
      await tester.tap(find.widgetWithText(SwitchListTile, 'Capitalize Words'));
      await tester.pump(const Duration(milliseconds: 100));

      // Save settings
      // Ignore the warning about the button being off-screen
      await tester.tap(find.byIcon(Icons.save), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));

      // Check that the onSave callback was called with updated params
      expect(savedParams.value, isNotNull);
      // The default value is true, so toggling it should make it false
      expect(savedParams.value!.capitalize, isFalse);
    });
  });
}
