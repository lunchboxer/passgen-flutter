import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passgen/ui/components/parameter_controls_panel.dart';
import 'package:passgen/models/password_params.dart';

void main() {
  group('ParameterControlsPanel', () {
    final testParams = PasswordParams(
      wordCount: 3,
      capitalize: true,
      separator: '-',
      appendNumber: false,
      appendSymbol: false,
    );

    testWidgets('renders all controls with correct initial values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ParameterControlsPanel(
            params: testParams,
            onParamsChanged: (params) {},
          ),
        ),
      );

      // Check word count slider
      expect(find.text('Word Count: '), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Check switches
      expect(find.text('Capitalize Words'), findsOneWidget);
      expect(find.byType(Switch), findsNWidgets(3));

      // Check separator text field
      expect(find.text('Separator:'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('updates word count when slider is moved', (
      WidgetTester tester,
    ) async {
      late PasswordParams updatedParams;
      await tester.pumpWidget(
        MaterialApp(
          home: ParameterControlsPanel(
            params: testParams,
            onParamsChanged: (params) {
              updatedParams = params;
            },
          ),
        ),
      );

      // Find the slider and move it to a specific value
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pump();

      // Verify that onParamsChanged was called
      expect(updatedParams, isNotNull);
    });

    testWidgets('toggles capitalize switch', (WidgetTester tester) async {
      late PasswordParams updatedParams;
      await tester.pumpWidget(
        MaterialApp(
          home: ParameterControlsPanel(
            params: testParams,
            onParamsChanged: (params) {
              updatedParams = params;
            },
          ),
        ),
      );

      // Find the capitalize switch and toggle it
      final switchFinder = find.widgetWithText(
        SwitchListTile,
        'Capitalize Words',
      );
      await tester.tap(switchFinder);

      // Verify that onParamsChanged was called with updated params
      expect(updatedParams.capitalize, isFalse);
    });

    testWidgets('updates separator when text field is changed', (
      WidgetTester tester,
    ) async {
      late PasswordParams updatedParams;
      await tester.pumpWidget(
        MaterialApp(
          home: ParameterControlsPanel(
            params: testParams,
            onParamsChanged: (params) {
              updatedParams = params;
            },
          ),
        ),
      );

      // Find the text field and enter a new separator
      final textField = find.byType(TextField);
      await tester.enterText(textField, '_');

      // Verify that onParamsChanged was called with updated params
      expect(updatedParams.separator, equals('_'));
    });
  });
}
