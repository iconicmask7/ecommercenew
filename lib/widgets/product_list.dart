
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_item.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  ProductList(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(products[i]),
    );
  }
}



