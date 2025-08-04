import 'package:flutter/material.dart';
import 'package:medical_store_app/view_models/product_view_model.dart';
import 'package:provider/provider.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = Provider.of<ProductViewModel>(context).selectedProduct;

    if (selected == null) {
      return Scaffold(body: Center(child: Text("No product selected.")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(selected.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(selected.name, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Text("Price: \$${selected.price}"),
            SizedBox(height: 10),
            Text(selected.description),
          ],
        ),
      ),
    );
  }
}
