import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:passgen/models/password_params.dart';

/// A manager for handling user settings using secure storage.
///
/// This class is responsible for:
/// - Loading saved settings from secure storage
/// - Saving settings to secure storage
/// - Resetting settings to default values
///
/// Unlike [SettingsManager], this class uses FlutterSecureStorage which provides
/// encrypted storage for sensitive data.
class SecureSettingsManager {
  static const String _wordCountKey = 'wordCount';
  static const String _capitalizeKey = 'capitalize';
  static const String _separatorKey = 'separator';
  static const String _appendNumberKey = 'appendNumber';
  static const String _appendSymbolKey = 'appendSymbol';
  static const String _lengthConstraintKey = 'lengthConstraint';

  // Default values
  static const int _defaultWordCount = 3;
  static const bool _defaultCapitalize = true;
  static const String _defaultSeparator = '-';
  static const bool _defaultAppendNumber = false;
  static const bool _defaultAppendSymbol = false;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Load settings from secure storage.
  ///
  /// Returns a [PasswordParams] object with the loaded settings.
  /// If no settings are found, default values are used.
  Future<PasswordParams> loadSettings() async {
    final wordCountString = await _secureStorage.read(key: _wordCountKey);
    final capitalizeString = await _secureStorage.read(key: _capitalizeKey);
    final separator = await _secureStorage.read(key: _separatorKey);
    final appendNumberString = await _secureStorage.read(key: _appendNumberKey);
    final appendSymbolString = await _secureStorage.read(key: _appendSymbolKey);
    final lengthConstraintString = await _secureStorage.read(key: _lengthConstraintKey);

    final wordCount = int.tryParse(wordCountString ?? '') ?? _defaultWordCount;
    final capitalize = capitalizeString == 'true' ? true : (capitalizeString == 'false' ? false : _defaultCapitalize);
    final appendNumber = appendNumberString == 'true' ? true : (appendNumberString == 'false' ? false : _defaultAppendNumber);
    final appendSymbol = appendSymbolString == 'true' ? true : (appendSymbolString == 'false' ? false : _defaultAppendSymbol);
    final lengthConstraint = int.tryParse(lengthConstraintString ?? '');

    return PasswordParams(
      wordCount: wordCount,
      capitalize: capitalize,
      separator: separator ?? _defaultSeparator,
      appendNumber: appendNumber,
      appendSymbol: appendSymbol,
      lengthConstraint: lengthConstraint,
    );
  }

  /// Save settings to secure storage.
  ///
  /// Takes a [PasswordParams] object and saves its values to secure storage.
  Future<void> saveSettings(PasswordParams params) async {
    await _secureStorage.write(key: _wordCountKey, value: params.wordCount.toString());
    await _secureStorage.write(key: _capitalizeKey, value: params.capitalize.toString());
    await _secureStorage.write(key: _separatorKey, value: params.separator);
    await _secureStorage.write(key: _appendNumberKey, value: params.appendNumber.toString());
    await _secureStorage.write(key: _appendSymbolKey, value: params.appendSymbol.toString());
    
    // Handle nullable lengthConstraint
    if (params.lengthConstraint != null) {
      await _secureStorage.write(key: _lengthConstraintKey, value: params.lengthConstraint.toString());
    } else {
      await _secureStorage.delete(key: _lengthConstraintKey);
    }
  }

  /// Reset settings to default values.
  ///
  /// This method sets all settings back to their default values
  /// and removes any saved length constraint.
  Future<void> resetToDefaults() async {
    await _secureStorage.write(key: _wordCountKey, value: _defaultWordCount.toString());
    await _secureStorage.write(key: _capitalizeKey, value: _defaultCapitalize.toString());
    await _secureStorage.write(key: _separatorKey, value: _defaultSeparator);
    await _secureStorage.write(key: _appendNumberKey, value: _defaultAppendNumber.toString());
    await _secureStorage.write(key: _appendSymbolKey, value: _defaultAppendSymbol.toString());
    await _secureStorage.delete(key: _lengthConstraintKey);
  }
}