import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool hidePassword = true;
  String? errorMessage = '';
  String successMessage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerContact = TextEditingController();
  final TextEditingController _controllerDesignation = TextEditingController();
  final TextEditingController _controllerCurrentPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerConfirmNewPassword = TextEditingController();

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerContact.dispose();
    _controllerDesignation.dispose();
    _controllerCurrentPassword.dispose();
    _controllerNewPassword.dispose();
    _controllerConfirmNewPassword.dispose();
    super.dispose();
  }

  String capitalizeName(String name) {
    if (name.isEmpty) return '';
    
    List<String> words = name.split(' '); // Split by space to handle first and last name
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase(); // Capitalize first letter, lowercase rest
      }
    }
    return words.join(' '); // Join the words back together
  }

  void _updateProfile() async {
    String name = _controllerName.text.trim();
    String contact = _controllerContact.text.trim();
    String designation = _controllerDesignation.text.trim();
    String currentPassword = _controllerCurrentPassword.text;
    String newPassword = _controllerNewPassword.text;
    String confirmNewPassword = _controllerConfirmNewPassword.text;

    if (currentPassword.isNotEmpty && newPassword != confirmNewPassword) {
      setState(() {
        errorMessage = 'Passwords do not match.';
      });
      return;
    }

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        Map<String, dynamic> updateData = {
          if (name.isNotEmpty) 'Name': capitalizeName(name),
          if (contact.isNotEmpty) 'Contact': contact,
          if (designation.isNotEmpty) 'Designation': designation,
          'UpdatedAt': DateTime.now(),
        };

        if (updateData.isEmpty) {
          setState(() {
            errorMessage = 'No changes to update.';
          });
          return;
        }

        // Querying to find the document ID matching the userId
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('id', isEqualTo: userId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          String documentId = userSnapshot.docs.first.id;

          // Update the user's Firestore document
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(documentId)
              .update(updateData);

          // Only reauthenticate if updating password
          if (newPassword.isNotEmpty) {
            // Reauthenticate user before updating the password
            AuthCredential credential = EmailAuthProvider.credential(
              email: currentUser.email ?? '',
              password: currentPassword,
            );

            await currentUser.reauthenticateWithCredential(credential);
            await currentUser.updatePassword(newPassword);
          }

          setState(() {
            successMessage = 'Profile updated successfully!';
          });
        } else {
          setState(() {
            errorMessage = 'User document not found.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'User is not logged in.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'FirebaseAuthException occurred.';
      });
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = 'Firestore error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unexpected error: $e';
      });
    }
  }


  Widget _entryField(String title, TextEditingController controller, String placeholder) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
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
      ),
    );
  }

  Widget _passwordField(String title, TextEditingController controller, String placeholder) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: hidePassword,
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
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            }, 
            icon: Icon(
              hidePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            )
          )
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "My Profile",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _updateButton() {
    return ElevatedButton(
      onPressed: _updateProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF90B3E9), // Theme color for button text
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Update'),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : '$errorMessage',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget _successMessage() {
    return Text(
    successMessage.isEmpty ? '' : successMessage,
      style: const TextStyle(color: Colors.white, fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
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
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(
            Icons.arrow_back
          ),
          iconSize: 30,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login_screen");
            }, 
            icon: const Icon(
              Icons.logout,
            ),
            iconSize: 30,
            color: Colors.red,
          ),
        ],
          ),
        )
      ),

      body: SafeArea(
        child: Container(
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _title(),
                    const SizedBox(height: 20),
                    _entryField('Name', _controllerName, 'Enter Name'),
                    const SizedBox(height: 20),
                    _entryField('Contact#', _controllerContact, 'Enter your Contact'),
                    const SizedBox(height: 20),
                    _entryField('Designation', _controllerDesignation, 'Please enter your Designation'),
                    const SizedBox(height: 20),
                    _passwordField('Old Password', _controllerCurrentPassword, 'Enter current Password'),
                    const SizedBox(height: 20),
                    _passwordField('New Password', _controllerNewPassword, 'Enter new Password'),
                    const SizedBox(height: 20),
                    _passwordField('Confirm Password', _controllerConfirmNewPassword, 'Please confirm new Password'),
                    const SizedBox(height: 4),
                    _errorMessage(),
                    const SizedBox(height: 10),
                    _successMessage(),
                    const SizedBox(height: 10),
                    _updateButton(),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}