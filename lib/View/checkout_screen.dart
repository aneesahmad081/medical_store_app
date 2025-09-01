import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_store_app/View/succes_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddress = "Home";
  String selectedPayment = "HBL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // ✅ Fix overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Delivery Address",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              _addressCard("Home", "(205) 555-024", "1786 Wheeler Bridge"),
              _addressCard(
                "Office",
                "(205) 555-024",
                "1786 w Dallas St underfield",
              ),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "+ Add Address",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                "Payment method",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              _paymentCard("HBL"),
              _paymentCard("Easypaisa"),
              _paymentCard("JazzCash"),
              _paymentCard("Cash on Delivery"),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderSuccessScreen(invoiceId: '3ds'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Pay Now",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressCard(String title, String phone, String address) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedAddress == title ? Colors.blue : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
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
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                phone,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
              ),
              Text(
                address,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.edit, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _paymentCard(String method) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedPayment == method ? Colors.blue : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
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
    );
  }
}
