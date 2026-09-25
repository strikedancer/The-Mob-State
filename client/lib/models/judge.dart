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
  final String? sourceCrimeId;
  final String? sourceCrimeName;
  final String? arrestReason;
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
    this.sourceCrimeId,
    this.sourceCrimeName,
    this.arrestReason,
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
      sourceCrimeId: json['sourceCrimeId'] as String?,
      sourceCrimeName: json['sourceCrimeName'] as String?,
      arrestReason: json['arrestReason'] as String?,
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

class ExpungePetitionOdds {
  final int convictionCount;
  final int basePercent;
  final int recordModifierPercent;
  final int recencyModifierPercent;
  final int reputationModifierPercent;
  final int reputation;
  final int donJudgePercent;
  final int donCommissionerPercent;
  final int donAldermanPercent;
  final bool hasJudge;
  final bool hasCommissioner;
  final bool hasAlderman;
  final double? hoursSinceLastArrest;
  final int mathCorrect;
  final int mathModifierPercent;
  final int successPercent;

  ExpungePetitionOdds({
    required this.convictionCount,
    required this.basePercent,
    required this.recordModifierPercent,
    required this.recencyModifierPercent,
    required this.reputationModifierPercent,
    required this.reputation,
    required this.donJudgePercent,
    required this.donCommissionerPercent,
    required this.donAldermanPercent,
    required this.hasJudge,
    required this.hasCommissioner,
    required this.hasAlderman,
    required this.hoursSinceLastArrest,
    required this.mathCorrect,
    required this.mathModifierPercent,
    required this.successPercent,
  });

  factory ExpungePetitionOdds.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    return ExpungePetitionOdds(
      convictionCount: (data['convictionCount'] as num?)?.toInt() ?? 0,
      basePercent: (data['basePercent'] as num?)?.toInt() ?? 38,
      recordModifierPercent:
          (data['recordModifierPercent'] as num?)?.toInt() ?? 0,
      recencyModifierPercent:
          (data['recencyModifierPercent'] as num?)?.toInt() ?? 0,
      reputationModifierPercent:
          (data['reputationModifierPercent'] as num?)?.toInt() ?? 0,
      reputation: (data['reputation'] as num?)?.toInt() ?? 0,
      donJudgePercent: (data['donJudgePercent'] as num?)?.toInt() ?? 0,
      donCommissionerPercent:
          (data['donCommissionerPercent'] as num?)?.toInt() ?? 0,
      donAldermanPercent: (data['donAldermanPercent'] as num?)?.toInt() ?? 0,
      hasJudge: data['hasJudge'] as bool? ?? false,
      hasCommissioner: data['hasCommissioner'] as bool? ?? false,
      hasAlderman: data['hasAlderman'] as bool? ?? false,
      hoursSinceLastArrest: (data['hoursSinceLastArrest'] as num?)?.toDouble(),
      mathCorrect: (data['mathCorrect'] as num?)?.toInt() ?? 0,
      mathModifierPercent: (data['mathModifierPercent'] as num?)?.toInt() ?? 0,
      successPercent: (data['successPercent'] as num?)?.toInt() ?? 0,
    );
  }
}

class ExpungePetitionQuote {
  final int convictionCount;
  final int cost;
  final DateTime? lastArrestAt;
  final int cooldownRemainingSeconds;
  final bool canSubmit;
  final String? blockReason;
  final ExpungePetitionOdds odds;

  ExpungePetitionQuote({
    required this.convictionCount,
    required this.cost,
    required this.lastArrestAt,
    required this.cooldownRemainingSeconds,
    required this.canSubmit,
    required this.blockReason,
    required this.odds,
  });

  factory ExpungePetitionQuote.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    final lastArrestRaw = data['lastArrestAt'] as String?;
    return ExpungePetitionQuote(
      convictionCount: (data['convictionCount'] as num?)?.toInt() ?? 0,
      cost: (data['cost'] as num?)?.toInt() ?? 0,
      lastArrestAt: lastArrestRaw == null
          ? null
          : DateTime.tryParse(lastArrestRaw),
      cooldownRemainingSeconds:
          (data['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0,
      canSubmit: data['canSubmit'] as bool? ?? false,
      blockReason: data['blockReason'] as String?,
      odds: ExpungePetitionOdds.fromJson(
        data['odds'] as Map<String, dynamic>?,
      ),
    );
  }
}
