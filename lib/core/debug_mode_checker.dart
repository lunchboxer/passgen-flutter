import 'package:flutter/foundation.dart';

class DebugModeChecker {
  /// Returns true if the app is running in debug mode
  static bool get isDebugMode {
    return kDebugMode;
  }

  /// Returns true if the app is running in release mode
  static bool get isReleaseMode {
    return kReleaseMode;
  }

  /// Returns true if the app is running in profile mode
  static bool get isProfileMode {
    return kProfileMode;
  }

  /// Disables a feature if running in debug mode
  static bool isFeatureEnabledInDebugMode(bool defaultValue) {
    return kReleaseMode ? true : defaultValue;
  }
}
