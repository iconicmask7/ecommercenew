import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Card(
          child: ListTile(
            title: Text(product.name),
            subtitle: Text(product.category),
            leading: Image.network(
              product.imageUrl,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            trailing: IconButton(
              icon: Icon(
                productProvider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
              ),
              color: productProvider.isFavorite(product) ? Colors.red : null,
              onPressed: () {
                productProvider.toggleFavorite(product);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

