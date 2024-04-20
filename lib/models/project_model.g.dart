// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: json['projectID'] as String,
      name: json['projectName'] as String,
      description: json['projectDescription'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      counters: json['counters'] == null
          ? null
          : CounterModel.fromJson(json['counters'] as Map<String, dynamic>),
      assignedTo: (json['assignedTo'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      todoTasks: (json['todoTasks'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e as String))
              .toList() ??
          [],
      onProcessTasks: (json['onProcessTasks'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e as String))
              .toList() ??
          [],
      finishedTasks: (json['finishedTasks'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e as String))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'projectID': instance.id,
      'projectName': instance.name,
      'projectDescription': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'counters': instance.counters?.toJson(),
      'assignedTo': instance.assignedTo,
      'todoTasks': instance.todoTasks.map((e) => e.toJson()).toList(),
      'onProcessTasks': instance.onProcessTasks.map((e) => e.toJson()).toList(),
      'finishedTasks': instance.finishedTasks.map((e) => e.toJson()).toList(),
    };
