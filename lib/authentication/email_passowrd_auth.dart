import 'package:firebase_auth/firebase_auth.dart';

class EmailPassowrdAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User registered successfully');
    } on FirebaseAuthException catch (e) {
      print('Error during registration: ${e.message}');
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed in successfully');
    } on FirebaseAuthException catch (e) {
      print('Error during sign-in: ${e.message}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error during sign-out: ${e.toString()}');
    }
  }
}
