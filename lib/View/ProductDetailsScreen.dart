import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_store_app/View/cart_screen.dart';
import 'package:medical_store_app/View/checkout_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required String name,
    required price,
    required String imageUrl,
    required double rating,
    required int stock,
    required description,
    required brand,
    required String expiryDate,
    required String userEmail,
  });

  Future<void> addToCart(
    BuildContext context,
    Map<String, dynamic> product,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to add items to cart")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("carts")
          .doc(user.uid)
          .collection("items")
          .doc(productId)
          .set({
            "productId": productId,
            "name": product["name"],
            "price": product["price"],
            "imageUrl": product["imageUrl"],
            "quantity": FieldValue.increment(1),
            "addedAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product added to cart")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("Product not found")));
        }

        final product = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.indigo,
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
                /// Title
                Text(
                  product["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product["shortDescription"] ?? "No description",
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const SizedBox(height: 16),

                /// Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product["imageUrl"] ?? "https://via.placeholder.com/180",
                      height: 180,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Price & Add to Cart
                Row(
                  children: [
                    if (product["oldPrice"] != null)
                      Text(
                        "Rs.${product["oldPrice"]}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      "Rs.${product["price"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Add to cart"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        final cartRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('cart');

                        // ✅ Check if product already in cart
                        final existing = await cartRef
                            .where('name', isEqualTo: product['name'])
                            .limit(1)
                            .get();

                        if (existing.docs.isNotEmpty) {
                          // Update quantity
                          final doc = existing.docs.first;
                          final currentQty = doc['quantity'] ?? 1;
                          await doc.reference.update({
                            'quantity': currentQty + 1,
                          });
                        } else {
                          // Add new product
                          await cartRef.add({
                            'name': product['name'],
                            'price': product['price'],
                            'image': product['image'],
                            'quantity': 1,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                        }

                        // ✅ Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Product details
                const Text(
                  "Product Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  product["description"] ?? "No details available",
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 16),

                /// Expiry Date & Brand
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date: ${product["expiryDate"] ?? "N/A"}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Brand: ${product["brand"] ?? "N/A"}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Stock
                Text(
                  "Stock: ${product["stock"] ?? 0}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// Rating
                Row(
                  children: [
                    Text(
                      (product["rating"] ?? 0).toString(),
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
                Text("${product["reviewsCount"] ?? 0} Reviews"),

                const SizedBox(height: 20),

                /// Reviews Section (real-time from subcollection)
                const Text(
                  "Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .doc(productId)
                      .collection("reviews")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, reviewSnapshot) {
                    if (!reviewSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (reviewSnapshot.data!.docs.isEmpty) {
                      return const Text("No reviews yet");
                    }
                    return Column(
                      children: reviewSnapshot.data!.docs.map((doc) {
                        final review = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(review["userName"] ?? "Anonymous"),
                          subtitle: Text(review["comment"] ?? ""),
                          trailing: Text(
                            review["date"] != null
                                ? (review["date"] as Timestamp)
                                      .toDate()
                                      .toString()
                                      .substring(0, 10)
                                : "",
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          /// Bottom Button
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
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
      },
    );
  }
}
