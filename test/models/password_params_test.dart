import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/password_params.dart';

void main() {
  group('PasswordParams', () {
    test('should create instance with default values', () {
      final params = PasswordParams();
      expect(params.wordCount, 3);
      expect(params.capitalize, true);
      expect(params.separator, '-');
      expect(params.appendNumber, false);
      expect(params.appendSymbol, false);
      expect(params.lengthConstraint, null);
    });

    test('should create instance with custom values', () {
      final params = PasswordParams(
        wordCount: 5,
        capitalize: false,
        separator: '_',
        appendNumber: true,
        appendSymbol: true,
        lengthConstraint: 20,
      );
      expect(params.wordCount, 5);
      expect(params.capitalize, false);
      expect(params.separator, '_');
      expect(params.appendNumber, true);
      expect(params.appendSymbol, true);
      expect(params.lengthConstraint, 20);
    });

    test('should copy with new values', () {
      final original = PasswordParams();
      final copied = original.copyWith(wordCount: 4, separator: '_');
      expect(copied.wordCount, 4);
      expect(copied.separator, '_');
      expect(copied.capitalize, true); // unchanged
    });

    test('should validate correct parameters', () {
      final validParams = PasswordParams(wordCount: 3, separator: '-');
      expect(validParams.validate(), true);
    });

    test('should invalidate incorrect word count', () {
      final invalidParams1 = PasswordParams(wordCount: 0);
      final invalidParams2 = PasswordParams(wordCount: 11);
      expect(invalidParams1.validate(), false);
      expect(invalidParams2.validate(), false);
    });

    test('should invalidate incorrect separator', () {
      final invalidParams = PasswordParams(separator: '--');
      expect(invalidParams.validate(), false);
    });

    test('should validate with length constraint', () {
      final validParams = PasswordParams(
        wordCount: 3,
        lengthConstraint: 12, // 3 words * 4 min chars = 12
      );
      expect(validParams.validate(), true);
    });

    test('should invalidate with insufficient length constraint', () {
      final invalidParams = PasswordParams(
        wordCount: 3,
        lengthConstraint: 11, // Less than 3 words * 4 min chars
      );
      expect(invalidParams.validate(), false);
    });

    test('should compare equal instances', () {
      final params1 = PasswordParams();
      final params2 = PasswordParams();
      expect(params1, equals(params2));
    });

    test('should compare unequal instances', () {
      final params1 = PasswordParams();
      final params2 = PasswordParams(wordCount: 4);
      expect(params1, isNot(equals(params2)));
    });
  });
}
