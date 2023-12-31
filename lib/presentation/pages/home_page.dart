import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/helpers/loaders/loading_screen.dart';
import 'package:my_notes/presentation/pages/authentication/email_verification_page.dart';
import 'package:my_notes/presentation/pages/authentication/login_page.dart';
import 'package:my_notes/presentation/pages/authentication/register_page.dart';
import 'package:my_notes/presentation/pages/authentication/reset_password_page.dart';
import 'package:my_notes/presentation/pages/notes/my_notes.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MyNotesPage();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailPage();
        } else if (state is AuthStateLoggedOut) {
          return const LoginPage();
        } else if (state is AuthStateRegistering) {
          return const RegisterPage();
        } else if (state is RefreshingState) {
          return const MyNotesPage();
        } else if (state is AuthStateResettingPasssword) {
          // final snackBarVerify = MySnackBar(
          //         'A link has been sent to your email address. Click the link to reset your password')
          //     .build();
          // ScaffoldMessenger.of(context).showSnackBar(snackBarVerify);
          return const ResetPassword();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
