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

  Future<void> addRating(
    BuildContext context,
    String productId,
    double rating,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login to rate this product")),
        );
      }
      return;
    }

    try {
      final productRef = FirebaseFirestore.instance
          .collection("products")
          .doc(productId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(productRef);
        if (!snapshot.exists) return;

        final data = snapshot.data() as Map<String, dynamic>;
        double oldRating = (data["rating"] ?? 0).toDouble();
        int oldCount = (data["reviewsCount"] ?? 0).toInt();

        double newRating = ((oldRating * oldCount) + rating) / (oldCount + 1);

        transaction.update(productRef, {
          "rating": newRating,
          "reviewsCount": oldCount + 1,
        });
      });

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Thanks for rating!")));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  /// ✅ Add Review (in subcollection)
  Future<void> addReview(
    BuildContext context,
    String productId,
    String review,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login to add review")),
        );
      }
      return;
    }

    try {
      final reviewRef = FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .collection("reviews");

      await reviewRef.add({
        "userId": user.uid,
        "userName": user.email ?? "Anonymous",
        "review": review,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Review added")));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
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
            actions: [
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(product: product),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
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

                        final existing = await cartRef
                            .where('name', isEqualTo: product['name'])
                            .limit(1)
                            .get();

                        if (existing.docs.isNotEmpty) {
                          final doc = existing.docs.first;
                          final currentQty = doc['quantity'] ?? 1;
                          await doc.reference.update({
                            'quantity': currentQty + 1,
                          });
                        } else {
                          await cartRef.add({
                            'name': product['name'],
                            'price': product['price'],
                            'image': product['image'],
                            'quantity': 1,
                            'createdAt': FieldValue.serverTimestamp(),
                          });
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to cart")),
                          );
                        }
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
                      "Expiry Date: ${product["expiryDate"] != null ? (product["expiryDate"] as Timestamp).toDate().toString().split(" ")[0] : "N/A"}",
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

                /// Average Rating
                Row(
                  children: [
                    Text(
                      (product["rating"] ?? 0).toStringAsFixed(1),
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
                Text("${product["reviewsCount"] ?? 0} Ratings"),

                const SizedBox(height: 20),

                /// ✅ Give Rating Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.star_rate),
                  label: const Text("Give Rating"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        double rating = 3.0;

                        return AlertDialog(
                          title: const Text("Rate this product"),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return IconButton(
                                    icon: Icon(
                                      index < rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        rating = index + 1.0;
                                      });
                                    },
                                  );
                                },
                              );
                            }),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                addRating(context, productId, rating);
                                Navigator.pop(dialogContext);
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),

                /// ✅ Reviews Section
                const Text(
                  "Customer Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                /// Show Reviews
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .doc(productId)
                      .collection("reviews")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, reviewSnapshot) {
                    if (!reviewSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (reviewSnapshot.data!.docs.isEmpty) {
                      return const Text("No reviews yet.");
                    }

                    return Column(
                      children: reviewSnapshot.data!.docs.map((doc) {
                        final review = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(review["userName"] ?? "Anonymous"),
                          subtitle: Text(review["review"] ?? ""),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 10),

                /// Add Review Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.rate_review),
                  label: const Text("Write a Review"),
                  onPressed: () {
                    final reviewController = TextEditingController();

                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text("Write a Review"),
                          content: TextField(
                            controller: reviewController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Enter your review",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (reviewController.text.isNotEmpty) {
                                  addReview(
                                    context,
                                    productId,
                                    reviewController.text,
                                  );
                                }
                                Navigator.pop(dialogContext);
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      },
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
                    builder: (context) =>
                        const CheckoutScreen(productId: '', name: null),
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
