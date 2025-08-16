// Sort imports alphabetically
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/password_generator_model.dart';
import 'package:passgen/core/word_repository_interface.dart';
import 'package:passgen/main.dart';
import 'package:passgen/models/password_params.dart';
import 'package:provider/provider.dart';

// Relative imports should come after package imports
import '../mock_word_repository.dart';

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
  group('Settings Workflow', () {
    testWidgets('opens settings screen when Settings button is pressed', (
      tester,
    ) async {
      final mockRepository = MockWordRepository();
      final model = PasswordGeneratorModel(wordRepository: mockRepository)
        ..setupForTesting('test-password', PasswordParams());

      await tester.pumpWidget(
        TestApp(wordRepository: mockRepository, model: model),
      );

      // Find and tap the Settings button
      await tester.tap(find.text('Settings'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));

      // Check that we're on the Settings screen
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Default Password Parameters'), findsOneWidget);
    });

    testWidgets('changes password parameters and saves them', (tester) async {
      final mockRepository = MockWordRepository();
      final model = PasswordGeneratorModel(wordRepository: mockRepository)
        ..setupForTesting('test-password', PasswordParams());

      await tester.pumpWidget(
        TestApp(wordRepository: mockRepository, model: model),
      );

      // Find and tap the Settings button
      await tester.tap(find.text('Settings'));
      await tester.pump(const Duration(milliseconds: 100));

      // Change the word count
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pump(const Duration(milliseconds: 100));

      // Toggle the capitalize switch
      await tester.tap(find.widgetWithText(SwitchListTile, 'Capitalize Words'));
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the save button
      await tester.tap(find.byIcon(Icons.save));
      await tester.pump(const Duration(milliseconds: 100));

      // Check that we're back on the main screen
      expect(find.text('Settings'), findsNothing);
      expect(find.text('Passgen'), findsOneWidget);
    });

    testWidgets('changes separator character in settings', (tester) async {
      final mockRepository = MockWordRepository();
      final model = PasswordGeneratorModel(wordRepository: mockRepository)
        ..setupForTesting('test-password', PasswordParams());

      await tester.pumpWidget(
        TestApp(wordRepository: mockRepository, model: model),
      );

      // Find and tap the Settings button
      await tester.tap(find.text('Settings'));
      await tester.pump(const Duration(milliseconds: 100));

      // Find the separator text field and enter a new separator
      final separatorField = find.byType(TextField).first;
      await tester.enterText(separatorField, '_');
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the save button
      await tester.tap(find.byIcon(Icons.save));
      await tester.pump(const Duration(milliseconds: 100));

      // Check that we're back on the main screen
      expect(find.text('Settings'), findsNothing);
    });
  });
}
