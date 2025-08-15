import 'package:flutter/foundation.dart';
import 'package:passgen/core/word_repository.dart';
import 'package:passgen/core/password_generator.dart';
import 'package:passgen/core/settings_manager.dart';
import 'package:passgen/models/password_params.dart';
import 'package:passgen/core/logger.dart';

class PasswordGeneratorModel extends ChangeNotifier {
  late WordRepository _wordRepository;
  late PasswordGeneratorService _passwordGenerator;
  late SettingsManager _settingsManager;
  
  PasswordParams _currentParams = PasswordParams();
  String _currentPassword = '';
  bool _isInitialized = false;
  
  PasswordParams get currentParams => _currentParams;
  String get currentPassword => _currentPassword;
  bool get isInitialized => _isInitialized;
  
  Future<void> initialize() async {
    Logger.info('Initializing PasswordGeneratorModel');
    
    // Initialize word repository
    _wordRepository = WordRepository();
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
  
  void regeneratePassword() {
    _generatePassword();
  }
  
  void updateParams(PasswordParams newParams) {
    _currentParams = newParams;
    notifyListeners();
    // Regenerate password when parameters change
    _generatePassword();
  }
  
  Future<void> saveSettings(PasswordParams params) async {
    await _settingsManager.saveSettings(params);
  }
  
  Future<PasswordParams> loadSettings() async {
    return _settingsManager.loadSettings();
  }
}