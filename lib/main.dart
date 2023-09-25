import 'package:flutter/material.dart';
import 'package:my_notes/pages/home_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/signup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: TextTheme(),
        textButtonTheme: const TextButtonThemeData(style: ButtonStyle())),
    routes: {
      '/': (context) => SignupPage(),
      '/login': (context) => const LoginPage(),
      '/home': (context) => const HomePage(),
    },
    initialRoute: '/',
  ));
}
