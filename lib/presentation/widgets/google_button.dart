import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_notes/presentation/widgets/snackbar_messages.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utils/functions.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({super.key});

  final AuthFunctions _auth = AuthFunctions();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is GenericAuthException) {
            final snackbar = MySnackBar('Oops! Error Signing in').build();
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        }
      },
      child: ElevatedButton.icon(
        onPressed: () async {
          _auth.signInWithGoogle(context);
        },
        icon: const Icon(FontAwesomeIcons.google),
        label: const Text('Continue with Google'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[50],
            foregroundColor: Colors.deepPurple),
      ),
    );
  }
}
