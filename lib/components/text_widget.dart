import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_duplicate_app/constants.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final double? textHeight;
  final TextDecoration? decoration;
  final List<Shadow>? shadow;

  const TextWidget(
      {super.key,
      this.text,
      this.color = colorWhite,
      this.fontSize,
      this.letterSpacing,
      this.textAlign,
      this.onTap,
      this.fontWeight = FontWeight.w400,
      this.textOverflow,
      this.maxLines,
      this.textHeight,
      this.decoration,
      this.shadow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        text ?? "",
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: textOverflow,

        // softWrap: true,
        style: GoogleFonts.inter(
          shadows: shadow,
          color: color,
          height: textHeight,
          fontSize: fontSize ?? 14,
          letterSpacing: letterSpacing,
          decoration: decoration,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
