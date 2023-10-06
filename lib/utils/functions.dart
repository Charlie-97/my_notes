import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';
import 'dart:developer' as devtools show log;

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

bool containsSpecialCharacter(String password) {
  final List<String> usableSpecialCharacters = [
    '#',
    '@',
    '\$',
    '&',
    '-',
    '!',
    '%',
    '^'
  ];

  return usableSpecialCharacters.any((element) => password.contains(element));
}

bool containsUpperCase(String password) {
  for (int i = 0; i < password.length; i++) {
    if (password[i].toUpperCase() == password[i]) {
      return true;
    }
  }
  return false;
}

bool containsLowerCase(String password) {
  for (int i = 0; i < password.length; i++) {
    if (password[i].toLowerCase() == password[i]) {
      return true;
    }
  }
  return false;
}

bool validateSignUp(email, password, confirmPassword) {
  return validateEmail(email: email) &&
      ((password != null || password.trim().isNotEmpty) &&
          (password.contains(RegExp(r'[A-Z]'))) &&
          (password.contains(RegExp(r'[a-z]'))) &&
          (password.contains(RegExp(r'[0-9]'))) &&
          (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) &&
          (!password.contains(RegExp(r'\s'))) &&
          (password.length >= 8)) &&
      (confirmPassword == password);
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your password';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter';
  }

  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }

  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character';
  }

  if (value.contains(RegExp(r'\s'))) {
    return 'Password must not contain whitespace';
  }
  if (value.length < 8) {
    return 'Your Password must contain at least 8 characters';
  }
  return null;
}

bool validateEmail({required String email}) {
  return email.contains('@') &&
      email.contains('.') &&
      !email.contains(' ') &&
      (email.substring(email.length - 1) != '.' &&
          email.substring(email.length - 1) != '@');
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
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String confirmPassword) async {
    final userPassword = password;
    final userEmail = email;

    if (validateSignUp(email, password, confirmPassword)) {
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
        }
      } catch (e) {
        final snackBar = MySnackBar(e.toString()).build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
      }
    } else {
      final snackBar = MySnackBar('Please fill in the required fields').build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBar);
    }
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    if (validateEmail(email: email)) {
      if (password.isNotEmpty) {
        try {
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          User? user = userCredential.user;
          String message = '';

          if (user?.emailVerified ?? false) {
            message = 'Signed successfully as ${user?.email}!';
            devtools.log('Signed in');
          } else {
            message =
                'Please verify your email to continue. A link has been sent to your email address!';
            devtools.log('Unregistered user');
            final snackBar = MySnackBar(message).build();
            await showMySnackBar(snackBar);
            return;
          }
          final snackBar = MySnackBar(message).build();
          await showMySnackBar(snackBar);
          BaseNavigator.pushNamedAndReplace(HomePage.routeName);
        } on FirebaseAuthException catch (e) {
          String message = '';

          if (e.code == 'user-not-found') {
            message = 'Error Signing in: User not found';
          } else if (e.code == 'wrong-password') {
            message = 'Error Signing in: Wrong cedentials';
          } else {
            message = 'Error Signing in: ${e.code}';
          }

          final snackBar = MySnackBar(message).build();
          await showMySnackBar(snackBar);
        } catch (e) {
          String message = e.toString();
          final snackBar = MySnackBar(message).build();
          await showMySnackBar(snackBar);
        }
      } else {
        final snackBar = MySnackBar('Please enter your password').build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
      }
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final snackBar = MySnackBar(
        'Logged out Successfully!',
      ).build();
      ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          .showSnackBar(snackBar);
      BaseNavigator.pushNamedAndReplace(LoginPage.routeName);
    } on FirebaseAuthException catch (e) {
      final snackBar = MySnackBar('Error Signing out: ${e.code}').build();
      await showMySnackBar(snackBar);
    } catch (e) {
      String message = e.toString();
      final snackBar = MySnackBar(message).build();
      await showMySnackBar(snackBar);
    }
  }
}
