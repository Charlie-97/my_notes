import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utils/home_state.dart';
import 'package:provider/provider.dart';

typedef DeleteNoteCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  final List<DatabaseNote> notes;
  final DeleteNoteCallBack onDeleteNote;

  @override
  Widget build(BuildContext context) {
    final notesState = Provider.of<MyNotesState>(context, listen: false);
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyNotesState(),
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final displayedNoteList = notes.reversed;
          final note = displayedNoteList.toList()[index];
          return ListTile(
            shape: RoundedRectangleBorder(
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
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Consumer<MyNotesState>(
                    builder: (BuildContext context, value, Widget? child) {
                      return IconButton(
                        onPressed: () {
                          notesState.toggleFavourite();
                        },
                        icon: Icon(
                          notesState.isFavourite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
