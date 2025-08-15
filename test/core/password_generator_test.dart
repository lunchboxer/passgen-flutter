import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/password_generator.dart';
import '../../lib/core/word_repository_interface.dart';
import '../../lib/models/password_params.dart';

// Mock implementation of IWordRepository for testing
class MockWordRepository implements IWordRepository {
  @override
  Future<void> initialize() async {}

  @override
  String getRandomWord({int? maxLength}) {
    // Return a fixed word for testing predictability
    return 'test';
  }
}

void main() {
  group('PasswordGeneratorService', () {
    late PasswordGeneratorService generator;
    late MockWordRepository mockRepository;

    setUp(() {
      mockRepository = MockWordRepository();
      generator = PasswordGeneratorService(mockRepository);
    });

    test('should generate password with default parameters', () {
      final params = PasswordParams();
      final password = generator.generate(params);

      // With default params: 3 words, capitalize=true, separator='-'
      // Expected: "Test-Test-Test"
      expect(password, equals('Test-Test-Test'));
    });

    test('should generate password with custom separator', () {
      final params = PasswordParams(separator: '_');
      final password = generator.generate(params);

      // Expected: "Test_Test_Test"
      expect(password, equals('Test_Test_Test'));
    });

    test('should generate password without capitalization', () {
      final params = PasswordParams(capitalize: false);
      final password = generator.generate(params);

      // Expected: "test-test-test"
      expect(password, equals('test-test-test'));
    });

    test('should generate password with appended number', () {
      final params = PasswordParams(appendNumber: true);
      final password = generator.generate(params);

      // Expected: "Test-Test-Test" + single digit
      expect(password.startsWith('Test-Test-Test'), isTrue);
      expect(
        password.length,
        equals(15),
      ); // "Test" (4) * 3 = 12 + "-" (1) * 2 = 2 + digit (1) = 15
      final lastChar = password.substring(password.length - 1);
      expect(int.tryParse(lastChar), isNotNull);
    });

    test('should generate password with appended symbol', () {
      final params = PasswordParams(appendSymbol: true);
      final password = generator.generate(params);

      // Expected: "Test-Test-Test" + single symbol
      expect(password.startsWith('Test-Test-Test'), isTrue);
      expect(
        password.length,
        equals(15),
      ); // "Test" (4) * 3 = 12 + "-" (1) * 2 = 2 + symbol (1) = 15
      final lastChar = password.substring(password.length - 1);
      expect(['!', '@', '#', '\$', '%', '&', '*'].contains(lastChar), isTrue);
    });

    test('should generate password with both appended number and symbol', () {
      final params = PasswordParams(appendNumber: true, appendSymbol: true);
      final password = generator.generate(params);

      // Expected: "Test-Test-Test" + single digit + single symbol
      expect(password.startsWith('Test-Test-Test'), isTrue);
      expect(
        password.length,
        equals(16),
      ); // "Test" (4) * 3 = 12 + "-" (1) * 2 = 2 + digit (1) + symbol (1) = 16
    });

    test('should throw error for invalid parameters', () {
      final invalidParams = PasswordParams(wordCount: 0);
      expect(() => generator.generate(invalidParams), throwsArgumentError);
    });
  });
}
