/// A class that represents the parameters for password generation.
///
/// This class holds all the configurable options for generating passwords,
/// such as the number of words, capitalization, separator character, and
/// whether to append numbers or symbols.
class PasswordParams {
  /// The number of words to include in the password.
  ///
  /// Must be between 1 and 10. Defaults to 3.
  final int wordCount;

  /// Whether to capitalize the first letter of each word.
  ///
  /// Defaults to true.
  final bool capitalize;

  /// The character to use as a separator between words.
  ///
  /// Must be a single character. Defaults to '-'.
  final String separator;

  /// Whether to append a random number to the password.
  ///
  /// Defaults to false.
  final bool appendNumber;

  /// Whether to append a random symbol to the password.
  ///
  /// Defaults to false.
  final bool appendSymbol;

  /// A minimum length constraint for the password.
  ///
  /// If specified, the generated password will be at least this long.
  /// Must be at least 4 times the word count (assuming minimum word length of 4).
  final int? lengthConstraint;

  /// Creates a new PasswordParams with the specified values.
  ///
  /// If no values are provided, the default values are used.
  PasswordParams({
    this.wordCount = 3,
    this.capitalize = true,
    this.separator = '-',
    this.appendNumber = false,
    this.appendSymbol = false,
    this.lengthConstraint,
  });

  /// Creates a new PasswordParams with updated values.
  ///
  /// Any parameters that are not provided will retain their current values.
  PasswordParams copyWith({
    int? wordCount,
    bool? capitalize,
    String? separator,
    bool? appendNumber,
    bool? appendSymbol,
    int? lengthConstraint,
  }) {
    return PasswordParams(
      wordCount: wordCount ?? this.wordCount,
      capitalize: capitalize ?? this.capitalize,
      separator: separator ?? this.separator,
      appendNumber: appendNumber ?? this.appendNumber,
      appendSymbol: appendSymbol ?? this.appendSymbol,
      lengthConstraint: lengthConstraint ?? this.lengthConstraint,
    );
  }

  /// Validates the parameters.
  ///
  /// Returns true if all parameters are valid, false otherwise.
  /// Validation rules:
  /// - Word count must be between 1 and 10
  /// - Separator must be a single character
  /// - If length constraint is specified, it must be at least 4 times the word count
  bool validate() {
    // Word count must be between 1 and 10
    if (wordCount < 1 || wordCount > 10) {
      return false;
    }

    // Separator must be a single character
    if (separator.length != 1) {
      return false;
    }

    // If length constraint is specified, it must be at least 4 times the word count
    // (assuming minimum word length of 4 characters)
    if (lengthConstraint != null && lengthConstraint! < wordCount * 4) {
      return false;
    }

    return true;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PasswordParams &&
        other.wordCount == wordCount &&
        other.capitalize == capitalize &&
        other.separator == separator &&
        other.appendNumber == appendNumber &&
        other.appendSymbol == appendSymbol &&
        other.lengthConstraint == lengthConstraint;
  }

  @override
  int get hashCode {
    return Object.hash(
      wordCount,
      capitalize,
      separator,
      appendNumber,
      appendSymbol,
      lengthConstraint,
    );
  }

  @override
  String toString() {
    return 'PasswordParams(wordCount: $wordCount, capitalize: $capitalize, '
        'separator: $separator, appendNumber: $appendNumber, '
        'appendSymbol: $appendSymbol, lengthConstraint: $lengthConstraint)';
  }
}
