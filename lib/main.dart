import 'package:ecommercepart/screens/chatscreen.dart';
import 'package:ecommercepart/screens/payment%20screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import models and screens
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/purchase_history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/download_screen.dart';

// Import providers
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/purchaseHistory': (context) => PurchaseHistoryScreen(),
          '/settings': (context) => SettingsScreen(),
          '/notifications': (context) => NotificationsScreen(),
          '/favorites': (context) => FavoritesScreen(),
          '/feedback': (context) => FeedbackScreen(),
          '/chat': (context) => ChatScreen(), // Add chat route
          // Other routes
          '/payment': (context) => PaymentScreen(
            products: [
              Product(
                id: '1',
                name: 'Sample Product',
                category: 'Category',
                description: 'Description',
                imageUrl: 'imageUrl',
                price: 100.0, // Placeholder for price, adjust as needed
                rating: 4, // Placeholder for rating, adjust as needed
                stockQuantity: 10, // Placeholder for stock quantity, adjust as needed
              ),
            ],
          ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/productDetail') {
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            );
          } else if (settings.name == '/download') {
            final downloadArgs = settings.arguments as Map<String, String>;
            return MaterialPageRoute(
              builder: (context) => DownloadScreen(
                downloadLink: downloadArgs['downloadLink']!,
                password: downloadArgs['password']!,
              ),
            );
          }
          return null;
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => HomeScreen());
        },
      ),
    );
  }
}