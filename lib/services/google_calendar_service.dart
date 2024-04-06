import 'dart:developer';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;

class GoogleCalendarService {
  static const _clienID =
      "217348332304-jnpqhfsar0p9d6cs7n265agp2fhpmphp.apps.googleusercontent.com";

  Future<void> insertEvent(Event event) async {
    try {
      final googleSignIn = await GoogleSignIn(
        clientId: _clienID,
        scopes: <String>[
          CalendarApi.calendarScope,
          CalendarApi.calendarEventsScope,
        ],
      ).signIn();

      if (googleSignIn == null) return;
      final authHeaders = await googleSignIn.authHeaders;
      print(authHeaders);

      var calendar = CalendarApi(
        GoogleAPIClient(authHeaders),
      );
      String calendarId = "primary";
      final createdEvent = await calendar.events.insert(event, calendarId);
      print(createdEvent);
    } catch (e) {
      print(e);
      log('Error creating event $e');
    }
  }

  void prompt(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}
