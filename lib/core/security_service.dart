import 'package:passgen/core/debug_mode_checker.dart';
import 'package:passgen/core/logger.dart';

class SecurityService {
  /// Checks if clipboard monitoring is allowed
  /// In debug mode, we might want to disable certain security features for testing
  static bool isClipboardMonitoringAllowed() {
    // In release mode, clipboard monitoring is always allowed
    // In debug mode, it's controlled by a flag for testing purposes
    final isAllowed =
        DebugModeChecker.isReleaseMode ||
        DebugModeChecker.isFeatureEnabledInDebugMode(true);

    if (!isAllowed) {
      Logger.debug('Clipboard monitoring is disabled in debug mode');
    }

    return isAllowed;
  }

  /// Checks if screen recording protection should be enabled
  /// This would be used to protect sensitive screens from recording
  static bool shouldEnableScreenRecordingProtection() {
    // In release mode, screen recording protection is always enabled
    // In debug mode, it's controlled by a flag for testing purposes
    final isEnabled =
        DebugModeChecker.isReleaseMode ||
        DebugModeChecker.isFeatureEnabledInDebugMode(true);

    if (!isEnabled) {
      Logger.debug('Screen recording protection is disabled in debug mode');
    }

    return isEnabled;
  }

  /// Checks if sensitive logging is allowed
  /// In release mode, we should limit logging of sensitive information
  static bool isSensitiveLoggingAllowed() {
    // In debug mode, sensitive logging is allowed for development
    // In release mode, it's disabled for security
    final isAllowed = DebugModeChecker.isDebugMode;

    if (!isAllowed) {
      Logger.debug('Sensitive logging is disabled in release mode');
    }

    return isAllowed;
  }
}
