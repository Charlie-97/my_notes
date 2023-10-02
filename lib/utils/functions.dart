import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/utils/navigator_key.dart';
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

      final snackBar = MySnackBar(
        'Signed in Successfully as ${googleUser.email}!',
      ).build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBar);
      BaseNavigator.pushNamedAndclear(HomePage.routeName);
    } on FirebaseAuthException catch (e) {
      // Sign-in with Google failed, show an error SnackBar

      final snackBar = MySnackBar(
        'Error signing in with Google: $e',
      ).build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBar);

      print('Error signing in with Google: $e');
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String confirmPassword) async {
    final userPassword = password;
    final userConfirmPassword = confirmPassword;
    final userEmail = email;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      User? user = userCredential.user;
      final snackBarSuccessful = MySnackBar('Sign-up successful').build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBarSuccessful);
      await user?.sendEmailVerification();
      // await Future.delayed(const Duration(seconds: 3));
      final snackBarVerify = MySnackBar(
              'Please verify your email to continue. A link has been sent to your email address!')
          .build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBarVerify);
      BaseNavigator.pushNamedAndReplace(LoginPage.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final snackBar =
            MySnackBar('Error signing up: Email already in use').build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
      } else if (e.code == 'weak-password') {
        final snackBar =
            MySnackBar('Error signing up: Enter a stronger password').build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
      } else if (userPassword != userConfirmPassword) {
        throw Exception(e);
      }
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
      if (user?.emailVerified ?? false) {
        final snackBar = MySnackBar(
          'Signed successfully as ${user?.email}!',
        ).build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
        BaseNavigator.pushNamedAndReplace(HomePage.routeName);
      } else {
        final snackBar = MySnackBar(
          'Please verify your email to continue. A link has been sent to your email address!',
        ).build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = MySnackBar(
        'Error signing in: ${e.toString().substring(42)}',
      ).build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBar);
      print('Error signing in: $e');
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final snackBar = MySnackBar(
        'Logged out Successfully!',
      ).build();
      ScaffoldMessenger.of(RootNavigatorKey.navigatorKey.currentContext!)
          .showSnackBar(snackBar);
      BaseNavigator.pushNamedAndReplace(LoginPage.routeName);
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
