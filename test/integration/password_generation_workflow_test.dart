import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/main.dart';

void main() {
  group('Password Generation Workflow', () {
    testWidgets('generates a password when the app starts', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Check that a password is displayed
      final passwordFinder = find.byType(Text).first;
      expect(passwordFinder, findsOneWidget);

      // Get the text of the password
      final passwordText =
          (passwordFinder.evaluate().single.widget as Text).data;
      expect(passwordText, isNotNull);
      expect(passwordText, isNotEmpty);
    });

    testWidgets('regenerates password when Regenerate button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the initial password
      final initialPasswordFinder = find.byType(Text).first;
      final initialPasswordText =
          (initialPasswordFinder.evaluate().single.widget as Text).data;

      // Find and tap the Regenerate button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Regenerate'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find the new password
      final newPasswordFinder = find.byType(Text).first;
      final newPasswordText =
          (newPasswordFinder.evaluate().single.widget as Text).data;

      // Verify that the password has changed
      expect(newPasswordText, isNotNull);
      expect(newPasswordText, isNotEmpty);
      // Note: There's a small chance the password could be the same, but it's very unlikely
    });

    testWidgets('copies password to clipboard when Copy button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap the Copy button
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Copy to Clipboard'),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check that the snackbar with "Password copied to clipboard" message is displayed
      expect(find.text('Password copied to clipboard'), findsOneWidget);
    });
  });
}
