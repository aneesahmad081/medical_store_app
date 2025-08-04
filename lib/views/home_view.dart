import 'package:flutter/material.dart';
import 'package:medical_store_app/services/product_service.dart';
import 'package:medical_store_app/views/product/ProductDetailView.dart';
import 'package:medical_store_app/widgets/product_tile.dart';
import 'package:provider/provider.dart';
import '../view_models/product_view_model.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Medical Store')),
      body: ListView.builder(
        itemCount: vm.products.length,
        itemBuilder: (_, i) => ProductTile(
          vm.products[i] as ProductService,
          onTap: () {
            vm.select(vm.products[i]);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailView()),
            );
          },
        ),
      ),
    );
  }
}
