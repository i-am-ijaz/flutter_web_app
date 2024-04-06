class LocationModel {
  final String date;
  final String locationAddress;
  final String appflowyID;

  LocationModel({
    required this.date,
    required this.locationAddress,
    required this.appflowyID,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      date: json['date'],
      locationAddress: json['locationAddress'] as String,
      appflowyID: json['appflowyID'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'locationAddress': locationAddress,
        'appflowyID': appflowyID,
      };
}
