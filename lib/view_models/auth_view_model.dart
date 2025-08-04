import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel with ChangeNotifier {
  final _auth = AuthService();
  UserModel? user;
  bool isLoading = false;
  bool get isSignedIn => user != null;

  Future<void> login(String email, String pass) async {
    _setLoading(true);
    user = await _auth.signIn(email, pass);
    _setLoading(false);
  }

  Future<void> signup(String email, String pass, BuildContext context) async {
    _setLoading(true);
    user = await _auth.signUp(email, pass);
    _setLoading(false);
  }

  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }
}
