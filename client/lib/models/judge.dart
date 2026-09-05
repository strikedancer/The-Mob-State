import 'package:flutter/material.dart';

class Judge {
  final int id;
  final String name;
  final String nameKey;
  final String specialtyKey;
  final int corruptibility; // 0-100%
  final int appointedYear;
  final String specialty;

  Judge({
    required this.id,
    required this.name,
    required this.nameKey,
    required this.specialtyKey,
    required this.corruptibility,
    required this.appointedYear,
    required this.specialty,
  });

  factory Judge.fromJson(Map<String, dynamic> json) {
    final specialtyKey =
        (json['specialtyKey'] as String?) ??
        (json['specialty'] as String?) ??
        '';
    return Judge(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      nameKey: json['nameKey'] as String? ?? '',
      specialtyKey: specialtyKey,
      corruptibility: (json['corruptibility'] as num?)?.toInt() ?? 50,
      appointedYear: (json['appointedYear'] as num?)?.toInt() ?? 2020,
      specialty: specialtyKey,
    );
  }

  Color get corruptibilityColor {
    if (corruptibility < 30) return Colors.green;
    if (corruptibility < 60) return Colors.orange;
    return Colors.red;
  }
}

class AppealOdds {
  final int lawLevel;
  final int lawBonusPercent;
  final int priorConvictions;
  final int priorConvictionModifierPercent;
  final int wantedLevel;
  final bool wantedPenaltyApplied;
  final int wantedPenaltyPercent;
  final double fbiHeat;
  final bool fbiPenaltyApplied;
  final int fbiPenaltyPercent;
  final int successPercent;

  AppealOdds({
    required this.lawLevel,
    required this.lawBonusPercent,
    required this.priorConvictions,
    required this.priorConvictionModifierPercent,
    required this.wantedLevel,
    required this.wantedPenaltyApplied,
    required this.wantedPenaltyPercent,
    required this.fbiHeat,
    required this.fbiPenaltyApplied,
    required this.fbiPenaltyPercent,
    required this.successPercent,
  });

  factory AppealOdds.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    return AppealOdds(
      lawLevel: (data['lawLevel'] as num?)?.toInt() ?? 0,
      lawBonusPercent: (data['lawBonusPercent'] as num?)?.toInt() ?? 0,
      priorConvictions: (data['priorConvictions'] as num?)?.toInt() ?? 0,
      priorConvictionModifierPercent:
          (data['priorConvictionModifierPercent'] as num?)?.toInt() ?? 0,
      wantedLevel: (data['wantedLevel'] as num?)?.toInt() ?? 0,
      wantedPenaltyApplied: data['wantedPenaltyApplied'] as bool? ?? false,
      wantedPenaltyPercent:
          (data['wantedPenaltyPercent'] as num?)?.toInt() ?? 0,
      fbiHeat: (data['fbiHeat'] as num?)?.toDouble() ?? 0,
      fbiPenaltyApplied: data['fbiPenaltyApplied'] as bool? ?? false,
      fbiPenaltyPercent: (data['fbiPenaltyPercent'] as num?)?.toInt() ?? 0,
      successPercent: (data['successPercent'] as num?)?.toInt() ?? 0,
    );
  }
}

class JailSentence {
  final int crimeAttemptId;
  final String crimeId;
  final String crime;
  final int sentenceMinutes;
  final int remainingMinutes;
  final Judge judge;
  final DateTime arrestedAt;
  final bool appealed;
  final AppealOdds? appealOdds;

  JailSentence({
    required this.crimeAttemptId,
    required this.crimeId,
    required this.crime,
    required this.sentenceMinutes,
    required this.remainingMinutes,
    required this.judge,
    required this.arrestedAt,
    required this.appealed,
    this.appealOdds,
  });

  factory JailSentence.fromJson(Map<String, dynamic> json) {
    return JailSentence(
      crimeAttemptId: (json['crimeAttemptId'] as num?)?.toInt() ?? 0,
      crimeId: json['crimeId'] as String? ?? '',
      crime: json['crime'] as String? ?? '',
      sentenceMinutes: (json['sentenceMinutes'] as num?)?.toInt() ?? 0,
      remainingMinutes: (json['remainingMinutes'] as num?)?.toInt() ?? 0,
      judge: Judge.fromJson(json['judge'] as Map<String, dynamic>? ?? {}),
      arrestedAt: DateTime.parse(
        json['arrestedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      appealed: json['appealed'] as bool? ?? false,
      appealOdds: json['appealOdds'] is Map<String, dynamic>
          ? AppealOdds.fromJson(json['appealOdds'] as Map<String, dynamic>)
          : null,
    );
  }
}
