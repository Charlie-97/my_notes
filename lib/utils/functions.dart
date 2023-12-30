import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/utils/router/base_navigator.dart';
import 'package:my_notes/presentation/widgets/snackbar_messages.dart';

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

class AuthFunctions {
  Future<void> signInWithGoogle(BuildContext context) async {
    context.read<AuthBloc>().add(const AuthEventGoogleLogin());
    // try {

    // } catch (e) {
    //   //null
    // }

    // final user = await _authService.signInWithGoogle();
    // final snackBar =
    //     MySnackBar('Signed in Successfully as ${user.email}').build();
    // ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
    //     .showSnackBar(snackBar);
    // BaseNavigator.pushNamedAndClear(MyNotesPage.routeName);
  }

  Future<void> signUpWithEmailAndPassword(
      {required BuildContext context,
      required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    if (validateSignUp(email, password, confirmPassword)) {
      context.read<AuthBloc>().add(AuthEventRegister(name, email, password));
      // context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
      // try {
      //   await _authService.createUser(
      //     email: email,
      //     password: password,
      //   );
      //   await _authService.updateDisplayName(displayName: name);
      //   final snackBarSuccessful = MySnackBar('Sign-up successful').build();
      //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      //       .showSnackBar(snackBarSuccessful);
      //   _authService.sendEmailVerification();

      //   final snackBarVerify = MySnackBar(
      //           'Please verify your email to continue. A link has been sent to your email address!')
      //       .build();
      //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      //       .showSnackBar(snackBarVerify);
      //   BaseNavigator.pushNamedAndClear(LoginPage.routeName);
      // } on EmailAlreadyInUseAuthException {
      //   final snackBarVerify =
      //       MySnackBar('Error Signing Up: Email already in use').build();
      //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      //       .showSnackBar(snackBarVerify);
      // } on WeakPasswordAuthException {
      //   final snackBarVerify =
      //       MySnackBar('Error Signing Up: Enter a stronger password').build();
      //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      //       .showSnackBar(snackBarVerify);
      // } on InvalidEmailAuthException {
      //   final snackBarVerify =
      //       MySnackBar('Error Signing Up: Enter a valid email').build();
      //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      //       .showSnackBar(snackBarVerify);
      // } on GenericAuthException {
      //   final snackBar = MySnackBar('Oops! Something went wrong').build();
      //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      //       .showSnackBar(snackBar);
      // }
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
        context.read<AuthBloc>().add(AuthEventLogin(email, password));
        // try {

        // await _authService.login(email: email, password: password);
        // final user = _authService.currentUser;

        // if (user?.isEmailVerified ?? true) {
        // final snackBar = MySnackBar('Logged in successfully as ').build();

        // ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
        //     .showSnackBar(snackBar);
        // BaseNavigator.pushNamedAndClear(MyNotesPage.routeName);
        // }
        // } on UserNotFoundAuthException {
        //   final snackBar =
        //       MySnackBar('Error Signing In: User not found').build();
        //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
        //       .showSnackBar(snackBar);
        // } on WrongPasswordAuthException {
        //   final snackBar =
        //       MySnackBar('Error Signing In: Incorrect Password').build();
        //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
        //       .showSnackBar(snackBar);
        // } on GenericAuthException {
        //   final snackBar = MySnackBar('Oops! Something went wrong').build();
        //   ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
        //       .showSnackBar(snackBar);
        // }
      } else {
        final snackBar = MySnackBar('Please enter your password').build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
      }
    }
  }

  void signOutUser(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventLogout());
    // try {

    //   // await _authService.logout();
    //   // final snackBar = MySnackBar(
    //   //   'Logged out Successfully!',
    //   // ).build();
    //   // ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
    //   //     .showSnackBar(snackBar);
    //   // BaseNavigator.pushNamedAndReplace(LoginPage.routeName);
    // } on UserNotLoggedInAuthException {
    //   final snackBar =
    //       MySnackBar('Error Signing out: Failed sign out attempt').build();
    //   await showMySnackBar(snackBar);
    // } on GenericAuthException catch (e) {
    //   String message = e.toString();
    //   final snackBar = MySnackBar(message).build();
    //   await showMySnackBar(snackBar);
    // }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (validateEmail(email: email)) {
      context.read<AuthBloc>().add(AuthEventResetPassword(email));
      final snackBar =
          MySnackBar('A password reset link has been sent to your email.')
              .build();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar =
          MySnackBar('Enter your email above and try again').build();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
