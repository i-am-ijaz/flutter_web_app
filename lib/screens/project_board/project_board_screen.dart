// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';

import 'package:web_duplicate_app/constants.dart';
import 'package:web_duplicate_app/screens/dashboard.dart';
import 'package:web_duplicate_app/screens/project_board/components/project_board.dart';

class ProjectBoardScreen extends StatefulWidget {
  const ProjectBoardScreen({super.key});

  @override
  State<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
}

class _ProjectBoardScreenState extends State<ProjectBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Film Planner',
      color: Colors.white,
      child: const Scaffold(
        backgroundColor: colorDarKBlue,
        body: DashboardScreen(
          backActionEnabled: false,
          title: 'Project',
          children: [
            ProjectBoard(),
          ],
        ),
      ),
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final TaskData data;
  TextItem(this.data);

  @override
  String get id => data.title;
}

enum TaskStatus { todo, onProcess, done }

class TaskData {
  final String title;
  final String description;
  final DateTime createdAt;
  final TaskStatus status;

  const TaskData({
    required this.title,
    required this.description,
    required this.createdAt,
    this.status = TaskStatus.todo,
  });

  TaskData copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    TaskStatus? status,
  }) {
    return TaskData(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status.name,
    };
  }

  factory TaskData.fromMap(Map<String, dynamic> map) {
    return TaskData(
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      status: TaskStatus.values.firstWhere((e) => e.name == map['status']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskData.fromJson(String source) =>
      TaskData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskData(title: $title, description: $description, createdAt: $createdAt, status: $status)';
  }

  @override
  bool operator ==(covariant TaskData other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
