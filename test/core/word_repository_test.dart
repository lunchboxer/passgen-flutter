import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/word_repository.dart';

void main() {
  group('WordRepository', () {
    late WordRepository repository;

    setUp(() {
      repository = WordRepository();
    });

    test('should initialize with empty word lists', () {
      expect(repository.primaryWordList, isEmpty);
      expect(repository.shortWordList, isEmpty);
    });

    test(
      'should throw error when getting word from uninitialized repository',
      () {
        expect(() => repository.getRandomWord(), throwsStateError);
        expect(() => repository.getRandomWord(maxLength: 5), throwsStateError);
      },
    );
  });
}
