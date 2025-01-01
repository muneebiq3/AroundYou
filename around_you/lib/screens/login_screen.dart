import 'package:around_you/screens/signup_screen.dart';
import 'package:around_you/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void _signIn() async {

      String email = _controllerEmail.text;
      String password = _controllerPassword.text;

      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if(user != null) {
        try {
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, "/home_screen");
        }

        on FirebaseAuthException catch (e) {
          setState(() {
            errorMessage = e.message;
          });
        }
      }
  }

  Widget _title() {
    return const Text(
      "Around You",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller, String placeholder, bool hide) {
    return TextField(
      controller: controller,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Humm ? $errorMessage',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {
        _signIn();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF90B3E9), // Theme color for button text
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Login'),
    );
  }

  Widget _signUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => const SignupScreen()
          )
        );
      },
      child: const Text(
        'Not a User? Register Now!',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF266DD1), // Darker shade
              Color(0xFF90B3E9), // Primary theme color
              Color(0xFFB3CFF1), // Lighter shade
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _title(),
                const SizedBox(height: 40),
                _entryField('Username or Email', _controllerEmail, 'Enter Username or Email', false),
                const SizedBox(height: 30),
                _entryField('Password', _controllerPassword, 'Enter Password', true),
                const SizedBox(height: 10),
                _errorMessage(),
                const SizedBox(height: 20),
                _loginButton(),
                const SizedBox(height: 20),
                _signUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
