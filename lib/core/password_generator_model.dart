// Sort directives and use relative imports
import 'package:flutter/foundation.dart';
import 'package:passgen/core/logger.dart';
import 'package:passgen/core/password_generator.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/core/word_repository.dart';
import 'package:passgen/core/word_repository_interface.dart';
import 'package:passgen/models/password_params.dart';

/// A model class that manages the state of the password generator.
///
/// This class extends [ChangeNotifier] to provide state management for the UI.
/// It handles:
/// - Initializing the word repository, password generator, and settings manager
/// - Managing the current password parameters
/// - Generating passwords
/// - Saving and loading settings
class PasswordGeneratorModel extends ChangeNotifier {
  /// Creates a PasswordGeneratorModel with an optional word repository.
  ///
  /// If no word repository is provided, a default WordRepository will be used.
  PasswordGeneratorModel({IWordRepository? wordRepository}) {
    _wordRepository = wordRepository ?? WordRepository();
  }

  late IWordRepository _wordRepository;
  late PasswordGeneratorService _passwordGenerator;
  late SettingsManager _settingsManager;

  PasswordParams _currentParams = PasswordParams();
  String _currentPassword = '';
  bool _isInitialized = false;

  /// The current password parameters.
  PasswordParams get currentParams => _currentParams;

  /// The currently generated password.
  String get currentPassword => _currentPassword;

  /// Whether the model has been initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize the model by setting up all dependencies.
  ///
  /// This method initializes:
  /// - The word repository
  /// - The settings manager
  /// - The password generator
  /// - Loads saved settings
  /// - Generates the initial password
  Future<void> initialize() async {
    Logger.info('Initializing PasswordGeneratorModel');

    // Initialize word repository
    await _wordRepository.initialize();
    Logger.debug('Word repository initialized');

    // Initialize settings manager
    _settingsManager = SettingsManager();
    await _settingsManager.initialize();
    _currentParams = await _settingsManager.loadSettings();
    Logger.debug('Settings manager initialized');

    // Initialize password generator
    _passwordGenerator = PasswordGeneratorService(_wordRepository);
    Logger.debug('Password generator initialized');

    // Generate initial password
    _generatePassword();

    _isInitialized = true;
    notifyListeners();
  }

  /// A method for testing that sets up the model with test data.
  void setupForTesting(String password, PasswordParams params) {
    // Initialize the required fields for testing
    _currentPassword = password;
    _currentParams = params;
    _isInitialized = true;

    // Create mock services for testing
    _passwordGenerator = PasswordGeneratorService(_wordRepository);
    _settingsManager = SettingsManager();
  }

  /// Generate a new password using the current parameters.
  ///
  /// This method uses the password generator to create a new password
  /// and notifies listeners of the change.
  void _generatePassword() {
    try {
      _currentPassword = _passwordGenerator.generate(_currentParams);
      Logger.debug('Generated new password');
      notifyListeners();
    } catch (e) {
      Logger.error('Failed to generate password: $e');
      // Error handling would be done at the UI level
      rethrow;
    }
  }

  /// Regenerate the password with the current parameters.
  ///
  /// This method is called when the user wants to generate a new password
  /// with the same parameters.
  void regeneratePassword() => _generatePassword();

  /// Update the password parameters and regenerate the password.
  ///
  /// This method updates the current parameters and immediately generates
  /// a new password with the updated parameters.
  void updateParams(PasswordParams newParams) {
    _currentParams = newParams;
    notifyListeners();
    // Regenerate password when parameters change
    _generatePassword();
  }

  /// Save the given parameters to persistent storage.
  ///
  /// This method saves the provided parameters to the settings manager.
  Future<void> saveSettings(PasswordParams params) async =>
      _settingsManager.saveSettings(params);

  /// Load parameters from persistent storage.
  ///
  /// This method loads the saved parameters from the settings manager.
  Future<PasswordParams> loadSettings() async =>
      _settingsManager.loadSettings();
}