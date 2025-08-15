import 'package:shared_preferences/shared_preferences.dart';
import 'package:passgen/models/password_params.dart';

/// A manager for handling user settings using SharedPreferences.
///
/// This class is responsible for:
/// - Initializing the SharedPreferences instance
/// - Loading saved settings
/// - Saving settings
/// - Resetting settings to default values
class SettingsManager {
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

  late SharedPreferences _prefs;

  /// Initialize the SettingsManager by getting the SharedPreferences instance.
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Load settings from SharedPreferences.
  ///
  /// Returns a [PasswordParams] object with the loaded settings.
  /// If no settings are found, default values are used.
  Future<PasswordParams> loadSettings() async {
    final wordCount = _prefs.getInt(_wordCountKey) ?? _defaultWordCount;
    final capitalize = _prefs.getBool(_capitalizeKey) ?? _defaultCapitalize;
    final separator = _prefs.getString(_separatorKey) ?? _defaultSeparator;
    final appendNumber = _prefs.getBool(_appendNumberKey) ?? _defaultAppendNumber;
    final appendSymbol = _prefs.getBool(_appendSymbolKey) ?? _defaultAppendSymbol;
    final lengthConstraint = _prefs.getInt(_lengthConstraintKey); // null by default

    return PasswordParams(
      wordCount: wordCount,
      capitalize: capitalize,
      separator: separator,
      appendNumber: appendNumber,
      appendSymbol: appendSymbol,
      lengthConstraint: lengthConstraint,
    );
  }

  /// Save settings to SharedPreferences.
  ///
  /// Takes a [PasswordParams] object and saves its values to SharedPreferences.
  Future<void> saveSettings(PasswordParams params) async {
    await _prefs.setInt(_wordCountKey, params.wordCount);
    await _prefs.setBool(_capitalizeKey, params.capitalize);
    await _prefs.setString(_separatorKey, params.separator);
    await _prefs.setBool(_appendNumberKey, params.appendNumber);
    await _prefs.setBool(_appendSymbolKey, params.appendSymbol);
    
    // Handle nullable lengthConstraint
    if (params.lengthConstraint != null) {
      await _prefs.setInt(_lengthConstraintKey, params.lengthConstraint!);
    } else {
      await _prefs.remove(_lengthConstraintKey);
    }
  }

  /// Reset settings to default values.
  ///
  /// This method sets all settings back to their default values
  /// and removes any saved length constraint.
  Future<void> resetToDefaults() async {
    await _prefs.setInt(_wordCountKey, _defaultWordCount);
    await _prefs.setBool(_capitalizeKey, _defaultCapitalize);
    await _prefs.setString(_separatorKey, _defaultSeparator);
    await _prefs.setBool(_appendNumberKey, _defaultAppendNumber);
    await _prefs.setBool(_appendSymbolKey, _defaultAppendSymbol);
    await _prefs.remove(_lengthConstraintKey);
  }
}