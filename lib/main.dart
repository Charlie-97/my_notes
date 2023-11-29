import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:my_notes/presentation/pages/splash_screen.dart';
import 'package:my_notes/utils/router/app_router.dart';
import 'package:my_notes/utils/router/base_navigator.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utils/providers/home_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.firebase().initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyNotesState(),
      child: const MyNotesApp(),
    ),
  );
}

class MyNotesApp extends StatefulWidget {
  const MyNotesApp({super.key});

  @override
  State<MyNotesApp> createState() => _MyNotesAppState();
}

class _MyNotesAppState extends State<MyNotesApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: BaseNavigator.key,
      title: 'My Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.montserrat(
            fontSize: 30,
            color: Colors.black,
          ),
          titleMedium: GoogleFonts.montserrat(
            fontSize: 26,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 20,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(),
        ),
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
