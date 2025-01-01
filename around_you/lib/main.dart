import 'package:around_you/screens/home_screen.dart';
import 'package:around_you/screens/login_screen.dart';
import 'package:around_you/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : const HomeScreen(),
      routes: {
        '/home_screen': (context) => const HomeScreen(),
        '/signup_screen': (context) => const SignupScreen(),
        '/login_screen': (context) => const LoginScreen(),
      },
    );
  }
}