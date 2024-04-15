// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:web_duplicate_app/components/snackbarMessage.dart';
import 'package:web_duplicate_app/constants.dart';

class LocationAlertDialogWidget extends StatefulWidget {
  final VoidCallback onLocationPicked;
  const LocationAlertDialogWidget({
    super.key,
    required this.onLocationPicked,
    required this.pickedLocationNotifier,
    required this.onLocationSaved,
  });
  final ValueNotifier<LatLng?> pickedLocationNotifier;
  final Function(
    String name,
    String description,
    LatLng coordinates,
    Duration leadTime,
  ) onLocationSaved;

  @override
  State<LocationAlertDialogWidget> createState() =>
      _LocationAlertDialogWidgetState();
}

class _LocationAlertDialogWidgetState extends State<LocationAlertDialogWidget> {
  Duration? selectedLeadTime;
  final List<Duration> notificationLeadTimes = [
    const Duration(minutes: 5),
    const Duration(minutes: 10),
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
  ];

  String durationToString(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final hours = duration.inHours;
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
    return timeString;
  }

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
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
                selectedLeadTime ?? const Duration(minutes: 5),
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
                selectedLeadTime ?? const Duration(minutes: 5),
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
        DropdownButtonFormField<Duration>(
          value: selectedLeadTime, // Selected duration
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
            setState(() => selectedLeadTime = newValue!);
            widget.onLocationSaved(
              _nameController.text,
              _descriptionController.text,
              widget.pickedLocationNotifier.value!,
              selectedLeadTime ?? const Duration(minutes: 5),
            );
          },
          hint: const Text(
            'Select Lead Time',
            style: TextStyle(color: colorWhite),
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                4,
                (index) => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'test@test.com',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: colorWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Container(
        //   margin: const EdgeInsets.only(bottom: defaultPadding),
        //   decoration: BoxDecoration(
        //     shape: BoxShape.rectangle,
        //     border: Border.all(
        //       color: colorSkyBlue,
        //     ),
        //   ),
        //   child: ListTile(
        //     leading: const Icon(
        //       Icons.location_on,
        //       color: Colors.white,
        //     ),
        //     title: const Text(
        //       'Pick a location',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     onTap: widget.onLocationPicked,
        //   ),
        // ),
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
                            zoom: 14,
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
}
