import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:passgen/core/logger.dart';
import 'package:passgen/core/word_repository_interface.dart';
import 'package:passgen/core/word_list_verifier.dart';
import 'package:passgen/core/security_service.dart';

/// A repository that manages word lists for password generation.
///
/// This class implements the [IWordRepository] interface and is responsible for:
/// - Loading word lists from assets
/// - Verifying the integrity of word lists
/// - Providing random words for password generation
class WordRepository implements IWordRepository {
  final Random _random = Random();
  List<String> _primaryWordList = [];
  List<String> _shortWordList = [];

  @override
  Future<void> initialize() async {
    Logger.info('Initializing WordRepository');
    try {
      // Verify word lists before loading them (security check)
      if (SecurityService.shouldEnableScreenRecordingProtection()) {
        final isPrimaryValid = await WordListVerifier.verifyWordList(
          'assets/words.txt',
        );
        final isShortValid = await WordListVerifier.verifyWordList(
          'assets/short-words.txt',
        );

        // Perform additional content verification
        final isPrimaryContentValid =
            await WordListVerifier.verifyWordListContent('assets/words.txt');
        final isShortContentValid =
            await WordListVerifier.verifyWordListContent(
              'assets/short-words.txt',
            );

        if (!isPrimaryValid ||
            !isShortValid ||
            !isPrimaryContentValid ||
            !isShortContentValid) {
          Logger.error(
            'Word list verification failed. '
            'Primary checksum: $isPrimaryValid, Short checksum: $isShortValid, '
            'Primary content: $isPrimaryContentValid, Short content: $isShortContentValid',
          );
          throw StateError('Word list integrity check failed');
        }

        Logger.info('Word list verification passed');
      } else {
        Logger.debug('Word list verification skipped in debug mode');
      }

      // Load primary word list
      final primaryWords = await rootBundle.loadString('assets/words.txt');
      _primaryWordList = primaryWords
          .split('\n')
          .map((word) => word.trim())
          .where((word) => word.isNotEmpty)
          .toList();

      Logger.info('Loaded ${_primaryWordList.length} primary words');

      // Load short word list
      final shortWords = await rootBundle.loadString('assets/short-words.txt');
      _shortWordList = shortWords
          .split('\n')
          .map((word) => word.trim())
          .where((word) => word.isNotEmpty)
          .toList();

      Logger.info('Loaded ${_shortWordList.length} short words');
    } catch (e) {
      Logger.error('Failed to load word lists: $e');
      rethrow;
    }
  }

  @override
  String getRandomWord({int? maxLength}) {
    // If no max length is specified, use the primary word list
    if (maxLength == null) {
      if (_primaryWordList.isEmpty) {
        throw StateError('Word repository not initialized');
      }
      return _primaryWordList[_random.nextInt(_primaryWordList.length)];
    }

    // Filter words by length constraint
    final filteredWords = _primaryWordList
        .where((word) => word.length <= maxLength)
        .toList();

    // If we have filtered words, use them
    if (filteredWords.isNotEmpty) {
      return filteredWords[_random.nextInt(filteredWords.length)];
    }

    // Fallback to short word list if no words meet the constraint
    if (_shortWordList.isEmpty) {
      throw StateError('Word repository not initialized');
    }

    // Filter short words by length constraint
    final filteredShortWords = _shortWordList
        .where((word) => word.length <= maxLength)
        .toList();

    if (filteredShortWords.isNotEmpty) {
      return filteredShortWords[_random.nextInt(filteredShortWords.length)];
    }

    // If no words meet the constraint, return any short word
    return _shortWordList[_random.nextInt(_shortWordList.length)];
  }

  /// Get the primary word list (for testing purposes).
  List<String> get primaryWordList => _primaryWordList;

  /// Get the short word list (for testing purposes).
  List<String> get shortWordList => _shortWordList;
}
