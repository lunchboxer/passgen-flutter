import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart' show sha256;
import 'package:passgen/core/logger.dart';

class WordListVerifier {
  // These are the expected SHA-256 checksums for our word lists
  static const Map<String, String> _expectedChecksums = {
    'assets/words.txt':
        '2bfb213ac8b44ff1ffa55122540270090be1eb9e8d36fc20a3ce7252d33277ea',
    'assets/short-words.txt':
        '5c4c9fc36b4855d126814286c84b5f3a8220478b1772898f0d1a16605eee1a45',
  };

  /// Verifies the integrity of a word list asset by calculating its SHA-256 checksum
  /// and comparing it with the expected value.
  ///
  /// Returns true if the checksum matches, false otherwise.
  static Future<bool> verifyWordList(String assetPath) async {
    try {
      // Load the asset as bytes
      final bytes = await rootBundle.load(assetPath);
      final byteData = bytes.buffer.asUint8List();

      // Calculate SHA-256 checksum
      final digest = sha256.convert(byteData);
      final calculatedChecksum = digest.toString();

      // Get expected checksum
      final expectedChecksum = _expectedChecksums[assetPath];

      if (expectedChecksum == null) {
        Logger.warn('No expected checksum found for $assetPath');
        return false;
      }

      // Compare checksums
      final isValid = calculatedChecksum == expectedChecksum;

      if (isValid) {
        Logger.info('Word list $assetPath verified successfully');
      } else {
        Logger.error(
          'Word list $assetPath verification failed. '
          'Expected: $expectedChecksum, Got: $calculatedChecksum',
        );
      }

      return isValid;
    } catch (e) {
      Logger.error('Failed to verify word list $assetPath: $e');
      return false;
    }
  }

  /// Performs additional integrity checks on the word list content
  static Future<bool> verifyWordListContent(String assetPath) async {
    try {
      // Load the asset as string
      final content = await rootBundle.loadString(assetPath);
      final lines = content.split('\n');

      // Check for empty lines
      final emptyLines = lines.where((line) => line.trim().isEmpty).length;
      if (emptyLines > 0) {
        Logger.warn('Word list $assetPath contains $emptyLines empty lines');
      }

      // Check for duplicate words
      final uniqueWords = <String>{};
      final duplicateWords = <String>[];

      for (final line in lines) {
        final word = line.trim();
        if (word.isNotEmpty) {
          if (!uniqueWords.add(word)) {
            duplicateWords.add(word);
          }
        }
      }

      if (duplicateWords.isNotEmpty) {
        Logger.warn(
          'Word list $assetPath contains ${duplicateWords.length} duplicate words',
        );
        // Log first few duplicates for debugging
        duplicateWords.take(5).forEach((word) {
          Logger.debug('Duplicate word: $word');
        });
      }

      // Check word length constraints
      final shortWords = lines.where((line) {
        final word = line.trim();
        return word.isNotEmpty && word.length < 3;
      }).toList();

      if (shortWords.isNotEmpty) {
        Logger.warn(
          'Word list $assetPath contains ${shortWords.length} words with less than 3 characters',
        );
        // Log first few short words for debugging
        shortWords.take(5).forEach((word) {
          Logger.debug('Short word: $word');
        });
      }

      // Check for non-lowercase words
      final nonLowercaseWords = lines.where((line) {
        final word = line.trim();
        return word.isNotEmpty && word != word.toLowerCase();
      }).toList();

      if (nonLowercaseWords.isNotEmpty) {
        Logger.warn(
          'Word list $assetPath contains ${nonLowercaseWords.length} non-lowercase words',
        );
        // Log first few non-lowercase words for debugging
        nonLowercaseWords.take(5).forEach((word) {
          Logger.debug('Non-lowercase word: $word');
        });
      }

      Logger.info('Word list $assetPath content verification completed');
      return true;
    } catch (e) {
      Logger.error('Failed to verify word list content $assetPath: $e');
      return false;
    }
  }

  /// Verifies all word lists and returns true only if all are valid
  static Future<bool> verifyAllWordLists() async {
    Logger.info('Verifying all word lists');

    bool allValid = true;

    for (final assetPath in _expectedChecksums.keys) {
      final isChecksumValid = await verifyWordList(assetPath);
      final isContentValid = await verifyWordListContent(assetPath);

      if (!isChecksumValid || !isContentValid) {
        allValid = false;
      }
    }

    if (allValid) {
      Logger.info('All word lists verified successfully');
    } else {
      Logger.error('Some word lists failed verification');
    }

    return allValid;
  }
}
