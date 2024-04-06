// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:web_duplicate_app/constants.dart';

Future<void> snackbarMessage({
  String? message,
  String? errorMessage,
  required BuildContext context,
  Function()? functionCode,
}) async {
  bool withoutError = true;

  if (functionCode != null) {
    try {
      (functionCode is Future Function())
          ? await functionCode()
          : functionCode();
    } catch (error) {
      withoutError = false;
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(withoutError && message != null ? message : errorMessage!),
      backgroundColor: withoutError && message != null
          ? colorSkyBlue
          : const Color.fromARGB(255, 142, 20, 12),
    ),
  );
}
