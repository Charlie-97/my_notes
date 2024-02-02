import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/dialogue_boxes.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  final List<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  @override
  Widget build(BuildContext context) {
    // final homeState = Provider.of<MyNotesState>(context);

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 75.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // final displayedNoteList =
        //     homeState.isReversed ? notes.toList().reversed : notes.toList();
        final note = notes[index];
        final date = note.editedAt.toString().substring(0, 10);
        final time = note.editedAt.toString().substring(11, 16);
        return Card(
          elevation: 3.0,
          child: ListTile(
            isThreeLine: true,
            contentPadding: EdgeInsets.zero,
            onTap: () {
              onTap(note);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.inversePrimary)),
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                note.title.isNotEmpty ? note.title : '[Title]',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                left: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.body.isNotEmpty ? note.body : '[Body]',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(
                    height: 6,
                  ),
                  // const SizedBox(height: 6),
                  Row(children: [
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12),
                    ),
                    VerticalDivider(
                      thickness: 1.5,
                    ),
                    // const SizedBox(width: 4),
                    // const Icon(
                    //   Icons.circle,
                    //   size: 8,
                    //   color: Colors.black,
                    // ),
                    // const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ])
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteNote(note);
                        }
                      },
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
