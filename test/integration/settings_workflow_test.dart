import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/main.dart';

void main() {
  group('Settings Workflow', () {
    testWidgets('opens settings screen when Settings button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap the Settings button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check that we're on the Settings screen
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Default Password Parameters'), findsOneWidget);
    });

    testWidgets('changes password parameters and saves them', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap the Settings button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Change the word count
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Toggle the capitalize switch
      await tester.tap(find.widgetWithText(SwitchListTile, 'Capitalize Words'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the save button
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check that we're back on the main screen
      expect(find.text('Settings'), findsNothing);
      expect(find.text('Passgen'), findsOneWidget);
    });

    testWidgets('changes separator character in settings', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Wait for the app to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap the Settings button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find the separator text field and enter a new separator
      final separatorField = find.byType(TextField).first;
      await tester.enterText(separatorField, '_');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the save button
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check that we're back on the main screen
      expect(find.text('Settings'), findsNothing);
    });
  });
}
