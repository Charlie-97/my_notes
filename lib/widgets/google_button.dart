import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_notes/utils/functions.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await _authService.signInWithGoogle(context);
      },
      icon: const Icon(FontAwesomeIcons.google),
      label: const Text('Continue with Google'),
    );
  }
}
