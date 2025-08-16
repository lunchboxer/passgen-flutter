import 'dart:math';

import '../core/password_generator_interface.dart';
import '../core/word_repository_interface.dart';
import '../models/password_params.dart';

/// A service that generates passwords based on specified parameters.
///
/// This class implements the [IPasswordGenerator] interface and uses a word
/// repository to generate passwords using a word-based approach. It supports
/// various customization options such as word count, capitalization, separators,
/// and appending numbers or symbols.
class PasswordGeneratorService implements IPasswordGenerator {
  /// Creates a new PasswordGeneratorService with the specified word repository.
  PasswordGeneratorService(this._wordRepository);

  final IWordRepository _wordRepository;

  /// Common symbols for appending to passwords.
  static const List<String> _symbols = ['!', '@', '#', r'$', '%', '&', '*'];

  @override
  String generate(PasswordParams params) {
    // Validate parameters first
    if (!params.validate()) {
      throw ArgumentError('Invalid password parameters: $params');
    }

    // Determine max word length if constraint is specified
    int? maxWordLength;
    if (params.lengthConstraint != null) {
      // Calculate approximate max length per word
      // This is a rough calculation that accounts for separators and appended
      // elements
      var totalExtraChars = 0;
      if (params.appendNumber) {
        totalExtraChars += 1; // One digit
      }
      if (params.appendSymbol) {
        totalExtraChars += 1; // One symbol
      }

      // Subtract separators (wordCount - 1) and extra chars, then divide by
      // wordCount
      final availableChars =
          params.lengthConstraint! - (params.wordCount - 1) - totalExtraChars;

      if (availableChars > 0) {
        maxWordLength = availableChars ~/ params.wordCount;
      }
    }

    // Generate the words
    final words = <String>[];
    for (int i = 0; i < params.wordCount; i++) {
      var word = _wordRepository.getRandomWord(maxLength: maxWordLength);

      // Apply capitalization if requested
      if (params.capitalize && word.isNotEmpty) {
        word = word[0].toUpperCase() + word.substring(1);
      }

      words.add(word);
    }

    // Join words with separator
    var password = words.join(params.separator);

    // Append number if requested
    if (params.appendNumber) {
      final random = Random();
      final number = random.nextInt(10); // 0-9
      password += number.toString();
    }

    // Append symbol if requested
    if (params.appendSymbol) {
      final random = Random();
      final symbol = _symbols[random.nextInt(_symbols.length)];
      password += symbol;
    }

    return password;
  }
}
