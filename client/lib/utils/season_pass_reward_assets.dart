/// Maps Season Pass / event reward JSON to display assets and labels.
class SeasonPassRewardDisplay {
  const SeasonPassRewardDisplay({
    required this.imagePath,
    required this.label,
    this.subtitle,
    this.kind = SeasonPassRewardKind.bundle,
  });

  final String imagePath;
  final String label;
  final String? subtitle;
  final SeasonPassRewardKind kind;
}

enum SeasonPassRewardKind {
  cash,
  credits,
  xp,
  ammo,
  weapon,
  vehicle,
  parts,
  bundle,
}

const _tilesBase = 'images/premium_tiles';

String? _weaponImagePath(Map<String, dynamic> rewards) {
  if (rewards['weapons'] is! List || (rewards['weapons'] as List).isEmpty) {
    return null;
  }
  final first = (rewards['weapons'] as List).first;
  if (first is! Map) return null;
  final id = first['weaponId']?.toString().trim();
  if (id == null || id.isEmpty) return null;
  return 'images/weapons/$id.png';
}

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
      imagePath: '$_tilesBase/credits_medium.png',
      label: bundleLabel,
    );
  }

  final cash = (rewards['cash'] as num?)?.toInt() ?? 0;
  final credits = (rewards['premiumCredits'] as num?)?.toInt() ?? 0;
  final xp = (rewards['xp'] as num?)?.toInt() ?? 0;
  final hasVehicle =
      rewards['vehicles'] is List && (rewards['vehicles'] as List).isNotEmpty;
  final weaponPath = _weaponImagePath(rewards);
  final hasWeapon = weaponPath != null;
  final hasAmmo =
      rewards['ammo'] is List && (rewards['ammo'] as List).isNotEmpty;
  final hasParts = rewards['vehicleParts'] is Map;

  if (hasVehicle) {
    return SeasonPassRewardDisplay(
      imagePath: 'images/ui/tuneshop_emblem.png',
      label: cash > 0 ? formatCash(cash) : vehicleLabel,
      subtitle: cash > 0 ? vehicleLabel : null,
      kind: SeasonPassRewardKind.vehicle,
    );
  }
  if (hasWeapon) {
    return SeasonPassRewardDisplay(
      imagePath: weaponPath,
      label: cash > 0 ? formatCash(cash) : weaponLabel,
      subtitle: cash > 0 ? weaponLabel : null,
      kind: SeasonPassRewardKind.weapon,
    );
  }
  if (credits > 0) {
    String img = '$_tilesBase/credits_250.png';
    if (credits >= 1000) {
      img = '$_tilesBase/credits_1000.png';
    } else if (credits >= 500) {
      img = '$_tilesBase/credits_500.png';
    } else if (credits >= 100) {
      img = '$_tilesBase/credits_medium.png';
    }
    return SeasonPassRewardDisplay(
      imagePath: img,
      label: formatCredits(credits),
      subtitle: cash > 0 ? formatCash(cash) : null,
      kind: SeasonPassRewardKind.credits,
    );
  }
  if (cash > 0) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_cash_bundle.png',
      label: formatCash(cash),
      subtitle: xp > 0
          ? xpLabel
          : (hasAmmo ? ammoLabel : (hasParts ? partsLabel : null)),
      kind: SeasonPassRewardKind.cash,
    );
  }
  if (hasParts) {
    return SeasonPassRewardDisplay(
      imagePath: 'images/ui/materials_inventory.png',
      label: partsLabel,
      kind: SeasonPassRewardKind.parts,
    );
  }
  if (hasAmmo) {
    return SeasonPassRewardDisplay(
      imagePath: 'images/weapons/handgun_9mm.png',
      label: ammoLabel,
      kind: SeasonPassRewardKind.ammo,
    );
  }
  if (xp > 0) {
    return SeasonPassRewardDisplay(
      imagePath: '$_tilesBase/shop_event_boost.png',
      label: xpLabel,
      kind: SeasonPassRewardKind.xp,
    );
  }
  return SeasonPassRewardDisplay(
    imagePath: '$_tilesBase/credits_medium.png',
    label: bundleLabel,
  );
}

/// Small icon for the goal category column.
String seasonPassGoalCategoryIcon(String category) {
  return switch (category) {
    'crime' => 'images/crimes/burglary_crime.png',
    'vehicles' => 'images/ui/tuneshop_emblem.png',
    'smuggling' => 'images/ui/smuggling_crate.png',
    'drugs' => 'images/ui/drug_lab.png',
    'money' => '$_tilesBase/shop_cash_bundle.png',
    'xp' => '$_tilesBase/shop_event_boost.png',
    _ => '$_tilesBase/credits_250.png',
  };
}
