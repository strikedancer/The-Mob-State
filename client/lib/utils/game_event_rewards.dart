import 'dart:convert';

import '../l10n/app_localizations.dart';

class GameEventPrizeTier {
  final int minRank;
  final int maxRank;
  final int cash;
  final int xp;
  final int premiumCredits;
  final List<({String itemKey, int quantity})> items;

  const GameEventPrizeTier({
    required this.minRank,
    required this.maxRank,
    required this.cash,
    required this.xp,
    required this.premiumCredits,
    required this.items,
  });
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

    tiers.add(
      GameEventPrizeTier(
        minRank: minRank,
        maxRank: maxRank,
        cash: (rewards['cash'] as num?)?.toInt() ?? 0,
        xp: (rewards['xp'] as num?)?.toInt() ?? 0,
        premiumCredits: (rewards['premiumCredits'] as num?)?.toInt() ?? 0,
        items: items,
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
      return itemKey;
  }
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
