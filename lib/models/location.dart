class LocationModel {
  final String date;
  final String locationAddress;
  final String name;
  final String description;
  final int remindBefore;

  LocationModel({
    this.name = '',
    this.description = '',
    this.remindBefore = 5,
    required this.date,
    required this.locationAddress,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      date: json['date'],
      locationAddress: json['locationAddress'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      remindBefore: json['remindBefore'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'locationAddress': locationAddress,
        'name': name,
        'description': description,
        'remindBefore': remindBefore,
      };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'locationAddress': locationAddress,
      'name': name,
      'description': description,
      'remindBefore': remindBefore,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      date: map['date'] as String,
      locationAddress: map['locationAddress'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      remindBefore: map['remindBefore'] as int,
    );
  }
}
