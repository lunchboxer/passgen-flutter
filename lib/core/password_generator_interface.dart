import 'package:passgen/models/password_params.dart';

/// An interface for password generation.
///
/// This interface defines the contract for password generators in the Passgen app.
abstract class IPasswordGenerator {
  /// Generate a password based on the provided parameters.
  ///
  /// Takes a [PasswordParams] object that specifies how the password should be generated
  /// and returns a string containing the generated password.
  String generate(PasswordParams params);
}