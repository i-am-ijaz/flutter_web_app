import 'package:flutter/foundation.dart';

class LocationModel {
  final String date;
  final String locationAddress;
  final String name;
  final String description;
  final List<int> remindBefore;

  LocationModel({
    required this.date,
    required this.locationAddress,
    this.name = '',
    this.description = '',
    this.remindBefore = const [],
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      date: json['date'],
      locationAddress: json['locationAddress'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      remindBefore: List<int>.from(
        (json['remindBefore']),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'locationAddress': locationAddress,
        'name': name,
        'description': description,
        'remindBefore': remindBefore,
      };

  LocationModel copyWith({
    String? date,
    String? locationAddress,
    String? name,
    String? description,
    List<int>? remindBefore,
  }) {
    return LocationModel(
      date: date ?? this.date,
      locationAddress: locationAddress ?? this.locationAddress,
      name: name ?? this.name,
      description: description ?? this.description,
      remindBefore: remindBefore ?? this.remindBefore,
    );
  }

  @override
  String toString() {
    return 'LocationModel(date: $date, locationAddress: $locationAddress, name: $name, description: $description, remindBefore: $remindBefore)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.locationAddress == locationAddress &&
        other.name == name &&
        other.description == description &&
        listEquals(other.remindBefore, remindBefore);
  }

  @override
  int get hashCode {
    return date.hashCode ^
        locationAddress.hashCode ^
        name.hashCode ^
        description.hashCode ^
        remindBefore.hashCode;
  }
}
