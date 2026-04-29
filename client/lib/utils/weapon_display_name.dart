import '../l10n/app_localizations.dart';

/// Localized display name for a weapon from inventory (overrides API/Dutch names in [weapons.json]).
String localizedWeaponDisplayName(
  AppLocalizations l10n,
  String? weaponId,
  String? apiName,
) {
  if (weaponId == null || weaponId.isEmpty) {
    return apiName ?? '';
  }
  switch (weaponId) {
    case 'knife':
      return l10n.weaponLabelKnife;
    case 'handgun_9mm':
      return l10n.weaponLabelHandgun9mm;
    case 'handgun_heavy':
      return l10n.weaponLabelHandgunHeavy;
    case 'smg_compact':
      return l10n.weaponLabelSmgCompact;
    case 'shotgun_pump':
      return l10n.weaponLabelShotgunPump;
    case 'molotov':
      return l10n.weaponLabelMolotov;
    case 'smg_suppressed':
      return l10n.weaponLabelSmgSuppressed;
    case 'shotgun_tactical':
      return l10n.weaponLabelShotgunTactical;
    case 'assault_rifle':
      return l10n.weaponLabelAssaultRifle;
    case 'grenade_flash':
      return l10n.weaponLabelGrenadeFlash;
    case 'grenade_frag':
      return l10n.weaponLabelGrenadeFrag;
    case 'sniper_standard':
      return l10n.weaponLabelSniperStandard;
    case 'assault_rifle_vip':
      return l10n.weaponLabelAssaultRifleVip;
    case 'sniper_vip':
      return l10n.weaponLabelSniperVip;
    default:
      return apiName?.trim().isNotEmpty == true ? apiName! : weaponId;
  }
}

/// Line shown in crime weapon selector: "Name (88%)".
String crimeWeaponLine(
  AppLocalizations l10n,
  Map<String, dynamic> weapon,
) {
  final id = weapon['weaponId'] as String?;
  final label = localizedWeaponDisplayName(
    l10n,
    id,
    weapon['name'] as String?,
  );
  final cond = weapon['condition'];
  return '$label ($cond%)';
}
