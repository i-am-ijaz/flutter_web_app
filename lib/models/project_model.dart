import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:web_duplicate_app/models/counter.dart';
import 'package:web_duplicate_app/screens/project_board/project_board_screen.dart';

part 'project_model.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class Project {
  @JsonKey(name: 'projectID')
  final String id;
  @JsonKey(name: 'projectName')
  final String name;
  @JsonKey(name: 'projectDescription')
  final String description;
  final DateTime? createdAt;
  final CounterModel? counters;
  @JsonKey(defaultValue: [])
  final List<String> assignedTo;
  @JsonKey(defaultValue: [])
  final List<TaskData> todoTasks;
  @JsonKey(defaultValue: [])
  final List<TaskData> onProcessTasks;
  @JsonKey(defaultValue: [])
  final List<TaskData> finishedTasks;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.counters,
    required this.assignedTo,
    this.todoTasks = const [],
    this.onProcessTasks = const [],
    this.finishedTasks = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  Project copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    CounterModel? counters,
    List<String>? assignedTo,
    List<TaskData>? todoTasks,
    List<TaskData>? onProcessTasks,
    List<TaskData>? finishedTasks,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      counters: counters ?? this.counters,
      assignedTo: assignedTo ?? this.assignedTo,
      todoTasks: todoTasks ?? this.todoTasks,
      onProcessTasks: onProcessTasks ?? this.onProcessTasks,
      finishedTasks: finishedTasks ?? this.finishedTasks,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, description: $description, createdAt: $createdAt, counters: $counters, assignedTo: $assignedTo, todoTasks: $todoTasks, onProcessTasks: $onProcessTasks, finishedTasks: $finishedTasks)';
  }

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.counters == counters &&
        listEquals(other.assignedTo, assignedTo) &&
        listEquals(other.todoTasks, todoTasks) &&
        listEquals(other.onProcessTasks, onProcessTasks) &&
        listEquals(other.finishedTasks, finishedTasks);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        counters.hashCode ^
        assignedTo.hashCode ^
        todoTasks.hashCode ^
        onProcessTasks.hashCode ^
        finishedTasks.hashCode;
  }
}
