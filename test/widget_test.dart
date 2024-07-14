import 'package:flutter_test/flutter_test.dart';
import 'package:ecommercepart/models/user.dart'; // Ensure correct path to User class

import 'package:ecommercepart/services/auth_service.dart'; // Assuming correct path to AuthService

void main() {
  test('Test login with valid credentials', () async {
    final authService = AuthService();
    final user = await authService.login('testuser', 'password');

    // Assert that the returned user is not null and has the expected email
    expect(user, isNotNull);
    expect(user?.email, 'test@example.com'); // Replace with expected email
  });

  test('Test login with invalid credentials', () async {
    final authService = AuthService();

    // Assert that attempting to login with invalid credentials throws an exception
    expect(() => authService.login('wronguser', 'wrongpassword'), throwsException);
  });
}
