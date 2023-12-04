import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/helpers/loaders/loading_screen.dart';
import 'package:my_notes/presentation/pages/authentication/email_verification_page.dart';
import 'package:my_notes/presentation/pages/authentication/login_page.dart';
import 'package:my_notes/presentation/pages/authentication/signup_page.dart';
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
          // final snackBarVerify = MySnackBar(
          //         'Please verify your email to continue. A link has been sent to your email address!')
          //     .build();
          // ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
          //     .showSnackBar(snackBarVerify);
          return const VerifyEmailPage();
        } else if (state is AuthStateLoggedOut) {
          return const LoginPage();
        } else if (state is AuthStateRegistering) {
          return const SignupPage();
        } else if (state is RefreshingState) {
          return const MyNotesPage();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
