import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:web_duplicate_app/components/custom_alertdialog.dart';
import 'package:web_duplicate_app/components/location_alert_dialog_widget.dart';
import 'package:web_duplicate_app/components/snackbarMessage.dart';
import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/models/frame.dart';
import 'package:web_duplicate_app/models/location.dart';
import 'package:web_duplicate_app/services/frame.dart';

class AlertsComponent {
  final FrameService frameService = FrameService();

  Future<dynamic> showLocationAlert({
    required FrameModel frameModel,
    required String projectID,
    required String frameID,
    required BuildContext context,
  }) async {
    final geocoding = GoogleMapsGeocoding(
      apiKey: googlePlacesApiKey,
      baseUrl: placesNoCorsApi,
    );
    ValueNotifier<String?> dateNotifier = ValueNotifier<String?>(null);

    ValueNotifier<LatLng?> pickedLocationNotifier =
        ValueNotifier<LatLng?>(null);

    if (frameModel.location?.date != null) {
      dateNotifier.value = frameModel.location!.date;
    }
    if (frameModel.location?.locationAddress != null) {
      String lat =
          frameModel.location!.locationAddress.toString().split(',')[0];
      String long =
          frameModel.location!.locationAddress.toString().split(',')[1];
      LatLng coordinates = LatLng(
        double.parse(lat.trim()),
        double.parse(long.trim()),
      );

      pickedLocationNotifier.value = coordinates;
    } else {
      pickedLocationNotifier.value = const LatLng(0, 0);
    }

    String name = frameModel.location?.name ?? '',
        description = frameModel.location?.description ?? '';
    List<Duration> remindersBefore = frameModel.location == null
        ? [const Duration(minutes: 5)]
        : List.generate(
            frameModel.location!.remindBefore.length,
            (index) => Duration(
              minutes: frameModel.location!.remindBefore[index],
            ),
          );

    return CustomAlertDialogComponent(
      dateNotifier: dateNotifier,
      title: 'Location',
      content: LocationAlertDialogWidget(
        projectID: projectID,
        name: name,
        description: description,
        reminders: remindersBefore,
        pickedLocationNotifier: pickedLocationNotifier,
        onLocationSaved: (
          updateName,
          updatedDescription,
          location,
          reminders,
        ) async {
          name = updateName.trim();
          description = updatedDescription.trim();
          pickedLocationNotifier.value = location;
          remindersBefore = reminders;
        },
        onLocationPicked: () async {
          final Prediction? p = await PlacesAutocomplete.show(
            proxyBaseUrl: placesNoCorsApi,
            context: context,
            apiKey: googlePlacesApiKey,
            onError: (error) {
              snackbarMessage(
                errorMessage: error.errorMessage ?? 'Unknown error',
                context: context,
              );
            },
            mode: Mode.overlay, // or Mode.fullscreen
            language: 'us',
          );
          List<GeocodingResult> response =
              (await geocoding.searchByAddress(p!.description!)).results;
          if (response.isNotEmpty) {
            pickedLocationNotifier.value = LatLng(
              response[0].geometry.location.lat,
              response[0].geometry.location.lng,
            );
          }
        },
      ),
      onSubmit: () async {
        if (pickedLocationNotifier.value == null) {
          snackbarMessage(
            errorMessage: 'Location is required',
            context: context,
          );
          return;
        }
        if (dateNotifier.value == null) {
          snackbarMessage(
            errorMessage: 'Date is required',
            context: context,
          );
          return;
        }

        if (name.isEmpty) {
          snackbarMessage(
            errorMessage: 'Name is required',
            context: context,
          );
          return;
        }

        if (description.isEmpty) {
          snackbarMessage(
            errorMessage: 'Description is required',
            context: context,
          );
          return;
        }

        // TODO: AppFlowyID Here
        await frameService.updateLocation(
          LocationModel(
            date: dateNotifier.value!,
            locationAddress:
                '${pickedLocationNotifier.value!.latitude}, ${pickedLocationNotifier.value!.longitude}',
            name: name,
            description: description,
            remindBefore: List.generate(
              remindersBefore.length,
              (index) => remindersBefore[index].inMinutes,
            ),
          ),
          projectID,
          frameID,
        );

        // try {
        //   GoogleCalendarService().insertEvent(
        //     Event(
        //       start: EventDateTime(
        //         date: DateTime.now().add(const Duration(minutes: 30)),
        //         dateTime: DateTime.now().add(const Duration(minutes: 30)),
        //         timeZone: 'Asia/Karachi',
        //       ),
        //       attendees: [
        //         EventAttendee(
        //           email: 'ijazsharif34@gmail.com',
        //         ),
        //       ],
        //       description: description,
        //       reminders: EventReminders(
        //         overrides: [
        //           EventReminder(
        //             minutes: remindBefore.inMinutes,
        //           )
        //         ],
        //       ),
        //       summary: name,
        //       location: coordinates.toString(),
        //     ),
        //   );
        // } catch (e) {
        //   log(e.toString());
        // }

        Navigator.of(context).pop();
        snackbarMessage(
          message: 'Location added correctly.',
          context: context,
        );
      },
    ).showAlertDialog(context);
  }
}
