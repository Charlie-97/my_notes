// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/presentation/pages/home_page.dart';
import 'package:my_notes/presentation/pages/notes/my_notes.dart';
import 'package:my_notes/presentation/pages/authentication/login_page.dart';
import 'package:my_notes/utils/router/base_navigator.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/presentation/widgets/snackbar_messages.dart';
import 'package:animate_do/animate_do.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initCheck();
  }

  initCheck() async {
    await Future.delayed(const Duration(seconds: 5));

    BaseNavigator.pushNamedAndClear(HomePage.routeName);

    // // final User? user = FirebaseAuth.instance.currentUser;

    // final AuthService authService = AuthService.firebase();
    // final user = authService.currentUser;

    // Future<bool> isUserLoggedIn() async {
    //   // final user = FirebaseAuth.instance.currentUser;
    //   final user = authService.currentUser;
    //   return user != null;
    // }

    // if (await isUserLoggedIn()) {
    //   if (user?.isEmailVerified ?? false) {
    //     final snackBar = MySnackBar(
    //       'Signed in Successfully as ${user?.email}!',
    //     ).build();
    //     ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
    //         .showSnackBar(snackBar);
    //     BaseNavigator.pushNamedAndClear(MyNotesPage.routeName);
    //   } else {
    //     BaseNavigator.pushNamedAndClear(LoginPage.routeName);
    //   }
    // } else {
    //   BaseNavigator.pushNamedAndClear(LoginPage.routeName);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeInDown(
                duration: const Duration(seconds: 1),
                child: Icon(
                  Icons.edit_note_sharp,
                  size: 100.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              // Future.delayed(Duration(seconds:1),),
              const SizedBox(height: 12.0),
              FadeInLeft(
                duration: const Duration(seconds: 1),
                child: Text(
                  'MY NOTES',
                  style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 24.0),
              FadeInRight(
                duration: const Duration(seconds: 2),
                child: Text(
                  'Your favourite notepad...',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
