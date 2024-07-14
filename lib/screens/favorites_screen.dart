import 'package:ecommercepart/screens/payment%20screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<ProductProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.yellow[700],
      ),
      body: favorites.isEmpty
          ? Center(
        child: Text('No favorite products found.'),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, i) {
                final product = favorites[i];
                return ListTile(
                  key: ValueKey(product.id),
                  leading: Image.network(product.imageUrl),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(
                      Provider.of<ProductProvider>(context, listen: false).isFavorite(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    color: Provider.of<ProductProvider>(context, listen: false).isFavorite(product)
                        ? Colors.red
                        : null,
                    onPressed: () {
                      Provider.of<ProductProvider>(context, listen: false).toggleFavorite(product);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ));
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (favorites.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen(products: favorites)),
                  );
                }
              },
              child: Text('Buy All Items!'),
            ),
          ),
        ],
      ),
    );
  }
}