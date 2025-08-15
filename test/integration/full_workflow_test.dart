import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/main.dart';

void main() {
  group('Full Application Workflow', () {
    testWidgets('complete workflow from settings to password generation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Open settings
      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Change settings
      // Change word count
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Change separator
      final separatorField = find.byType(TextField).first;
      await tester.enterText(separatorField, '_');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Save settings
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Generate a new password with the new settings
      await tester.tap(find.widgetWithText(ElevatedButton, 'Regenerate'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

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
    });

    testWidgets('copy password after changing settings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Open settings
      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Change settings
      // Toggle capitalize switch
      await tester.tap(find.widgetWithText(SwitchListTile, 'Capitalize Words'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Save settings
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Generate a new password
      await tester.tap(find.widgetWithText(ElevatedButton, 'Regenerate'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Copy the password
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Copy to Clipboard'),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check that the snackbar with "Password copied to clipboard" message is displayed
      expect(find.text('Password copied to clipboard'), findsOneWidget);
    });
  });
}
