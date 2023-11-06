import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/my_textfield.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';

class NewNotes extends StatefulWidget {
  const NewNotes({super.key});
  static const routeName = 'new_notes';

  @override
  State<NewNotes> createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  DatabaseNote? _note;
  late final NoteService _noteService;

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _noteService.getUser(email: email);
    return await _noteService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if ((_titleController.text.isEmpty || _bodyController.text.isEmpty) &&
        note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  Future<void> _saveNoteIfTextNotEmpty() async {
    final title = _titleController.text;
    final body = _bodyController.text;
    final note = _note;
    if ((title.isNotEmpty || body.isNotEmpty) && note != null) {
      await _noteService.updateNotes(note: note, title: title, body: body);
    }
  }

  @override
  void initState() {
    _noteService = NoteService();
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
    final title = _titleController.text;
    final body = _bodyController.text;
    await _noteService.updateNotes(note: note, body: body, title: title);
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
          'Create New Note',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
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
