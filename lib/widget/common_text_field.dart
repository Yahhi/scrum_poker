import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({Key? key, required this.label, this.controller, this.maxLines = 1}) : super(key: key);

  static const borderRadius10 = BorderRadius.all(Radius.circular(10));
  static const textInputBorder = OutlineInputBorder(
    borderRadius: borderRadius10,
    borderSide: BorderSide(color: Colors.grey),
  );
  static const textFocusedBorder = OutlineInputBorder(
    borderRadius: borderRadius10,
    borderSide: BorderSide(color: Colors.blue),
  );
  static const double sidePadding16 = 16;

  final TextEditingController? controller;
  final String label;

  /// if null, it can expand
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      expands: maxLines == null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: textInputBorder,
        enabledBorder: textInputBorder,
        focusedBorder: textFocusedBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: sidePadding16),
      ),
    );
  }
}
