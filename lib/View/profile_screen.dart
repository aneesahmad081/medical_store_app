import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// If you want Firebase upload:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_store_app/view/profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? _profileImageUrl;

  get pickImage => null; // For Firebase Storage URL

  Future<void> _pickImage(dynamic FirebaseStorage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // ✅ OPTIONAL: Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
        "profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      await storageRef.putFile(_imageFile!);
      String downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      // ✅ Save URL to Firestore (example: users collection)
      await FirebaseFirestore.instance
          .collection("users")
          .doc("USER_ID") // replace with actual logged-in user ID
          .update({"profilePic": downloadUrl});
    }
  }

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

              // ✅ Profile picture with upload option
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const NetworkImage(
                                'https://via.placeholder.com/150',
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: pickImage,
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${widget.userName}",
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

              // ✅ Your menu items remain the same
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
