import 'package:flutter/material.dart';

void login() async {}

void signout() async {}

void signup() async {}

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
