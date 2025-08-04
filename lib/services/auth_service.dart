import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserModel?> signIn(String email, String pass) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
    final user = cred.user;
    return user != null
        ? UserModel(uid: user.uid, email: user.email ?? '')
        : null;
  }

  Future<UserModel?> signUp(String email, String pass) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    final user = cred.user;
    return user != null
        ? UserModel(uid: user.uid, email: user.email ?? '')
        : null;
  }

  Future<void> signOut() async => _auth.signOut();
}
