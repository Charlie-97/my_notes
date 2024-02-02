import 'package:flutter/material.dart';
import 'package:my_notes/utils/router/base_navigator.dart';

class MySnackBar {
  final String message;

  MySnackBar(this.message);

  SnackBar build() {
    final colorScheme = Theme.of(BaseNavigator.currentContext)
        .colorScheme; // Replace with your app's theme

    return SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.all(6),
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.primary, // Background color
      content: Center(
        child: Text(
          message,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 12, // Text color
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}

Future<void> showMySnackBar(SnackBar snackBar) async {
  ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
      .showSnackBar(snackBar);
}
