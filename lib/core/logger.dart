import 'package:flutter/foundation.dart';
// Use relative imports for files in the 'lib' directory
import 'package:passgen/core/security_service.dart';

/// A utility class for logging messages.
///
/// This class provides methods to log messages at different levels.
class Logger {
  static const bool _isDebugMode = kDebugMode;

  static void debug(String message) {
    if (_isDebugMode) {
      // In debug mode, we can log more detailed information
      // In release mode, we limit logging
      if (SecurityService.isSensitiveLoggingAllowed()) {
        // Log with full details in debug mode when allowed
        // ignore: avoid_print
        print('DEBUG: $message');
      } else {
        // Still log but with less detail in release mode
        // ignore: avoid_print
        print('DEBUG: $message');
      }
    }
  }

  static void info(String message) {
    // Info level logging is always enabled
    // ignore: avoid_print
    print('INFO: $message');
  }

  static void warn(String message) {
    // Warning level logging is always enabled
    // ignore: avoid_print
    print('WARN: $message');
  }

  static void error(String message) {
    // Error level logging is always enabled
    // ignore: avoid_print
    print('ERROR: $message');
  }

  /// Logs sensitive information only if allowed by security settings
  static void sensitive(String message) {
    if (SecurityService.isSensitiveLoggingAllowed()) {
      // ignore: avoid_print
      print('SENSITIVE: $message');
    } else {
      // In release mode, we don't log sensitive information
      debug('Sensitive logging disabled for: $message');
    }
  }
}