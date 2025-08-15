import 'package:passgen/models/password_params.dart';

abstract class IPasswordGenerator {
  /// Generate a password based on the provided parameters
  String generate(PasswordParams params);
}