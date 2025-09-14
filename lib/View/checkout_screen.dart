import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_store_app/View/succes_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedAddress = "";
  String selectedPayment = "HBL";

  List<Map<String, String>> userAddresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  /// Load saved addresses from Firestore
  Future<void> _loadAddresses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .get();

    setState(() {
      userAddresses = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id, // ✅ Save Firestore document ID
          "title": data["title"]?.toString() ?? "",
          "phone": data["phone"]?.toString() ?? "",
          "address": data["address"]?.toString() ?? "",
        };
      }).toList();

      if (userAddresses.isNotEmpty && userAddresses.first["title"] != null) {
        selectedAddress = userAddresses.first["title"]!;
      } else {
        selectedAddress = "";
      }
      isLoading = false;
    });
  }

  /// Add new address
  void _showAddAddressDialog() {
    final titleController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Address"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    addressController.text.isNotEmpty) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;

                  final newAddress = {
                    "title": titleController.text,
                    "phone": phoneController.text,
                    "address": addressController.text,
                  };

                  final docRef = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .collection("addresses")
                      .add(newAddress);

                  setState(() {
                    userAddresses.add({"id": docRef.id, ...newAddress});
                    selectedAddress = titleController.text;
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// Edit existing address
  void _editAddressDialog(Map<String, String> addr) {
    final titleController = TextEditingController(text: addr["title"]);
    final phoneController = TextEditingController(text: addr["phone"]);
    final addressController = TextEditingController(text: addr["address"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Address"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final updatedAddress = {
                  "title": titleController.text,
                  "phone": phoneController.text,
                  "address": addressController.text,
                };

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("addresses")
                    .doc(addr["id"])
                    .update(updatedAddress);

                setState(() {
                  final index = userAddresses.indexWhere(
                    (element) => element["id"] == addr["id"],
                  );
                  if (index != -1) {
                    userAddresses[index] = {
                      "id": addr["id"]!,
                      ...updatedAddress,
                    };
                  }
                  if (selectedAddress == addr["title"]) {
                    selectedAddress = updatedAddress["title"]!;
                  }
                });

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  /// Delete address
  Future<void> _deleteAddress(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .doc(id)
        .delete();

    setState(() {
      userAddresses.removeWhere((addr) => addr["id"] == id);
      if (selectedAddress.isNotEmpty &&
          !userAddresses.any((addr) => addr["title"] == selectedAddress)) {
        selectedAddress = userAddresses.isNotEmpty
            ? userAddresses.first["title"]!
            : "";
      }
    });
  }

  /// UI
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

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (userAddresses.isEmpty)
                const Text("No addresses yet. Add one!")
              else
                Column(
                  children: userAddresses.map((addr) {
                    return _addressCard(addr);
                  }).toList(),
                ),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: _showAddAddressDialog,
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

  /// Address Card
  Widget _addressCard(Map<String, String> addr) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedAddress == addr["title"]
              ? Colors.blue
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: addr["title"]!,
            groupValue: selectedAddress,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                selectedAddress = value!;
              });
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addr["title"]!,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  addr["phone"]!,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  addr["address"]!,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () => _editAddressDialog(addr),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteAddress(addr["id"]!), // ✅ fixed
          ),
        ],
      ),
    );
  }

  /// Payment Card
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
