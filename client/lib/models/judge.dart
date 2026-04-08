import 'package:flutter/material.dart';

class Judge {
  final int id;
  final String name;
  final int corruptibility; // 0-100%
  final int appointedYear;
  final String specialty;

  Judge({
    required this.id,
    required this.name,
    required this.corruptibility,
    required this.appointedYear,
    required this.specialty,
  });

  factory Judge.fromJson(Map<String, dynamic> json) {
    return Judge(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      corruptibility: (json['corruptibility'] as num?)?.toInt() ?? 50,
      appointedYear: (json['appointedYear'] as num?)?.toInt() ?? 2020,
      specialty: json['specialty'] as String? ?? '',
    );
  }

  String get corruptibilityLevel {
    if (corruptibility < 30) return 'Zeer eerlijk';
    if (corruptibility < 60) return 'Gemiddeld';
    return 'Corruptibel';
  }

  Color get corruptibilityColor {
    if (corruptibility < 30) return Colors.green;
    if (corruptibility < 60) return Colors.orange;
    return Colors.red;
  }
}

class JailSentence {
  final int crimeAttemptId;
  final String crime;
  final int sentenceMinutes;
  final int remainingMinutes;
  final Judge judge;
  final DateTime arrestedAt;

  JailSentence({
    required this.crimeAttemptId,
    required this.crime,
    required this.sentenceMinutes,
    required this.remainingMinutes,
    required this.judge,
    required this.arrestedAt,
  });

  factory JailSentence.fromJson(Map<String, dynamic> json) {
    return JailSentence(
      crimeAttemptId: (json['crimeAttemptId'] as num?)?.toInt() ?? 0,
      crime: json['crime'] as String? ?? '',
      sentenceMinutes: (json['sentenceMinutes'] as num?)?.toInt() ?? 0,
      remainingMinutes: (json['remainingMinutes'] as num?)?.toInt() ?? 0,
      judge: Judge.fromJson(json['judge'] as Map<String, dynamic>? ?? {}),
      arrestedAt: DateTime.parse(json['arrestedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
