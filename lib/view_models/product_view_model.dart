import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductViewModel with ChangeNotifier {
  final _service = ProductService();
  List<ProductModel> products = [];
  ProductModel? selected;
  ProductViewModel() {
    _service.getProducts().listen((list) {
      products = list;
      notifyListeners();
    });
  }

  void select(ProductModel p) {
    selected = p;
    notifyListeners();
  }

  List<ProductModel> cart = [];

  get selectedProduct => null;
  void addToCart(ProductModel p) {
    cart.add(p);
    notifyListeners();
  }
}
