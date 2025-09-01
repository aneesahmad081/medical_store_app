import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_store_app/Utils/toast_utils.dart';
import 'package:medical_store_app/Widgets/Button.dart';
import 'package:medical_store_app/Widgets/buildTextField.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      ToastUtils.show('Account created successfully');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = switch (e.code) {
        'email-already-in-use' => 'This email is already in use.',
        'invalid-email' => 'Please enter a valid email.',
        'weak-password' => 'Password must be at least 8 characters.',
        _ => 'Signup failed. Please try again.',
      };
      ToastUtils.show(errorMessage);
    } catch (e) {
      ToastUtils.show('An error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.02,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),

                // Logo
                Container(
                  padding: EdgeInsets.all(size.width * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/Logo/Vector.png',
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                Text(
                  'Anees Medical Store',
                  style: GoogleFonts.poppins(
                    fontStyle: FontStyle.italic,
                    fontSize: size.width * 0.05,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Text(
                  'Create a new account',
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.035,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: size.height * 0.025),

                // Email
                buildTextField(
                  controller: emailController,
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: size.height * 0.02),

                // Password
                buildTextField(
                  controller: passwordController,
                  hint: 'Enter your password',
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: size.height * 0.02),

                // Confirm Password
                buildTextField(
                  controller: confirmPasswordController,
                  hint: 'Confirm your password',
                  obscure: true,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: size.height * 0.04),

                // Sign Up Button
                Button(title: 'Sign Up', loading: loading, onTap: _signUp),

                SizedBox(height: size.height * 0.03),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
