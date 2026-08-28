/// Maps Season Pass / event reward JSON to display assets and labels.
class SeasonPassRewardDisplay {
  const SeasonPassRewardDisplay({
    required this.imagePath,
    required this.label,
    this.subtitle,
  });

  final String imagePath;
  final String label;
  final String? subtitle;
}

const _tilesBase = 'images/premium_tiles';

SeasonPassRewardDisplay seasonPassRewardDisplay(
  Map<String, dynamic>? rewards, {
  required String Function(int amount) formatCash,
  required String Function(int amount) formatCredits,
  required String ammoLabel,
  required String vehicleLabel,
  required String weaponLabel,
  required String partsLabel,
  required String bundleLabel,
  required String xpLabel,
}) {
  if (rewards == null || rewards.isEmpty) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/credits_250.png',
      label: bundleLabel,
    );
  }

  final cash = (rewards['cash'] as num?)?.toInt() ?? 0;
  final credits = (rewards['premiumCredits'] as num?)?.toInt() ?? 0;
  final xp = (rewards['xp'] as num?)?.toInt() ?? 0;
  final hasVehicle =
      rewards['vehicles'] is List && (rewards['vehicles'] as List).isNotEmpty;
  final hasWeapon =
      rewards['weapons'] is List && (rewards['weapons'] as List).isNotEmpty;
  final hasAmmo =
      rewards['ammo'] is List && (rewards['ammo'] as List).isNotEmpty;
  final hasParts = rewards['vehicleParts'] is Map;

  if (hasVehicle) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_vehicle_repair.png',
      label: vehicleLabel,
      subtitle: cash > 0 ? formatCash(cash) : null,
    );
  }
  if (hasWeapon) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_hit_protection.png',
      label: weaponLabel,
      subtitle: cash > 0 ? formatCash(cash) : null,
    );
  }
  if (credits > 0) {
    String img = '$_tilesBase/credits_250.png';
    if (credits >= 1000) {
      img = '$_tilesBase/credits_1000.png';
    } else if (credits >= 500) {
      img = '$_tilesBase/credits_500.png';
    }
    return SeasonPassRewardDisplay(
      imagePath: img,
      label: formatCredits(credits),
      subtitle: cash > 0 ? formatCash(cash) : null,
    );
  }
  if (cash > 0) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_cash_bundle.png',
      label: formatCash(cash),
      subtitle: xp > 0 ? xpLabel : (hasAmmo ? ammoLabel : null),
    );
  }
  if (hasParts) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_vehicle_repair.png',
      label: partsLabel,
    );
  }
  if (hasAmmo) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_hit_protection.png',
      label: ammoLabel,
    );
  }
  if (xp > 0) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_event_boost.png',
      label: xpLabel,
    );
  }
  return SeasonPassRewardDisplay(
    imagePath: '$_tilesBase/credits_250.png',
    label: bundleLabel,
  );
}
