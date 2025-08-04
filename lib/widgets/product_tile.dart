import 'package:flutter/material.dart';
import 'package:medical_store_app/services/product_service.dart';

class ProductTile extends StatelessWidget {
  final ProductService product;
  final VoidCallback onTap;

  const ProductTile(this.product, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    var name = product.name;
    return ListTile(
      title: Text(name!),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      onTap: onTap,
    );
  }
}
