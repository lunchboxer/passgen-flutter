class PasswordParams {
  final int wordCount;
  final bool capitalize;
  final String separator;
  final bool appendNumber;
  final bool appendSymbol;
  final int? lengthConstraint;

  PasswordParams({
    this.wordCount = 3,
    this.capitalize = true,
    this.separator = '-',
    this.appendNumber = false,
    this.appendSymbol = false,
    this.lengthConstraint,
  });

  /// Creates a new PasswordParams with updated values
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

  /// Validates the parameters
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