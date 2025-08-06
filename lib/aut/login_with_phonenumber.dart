import 'package:flutter/material.dart';
import 'package:medical_store_app/view_model.dart/aut_view_model.dart';
import 'package:provider/provider.dart';

class LoginWithPhonenumber extends StatefulWidget {
  const LoginWithPhonenumber({super.key});

  @override
  State<LoginWithPhonenumber> createState() => _LoginWithPhonenumberState();
}

class _LoginWithPhonenumberState extends State<LoginWithPhonenumber> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login with Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(hintText: "Phone Number"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                authProvider.loginWithPhone(
                  "+92${phoneController.text}",
                  context,
                  (vId) {
                    setState(() => verificationId = vId);
                  },
                );
              },
              child: const Text("Send Code"),
            ),
            if (verificationId != null) ...[
              TextField(
                controller: codeController,
                decoration: const InputDecoration(hintText: "Enter OTP"),
              ),
              ElevatedButton(
                onPressed: () => authProvider.verifyOTP(
                  verificationId!,
                  codeController.text,
                  context,
                ),
                child: const Text("Verify"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
