import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textController;
  final TextStyle? hintStyle;

  const MyTextField({
    super.key,
    required this.hint,
    required this.textController,
    required this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      maxLines: null,
      minLines: hint == '[Title]' ? 1 : 50,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle,
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.deepPurple[50],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 12.0,
        ),
      ),
    );
  }
}
