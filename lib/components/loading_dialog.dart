import 'package:flutter/material.dart';
import 'package:web_duplicate_app/constants.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        backgroundColor: colorDarKBlue,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: colorSkyBlue, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text(
                'Please wait...',
                style: TextStyle(color: colorWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
