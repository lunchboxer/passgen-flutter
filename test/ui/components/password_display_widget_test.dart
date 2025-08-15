import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/ui/components/password_display_widget.dart';

void main() {
  group('PasswordDisplayWidget', () {
    const testPassword = 'Test-Password-123';

    testWidgets('renders password correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PasswordDisplayWidget(
            password: testPassword,
            onCopy: () {},
          ),
        ),
      );

      expect(find.text(testPassword), findsOneWidget);
    });

    testWidgets('shows copy button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PasswordDisplayWidget(
            password: testPassword,
            onCopy: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('calls onCopy callback when copy button is pressed',
        (WidgetTester tester) async {
      bool copyCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: PasswordDisplayWidget(
            password: testPassword,
            onCopy: () {
              copyCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.copy));
      expect(copyCalled, isTrue);
      
      // Advance the timer to complete the test
      await tester.pumpAndSettle();
    });

    testWidgets('shows placeholder when password is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PasswordDisplayWidget(
            password: '',
            onCopy: () {},
          ),
        ),
      );

      expect(find.text('Generating...'), findsOneWidget);
    });
  });
}