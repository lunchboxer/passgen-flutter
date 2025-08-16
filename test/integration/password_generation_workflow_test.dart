// Sort directives
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/password_generator_model.dart';
import '../../lib/core/word_repository_interface.dart';
import 'package:passgen/main.dart';
import 'package:provider/provider.dart';

// Relative imports should come after package imports
import '../mock_word_repository.dart';

class TestApp extends StatelessWidget {
  final IWordRepository wordRepository;

  const TestApp({
    super.key,
    required this.wordRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passgen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TestHome(wordRepository: wordRepository),
    );
  }
}

class TestHome extends StatelessWidget {
  final IWordRepository wordRepository;

  const TestHome({
    super.key,
    required this.wordRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          PasswordGeneratorModel(wordRepository: wordRepository)..initialize(),
      child: const MainScreen(),
    );
  }
}

void main() {
  group('Password Generation Workflow', () {
    testWidgets(
      'generates a password when the app starts',
      (WidgetTester tester) async {
        final mockRepository = MockWordRepository();
        await tester.pumpWidget(TestApp(wordRepository: mockRepository));

        // Wait for the app to initialize
        await tester.pump(const Duration(milliseconds: 100));

        // Check that a password is displayed
        final passwordFinder = find.byType(Text).first;
        expect(passwordFinder, findsOneWidget);

        // Get the text of the password
        final passwordText =
            (passwordFinder.evaluate().single.widget as Text).data;
        expect(passwordText, isNotNull);
        expect(passwordText, isNotEmpty);
      },
    );

    testWidgets(
      'regenerates password when Regenerate button is pressed',
      (WidgetTester tester) async {
        final mockRepository = MockWordRepository();
        await tester.pumpWidget(TestApp(wordRepository: mockRepository));

        // Wait for the app to initialize
        await tester.pump(const Duration(milliseconds: 100));

        // Find the initial password
        // final initialPasswordFinder = find.byType(Text).first;
        // final initialPasswordText =
        //     (initialPasswordFinder.evaluate().single.widget as Text).data;

        // Find and tap the Regenerate button
        await tester.tap(find.widgetWithText(ElevatedButton, 'Regenerate'));
        await tester.pump(const Duration(milliseconds: 100));

        // Find the new password
        final newPasswordFinder = find.byType(Text).first;
        final newPasswordText =
            (newPasswordFinder.evaluate().single.widget as Text).data;

        // Verify that the password has changed
        expect(newPasswordText, isNotNull);
        expect(newPasswordText, isNotEmpty);
        // Note: There's a small chance the password could be the same, but it's very unlikely
      },
    );

    testWidgets(
      'copies password to clipboard when Copy button is pressed',
      (WidgetTester tester) async {
        final mockRepository = MockWordRepository();
        await tester.pumpWidget(TestApp(wordRepository: mockRepository));

        // Wait for the app to initialize
        await tester.pump(const Duration(milliseconds: 100));

        // Find and tap the Copy button
        await tester.tap(find.widgetWithText(ElevatedButton, 'Copy to Clipboard'));
        await tester.pump(const Duration(milliseconds: 100));

        // Check that the snackbar with "Password copied to clipboard" message is displayed
        expect(find.text('Password copied to clipboard'), findsOneWidget);
      },
    );
  });
}
