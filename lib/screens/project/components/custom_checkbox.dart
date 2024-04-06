import 'package:flutter/material.dart';
import 'package:web_duplicate_app/constants.dart';

class CustomCheckBox extends StatefulWidget {
  final bool initialValue;
  final Function(bool newValue) onChange;

  const CustomCheckBox(
      {super.key, required this.initialValue, required this.onChange});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool isTrue;

  @override
  void initState() {
    super.initState();
    isTrue = widget.initialValue;
  }

  toggleCheckBox() {
    setState(() {
      isTrue = !isTrue;
    });
    widget.onChange(isTrue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorMediumBlue,
        shape: BoxShape.circle,
        border: Border.all(color: colorLightBlue),
      ),
      child: OutlinedButton(
        onPressed: toggleCheckBox,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(23, 23),
          side: const BorderSide(color: colorLightBlue),
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
        ),
        child: isTrue
            ? const Icon(
                Icons.done,
                size: 10,
                color: colorWhite,
              )
            : const SizedBox(width: 8),
      ),
    );
  }
}
