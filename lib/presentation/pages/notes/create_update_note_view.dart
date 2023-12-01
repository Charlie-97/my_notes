import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/my_textfield.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  final String pageTitle;
  final CloudNote? note;
  const CreateUpdateNoteView({super.key, required this.pageTitle, this.note});
  static const routeName = 'new_notes';

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  Future<CloudNote> createOrGetExistingNote() async {
    final widgetNote = widget.note;

    if (widgetNote != null) {
      _note = widgetNote;
      _titleController.text = widgetNote.title;
      _bodyController.text = widgetNote.body;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final newNote =
        await _noteService.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if ((_titleController.text.isEmpty && _bodyController.text.isEmpty) &&
        note != null) {
      _noteService.deleteNotes(docId: note.docId);
    }
  }

  Future<void> _saveNoteIfTextNotEmpty() async {
    final title = _titleController.text;
    final body = _bodyController.text;
    final note = _note;
    if ((title.isNotEmpty || body.isNotEmpty) && note != null) {
      await _noteService.updateNote(
          docId: note.docId, title: title, body: body);
    }
  }

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _bodyController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    await _noteService.updateNote(docId: note.docId, body: body, title: title);
  }

  void _setupTextControllerListener() {
    _titleController.removeListener(_textControllerListener);
    _bodyController.removeListener(_textControllerListener);
    _titleController.addListener(_textControllerListener);
    _bodyController.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (_titleController.text.isNotEmpty ||
                  _bodyController.text.isNotEmpty) {
                final title = _titleController.text.isNotEmpty
                    ? _titleController.text
                    : '[UNTITLED]';
                final body = _bodyController.text.isNotEmpty
                    ? _bodyController.text
                    : '[EMPTY NOTES]';

                final text = '$title\n$body';
                Share.share(text);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  children: [
                    MyTextField(
                      hint: '[Title]',
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                      textController: _titleController,
                    ),
                    Divider(
                      height: 20.0,
                      thickness: 3.0,
                      color: Colors.deepPurple[900],
                    ),
                    Expanded(
                      child: MyTextField(
                        hint: '[Enter your note here...]',
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        textController: _bodyController,
                      ),
                    )
                  ],
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
