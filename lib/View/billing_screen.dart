import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems; // Real selected products

  const BillingScreen({
    super.key,
    required this.cartItems,
    required List productIds,
  });

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late List<Map<String, dynamic>> cartItems;
  double subtotal = 0;
  double tax = 0;
  double deliveryFee = 100;
  double total = 0;

  @override
  void initState() {
    super.initState();
    cartItems = widget.cartItems;
    _calculateBill();
  }

  void _calculateBill() {
    subtotal = cartItems.fold(
      0,
      (sum, item) => sum + (item["price"] * item["qty"]),
    );
    tax = subtotal * 0.1; // 10% tax
    total = subtotal + tax + deliveryFee;
    setState(() {});
  }

  Future<void> _confirmOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    try {
      // Save order to Firestore
      await FirebaseFirestore.instance.collection("orders").add({
        "userId": user.uid,
        "medicines": cartItems, // real products with qty & price
        "subtotal": subtotal,
        "tax": tax,
        "deliveryFee": deliveryFee,
        "total": total,
        "status": "Pending",
        "date": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );

      Navigator.pop(context); // go back after order
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error placing order: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cart Items
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item["name"]),
                      subtitle: Row(
                        children: [
                          Text("Qty: ${item["qty"]}"),
                          const SizedBox(width: 20),
                          // Buttons to increase/decrease quantity
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                if (item["qty"] > 1) item["qty"]--;
                                _calculateBill();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                item["qty"]++;
                                _calculateBill();
                              });
                            },
                          ),
                        ],
                      ),
                      trailing: Text(
                        "${(item["price"] * item["qty"]).toStringAsFixed(2)} PKR",
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 1),

            // Bill Summary
            Column(
              children: [
                _billRow("Subtotal", subtotal),
                _billRow("Tax (10%)", tax),
                _billRow("Delivery Fee", deliveryFee),
                const Divider(thickness: 1),
                _billRow("Total", total, bold: true),
              ],
            ),

            const SizedBox(height: 20),

            // Confirm Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billRow(String title, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
          Text(
            "${value.toStringAsFixed(2)} PKR",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
