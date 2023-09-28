import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';

Function setPasswordVisibility({required bool obscureText}) {
  return () {
    obscureText = !obscureText;
    return obscureText ? Icons.visibility : Icons.visibility_off;
  };
}

bool checkPasswordsMatch({
  required String password,
  required String passwordConfirmation,
}) {
  return password == passwordConfirmation || passwordConfirmation.isEmpty;
}

bool checkPasswordLength(String password) {
  return password.length >= 8 || password.isEmpty;
}

bool validateEmail({required String email}) {
  return ((email.contains('@') &&
          email.contains('.') &&
          (email.substring(email.length - 1) != '.' &&
              email.substring(email.length - 1) != '@'))) ||
      email.isEmpty;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final snackBarHelper = SnackBarHelper();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled Google Sign-In
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Sign-in with Google using Firebase
      await _auth.signInWithCredential(credential);

      // Sign-in with Google successful, show a success SnackBar
      
      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Signed in Successfully as ${googleUser.email}!',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Sign-in with Google failed, show an error SnackBar
      
      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Error signing in with Google: $e',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print('Error signing in with Google: $e');
    }
  }

  Future<void> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Sign-up successful!',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Error signing up: ${e.toString().substring(37)}',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Error signing up: ${e.toString().substring(37)}');
    }
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Signed successfully as ${user?.email}!',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Error signing in: ${e.toString().substring(42)}',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Error signing in: $e');
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final snackBar = snackBarHelper.getSnackBar(
        context,
        'Logged out Successfully!',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
