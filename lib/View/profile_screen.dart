import 'package:flutter/material.dart';
import 'package:medical_store_app/View/edit_profile_screen.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: const Center(child: Text("Orders Screen")),
    );
  }
}

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Billing")),
      body: const Center(child: Text("Billing Screen")),
    );
  }
}

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FAQ")),
      body: const Center(child: Text("FAQ Screen")),
    );
  }
}

/// ✅ Profile Screen
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
              // ✅ Title
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name + subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $userName", // 👈 Dynamic User Name
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

              // ✅ Menu Items
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
                const BillingScreen(),
              ),
              buildMenuItem(
                context,
                Icons.help_outline,
                "FAQ",
                const FaqScreen(),
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
