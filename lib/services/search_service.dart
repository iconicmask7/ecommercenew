import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class SearchService {
  static const String baseUrl = 'https://yourapi.com/api';

  Future<List<Product>> searchProducts(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/products/search?q=$query'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }
}