// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      counters: CounterModel.fromJson(json['counters'] as Map<String, dynamic>),
      assignedTo: (json['assignedTo'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      todoTasks: (json['todoTasks'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e as String))
              .toList() ??
          const [],
      onProcessTasks: (json['onProcessTasks'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e as String))
              .toList() ??
          const [],
      finishedTasks: (json['finishedTasks'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e as String))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'counters': instance.counters.toJson(),
      'assignedTo': instance.assignedTo,
      'todoTasks': instance.todoTasks.map((e) => e.toJson()).toList(),
      'onProcessTasks': instance.onProcessTasks.map((e) => e.toJson()).toList(),
      'finishedTasks': instance.finishedTasks.map((e) => e.toJson()).toList(),
    };
