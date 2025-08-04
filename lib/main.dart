import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medical_store_app/views/auth/signup_view.dart';
import 'package:medical_store_app/views/home_view.dart';
import 'package:medical_store_app/views/auth/LoginView.dart';
import 'package:provider/provider.dart';

import 'core/firebase_options.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/product_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: MaterialApp(
        title: 'Medical Store',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<AuthViewModel>(
          builder: (context, authVM, _) =>
              authVM.isSignedIn ? HomeView() : SignUpView(),
        ),
      ),
    );
  }
}
