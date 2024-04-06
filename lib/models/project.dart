import 'package:web_duplicate_app/models/counter.dart';

class ProjectModel {
  final String projectID;
  final String projectName;
  final String projectDescription;
  final String status; // (To Do, On Process, Finished)
  final DateTime date;
  final CounterModel counters;
  final List<dynamic> assignedTo;

  ProjectModel({
    required this.projectID,
    required this.projectName,
    required this.projectDescription,
    required this.status,
    required this.date,
    required this.counters,
    required this.assignedTo,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectID: json['projectID'] as String,
      projectName: json['projectName'] as String,
      projectDescription: json['projectDescription'] as String,
      status: json['status'] as String,
      date: DateTime.parse(json['date'] as String),
      counters: CounterModel.fromJson(json['counters'] as Map<String, dynamic>),
      assignedTo: json['assignedTo'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
        'projectID': projectID,
        'projectName': projectName,
        'projectDescription': projectDescription,
        'status': status,
        'date': date.toIso8601String(),
        'counters': counters.toJson(),
        'assignedTo': assignedTo
      };
  ProjectModel copyWith({
    String? projectID,
    String? projectName,
    String? projectDescription,
    List<String>? assignedTo,
    String? status,
    DateTime? date,
    CounterModel? counters,
  }) {
    return ProjectModel(
      projectID: projectID ?? this.projectID,
      projectName: projectName ?? this.projectName,
      projectDescription: projectDescription ?? this.projectDescription,
      status: status ?? this.status,
      date: date ?? this.date,
      counters: counters ?? this.counters,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}
