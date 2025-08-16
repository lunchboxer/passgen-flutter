import 'package:passgen/core/word_repository_interface.dart';

/// A mock implementation of IWordRepository for testing purposes.
///
/// This implementation provides a small set of predefined words and doesn't
/// require loading assets, making tests faster and more reliable.
class MockWordRepository implements IWordRepository {
  final List<String> _words = [
    'apple',
    'banana',
    'cherry',
    'date',
    'elderberry',
    'fig',
    'grape',
    'honeydew',
  ];

  @override
  Future<void> initialize() async {
    // Mock implementation - no async work needed
  }

  @override
  String getRandomWord({int? maxLength}) {
    if (maxLength != null) {
      final filteredWords = _words
          .where((word) => word.length <= maxLength)
          .toList();
      if (filteredWords.isNotEmpty) {
        return filteredWords.first;
      }
    }
    return _words[0]; // Return the first word if no filtering or no matches
  }
}
