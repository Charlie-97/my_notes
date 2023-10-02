import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';

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

    final User? user = FirebaseAuth.instance.currentUser;

    Future<bool> isUserLoggedIn() async {
      final user = FirebaseAuth.instance.currentUser;
      return user != null;
    }

    if (await isUserLoggedIn()) {
      if (user?.emailVerified ?? false) {
        final snackBar = MySnackBar(
          'Signed in Successfully as ${user?.email}!',
        ).build();
        ScaffoldMessenger.of(BaseNavigator.key.currentContext!)
            .showSnackBar(snackBar);
        BaseNavigator.pushNamedAndclear(HomePage.routeName);
      } else {
        BaseNavigator.pushNamedAndclear(LoginPage.routeName);
      }
    } else {
      BaseNavigator.pushNamedAndclear(LoginPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Text(
            'SPLASH SCREEN',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
