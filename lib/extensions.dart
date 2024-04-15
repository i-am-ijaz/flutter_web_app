import 'package:flutter/material.dart';
import 'package:web_duplicate_app/components/loading_dialog.dart';

extension Loader on BuildContext {
  showLoading() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const LoadingDialog(),
    );
  }

  void hideLoading() {
    Navigator.of(this).pop();
  }
}
