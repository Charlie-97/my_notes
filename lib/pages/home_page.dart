import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/utils/home_state.dart';
import 'package:my_notes/widgets/my_drawer.dart';
import 'package:my_notes/widgets/snackbar_messages.dart';
import 'package:my_notes/widgets/dialogue_boxes.dart';
import 'dart:developer' as devtools show log;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = 'home_page';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppOverlays _appOverlays = AppOverlays();
  final AuthService _authService = AuthService();
  final homeState = HomeState();

  bool _loading = false;

  void _incrementCounter() {
    // _counter++;
    // homeState.updateCounter(_counter);
    final homeState = Provider.of<HomeState>(context, listen: false);
    homeState.updateCounter(homeState.counter + 1);
  }

  @override
  Widget build(BuildContext context) {
    final homeState = Provider.of<HomeState>(context);
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: Text(
                      'My Notes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    actions: [
                      PopupMenuButton<MenuAction>(
                        onSelected: (value) async {
                          switch (value) {
                            case MenuAction.logout:
                              final shouldLogout =
                                  await _appOverlays.showLogOutDialog(
                                      BaseNavigator.key.currentContext!);
                              devtools.log(shouldLogout.toString());
                              if (shouldLogout) {
                                await _authService.signOutUser(
                                    BaseNavigator.key.currentContext!);
                                BaseNavigator.pushNamedAndclear(
                                    LoginPage.routeName);
                              }
                              break;
                            case MenuAction.refresh:
                              setState(() {
                                _loading = true;
                              });
                              await Future.delayed(const Duration(seconds: 3));
                              setState(() {
                                _loading = false;
                              });
                            default:
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<MenuAction>(
                              value: MenuAction.logout,
                              child: Text('Logout'),
                            ),
                            const PopupMenuItem(
                              value: MenuAction.refresh,
                              child: Text('Refresh'),
                            )
                          ];
                        },
                      ),
                    ],
                  ),
                  drawer: MyDrawer(),
                  body: FutureBuilder(
                    future: Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Notes will be displayed here.',
                                ),
                                Text(
                                  'You have ${homeState.counter} notes. Tap Add Notes to create new',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          );

                        default:
                          return const Text('data');
                      }
                    },
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      _incrementCounter();
                      final snackBar = MySnackBar(
                        'Note added Successfully!',
                      ).build();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    tooltip: 'Increment',
                    icon: const Icon(Icons.add),
                    label: const Text('Add Note'),
                  ),
                ),
                Visibility(
                  visible: _loading,
                  child: Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        color: Colors.lightBlue[50],
                        height: MediaQuery.maybeSizeOf(context)!.height,
                        width: MediaQuery.maybeSizeOf(context)!.width,
                        child: SpinKitFoldingCube(
                          color: Theme.of(context).colorScheme.primary,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _loading,
                  child: SpinKitFoldingCube(
                    color: Theme.of(context).colorScheme.primary,
                    size: 100,
                  ),
                ),
              ],
            );

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout, refresh }
