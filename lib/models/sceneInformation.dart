// ignore_for_file: file_names

class SceneInformationModel {
  final List<String>? images;
  final String? sketchType;
  final String? aspectRatio;
  final String? shotSize;
  final String? shotType;
  final String? lens;
  final String? camera;
  final String? frameRate;

  final String? cameraAngle;
  final String? cameraMovement;

  SceneInformationModel({
    this.images,
    this.sketchType,
    this.aspectRatio,
    this.shotSize,
    this.shotType,
    this.lens,
    this.camera,
    this.frameRate,
    this.cameraAngle,
    this.cameraMovement,
  });

  factory SceneInformationModel.fromJson(Map<String, dynamic>? json) {
    return SceneInformationModel(
      images: (json?['images'] as List<dynamic>?)?.cast<String>(),
      sketchType: json?['sketchType'] as String?,
      aspectRatio: json?['aspectRatio'] as String?,
      shotSize: json?['shotSize'] as String?,
      shotType: json?['shotType'] as String?,
      lens: json?['lens'] as String?,
      camera: json?['camera'] as String?,
      frameRate: json?['frameRate'] as String?,
      cameraAngle: json?['cameraAngle'] as String?,
      cameraMovement: json?['cameraMovement'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'images': images,
        'sketchType': sketchType,
        'aspectRatio': aspectRatio,
        'shotSize': shotSize,
        'shotType': shotType,
        'lens': lens,
        'camera': camera,
        'frameRate': frameRate,
        'cameraAngle': cameraAngle,
        'cameraMovement': cameraMovement,
      };

  SceneInformationModel copyWith({
    List<String>? images,
    String? sketchType,
    String? aspectRatio,
    String? shotSize,
    String? shotType,
    String? lens,
    String? camera,
    String? frameRate,
    String? cameraAngle,
    String? cameraMovement,
  }) {
    return SceneInformationModel(
      images: images ?? this.images,
      sketchType: sketchType ?? this.sketchType,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      shotSize: shotSize ?? this.shotSize,
      shotType: shotType ?? this.shotType,
      lens: lens ?? this.lens,
      camera: camera ?? this.camera,
      frameRate: frameRate ?? this.frameRate,
      cameraAngle: cameraAngle ?? this.cameraAngle,
      cameraMovement: cameraMovement ?? this.cameraMovement,
    );
  }
}
