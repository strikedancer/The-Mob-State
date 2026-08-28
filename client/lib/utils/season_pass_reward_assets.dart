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

const _weaponLabels = <String, String>{
  'knife': 'Mes',
  'handgun_9mm': 'Pistool 9mm',
  'handgun_heavy': 'Zwaar pistool',
  'smg_compact': 'Compacte SMG',
  'smg_suppressed': 'SMG (demper)',
  'shotgun_pump': 'Pump shotgun',
  'shotgun_tactical': 'Tactische shotgun',
  'assault_rifle': 'Aanvalsgeweer',
  'sniper_standard': 'Sluipschuttersgeweer',
  'molotov': 'Molotov',
  'grenade_flash': 'Flashbang',
  'grenade_frag': 'Granaat',
};

const _toolLabels = <String, String>{
  'bolt_cutter': 'Betonschaar',
  'crowbar': 'Koevoet',
  'car_theft_tools': 'Auto-gereedschap',
  'hacking_laptop': 'Hacking laptop',
  'gps_jammer': 'GPS-jammer',
  'toolbox': 'Gereedschapskist',
};

String? _weaponIdFromRewards(Map<String, dynamic> rewards) {
  if (rewards['weapons'] is! List || (rewards['weapons'] as List).isEmpty) {
    return null;
  }
  final first = (rewards['weapons'] as List).first;
  if (first is! Map) return null;
  final id = first['weaponId']?.toString().trim();
  if (id == null || id.isEmpty) return null;
  return id;
}

String? _toolIdFromRewards(Map<String, dynamic> rewards) {
  if (rewards['tools'] is! List || (rewards['tools'] as List).isEmpty) {
    return null;
  }
  final first = (rewards['tools'] as List).first;
  if (first is! Map) return null;
  final id = first['toolId']?.toString().trim();
  if (id == null || id.isEmpty) return null;
  return id;
}

String? _weaponImagePath(Map<String, dynamic> rewards) {
  final id = _weaponIdFromRewards(rewards);
  if (id == null) return null;
  return 'images/weapons/$id.png';
}

String _weaponLabel(String weaponId, String fallback) {
  return _weaponLabels[weaponId] ?? fallback;
}

String _toolLabel(String toolId, String fallback) {
  return _toolLabels[toolId] ?? fallback;
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
  final weaponId = _weaponIdFromRewards(rewards);
  final hasWeapon = weaponPath != null && weaponId != null;
  final toolId = _toolIdFromRewards(rewards);
  final hasTool = toolId != null;
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
    final name = _weaponLabel(weaponId, weaponLabel);
    return SeasonPassRewardDisplay(
      imagePath: weaponPath,
      label: name,
      subtitle: cash > 0 ? formatCash(cash) : null,
      kind: SeasonPassRewardKind.weapon,
    );
  }
  if (hasTool) {
    return SeasonPassRewardDisplay(
      imagePath: 'images/ui/materials_inventory.png',
      label: _toolLabel(toolId, partsLabel),
      subtitle: cash > 0 ? formatCash(cash) : null,
      kind: SeasonPassRewardKind.parts,
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
