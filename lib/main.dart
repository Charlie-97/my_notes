import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/signup_page.dart';
import 'package:my_notes/utils/navigator_key.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    navigatorKey: RootNavigatorKey.navigatorKey,
    title: 'Flutter Demo',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
        textTheme: const TextTheme(),
        textButtonTheme: const TextButtonThemeData(style: ButtonStyle())),
    routes: {
      '/': (context) => const SignupPage(),
      '/login': (context) => const LoginPage(),
      '/home': (context) => const HomePage(),
    },
    initialRoute: '/',
  ));
  
}
