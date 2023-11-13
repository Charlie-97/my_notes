import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_notes/enums/menu_action.dart';
import 'package:my_notes/presentation/pages/new_note_page.dart';
import 'package:my_notes/presentation/pages/notes_list_view.dart';
import 'package:my_notes/router/base_navigator.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/utils/home_state.dart';
import 'package:my_notes/presentation/widgets/my_drawer.dart';
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

  // void getDbUser() async {
  //   final dbUser = await _noteService.getOrCreateUser(
  //       email: AuthService.firebase().currentUser!.email!);
  //   print('The dbUser is: ${dbUser.email}.');
  // }

  @override
  void initState() {
    _noteService = NoteService();
    final user = _authService.currentUser!;
    print('The logged in user is: ${user.email}');
    // getDbUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = Provider.of<MyNotesState>(context, listen: false);
    final authUser = _authService.currentUser!;
    return FutureBuilder(
      future: _noteService.getOrCreateUser(email: authUser.email!),
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
                                final shouldLogout =
                                    await _appOverlays.showLogOutDialog(
                                        BaseNavigator.key.currentContext!);

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
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              List<DatabaseNote> notesList =
                                  snapshot.data as List<DatabaseNote>;
                              return NotesListView(
                                notes: notesList,
                                onDeleteNote: (note) async{
                                  await _noteService.deleteNote(id: note.id);
                                },
                              );
                            } else {
                              return Text('No notes yet');
                            }

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
  }
}
