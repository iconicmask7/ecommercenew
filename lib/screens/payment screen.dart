import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../services/payment_services.dart';

class PaymentScreen extends StatefulWidget {
  final List<Product> products;

  const PaymentScreen({Key? key, required this.products}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  final PaymentService _paymentService = PaymentService();
  TextEditingController _couponController = TextEditingController();
  bool _isLoadingCoupon = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _couponController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful: ${response.paymentId}");

    // Remove purchased products from the home screen
    Provider.of<ProductProvider>(context, listen: false).hidePurchasedProducts(widget.products);

    // Navigate to download screen
    Navigator.pushReplacementNamed(context, '/download', arguments: {
      'downloadLink': 'https://example.com/download',
      'password': 'FAKER234',
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    _showErrorDialog('Payment Error', response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  void _startPayment() async {
    try {
      double totalPrice = widget.products.fold(0.0, (sum, product) => sum + (product.price * 100));

      var options = {
        'key': 'rzp_test_F9Tck6BotbRZCK',
        'amount': totalPrice.toInt(), // Razorpay amount is in paisa
        'name': 'Ecomp',
        'description': 'Payment for selected products',
        'prefill': {'name': 'Luffy', 'email': 'luffy@gmail.com'},
        'external': {
          'wallets': ['paytm', 'phonepe', 'googlepay', 'amazonpay']
        }
      };
      _razorpay.open(options);
    } catch (e) {
      print("Error starting Razorpay payment: $e");
    }
  }

  Future<void> _validateCoupon() async {
    setState(() {
      _isLoadingCoupon = true;
    });

    final String couponCode = _couponController.text.trim();

    if (couponCode.isEmpty) {
      _showErrorDialog('Coupon Error', 'Please enter a coupon code.');
      setState(() {
        _isLoadingCoupon = false;
      });
      return;
    }

    try {
      // Validate coupon code using payment service API
      final bool isValid = await _paymentService.validateCoupon(couponCode);

      if (isValid || couponCode == 'COUPON123') {
        setState(() {
        });

        // Remove purchased products from the home screen
        Provider.of<ProductProvider>(context, listen: false).hidePurchasedProducts(widget.products);

        Navigator.pushReplacementNamed(context, '/download', arguments: {
          'downloadLink': 'https://example.com/your-download-link', // Your download link here
          'password': 'your@123password', // Your password here
        });
      } else {
        _showErrorDialog('Invalid Coupon', 'The coupon code is invalid.');
      }
    } catch (e) {
      print("Error validating coupon: $e");
      _showErrorDialog('Error', 'An error occurred while validating the coupon.');
    } finally {
      setState(() {
        _isLoadingCoupon = false;
      });
    }
  }

  void _showErrorDialog(String title, String? content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content ?? 'Unknown error'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.products.fold(0.0, (sum, product) => sum + product.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products: ${widget.products.map((p) => p.name).join(', ')}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                labelText: 'Coupon Code',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => _validateCoupon(),
                ),
              ),
            ),
            if (_isLoadingCoupon)...[
              const SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startPayment,
              child: Text('Pay with Razorpay'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}