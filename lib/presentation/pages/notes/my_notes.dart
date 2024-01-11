import 'dart:io';

import 'package:flutter/material.dart';

import 'package:my_notes/presentation/pages/notes/create_update_note_view.dart';
import 'package:my_notes/presentation/pages/notes/notes_list_view.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';
import 'package:my_notes/utils/functions.dart';
import 'package:my_notes/utils/providers/home_state.dart';
import 'package:my_notes/utils/router/base_navigator.dart';

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
  late final FirebaseCloudStorage _noteService;
  List<CloudNote> notes = [];

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authUser = _authService.currentUser!;
    final auth = AuthFunctions();
    late final signOut = auth.signOutUser(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final bool shouldPop = await showCloseDialog(context);
          if (shouldPop) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            'My Notes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final shouldLogout = await _appOverlays
                    .showLogOutDialog(BaseNavigator.key.currentContext!);

                if (shouldLogout) {
                  signOut;
                }
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            BaseNavigator.pushNamed(
              CreateUpdateNoteView.routeName,
              args: {'pageTitle': 'Create New Note'},
            );
          },
          tooltip: 'Create New Note',
          icon: const Icon(Icons.add),
          label: const Text('Add Note'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 3.0),
          child: StreamBuilder(
            stream: _noteService.allNotes(ownerUserId: authUser.id),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    Iterable<CloudNote> notesIterable =
                        snapshot.data as Iterable<CloudNote>;
                    final List<CloudNote> notesList = notesIterable.toList();
                    return NotesListView(
                      notes: notesList,
                      onTap: (note) {
                        BaseNavigator.pushNamed(
                          CreateUpdateNoteView.routeName,
                          args: {
                            'pageTitle': 'Update Note',
                            'note': note,
                          },
                        );
                      },
                      onDeleteNote: (note) async {
                        await _noteService.deleteNotes(docId: note.docId);
                      },
                    );
                  } else {
                    return const Text('No notes yet');
                  }

                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
