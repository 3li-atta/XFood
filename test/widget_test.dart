import 'package:flutter_test/flutter_test.dart';
import 'package:xfood_pos/core/utils/password_hasher.dart';

void main() {
  group('PasswordHasher Tests', () {
    test('should hash and verify passwords correctly', () {
      const password = 'testPassword123';
      final hash = PasswordHasher.hash(password);

      expect(hash, isNotEmpty);
      expect(PasswordHasher.verify(password, hash), isTrue);
      expect(PasswordHasher.verify('wrong_password', hash), isFalse);
    });
  });
}
