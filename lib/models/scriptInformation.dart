// ignore_for_file: file_names

class ScriptInformationModel {
  final String? time;
  final String? scriptID;
  final String? visualExplanationID;

  ScriptInformationModel({
    required this.time,
    required this.scriptID,
    required this.visualExplanationID,
  });

  factory ScriptInformationModel.fromJson(Map<String, dynamic>? json) {
    return ScriptInformationModel(
      time: json?['time'] as String?,
      scriptID: json?['scriptID'] as String?,
      visualExplanationID: json?['visualExplanationID'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'scriptID': scriptID,
        'visualExplanationID': visualExplanationID,
      };
}
