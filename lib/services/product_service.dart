import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../core/constants.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  String? get name => null;

  get price => null;
  Stream<List<ProductModel>> getProducts() => _db
      .collection(PRODUCTS)
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((d) => ProductModel.fromMap(d.id, d.data())).toList(),
      );
}
