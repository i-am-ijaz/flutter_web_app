import 'package:flutter/material.dart';
import 'package:web_duplicate_app/components/email_field.dart.dart';
import 'package:web_duplicate_app/components/snackbarMessage.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/services/project.dart';

class InviteCollaboratorsDialog extends StatefulWidget {
  const InviteCollaboratorsDialog({
    super.key,
    required this.projectID,
  });
  final String projectID;

  @override
  InviteCollaboratorsDialogState createState() =>
      InviteCollaboratorsDialogState();
}

class InviteCollaboratorsDialogState extends State<InviteCollaboratorsDialog> {
  final List<TextEditingController> _emailControllers = [
    TextEditingController()
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in _emailControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addEmailField() {
    setState(() {
      _emailControllers.add(TextEditingController());
    });
  }

  Future<void> _sendInvitations() async {
    if (_formKey.currentState!.validate()) {
      for (var i = 0; i < _emailControllers.length; i++) {
        await ProjectService().inviteUser(
          _emailControllers[i].text,
          widget.projectID,
        );
      }

      if (mounted) {
        snackbarMessage(context: context, message: 'Invitations sent');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Invite User',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: colorDarKBlue,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: colorSkyBlue, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (int i = 0; i < _emailControllers.length; i++)
                  Row(
                    children: [
                      Expanded(
                        child: EmailField(
                          key: ValueKey(i),
                          controller: _emailControllers[i],
                        ),
                      ),
                      if (i > 0)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: colorWhite,
                          ),
                          onPressed: () {
                            setState(() {
                              _emailControllers.removeAt(i);
                            });
                          },
                        ),
                    ],
                  ),
                TextButton(
                  onPressed: _addEmailField,
                  child: const Text('Add Another Email'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _sendInvitations,
          child: const Text('Send Invitations'),
        ),
      ],
    );
  }
}
