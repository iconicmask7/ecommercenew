import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/purchasehistory.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../utils/secure_storage.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  static const String baseUrl = 'https://yourapi.com/api'; // Define your base URL here

  User? _user; // Current authenticated user
  bool _isLoading = false; // Loading state indicator
  List<PurchaseHistory> _purchaseHistory = []; // Purchase history

  User? get user => _user; // Getter for current user
  bool get isLoading => _isLoading; // Getter for loading state
  List<PurchaseHistory> get purchaseHistory => _purchaseHistory; // Getter for purchase history
  bool get isLoggedIn => _user != null; // Getter for login state

  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  Future<void> login(String username, String password) async {
    _isLoading = true; // Set loading state to true
    notifyListeners(); // Notify listeners to update UI

    try {
      // Attempt to login using AuthService
      _user = await _authService.login(username, password);
      notifyListeners(); // Notify listeners of state change
    } catch (error) {
      // Handle errors (e.g., show error message)
      print(error);
      throw Exception('Login failed'); // Propagate the error to the UI
    } finally {
      _isLoading = false; // Reset loading state on success or error
      notifyListeners(); // Notify listeners of state change
    }
  }

  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

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
        _user = User.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      throw Exception('Failed to fetch user data: $e'); // Propagate the error to the UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPurchaseHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      _purchaseHistory = await _apiService.fetchPurchaseHistory(authToken: await SecureStorage.getToken());
      notifyListeners();
    } catch (e) {
      print("Error fetching purchase history: $e");
      throw Exception('Failed to fetch purchase history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPurchaseHistoryForUser123() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Assuming username is '123' and you know the password
      const username = '123';
      const password = 'yourpassword';

      User? user123 = await _authService.login(username, password);
      if (user123 == null) {
        throw Exception('Failed to authenticate user 123');
      }

      final String? authToken = await SecureStorage.getToken();
      if (authToken == null) {
        throw Exception('No token found for user 123');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/purchasehistory'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _purchaseHistory = responseData.map((json) => PurchaseHistory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch purchase history for user 123. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching purchase history for user 123: $e");
      throw Exception('Failed to fetch purchase history for user 123: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null; // Clear current user on logout
      _purchaseHistory = []; // Clear purchase history on logout
      notifyListeners(); // Notify listeners of state change
    } catch (error) {
      print(error);
      throw Exception('Logout failed'); // Propagate the error to the UI
    }
  }
}

