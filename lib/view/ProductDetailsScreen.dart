import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String description;
  final String brand;
  final String expiryDate;
  final int stock;

  const ProductDetailsScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.brand,
    required this.expiryDate,
    required this.stock,
    required String userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.shopping_cart_outlined, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Etiam mollis metus non purus",
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imageUrl, height: 180),
              ),
            ),

            const SizedBox(height: 16),

            // Price
            Row(
              children: [
                const Text(
                  "Rs.99",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Rs.$price",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Add to cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Package size
            const Text(
              "Package size",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                buildPackageBox("Rs.106", "500 pellets", true),
                buildPackageBox("Rs.166", "110 pellets", false),
                buildPackageBox("Rs.252", "300 pellets", false),
              ],
            ),

            const SizedBox(height: 20),

            // Product details
            const Text(
              "Product Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(description, style: TextStyle(color: Colors.grey[700])),

            const SizedBox(height: 16),

            // Ingredients
            const Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Interdum et malesuada fames ac ante ipsum primis "
              "in faucibus. Morbi ut nisi odio. Nulla facilisi.",
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // Expiry Date & Brand
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Expiry Date: $expiryDate",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Brand: $brand",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Rating
            Row(
              children: [
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 4),
            const Text("923 Ratings and 257 Reviews"),

            const SizedBox(height: 20),

            // Review Section
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text("Erric Hoffman"),
              subtitle: const Text(
                "Interdum et malesuada fames ac ante ipsum primis in faucibus.",
              ),
              trailing: const Text("05-Oct-2020"),
            ),
          ],
        ),
      ),

      // Bottom Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "GO TO CART",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Package Box Widget
  Widget buildPackageBox(String price, String size, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? Colors.orange[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? Colors.orange : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            price,
            style: TextStyle(
              color: selected ? Colors.orange : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(size, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
