// ignore_for_file: file_names

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_duplicate_app/components/text_field.dart';
import 'package:web_duplicate_app/components/text_widget.dart';
import 'package:web_duplicate_app/constants.dart';

class ScriptInformationExpansionPanelComponent extends StatefulWidget {
  const ScriptInformationExpansionPanelComponent({super.key});

  @override
  State<ScriptInformationExpansionPanelComponent> createState() =>
      _ScriptInformationExpansionPanelComponentState();
}

class _ScriptInformationExpansionPanelComponentState
    extends State<ScriptInformationExpansionPanelComponent> {
  late double height;

  bool isPanelOpen = false;

  togglePanelHeight() {
    if (isPanelOpen) {
      height = 24;
    } else {
      height = 226;
    }
    isPanelOpen = !isPanelOpen;
    setState(() {});
  }

  @override
  void initState() {
    height = 24;
    super.initState();
  }

  final scriptState = EditorState.blank();
  final visualState = EditorState.blank();
  final scriptFocus = FocusNode();
  final visualFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      duration: const Duration(milliseconds: 100),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () => togglePanelHeight(),
            style: OutlinedButton.styleFrom(
              backgroundColor: colorMediumBlue,
              side: const BorderSide(
                color: colorLightBlue,
                width: 0.7,
              ),
              minimumSize: const Size(516, 32),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TextWidget(
                  text: 'Script Information',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(icDownArrow),
              ],
            ),
          ),
          Visibility(
            visible: isPanelOpen,
            child: Expanded(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(3.5),
                },
                border: TableBorder.symmetric(
                  inside: const BorderSide(color: colorLightBlue),
                ),
                children: [
                  TableRow(
                    children: [
                      tableHeading(icon: icTime, text: 'Time'),
                      tableHeading(icon: icScript, text: 'Script'),
                      tableHeading(icon: icVisual, text: 'Visual Explanation')
                    ],
                  ),
                  TableRow(
                    children: [
                      const CustomTextField(),
                      SizedBox(
                        height: 165,
                        width: 200,
                        child: AppFlowyEditor(
                          editorState: scriptState,
                          editorStyle: customizeEditorStyle(),
                        ),
                      ),
                      SizedBox(
                        height: 165,
                        width: 200,
                        child: TapRegion(
                          onTapOutside: (event) {
                            setState(() {
                              visualFocus.unfocus();
                            });
                          },
                          child: AppFlowyEditor(
                            focusNode: visualFocus,
                            editorState: visualState,
                            editorStyle: customizeEditorStyle(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget tableHeading({required String icon, required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    child: Row(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(width: 6),
        TextWidget(
          text: text,
          fontSize: 11,
        )
      ],
    ),
  );
}

EditorStyle customizeEditorStyle() {
  return EditorStyle(
    padding: const EdgeInsets.all(8),
    cursorColor: colorLightBlue,
    dragHandleColor: colorLightBlue,
    selectionColor: colorLightBlue.withOpacity(0.5),
    textStyleConfiguration: TextStyleConfiguration(
      text: GoogleFonts.inter(
        fontSize: 14.0,
        color: Colors.white,
      ),
      bold: const TextStyle(
        fontWeight: FontWeight.w900,
      ),
      href: TextStyle(
        color: Colors.amber,
        decoration: TextDecoration.combine(
          [
            TextDecoration.overline,
            TextDecoration.underline,
          ],
        ),
      ),
      code: const TextStyle(
        fontSize: 14.0,
        fontStyle: FontStyle.italic,
        color: colorLightBlueShade2,
        backgroundColor: Colors.black12,
      ),
    ),
    textSpanDecorator: (context, node, index, text, before, _) {
      final attributes = text.attributes;
      final href = attributes?[AppFlowyRichTextKeys.href];
      if (href != null) {
        return TextSpan(
          text: text.text,
          style: before.style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              debugPrint('onTap: $href');
            },
        );
      }
      return before;
    },
  );
}
