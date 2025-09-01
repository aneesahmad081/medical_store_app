import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medical_store_app/View/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const CartScreen({super.key, this.product});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity1 = 1;
  int quantity2 = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              "Your cart",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                "+ Add more",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2 Items in your cart",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            cartItem(
              widget.product?["image"] ?? "https://i.ibb.co/4PN9d6D/bottle.png",
              widget.product?["name"] ?? "Sugar free gold",
              "bottle of 500 pellets",
              (widget.product?["price"] ?? 25).toDouble(),
              quantity1,
              () => setState(() => quantity1--),
              () => setState(() => quantity1++),
            ),

            // ✅ Second dummy item
            cartItem(
              "https://i.ibb.co/pKT9jbf/medicine.png",
              "Sugar free gold",
              "bottle of 500 pellets",
              18,
              quantity2,
              () => setState(() => quantity2--),
              () => setState(() => quantity2++),
            ),

            const SizedBox(height: 20),

            // Payment Summary
            Text(
              "Payment Summary",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            summaryRow("Order Total", "228.80"),
            summaryRow("Items Discount", "- 28.80", color: Colors.grey),
            summaryRow("Coupon Discount", "-15.80", color: Colors.grey),
            summaryRow("Shipping", "Free", color: Colors.grey),

            const Divider(height: 30),

            summaryRow(
              "Total",
              "Rs.185.00",
              isBold: true,
              fontSize: 18,
              color: Colors.black,
            ),

            const Spacer(),

            // Place Order Button
            SizedBox(
              width: double.infinity,
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Place Order",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cartItem(
    String image,
    String title,
    String subtitle,
    double price,
    int quantity,
    VoidCallback onRemove,
    VoidCallback onAdd,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rs.$price",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: quantity > 1 ? onRemove : null,
                icon: const Icon(Icons.remove_circle, color: Colors.grey),
              ),
              Text(
                "$quantity",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget summaryRow(
    String title,
    String value, {
    bool isBold = false,
    double fontSize = 14,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
