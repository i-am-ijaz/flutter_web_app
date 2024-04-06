import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web_duplicate_app/components/text_widget.dart';
import 'package:web_duplicate_app/constants.dart';

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.text,
    required this.count,
    this.iconSize,
  });
  final String text;
  final String count;
  final String icon;
  final double? iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        onPressed: onPressed ?? () {},
        style: OutlinedButton.styleFrom(
            backgroundColor: colorMediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            side: const BorderSide(color: colorLightBlue),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(88))),
        label: TextWidget(
          text: '$text \t\t $count',
        ),
        icon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SvgPicture.asset(
            icon,
            height: iconSize,
          ),
        ));
  }
}

class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.text,
    this.iconSize,
  });
  final String text;
  final String icon;
  final double? iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed ?? () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: colorMediumBlue,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            side: const BorderSide(color: colorLightBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(88),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SvgPicture.asset(
              icon,
              height: iconSize,
            ),
          ),
          label: TextWidget(
            text: text,
          ),
        ),
      ),
    );
  }
}

class CloseOpenDrawerButton extends StatelessWidget {
  const CloseOpenDrawerButton(
      {super.key, this.onPressed, required this.isExpanded});
  final VoidCallback? onPressed;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 17,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: colorSkyBlue,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Transform.rotate(
          angle: isExpanded ? pi / 1 : 0,
          child: SvgPicture.asset(icRightArrow),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });
  final String icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          backgroundColor: colorMediumBlue,
          side: const BorderSide(color: colorLightBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 0,
          ),
          minimumSize: const Size(50, 30)),
      icon: SvgPicture.asset(
        icon,
        height: 14,
      ),
      label: TextWidget(
        text: text,
        fontSize: 11,
      ),
    );
  }
}

class ArrowButtons extends StatelessWidget {
  const ArrowButtons({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: colorMediumBlue,
        side: const BorderSide(color: colorLightBlue),
        padding: EdgeInsets.zero,
        minimumSize: const Size(20, 20),
        shape: const CircleBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          icon,
          height: 12,
        ),
      ),
    );
  }
}
