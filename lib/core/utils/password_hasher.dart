/// Wrapper around bcrypt for password hashing and verification.
library;

import 'package:bcrypt/bcrypt.dart';

/// Handles password hashing and verification using bcrypt.
class PasswordHasher {
  /// Hash a plain-text password. Returns the bcrypt hash string.
  static String hash(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  /// Verify a plain-text password against a bcrypt hash.
  static bool verify(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }
}
