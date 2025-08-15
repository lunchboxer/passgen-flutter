// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Sort directives
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/core/password_generator_model.dart';
import '../lib/core/word_repository_interface.dart';
import 'package:passgen/main.dart';
import '../lib/models/password_params.dart';
import 'package:provider/provider.dart';

// Relative imports should come after package imports
import 'mock_word_repository.dart';

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
      create: (context) {
        final model = PasswordGeneratorModel(wordRepository: wordRepository);
        model.setupForTesting('test-password', PasswordParams());
        return model;
      },
      child: const MainScreen(),
    );
  }
}

void main() {
  testWidgets(
    'App starts and displays password',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final mockRepository = MockWordRepository();
      await tester.pumpWidget(TestApp(wordRepository: mockRepository));

      // Wait for the app to initialize
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the app title is displayed
      expect(find.text('Passgen'), findsOneWidget);

      // Verify that a password is displayed
      // Find the first Text widget which should be the password display
      final passwordFinder = find.byType(Text).first;
      expect(passwordFinder, findsOneWidget);

      // Get the text of the password
      final passwordText =
          (passwordFinder.evaluate().single.widget as Text).data;
      expect(passwordText, isNotNull);
      expect(passwordText, isNotEmpty);
    },
  );
}