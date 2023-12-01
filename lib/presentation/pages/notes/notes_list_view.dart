import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/utils/providers/home_state.dart';
import 'package:provider/provider.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  @override
  Widget build(BuildContext context) {
    // final homeState = Provider.of<MyNotesState>(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyNotesState(),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          // final displayedNoteList =
          //     homeState.isReversed ? notes.toList().reversed : notes.toList();
          final note = notes.toList()[index];
          return Card(
            elevation: 3.0,
            child: ListTile(
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
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  note.body.isNotEmpty ? note.body : '[Body]',
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
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
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
