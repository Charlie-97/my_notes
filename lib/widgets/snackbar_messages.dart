import 'package:flutter/material.dart';

class SnackBarHelper {
  static final SnackBarHelper _instance = SnackBarHelper._internal();

  factory SnackBarHelper() {
    return _instance;
  }

  SnackBarHelper._internal();

  SnackBar getSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          message,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      duration: const Duration(seconds: 2),
    );
    return snackBar;
  }
}
