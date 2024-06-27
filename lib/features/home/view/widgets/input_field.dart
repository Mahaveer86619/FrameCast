import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final int? lines;
  final String? initialValue;

  const MyInputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.lines,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      validator: validator,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: lines,
      minLines: lines,
      autocorrect: true,
      onChanged: (value) {
        controller.text = value;
      },
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
