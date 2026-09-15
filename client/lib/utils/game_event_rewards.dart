import 'dart:convert';

import '../l10n/app_localizations.dart';
import 'tool_display_name.dart';
import 'weapon_display_name.dart';

class GameEventPrizeTier {
  final int minRank;
  final int maxRank;
  final int cash;
  final int xp;
  final int premiumCredits;
  final List<({String itemKey, int quantity})> items;
  final List<({String ammoType, int quantity})> ammo;
  final List<({String toolId, int quantity})> tools;
  final List<({String weaponId, int quantity})> weapons;
  final List<({String vehicleId, int quantity})> vehicles;
  final int carParts;
  final int motorcycleParts;
  final int boatParts;

  const GameEventPrizeTier({
    required this.minRank,
    required this.maxRank,
    required this.cash,
    required this.xp,
    required this.premiumCredits,
    required this.items,
    this.ammo = const [],
    this.tools = const [],
    this.weapons = const [],
    this.vehicles = const [],
    this.carParts = 0,
    this.motorcycleParts = 0,
    this.boatParts = 0,
  });

  List<String> extendedPrizeLines(AppLocalizations l10n) {
    final lines = <String>[];
    for (final a in ammo) {
      lines.add(
        l10n.gameScreenPrizeAmmoLine(
          localizedAmmoCaliber(a.ammoType),
          a.quantity.toString(),
        ),
      );
    }
    for (final t in tools) {
      lines.add(
        l10n.gameScreenPrizeToolLine(
          _localizedOrHumanized(
            t.toolId,
            localizedToolName(l10n, t.toolId, null),
          ),
          t.quantity.toString(),
        ),
      );
    }
    for (final w in weapons) {
      lines.add(
        l10n.gameScreenPrizeWeaponLine(
          _localizedOrHumanized(
            w.weaponId,
            localizedWeaponDisplayName(l10n, w.weaponId, null),
          ),
          w.quantity.toString(),
        ),
      );
    }
    for (final v in vehicles) {
      lines.add(
        l10n.gameScreenPrizeVehicleLine(catalogIdFallbackLabel(v.vehicleId)),
      );
    }
    if (carParts > 0) {
      lines.add(l10n.gameScreenPrizeCarParts(carParts.toString()));
    }
    if (motorcycleParts > 0) {
      lines.add(
        l10n.gameScreenPrizeMotorcycleParts(motorcycleParts.toString()),
      );
    }
    if (boatParts > 0) {
      lines.add(l10n.gameScreenPrizeBoatParts(boatParts.toString()));
    }
    return lines;
  }
}

Map<String, dynamic>? _parseJsonMap(dynamic raw) {
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  if (raw is String && raw.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }
  return null;
}

List<({String key, int quantity})> _parseKeyedList(
  dynamic raw, {
  required List<String> keyFields,
}) {
  final out = <({String key, int quantity})>[];
  if (raw is! List) return out;
  for (final item in raw) {
    if (item is! Map) continue;
    final map = Map<String, dynamic>.from(item);
    String? key;
    for (final field in keyFields) {
      final v = map[field]?.toString();
      if (v != null && v.isNotEmpty) {
        key = v;
        break;
      }
    }
    final qty = (map['quantity'] as num?)?.toInt() ??
        (map['qty'] as num?)?.toInt() ??
        1;
    if (key == null || qty <= 0) continue;
    out.add((key: key, quantity: qty));
  }
  return out;
}

