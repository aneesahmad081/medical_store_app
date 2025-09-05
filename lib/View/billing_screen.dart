import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  // Example: [{name: "Paracetamol", qty: 2, price: 200}, {name: "Vitamin C", qty: 1, price: 300}]

  const BillingScreen({super.key, required this.cartItems});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  double subtotal = 0;
  double tax = 0;
  double deliveryFee = 100; // flat fee
  double total = 0;

  @override
  void initState() {
    super.initState();
    _calculateBill();
  }

  void _calculateBill() {
    subtotal = widget.cartItems.fold(
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to place an order")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("orders").add({
      "userId": user.uid,
      "medicines": widget.cartItems,
      "subtotal": subtotal,
      "tax": tax,
      "deliveryFee": deliveryFee,
      "total": total,
      "status": "Pending",
      "date": DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Order placed successfully!")));

    Navigator.pop(context); // Go back after order
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
            // Medicines List
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item["name"]),
                      subtitle: Text("Qty: ${item["qty"]}"),
                      trailing: Text("${item["price"] * item["qty"]} PKR"),
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

            // Confirm Button
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
