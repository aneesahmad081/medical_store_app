import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  bool get isSignedIn => _user != null;

  AuthViewModel() {
    _user = _auth.currentUser;
  }

  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = _auth.currentUser;
      notifyListeners();
      Navigator.pushReplacementNamed(
        context,
        '/home',
      ); // Make sure this route exists
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
      );
    }
  }
}
