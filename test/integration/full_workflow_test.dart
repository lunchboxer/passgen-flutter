// Sort directives
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/password_generator_model.dart';
import 'package:passgen/core/word_repository_interface.dart';
import 'package:passgen/main.dart';
import 'package:provider/provider.dart';

// Relative imports should come after package imports
import '../mock_word_repository.dart';

class TestApp extends StatelessWidget {

  const TestApp({
    required this.wordRepository, super.key,
  });
  final IWordRepository wordRepository;

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Passgen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TestHome(wordRepository: wordRepository),
    );
}

class TestHome extends StatelessWidget {

  const TestHome({
    required this.wordRepository, super.key,
  });
  final IWordRepository wordRepository;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) =>
          PasswordGeneratorModel(wordRepository: wordRepository)..initialize(),
      child: const MainScreen(),
    );
}

void main() {
  group('Full Application Workflow', () {
    testWidgets(
      'complete workflow from settings to password generation',
      (tester) async {
        final mockRepository = MockWordRepository();
        await tester.pumpWidget(TestApp(wordRepository: mockRepository));

        // Wait for the app to initialize
        await tester.pump(const Duration(milliseconds: 100));

        // Open settings
        await tester.tap(find.text('Settings'));
        await tester.pump(const Duration(milliseconds: 100));

        // Change settings
        // Change word count
        final slider = find.byType(Slider);
        await tester.drag(slider, const Offset(100, 0));
        await tester.pump(const Duration(milliseconds: 100));

        // Change separator
        final separatorField = find.byType(TextField).first;
        await tester.enterText(separatorField, '_');
        await tester.pump(const Duration(milliseconds: 100));

        // Save settings
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump(const Duration(milliseconds: 100));

        // Generate a new password with the new settings
        await tester.tap(find.widgetWithText(ElevatedButton, 'Regenerate'));
        await tester.pump(const Duration(milliseconds: 100));

        // Check that the password reflects the new settings
        final passwordFinder = find.byType(Text).first;
        final passwordText =
            (passwordFinder.evaluate().single.widget as Text).data;
        expect(passwordText, isNotNull);
        expect(passwordText, isNotEmpty);
        expect(
          passwordText,
          contains('_'),
        ); // Check that underscore separator is used
      },
    );

    testWidgets(
      'copy password after changing settings',
      (tester) async {
        final mockRepository = MockWordRepository();
        await tester.pumpWidget(TestApp(wordRepository: mockRepository));

        // Wait for the app to initialize
        await tester.pump(const Duration(milliseconds: 100));

        // Open settings
        await tester.tap(find.text('Settings'));
        await tester.pump(const Duration(milliseconds: 100));

        // Change settings
        // Toggle capitalize switch
        await tester.tap(find.widgetWithText(SwitchListTile,
          'Capitalize Words'));
        await tester.pump(const Duration(milliseconds: 100));

        // Save settings
        await tester.tap(find.byIcon(Icons.save));
        await tester.pump(const Duration(milliseconds: 100));

        // Generate a new password
        await tester.tap(find.widgetWithText(ElevatedButton, 
          'Regenerate'));
        await tester.pump(const Duration(milliseconds: 100));

        // Copy the password
        await tester.tap(find.widgetWithText(ElevatedButton,
          'Copy to Clipboard'));
        await tester.pump(const Duration(milliseconds: 100));

        // Check that the snackbar with "Password copied to clipboard" message
        // is displayed
        expect(find.text('Password copied to clipboard'), findsOneWidget);
      },
    );
  });
}
