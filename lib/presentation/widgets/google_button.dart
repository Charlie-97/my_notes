import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_notes/utils/functions.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({super.key});

  final AuthFunctions _auth = AuthFunctions();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        _auth.signInWithGoogle();
      },
      icon: const Icon(FontAwesomeIcons.google),
      label: const Text('Continue with Google'),
    );
  }
}
