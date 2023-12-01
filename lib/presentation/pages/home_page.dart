import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/presentation/pages/authentication/login_page.dart';
import 'package:my_notes/presentation/pages/notes/my_notes.dart';
import 'package:my_notes/presentation/widgets/snackbar_messages.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/services/auth/bloc/auth_state.dart';
import 'package:my_notes/utils/router/base_navigator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventLoading());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const MyNotesPage();
      } else if (state is AuthStateNeedsVerification) {
        final snackBarVerify = MySnackBar(
                'Please verify your email to continue. A link has been sent to your email address!')
            .build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBarVerify);
        return const LoginPage();
      } else if (state is AuthStateLoggedOut) {
        return const LoginPage();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
