import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  Future<bool> processPayment(String userId, String productId, double amount) async {
    await Future.delayed(Duration(seconds: 2));
    final response = await http.post(
      Uri.parse('https://yourpaymentgateway.com/api/processPayment'),
      body: {
        'userId': userId,
        'productId': productId,
        'amount': amount.toString(),
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> validateCoupon(String couponCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/api/validate_coupon'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'couponCode': couponCode}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['isValid'];
      } else {
        return false;
      }
    } catch (e) {
      print("Error validating coupon: $e");
      return false;
    }
  }
}
