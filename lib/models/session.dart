import 'dart:convert';

class Session {
  final int id;
  final String exerciseId;
  final String exerciseName;
  final String exerciseType;
  final int stressBefore;
  final int stressAfter;
  final int helpfulness;
  final DateTime date;

  Session({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseType,
    required this.stressBefore,
    required this.stressAfter,
    this.helpfulness = 3,
    required this.date,
  });

  int get reduction => stressBefore - stressAfter;
  double get reductionPercent =>
      stressBefore > 0 ? (reduction / stressBefore * 100) : 0;

  Map<String, dynamic> toMap() => {
        'id': id,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'exerciseType': exerciseType,
        'stressBefore': stressBefore,
        'stressAfter': stressAfter,
        'helpfulness': helpfulness,
        'date': date.toIso8601String(),
      };

  factory Session.fromMap(Map<String, dynamic> map) => Session(
        id: map['id'] ?? 0,
        exerciseId: map['exerciseId'] ?? '',
        exerciseName: map['exerciseName'] ?? '',
        exerciseType: map['exerciseType'] ?? '',
        stressBefore: map['stressBefore'] ?? 0,
        stressAfter: map['stressAfter'] ?? 0,
        helpfulness: map['helpfulness'] ?? 3,
        date: map['date'] != null ? DateTime.tryParse(map['date']) ?? DateTime.now() : DateTime.now(),
      );

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source) as Map<String, dynamic>);
}
