import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../utils/secure_storage.dart';

class AuthService {
  static const String baseUrl = 'https://yourapi.com/api/auth'; // Replace with your actual base URL

  Future<User?> login(String username, String password) async {
    try {
      // Hardcoded login for testing
      if (username == 'user' && password == '123') {
        // Simulate a successful login response for testing purposes
        final responseData = {
          'token': 'fake-jwt-token',
          'user': {
            'userName': 'user',
            'email': 'user@example.com',
            'name': 'John Doe', // Replace with actual name if available
            'purchaseHistory': [], // Initialize with an empty list or fetch from API
          },
        };
        await SecureStorage.saveToken(responseData['token'] as String);
        return User.fromJson(responseData['user'] as Map<String, dynamic>);
      }

      // Proceed with actual API call if hardcoded credentials are not used
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'] as String;
        final Map<String, dynamic> userJson = responseData['user'] as Map<String, dynamic>;

        await SecureStorage.saveToken(token);
        return User.fromJson(userJson);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
  Future<User?> getUserData() async {
    try {
      // Fetch user data from your API endpoint
      final String? authToken = await SecureStorage.getToken();
      if (authToken == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return User.fromJson(responseData); // Assuming User.fromJson is correctly implemented
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }


  Future<void> logout() async {
    try {
      await SecureStorage.deleteToken();
    } catch (e) {
      print('Logout error: $e');
      throw Exception('Failed to logout: $e');
    }
  }
}


