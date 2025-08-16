/// An interface for word repositories.
///
/// This interface defines the contract for word repositories in the Passgen app.
/// Word repositories are responsible for loading word lists and providing random
/// words.
abstract class IWordRepository {
  /// Initialize the repository by loading word lists from assets.
  ///
  /// This method should be called before using the repository to ensure
  /// that all word lists are loaded and ready for use.
  Future<void> initialize();

  /// Get a random word from the appropriate word list.
  ///
  /// If [maxLength] is specified, only words with length less than or equal to
  /// maxLength are considered. This is useful when generating passwords with
  /// length constraints.
  String getRandomWord({int? maxLength});
}