List<GameEventPrizeTier> parseGameEventPrizeTiers(List<dynamic> rawRules) {
  final tiers = <GameEventPrizeTier>[];

  for (final entry in rawRules) {
    if (entry is! Map) continue;
    final rule = Map<String, dynamic>.from(entry);
    if (rule['isActive'] == false) continue;

    final trigger = _parseJsonMap(rule['triggerConfigJson']) ?? {};
    final rewards = _parseJsonMap(rule['rewardsJson']) ?? {};

    final minRank = (trigger['minRank'] as num?)?.toInt() ?? 1;
    final maxRank = (trigger['maxRank'] as num?)?.toInt() ?? minRank;

    final items = <({String itemKey, int quantity})>[];
    final rawItems = rewards['items'];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final itemKey = map['itemKey']?.toString() ?? map['key']?.toString();
        final qty = (map['quantity'] as num?)?.toInt() ??
            (map['qty'] as num?)?.toInt() ??
            0;
        if (itemKey == null || itemKey.isEmpty || qty <= 0) continue;
        items.add((itemKey: itemKey, quantity: qty));
      }
    }

    final ammoRaw = _parseKeyedList(
      rewards['ammo'],
      keyFields: ['ammoType', 'type'],
    );
    final toolsRaw = _parseKeyedList(
      rewards['tools'],
      keyFields: ['toolId', 'id'],
    );
    final weaponsRaw = _parseKeyedList(
      rewards['weapons'],
      keyFields: ['weaponId', 'id'],
    );
    final vehiclesRaw = _parseKeyedList(
      rewards['vehicles'],
      keyFields: ['vehicleId', 'id'],
    );

    final parts = rewards['vehicleParts'];
    var carParts = 0;
    var motorcycleParts = 0;
    var boatParts = 0;
    if (parts is Map) {
      final p = Map<String, dynamic>.from(parts);
      carParts = (p['car'] as num?)?.toInt() ??
          (p['car_parts'] as num?)?.toInt() ??
          0;
      motorcycleParts = (p['motorcycle'] as num?)?.toInt() ??
          (p['motorcycle_parts'] as num?)?.toInt() ??
          0;
      boatParts = (p['boat'] as num?)?.toInt() ??
          (p['boat_parts'] as num?)?.toInt() ??
          0;
    }

    tiers.add(
      GameEventPrizeTier(
        minRank: minRank,
        maxRank: maxRank,
        cash: (rewards['cash'] as num?)?.toInt() ?? 0,
        xp: (rewards['xp'] as num?)?.toInt() ?? 0,
        premiumCredits: (rewards['premiumCredits'] as num?)?.toInt() ?? 0,
        items: items,
        ammo: ammoRaw
            .map((e) => (ammoType: e.key, quantity: e.quantity))
            .toList(),
        tools:
            toolsRaw.map((e) => (toolId: e.key, quantity: e.quantity)).toList(),
        weapons: weaponsRaw
            .map((e) => (weaponId: e.key, quantity: e.quantity))
            .toList(),
        vehicles: vehiclesRaw
            .map((e) => (vehicleId: e.key, quantity: e.quantity))
            .toList(),
        carParts: carParts,
        motorcycleParts: motorcycleParts,
        boatParts: boatParts,
      ),
    );
  }

  tiers.sort((a, b) {
    if (a.minRank != b.minRank) return a.minRank.compareTo(b.minRank);
    return a.maxRank.compareTo(b.maxRank);
  });

  return tiers;
}

String eventItemDisplayName(AppLocalizations l10n, String itemKey) {
  switch (itemKey) {
    case 'event_chip_gold':
      return l10n.eventItemName_event_chip_gold;
    case 'event_chip_silver':
      return l10n.eventItemName_event_chip_silver;
    case 'event_chip_bronze':
      return l10n.eventItemName_event_chip_bronze;
    case 'event_badge_rival':
      return l10n.eventItemName_event_badge_rival;
    default:
      return catalogIdFallbackLabel(itemKey);
  }
}

/// Player-facing caliber, never a raw catalog code like `45acp`.
String localizedAmmoCaliber(String ammoType) {
  switch (ammoType) {
    case '9mm':
      return '9mm';
    case '45acp':
      return '.45 ACP';
    case '12gauge':
      return '12 Gauge';
    case '556mm':
      return '5.56mm';
    case '762mm':
      return '7.62mm';
    case '308':
      return '.308';
    default:
      return catalogIdFallbackLabel(ammoType);
  }
}

/// Last-resort label when a catalog id has no l10n (`honda_nsx_street` → `Honda NSX Street`).
String catalogIdFallbackLabel(String id) {
  const acronyms = {
    'gps',
    'nsx',
    'acp',
    'smg',
    'vip',
    'atv',
    'suv',
    'gto',
    'gt',
  };
  final parts = id
      .split(RegExp(r'[_\-]+'))
      .where((part) => part.isNotEmpty)
      .map((part) {
        final lower = part.toLowerCase();
        if (acronyms.contains(lower)) return lower.toUpperCase();
        if (part.length <= 3 && RegExp(r'^[A-Za-z0-9]+$').hasMatch(part)) {
          return part.toUpperCase();
        }
        return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
      });
  final label = parts.join(' ').trim();
  return label.isEmpty ? id : label;
}

String _localizedOrHumanized(String id, String localized) {
  final trimmed = localized.trim();
  if (trimmed.isEmpty || trimmed == id) {
    return catalogIdFallbackLabel(id);
  }
  return trimmed;
}

String formatPrizeRankLabel(AppLocalizations l10n, int minRank, int maxRank) {
  if (minRank == maxRank) {
    return l10n.gameScreenPrizeRankSingle(minRank.toString());
  }
  return l10n.gameScreenPrizeRankRange(
    minRank.toString(),
    maxRank.toString(),
  );
}
