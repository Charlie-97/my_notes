import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textController;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final FocusNode? nextField;

  const MyTextField(
      {super.key,
      required this.hint,
      required this.textController,
      this.hintStyle,
      this.focusNode,
      this.nextField});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      focusNode: focusNode,
      onEditingComplete: () {
        nextField?.requestFocus();
      },
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      maxLines: null,
      minLines: hint == '[Title]' ? 1 : 50,
      keyboardType:
          hint == '[Title]' ? TextInputType.text : TextInputType.multiline,
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
