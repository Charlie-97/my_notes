import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utils/home_state.dart';
import 'package:provider/provider.dart';

typedef NoteCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  final List<DatabaseNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyNotesState(),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final displayedNoteList = notes.reversed;
          final note = displayedNoteList.toList()[index];
          return ListTile(
            onTap: () {
              onTap(note);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.inversePrimary)),
            title: Text(
              note.title.isNotEmpty ? note.title : '[Title]',
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              note.body.isNotEmpty ? note.body : '[Body]',
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}
