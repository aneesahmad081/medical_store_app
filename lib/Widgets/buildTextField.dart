import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String hint,
  bool obscure = false,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 16.0,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: validator,
  );
}
