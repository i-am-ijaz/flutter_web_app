// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_duplicate_app/constants.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (email) {
        if (email == null || email.isEmpty) {
          return 'Please enter your email.';
        }

        if (!EmailValidator.validate(email)) {
          return 'Please enter a valid email.';
        }

        return null;
      },
      maxLength: 30,
      keyboardType: TextInputType.multiline,
      style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: colorWhite,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: colorSkyBlue),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: colorSkyBlue),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: BorderSide(color: colorSkyBlue),
        ),
      ),
    );
  }
}
