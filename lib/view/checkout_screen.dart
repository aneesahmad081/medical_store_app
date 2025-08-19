import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddress = "Home";
  String selectedPayment = "Easypaisa";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "2 Items in your cart",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  "TOTAL\nRs.185.00",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Delivery Address
            Text(
              "Delivery Address",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            _addressCard("Home", "(205) 555-024", "1786 Wheeler Bridge"),
            const SizedBox(height: 10),
            _addressCard(
              "Office",
              "(205) 555-024",
              "1786 w Dallas St underfield",
            ),

            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.add, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    "Add Address",
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Payment Method
            Text(
              "Payment method",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            _paymentCard("HBL"),
            const SizedBox(height: 10),
            _paymentCard("Easypaisa"),
            const SizedBox(height: 10),
            _paymentCard("JazzCash"),
            const SizedBox(height: 10),
            _paymentCard("Cash on Delivery"),

            const Spacer(),

            // Pay Now Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Order placed with $selectedPayment",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              },
              child: Text(
                "Pay Now",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressCard(String title, String phone, String address) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddress = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedAddress == title
                ? Colors.blue
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: title,
              groupValue: selectedAddress,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedAddress = value!;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(phone, style: TextStyle(color: Colors.grey[700])),
                  Text(address, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            const Icon(Icons.edit, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedPayment == method
                ? Colors.blue
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (method == "HBL")
              // Image.network(
              // ),
              if (method == "Easypaisa")
                // Image.network(
                //   "https://seeklogo.com/images/E/easypaisa-logo-920D6341F4-seeklogo.com.png",
                //   height: 25,
                // ),
                if (method == "JazzCash")
                  // Image.network(
                  //   "https://seeklogo.com/images/J/jazz-cash-logo-7CA2F1E6F3-seeklogo.com.png",
                  //   height: 25,
                  // ),
                  if (method != "Cash on Delivery") const SizedBox(width: 10),

            Text(
              method,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Radio<String>(
              value: method,
              groupValue: selectedPayment,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
