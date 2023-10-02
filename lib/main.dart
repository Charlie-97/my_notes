import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/splash_screen.dart';
import 'package:my_notes/router/app_router.dart';
import 'package:my_notes/router/base_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      navigatorKey: BaseNavigator.key,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
          textTheme: const TextTheme(),
          textButtonTheme: const TextButtonThemeData(style: ButtonStyle())),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
    ),
  );
}
