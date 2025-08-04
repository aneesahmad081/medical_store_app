class ProductModel {
  final String id, name;
  final double price;
  final String description, imageUrl;
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
  factory ProductModel.fromMap(String id, Map<String, dynamic> map) =>
      ProductModel(
        id: id,
        name: map['name'],
        price: map['price'] + 0.0,
        description: map['description'],
        imageUrl: map['imageUrl'],
      );
}
