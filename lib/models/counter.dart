class CounterModel {
  final String estTimeSpeak;
  final String wordsCount;
  final String characters;
  final int framesCount;

  CounterModel({
    required this.framesCount,
    required this.estTimeSpeak,
    required this.wordsCount,
    required this.characters,
  });

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      framesCount: json['framesCount'] as int,
      estTimeSpeak: json['estTimeSpeak'] as String,
      wordsCount: json['wordsCount'] as String,
      characters: json['characters'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "framesCount": framesCount,
        'estTimeSpeak': estTimeSpeak,
        'wordsCount': wordsCount,
        'characters': characters,
      };
}
