import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medical_store_app/View/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required Map<String, dynamic> product});

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  /// 🧮 Helper: Calculate totals
  double _getOrderTotal(List<QueryDocumentSnapshot> docs) {
    return docs.fold(0.0, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>;

      final price = (data['price'] ?? 0);
      final qty = (data['quantity'] ?? 1);

      final priceNum = price is num
          ? price
          : num.tryParse(price.toString()) ?? 0;
      final qtyNum = qty is num ? qty : int.tryParse(qty.toString()) ?? 1;

      return sum + (priceNum * qtyNum);
    });
  }

  void _increaseQuantity(String docId, int currentQty) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(docId)
        .update({"quantity": currentQty + 1});
  }

  void _decreaseQuantity(String docId, int currentQty) {
    if (currentQty > 1) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(docId)
          .update({"quantity": currentQty - 1});
    }
  }

  void _deleteItem(String docId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            );
          }

          final orderTotal = _getOrderTotal(docs);
          const discount = 5.0;
          final total = orderTotal - discount;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🛒 Items Count
                Text(
                  "${docs.length} Items in your cart",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                /// 🛍️ Cart Items
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      // ✅ Safe quantity parsing
                      final int quantity = (data["quantity"] ?? 1) is int
                          ? data["quantity"] as int
                          : int.tryParse(data["quantity"].toString()) ?? 1;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              /// Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data["image"],
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// Product Name + Price
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["name"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rs. ${data["price"]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Quantity Buttons
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () =>
                                        _decreaseQuantity(doc.id, quantity),
                                  ),
                                  Text(
                                    "$quantity",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () =>
                                        _increaseQuantity(doc.id, quantity),
                                  ),
                                ],
                              ),

                              /// Delete Button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteItem(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 📊 Payment Summary
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        summaryRow("Order Total", "Rs. $orderTotal"),
                        const SizedBox(height: 6),
                        summaryRow("Items Discount", "- Rs. $discount"),
                        const Divider(),
                        summaryRow("Total", "Rs. $total", isBold: true),
                      ],
                    ),
                  ),
                ),

                /// 🟦 Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Proceed to Checkout",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper for Payment Summary
  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
