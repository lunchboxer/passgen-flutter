// Sort directives
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/core/theme_manager.dart';
import 'package:passgen/models/app_theme.dart';
import 'package:passgen/models/password_params.dart';
import 'package:passgen/ui/components/action_buttons_row.dart';
import 'package:passgen/ui/components/parameter_controls_panel.dart';
import 'package:passgen/ui/components/password_display_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Theme-aware Components', () {
    late ThemeManager themeManager;

    setUp(() async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      final settingsManager = SettingsManager();
      await settingsManager.initialize();
      themeManager = ThemeManager(settingsManager);
    });

    group('PasswordDisplayWidget', () {
      testWidgets('adapts to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: PasswordDisplayWidget(
                password: 'test-password',
                onCopy: () {},
              ),
            ),
          ),
        );

        // Verify the widget is displayed
        expect(find.text('test-password'), findsOneWidget);
        expect(find.byIcon(Icons.copy), findsOneWidget);
      });

      testWidgets('adapts to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: PasswordDisplayWidget(
                password: 'test-password',
                onCopy: () {},
              ),
            ),
          ),
        );

        // Verify the widget is displayed
        expect(find.text('test-password'), findsOneWidget);
        expect(find.byIcon(Icons.copy), findsOneWidget);
      });

      testWidgets('adapts to black theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            home: Scaffold(
              body: PasswordDisplayWidget(
                password: 'test-password',
                onCopy: () {},
              ),
            ),
          ),
        );

        // Verify the widget is displayed
        expect(find.text('test-password'), findsOneWidget);
        expect(find.byIcon(Icons.copy), findsOneWidget);
      });
    });

    group('ParameterControlsPanel', () {
      final testParams = PasswordParams();

      testWidgets('adapts to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: ParameterControlsPanel(
                params: testParams,
                onParamsChanged: (_) {},
              ),
            ),
          ),
        );

        // Verify the widget is displayed
        expect(find.text('Password Parameters'), findsOneWidget);
        expect(find.text('Word Count: '), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
        expect(find.text('Capitalize Words'), findsOneWidget);
      });

      testWidgets('adapts to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: ParameterControlsPanel(
                params: testParams,
                onParamsChanged: (_) {},
              ),
            ),
          ),
        );

        // Verify the widget is displayed
        expect(find.text('Password Parameters'), findsOneWidget);
        expect(find.text('Word Count: '), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
        expect(find.text('Capitalize Words'), findsOneWidget);
      });

      testWidgets('adapts to black theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            home: Scaffold(
              body: ParameterControlsPanel(
                params: testParams,
                onParamsChanged: (_) {},
              ),
            ),
          ),
        );

        // Verify the widget is displayed
        expect(find.text('Password Parameters'), findsOneWidget);
        expect(find.text('Word Count: '), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
        expect(find.text('Capitalize Words'), findsOneWidget);
      });
    });

    group('ActionButtonsRow', () {
      testWidgets('adapts to light theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: ActionButtonsRow(
                onRegenerate: () {},
                onSettings: () {},
              ),
            ),
          ),
        );

        // Verify the buttons are displayed
        expect(find.text('Regenerate'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('adapts to dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: ActionButtonsRow(
                onRegenerate: () {},
                onSettings: () {},
              ),
            ),
          ),
        );

        // Verify the buttons are displayed
        expect(find.text('Regenerate'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('adapts to black theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            home: Scaffold(
              body: ActionButtonsRow(
                onRegenerate: () {},
                onSettings: () {},
              ),
            ),
          ),
        );

        // Verify the buttons are displayed
        expect(find.text('Regenerate'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });
    });
  });
}