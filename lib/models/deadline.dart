import 'package:cloud_firestore/cloud_firestore.dart';

class DeadlineModel {
  final DateTime date;
  final List<DateTime> reminders;

  DeadlineModel({
    required this.date,
    required this.reminders,
  });

  factory DeadlineModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else {
        throw const FormatException('Invalid date format');
      }
    }

    List<DateTime> parseReminders(List<dynamic> reminders) {
      return reminders.map((reminder) => parseDateTime(reminder)).toList();
    }

    return DeadlineModel(
      date: parseDateTime(json['date']),
      reminders: parseReminders(json['reminders']),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'reminders':
            reminders.map((reminder) => reminder.toIso8601String()).toList(),
      };
}
