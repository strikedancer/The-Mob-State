// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crime _$CrimeFromJson(Map<String, dynamic> json) => Crime(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  requiredRank: (json['minLevel'] as num).toInt(),
  minPay: (json['minReward'] as num).toInt(),
  maxPay: (json['maxReward'] as num).toInt(),
  xpReward: (json['xpReward'] as num).toInt(),
  baseSuccessChance: (json['baseSuccessChance'] as num?)?.toDouble(),
  playerSuccessChance: (json['playerSuccessChance'] as num?)?.toInt(),
  jailTime: (json['jailTime'] as num?)?.toInt(),
  requiresVehicle: json['requiredVehicle'] as bool,
  breakdownChance: (json['breakdownChance'] as num?)?.toDouble(),
  requiredTools: (json['requiredTools'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  requiredDrugs: (json['requiredDrugs'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  minDrugQuantity: (json['minDrugQuantity'] as num?)?.toInt(),
  requiredWeapon: json['requiredWeapon'] as bool?,
  canAttempt: json['canAttempt'] as bool?,
  isAvailable: json['isAvailable'] as bool?,
  readinessBlocker: json['readinessBlocker'] as String?,
  missingToolIds: (json['missingToolIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  toolsInStorageIds: (json['toolsInStorageIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  toolsReady: json['toolsReady'] as bool?,
  weaponReady: json['weaponReady'] as bool?,
  selectedCrimeWeaponId: json['selectedCrimeWeaponId'] as String?,
  selectedCrimeWeaponName: json['selectedCrimeWeaponName'] as String?,
  isFederalCrime: json['isFederalCrime'] as bool? ?? false,
);

Map<String, dynamic> _$CrimeToJson(Crime instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'minLevel': instance.requiredRank,
  'minReward': instance.minPay,
  'maxReward': instance.maxPay,
  'xpReward': instance.xpReward,
  'baseSuccessChance': instance.baseSuccessChance,
  'playerSuccessChance': instance.playerSuccessChance,
  'jailTime': instance.jailTime,
  'requiredVehicle': instance.requiresVehicle,
  'breakdownChance': instance.breakdownChance,
  'requiredTools': instance.requiredTools,
  'requiredDrugs': instance.requiredDrugs,
  'minDrugQuantity': instance.minDrugQuantity,
  'requiredWeapon': instance.requiredWeapon,
  'canAttempt': instance.canAttempt,
  'isAvailable': instance.isAvailable,
  'readinessBlocker': instance.readinessBlocker,
  'missingToolIds': instance.missingToolIds,
  'toolsInStorageIds': instance.toolsInStorageIds,
  'toolsReady': instance.toolsReady,
  'weaponReady': instance.weaponReady,
  'selectedCrimeWeaponId': instance.selectedCrimeWeaponId,
  'selectedCrimeWeaponName': instance.selectedCrimeWeaponName,
  'isFederalCrime': instance.isFederalCrime,
};
