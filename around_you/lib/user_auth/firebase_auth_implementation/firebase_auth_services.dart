import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage = '';

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{

    try {

      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;

    } on FirebaseAuthException catch(e) {
        errorMessage = e.message;
    }
    return null;
  }

    Future<User?> signInWithEmailAndPassword(String email, String password) async{

    try {

      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;

    } on FirebaseAuthException catch(e) {
        errorMessage = e.message;
    }
    return null;
  }

}