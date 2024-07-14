import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/purchasehistory.dart';

class ApiService {
  static const String baseUrl = 'https://yourapi.com/api';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        print('Error fetching products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProductDetails(String productId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$productId'));

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        return Product.fromJson(body);
      } else {
        print('Error fetching product details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Error fetching product details: $e');
      throw Exception('Failed to load product details');
    }
  }

  Future<List<Product>> filterProducts(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products?category=$category'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        print('Error filtering products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to filter products');
      }
    } catch (e) {
      print('Error filtering products: $e');
      throw Exception('Failed to filter products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products?category=$categoryId'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        print('Error fetching products by category. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsByCategoryAndPriceRange(String categoryId, String priceRange) async {
    try {
      final url = '$baseUrl/products?category=$categoryId&priceRange=$priceRange';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        print('Error filtering products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to filter products');
      }
    } catch (e) {
      print('Error filtering products: $e');
      throw Exception('Failed to filter products');
    }
  }

  Future<List<Product>> fetchProductsByFilters(String categoryId, String priceRange, String subCategory) async {
    try {
      final url = '$baseUrl/products?category=$categoryId&priceRange=$priceRange&subCategory=$subCategory';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Product.fromJson(item)).toList();
      } else {
        print('Error fetching products by filters. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch products by filters');
      }
    } catch (e) {
      print('Error fetching products by filters: $e');
      throw Exception('Failed to fetch products by filters');
    }
  }

  Future<void> addToFavorites(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(product.toJson()), // Assuming toJson() method in Product model
      );

      if (response.statusCode != 201) {
        print('Failed to add product to favorites. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to add product to favorites');
      }
    } catch (e) {
      print('Error adding product to favorites: $e');
      throw Exception('Failed to add product to favorites');
    }
  }

  Future<void> removeFromFavorites(Product product) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/${product.id}'), // Adjust endpoint as per your API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        print('Failed to remove product from favorites. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to remove product from favorites');
      }
    } catch (e) {
      print('Error removing product from favorites: $e');
      throw Exception('Failed to remove product from favorites');
    }
  }

  Future<List<PurchaseHistory>> fetchPurchaseHistory({String? authToken}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/purchases'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => PurchaseHistory.fromJson(item)).toList();
      } else {
        print('Error fetching purchase history. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load purchase history');
      }
    } catch (e) {
      print('Error fetching purchase history: $e');
      throw Exception('Failed to load purchase history');
    }
  }
}

