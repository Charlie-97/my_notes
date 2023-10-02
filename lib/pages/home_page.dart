import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/widgets/my_drawer.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = 'home_page';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      drawer: MyDrawer(),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;

                if (user?.emailVerified ?? false) {
                  print('email verified');
                } else {
                  print('Verify email to get full access');
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Notes will be displayed here.',
                      ),
                      Text(
                        'You have $_counter notes. Tap Add Notes to create new',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );

              default:
                return const Text('data');
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _incrementCounter;

          final snackBar = MySnackBar(
            'Note added Successfully!',
          ).build();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
    );
  }
}
