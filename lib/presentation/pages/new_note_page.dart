import 'package:flutter/material.dart';

class NewNotes extends StatelessWidget {
  const NewNotes({super.key});
  static const routeName = 'new_notes';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Note'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(),
    );
  }
}
