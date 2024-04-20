// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:web_duplicate_app/components/snackbarMessage.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/screens/project_board/components/email_inviation_dialog.dart';
import 'package:web_duplicate_app/services/project.dart';

class LocationAlertDialogWidget extends StatefulWidget {
  final VoidCallback onLocationPicked;
  const LocationAlertDialogWidget({
    super.key,
    required this.onLocationPicked,
    required this.pickedLocationNotifier,
    required this.onLocationSaved,
    required this.name,
    required this.description,
    required this.reminders,
    required this.projectID,
  });
  final ValueNotifier<LatLng?> pickedLocationNotifier;
  final Function(
    String name,
    String description,
    LatLng coordinates,
    List<Duration> remindersBefore,
  ) onLocationSaved;
  final String name;
  final String description;
  final List<Duration> reminders;
  final String projectID;

  @override
  State<LocationAlertDialogWidget> createState() =>
      _LocationAlertDialogWidgetState();
}

class _LocationAlertDialogWidgetState extends State<LocationAlertDialogWidget> {
  List<Duration> selectedReminders = [
    const Duration(minutes: 5),
  ];
  List<bool> reminderWidgets = [
    true,
  ];
  final List<Duration> notificationLeadTimes = [
    const Duration(minutes: 5),
    const Duration(minutes: 10),
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
    const Duration(days: 1),
    const Duration(days: 2),
    const Duration(days: 7),
  ];

  String durationToString(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final hours = duration.inHours;
    final days = duration.inDays;
    String timeString = "";
    if (hours > 0) {
      timeString += "$hours hour${hours > 1 ? "s" : ""}";
    }
    if (minutes > 0) {
      if (timeString.isNotEmpty) {
        timeString += " and ";
      }
      timeString += "$minutes minute${minutes > 1 ? "s" : ""}";
    }

    if (days > 0 && days < 7) {
      timeString = "$days day${days > 1 ? "s" : ""}";
    }

    if (days >= 7) {
      timeString = "${days ~/ 7} week${(days ~/ 7) > 1 ? "s" : ""}";
    }

    return "$timeString before";
  }

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  List<String> assignedTo = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    selectedReminders = widget.reminders;
    reminderWidgets = List.generate(widget.reminders.length, (index) => true);
    Future.delayed(Duration.zero, () async {
      final project = await ProjectService().readProject(widget.projectID);
      if (project != null) {
        setState(() {
          assignedTo = project.assignedTo;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _nameController,
          validator: (description) {
            if (description == null || description.isEmpty) {
              return 'Please enter name';
            }
            return null;
          },
          maxLength: 180,
          keyboardType: TextInputType.multiline,
          style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
          onChanged: (value) {
            if (value.isNotEmpty) {
              widget.onLocationSaved(
                _nameController.text,
                _descriptionController.text,
                widget.pickedLocationNotifier.value!,
                selectedReminders,
              );
            }
          },
          decoration: InputDecoration(
            labelText: 'Name',
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              color: colorWhite,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: colorSkyBlue),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: colorSkyBlue),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: colorSkyBlue),
            ),
          ),
        ),
        TextFormField(
          controller: _descriptionController,
          validator: (description) {
            if (description == null || description.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
          maxLength: 180,
          keyboardType: TextInputType.multiline,
          style: GoogleFonts.inter(fontSize: 12, color: colorWhite),
          onChanged: (value) {
            if (value.isNotEmpty) {
              widget.onLocationSaved(
                _nameController.text,
                _descriptionController.text,
                widget.pickedLocationNotifier.value!,
                selectedReminders,
              );
            }
          },
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: GoogleFonts.inter(
              fontSize: 12,
              color: colorWhite,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: colorSkyBlue),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: colorSkyBlue),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              borderSide: BorderSide(color: colorSkyBlue),
            ),
          ),
        ),
        const Row(
          children: [
            Text(
              'Remind before:',
              style: TextStyle(
                color: colorWhite,
              ),
            ),
          ],
        ),
        for (int i = 0; i < reminderWidgets.length; i++)
          DropdownButtonFormField<Duration>(
            value: selectedReminders[i], // Selected duration
            dropdownColor: colorSkyBlue,
            isDense: true,
            padding: EdgeInsets.zero,
            items: notificationLeadTimes
                .map(
                  (duration) => DropdownMenuItem<Duration>(
                    value: duration,
                    child: Text(
                      durationToString(duration),
                      style: const TextStyle(color: colorWhite),
                    ),
                  ),
                )
                .toList(),
            onChanged: (newValue) {
              if (selectedReminders.length > i) {
                selectedReminders[i] = newValue!;
              } else {
                selectedReminders.insert(i, newValue!);
              }
              widget.onLocationSaved(
                _nameController.text,
                _descriptionController.text,
                widget.pickedLocationNotifier.value ?? const LatLng(0, 0),
                selectedReminders,
              );
            },
            hint: const Text(
              'Select Lead Time',
              style: TextStyle(color: colorWhite),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextButton(
            onPressed: _addAnotherReminder,
            child: const Text('Add New'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            bottom: 8.0,
            top: 12.0,
          ),
          child: Row(
            children: [
              Text(
                'Assigned to:',
                style: TextStyle(
                  color: colorWhite,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: assignedTo
              .map((e) => Row(
                    children: [
                      Text(
                        e,
                        style: const TextStyle(color: colorWhite),
                      )
                    ],
                  ))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextButton(
            onPressed: _inviteUser,
            child: const Text('Invite More'),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.only(bottom: defaultPadding),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: colorSkyBlue,
            ),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            title: const Text(
              'Pick a location',
              style: TextStyle(color: Colors.white),
            ),
            onTap: widget.onLocationPicked,
          ),
        ),
        ValueListenableBuilder<LatLng?>(
            valueListenable: widget.pickedLocationNotifier,
            builder: (context, pickedLocation, child) {
              if (pickedLocation == null) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Click on map to open Google Maps Navigation',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: pickedLocation,
                            zoom: 7.0,
                          ),
                          onMapCreated: (GoogleMapController controller) {},
                          markers: {
                            Marker(
                              markerId: const MarkerId('pickedLocation'),
                              position: pickedLocation,
                            ),
                          },
                        ),
                        Positioned.fill(
                          child: InkWell(
                            onTap: () => launchGoogleMaps(
                              pickedLocation.latitude,
                              pickedLocation.longitude,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              );
            }),
      ],
    );
  }

  Future<void> launchGoogleMaps(double latitude, double longitude) async {
    snackbarMessage(
      message: 'Google Maps opened correctly',
      errorMessage: 'Could not open the map. Chat with support to fix this.',
      context: context,
      functionCode: () async {
        await launchUrlString(
          "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving",
        );
      },
    );
  }

  void _addAnotherReminder() {
    setState(() {
      reminderWidgets.add(true);
      selectedReminders.add(
        const Duration(minutes: 5),
      );
    });
  }

  void _inviteUser() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => InviteCollaboratorsDialog(
        projectID: widget.projectID,
      ),
    );
  }
}
