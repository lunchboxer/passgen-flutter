abstract class IWordRepository {
  /// Initialize the repository by loading word lists from assets
  Future<void> initialize();

  /// Get a random word from the appropriate word list
  /// If [maxLength] is specified, only words with length <= maxLength are considered
  String getRandomWord({int? maxLength});
}