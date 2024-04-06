import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_duplicate_app/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class CustomTextEditor extends StatelessWidget {
  const CustomTextEditor({super.key, required this.editorState});

  final EditorState editorState;

  @override
  Widget build(BuildContext context) {
    return AppFlowyEditor(
      editorState: editorState,
    );
  }
}
