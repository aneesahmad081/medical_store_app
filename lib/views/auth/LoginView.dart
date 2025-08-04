import 'package:flutter/material.dart';
import 'package:medical_store_app/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  authVM.login(emailController.text, passController.text),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
