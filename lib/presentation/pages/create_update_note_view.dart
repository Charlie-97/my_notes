import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/my_textfield.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';

class CreateUpdateNoteView extends StatefulWidget {
  final String pageTitle;
  final DatabaseNote? note;
  const CreateUpdateNoteView({super.key, required this.pageTitle, this.note});
  static const routeName = 'new_notes';

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  Future<DatabaseNote> createOrGetExistingNote() async {
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
    final email = currentUser.email;
    final owner = await _noteService.getUser(email: email);
    final newNote = await _noteService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if ((_titleController.text.isEmpty && _bodyController.text.isEmpty) &&
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
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
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
          widget.pageTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
