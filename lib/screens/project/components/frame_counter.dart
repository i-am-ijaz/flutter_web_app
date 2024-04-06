import 'package:flutter/material.dart';
import 'package:web_duplicate_app/components/text_widget.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/screens/login/login.dart';

class FrameCounter extends StatelessWidget {
  const FrameCounter({
    super.key,
    required this.count,
    required this.onChange,
    required this.isShotOrder,
  });

  final bool isShotOrder;
  final double count;
  final Function(String newValue) onChange;

  Future<void> _showInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorDarKBlue,
          title: Text(
            isShotOrder ? 'Shot Order' : 'Story Order',
            style: const TextStyle(color: Colors.white),
          ),
          content: TextFieldWithIcon(
            hintText: 'Enter the value',
            icon: Icons.numbers,
            onChanged: onChange,
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: colorSkyBlue, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showInputDialog(context);
      },
      child: Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: colorMediumBlue,
          shape: BoxShape.circle,
          border: Border.all(color: colorLightBlue),
        ),
        child: Center(
          child: TextWidget(
            text: "$count",
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
