import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/ui/components/action_buttons_row.dart';

void main() {
  group('ActionButtonsRow', () {
    testWidgets('renders both buttons with correct icons and text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ActionButtonsRow(
            onRegenerate: () {},
            onSettings: () {},
          ),
        ),
      );

      // Check regenerate button
      expect(find.text('Regenerate'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Check settings button
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onRegenerate callback when regenerate button is pressed',
        (WidgetTester tester) async {
      bool regenerateCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ActionButtonsRow(
            onRegenerate: () {
              regenerateCalled = true;
            },
            onSettings: () {},
          ),
        ),
      );

      await tester.tap(find.text('Regenerate'));
      expect(regenerateCalled, isTrue);
    });

    testWidgets('calls onSettings callback when settings button is pressed',
        (WidgetTester tester) async {
      bool settingsCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ActionButtonsRow(
            onRegenerate: () {},
            onSettings: () {
              settingsCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Settings'));
      expect(settingsCalled, isTrue);
    });
  });
}