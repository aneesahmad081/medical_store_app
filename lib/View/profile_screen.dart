import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_store_app/View/billing_screen.dart';
import 'package:medical_store_app/View/edit_profile_screen.dart';
import 'package:medical_store_app/View/faq_screen.dart';
import 'package:medical_store_app/View/orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/profile.png"),
                        );
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;

                      // 🔹 Use the SAME field name as EditProfileScreen ("imageUrl")
                      final imageUrl = data?['imageUrl'];

                      return CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            (imageUrl != null && imageUrl.isNotEmpty)
                            ? NetworkImage(imageUrl)
                            : const AssetImage("assets/profile.png")
                                  as ImageProvider,
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $userName",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Welcome to Anees Medical Store",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              buildMenuItem(
                context,
                Icons.person_outline,
                "Edit Profile",
                const EditProfileScreen(),
              ),
              buildMenuItem(
                context,
                Icons.list_alt_outlined,
                "My Orders",
                const MyOrdersScreen(),
              ),
              buildMenuItem(
                context,
                Icons.access_time,
                "Billing",
                const BillingScreen(cartItems: []),
              ),
              buildMenuItem(
                context,
                Icons.help_outline,
                "FAQ",
                const FAQScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Reusable Widget for Menu with Navigation
  Widget buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
        ),
        Divider(color: Colors.grey.shade300, height: 1),
      ],
    );
  }
}
