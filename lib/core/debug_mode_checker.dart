import 'package:flutter/foundation.dart';

/// A utility class for checking the current mode of the application.
///
/// This class provides methods to determine if the app is running in debug,
/// release, or profile mode.
class DebugModeChecker {
  /// Returns true if the app is running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Returns true if the app is running in release mode
  static bool get isReleaseMode => kReleaseMode;

  /// Returns true if the app is running in profile mode
  static bool get isProfileMode => kProfileMode;

  /// Disables a feature if running in debug mode
  static bool isFeatureEnabledInDebugMode(bool defaultValue) =>
      kReleaseMode || defaultValue;
}