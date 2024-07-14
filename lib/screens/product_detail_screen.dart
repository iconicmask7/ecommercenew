import 'package:ecommercepart/screens/payment%20screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text(product.name),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return IconButton(
                icon: Icon(
                  productProvider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
                  color: productProvider.isFavorite(product) ? Colors.red : null,
                ),
                onPressed: () {
                  productProvider.toggleFavorite(product);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(product.imageUrl),
            SizedBox(height: 20),
            Text(product.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: product.youtubeVideoId ?? 'default_video_id',
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              onReady: () {
                print('Player is ready.');
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (!userProvider.isLoggedIn) {
                  // Show alert if not logged in
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Authentication Required'),
                        content: Text('Please log in to buy products.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('OK'),
                          )
                        ],
                      ));
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(products: [product]), // Passing single product in a list
                  ),
                );
              },
              child: Text('Buy Now!'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}