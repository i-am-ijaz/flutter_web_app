// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:web_duplicate_app/constants.dart';

class CustomAlertDialogComponent {
  final ValueNotifier<String?>? dateNotifier;
  final String title;
  final Widget content;

  final Function() onSubmit;

  CustomAlertDialogComponent({
    this.dateNotifier,
    required this.title,
    required this.content,
    required this.onSubmit,
  });

  pickerTheme({required Widget child}) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          surface: colorDarKBlue, // Picker Background color
          surfaceTint:
              colorDarKBlue, // Picker Background color without varients
          primary: colorSkyBlue, // Button Selection BG Color
          onPrimary: Colors.white, // Selection color: text and circular border
          onSurface: Colors.white, // Calendar Text Colors,
          tertiary: colorSkyBlue, // Time AM/PM BG Color
          onTertiary: Colors.white, // Time AM/PM Text Color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // button text color
          ),
        ),
      ),
      child: child,
    );
  }

  Future<void> requestDate(BuildContext context) async {
    if (dateNotifier!.value != null) {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        builder: (BuildContext context, Widget? child) {
          return pickerTheme(child: child!);
        },
      );
      if (pickedDate != null) {
        requestTime(context, initialDate: pickedDate);
      }
    }
  }

  Future<void> requestTime(BuildContext context,
      {required DateTime initialDate}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return pickerTheme(child: child!);
      },
    );
    if (pickedTime != null) {
      final DateTime finalDateTime = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      dateNotifier!.value =
          "${DateFormat('yyyy-MM-dd – HH:mm a').format(finalDateTime)} ${await FlutterNativeTimezone.getLocalTimezone()}";
    }
  }

  showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: colorDarKBlue,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: colorSkyBlue, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              constraints: const BoxConstraints(minWidth: 400),
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    content,
                    if (dateNotifier != null)
                      InkWell(
                          onTap: () => requestDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: colorSkyBlue,
                              ),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              title: ValueListenableBuilder<String?>(
                                valueListenable: dateNotifier!,
                                builder: (context, date, child) {
                                  if (date == null) {
                                    return Text(
                                      "Select Date and Time",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    );
                                  }
                                  return Text(
                                    date,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          )),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                onPressed: onSubmit,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
