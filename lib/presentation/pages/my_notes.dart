import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_notes/enums/menu_action.dart';
import 'package:my_notes/presentation/pages/new_note_page.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/utils/home_state.dart';
import 'package:my_notes/presentation/widgets/my_drawer.dart';
import 'package:my_notes/presentation/widgets/snackbar_messages.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'package:provider/provider.dart';
import 'package:my_notes/services/auth/auth_service.dart';

class MyNotesPage extends StatefulWidget {
  const MyNotesPage({super.key});
  static const routeName = 'my_notes_page';
  @override
  State<MyNotesPage> createState() => _MyNotesPageState();
}

class _MyNotesPageState extends State<MyNotesPage> {
  final AppOverlays _appOverlays = AppOverlays();
  final AuthService _authService = AuthService.firebase();
  final myNotesState = MyNotesState();
  late final NoteService _noteService;

  final title = 'Title';
  final body = 'body';

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = Provider.of<MyNotesState>(context, listen: false);
    return FutureBuilder(
      future: _authService.initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return FutureBuilder(
              future: _noteService.getOrCreateUser(
                  email: _authService.currentUser!.email!),
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
                                        final auth = AuthFunctions();
                                        final shouldLogout = await _appOverlays
                                            .showLogOutDialog(BaseNavigator
                                                .key.currentContext!);

                                        if (shouldLogout) {
                                          await auth.signOutUser();
                                        }
                                        break;
                                      case MenuAction.refresh:
                                        homeState.refresh();
                                        // setState(() {});
                                        break;
                                      default:
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem<MenuAction>(
                                        value: MenuAction.logout,
                                        child: Text('Logout'),
                                      ),
                                      const PopupMenuItem<MenuAction>(
                                        value: MenuAction.refresh,
                                        child: Text('Refresh'),
                                      )
                                    ];
                                  },
                                ),
                              ],
                            ),
                            drawer: MyDrawer(),
                            floatingActionButton: FloatingActionButton.extended(
                              onPressed: () {
                                // homeState.updateCounter();
                                // final snackBar = MySnackBar(
                                //   'Note added Successfully!',
                                // ).build();
                                // ScaffoldMessenger.of(
                                //         BaseNavigator.key.currentContext!)
                                //     .showSnackBar(snackBar);
                                BaseNavigator.pushNamed(NewNotes.routeName);
                              },
                              tooltip: 'Create New Note',
                              icon: const Icon(Icons.add),
                              label: const Text('Add Note'),
                            ),
                            body: StreamBuilder(
                              stream: _noteService.allNotes,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return const Text('Waiting...');
                                  case ConnectionState.active:
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text(
                                            'Notes will be displayed here.',
                                          ),
                                          Consumer<MyNotesState>(
                                            builder: (_, homeState, __) => Text(
                                              'You have ${homeState.counter} notes. Tap Add Notes to create new',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                  default:
                                    return const CircularProgressIndicator();
                                }
                              },
                            )),
                        Visibility(
                          visible: homeState.loading,
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
                          visible: homeState.loading,
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

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
