import 'package:web_duplicate_app/models/deadline.dart';
import 'package:web_duplicate_app/models/location.dart';
import 'package:web_duplicate_app/models/sceneInformation.dart';
import 'package:web_duplicate_app/models/scriptInformation.dart';

class FrameModel {
  String id;
  double storyOrder;
  double shotOrder;
  bool? completed;
  LocationModel? location;
  String? checklistID;
  DeadlineModel? deadline;
  String? ideasID;
  String? obstaclesID;
  SceneInformationModel? sceneInformation;
  ScriptInformationModel? scriptInformation;

  FrameModel({
    required this.id,
    required this.storyOrder,
    required this.shotOrder,
    this.completed = false,
    this.location,
    this.checklistID,
    this.deadline,
    this.ideasID,
    this.obstaclesID,
    this.sceneInformation,
    this.scriptInformation,
  });

  factory FrameModel.fromJson(Map<String, dynamic> json) {
    return FrameModel(
      id: json['id'] as String,
      storyOrder: json['storyOrder'] as double,
      shotOrder: json['shotOrder'] as double,
      completed: json['completed'] as bool?,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      checklistID: json['checklistID'] as String?,
      deadline: json['deadline'] != null
          ? DeadlineModel.fromJson(json['deadline'] as Map<String, dynamic>)
          : null,
      ideasID: json['ideasID'] as String?,
      obstaclesID: json['obstaclesID'] as String?,
      sceneInformation: json['sceneInformation'] != null
          ? SceneInformationModel.fromJson(
              json['sceneInformation'] as Map<String, dynamic>)
          : null,
      scriptInformation: json['scriptInformation'] != null
          ? ScriptInformationModel.fromJson(
              json['scriptInformation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'storyOrder': storyOrder,
      'shotOrder': shotOrder,
      'completed': completed,
    };
    if (location != null) data['location'] = location!.toJson();
    if (checklistID != null) data['checklistID'] = checklistID!;
    if (deadline != null) data['deadline'] = deadline!.toJson();
    if (ideasID != null) data['ideasID'] = ideasID!;
    if (obstaclesID != null) data['obstaclesID'] = obstaclesID!;
    if (sceneInformation != null) {
      data['sceneInformation'] = sceneInformation!.toJson();
    }
    if (scriptInformation != null) {
      data['scriptInformation'] = scriptInformation!.toJson();
    }
    return data;
  }

  FrameModel copyWith({
    String? id,
    double? storyOrder,
    double? shotOrder,
    bool? completed,
    LocationModel? location,
    String? checklistID,
    DeadlineModel? deadline,
    String? ideasID,
    String? obstaclesID,
    SceneInformationModel? sceneInformation,
    ScriptInformationModel? scriptInformation,
  }) {
    return FrameModel(
      id: id ?? this.id,
      storyOrder: storyOrder ?? this.storyOrder,
      shotOrder: shotOrder ?? this.shotOrder,
      completed: completed ?? this.completed,
      location: location ?? this.location,
      checklistID: checklistID ?? this.checklistID,
      deadline: deadline ?? this.deadline,
      ideasID: ideasID ?? this.ideasID,
      obstaclesID: obstaclesID ?? this.obstaclesID,
      sceneInformation: sceneInformation ?? this.sceneInformation,
      scriptInformation: scriptInformation ?? this.scriptInformation,
    );
  }
}
