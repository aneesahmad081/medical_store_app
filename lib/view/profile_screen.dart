import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

              // ✅ Profile Header
              Row(
                children: [
                  // Profile Image
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150", // replace with user photo
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name + subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hi, User",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Welcome to  Nilkanth Medical Store",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ✅ Menu Options
              buildMenuItem(Icons.person_outline, "Edit Profile"),
              buildMenuItem(Icons.list_alt_outlined, "My orders"),
              buildMenuItem(Icons.access_time, "Billing"),
              buildMenuItem(Icons.help_outline, "Faq"),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Reusable Widget for Menu
  Widget buildMenuItem(IconData icon, String title) {
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
            // TODO: Navigate to screens
          },
        ),
        Divider(color: Colors.grey.shade300, height: 1),
      ],
    );
  }
}
