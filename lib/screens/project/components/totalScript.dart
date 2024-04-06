// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_duplicate_app/components/snackbarMessage.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/services/project.dart';

class TotalScriptComponent extends StatefulWidget {
  final String projectID;
  const TotalScriptComponent({super.key, required this.projectID});

  @override
  State<TotalScriptComponent> createState() => _TotalScriptComponentState();
}

class _TotalScriptComponentState extends State<TotalScriptComponent> {
  final ProjectService _projectService = ProjectService();
  late TextEditingController _scriptController;

  @override
  void initState() {
    super.initState();
    _scriptController = TextEditingController();
    _loadTotalScript();
  }

  @override
  void dispose() {
    _scriptController.dispose();
    super.dispose();
  }

  Future<void> _loadTotalScript() async {
    final totalScript = await _projectService.getTotalScript(widget.projectID);
    setState(() {
      _scriptController.text = totalScript ?? '';
    });
  }

  Future<void> _updateTotalScript() async {
    final newScript = _scriptController.text;
    await _projectService.setTotalScript(newScript, widget.projectID);
    await _projectService.updateWordsCounter(widget.projectID, newScript);

    snackbarMessage(
      message: 'Script saved successfully.',
      context: context,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Total Script',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: colorDarKBlue,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: colorSkyBlue, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width > 800
                  ? 800
                  : MediaQuery.of(context).size.width,
              child: TextField(
                controller: _scriptController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorSkyBlue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorSkyBlue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: colorSkyBlue),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: _updateTotalScript,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: defaultPadding),
        width: 850,
        decoration: BoxDecoration(
          color: colorMediumBlue,
          border: Border.all(color: colorLightBlue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const ListTile(
          leading: Icon(
            Icons.edit_document,
            color: Colors.white,
          ),
          title: Text(
            'Total Script',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: Text(
            'Open',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
