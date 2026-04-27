import 'dart:convert';

import 'auth_service.dart';

class TheftCooldownCreditInfo {
  TheftCooldownCreditInfo({
    required this.itemKey,
    required this.creditCost,
    required this.creditBalance,
    required this.canRedeemNow,
    this.unavailableReason = '',
  });

  final String itemKey;
  final int creditCost;
  final int creditBalance;
  final bool canRedeemNow;
  final String unavailableReason;
}

/// Reads credit shop item for ACTION_COOLDOWN_RESET + [cooldownActionType] and redeems.
class TheftCooldownCreditService {
  static Future<TheftCooldownCreditInfo?> load(String cooldownActionType) async {
    if (cooldownActionType.isEmpty) return null;
    try {
      final response = await AuthService().apiClient.get(
        '/subscriptions/credits/overview',
      );
      if (response.statusCode != 200) return null;
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (payload['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>();
      final match = items
          .where((item) {
            final effectType = (item['effectType'] ?? '').toString();
            final itemActionType = (item['actionType'] ?? '').toString();
            return effectType == 'ACTION_COOLDOWN_RESET' &&
                itemActionType == cooldownActionType;
          })
          .cast<Map<String, dynamic>>()
          .toList();

      final balance = (payload['balance'] as num?)?.toInt() ?? 0;
      if (match.isEmpty) {
        return TheftCooldownCreditInfo(
          itemKey: '',
          creditCost: 0,
          creditBalance: balance,
          canRedeemNow: false,
        );
      }
      final item = match.first;
      final fallbackCost = (item['creditCost'] as num?)?.toInt() ?? 0;
      final effectiveCost =
          (item['effectiveCreditCost'] as num?)?.toInt() ?? fallbackCost;
      return TheftCooldownCreditInfo(
        itemKey: (item['key'] ?? '').toString(),
        creditCost: effectiveCost,
        creditBalance: balance,
        canRedeemNow: item['canRedeemNow'] == true,
        unavailableReason: (item['unavailableReason'] ?? '').toString(),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<({bool ok, String? message})> redeem({
    required String itemKey,
    required String cooldownActionType,
  }) async {
    if (itemKey.isEmpty) {
      return (ok: false, message: null);
    }
    try {
      final response = await AuthService().apiClient.post(
        '/subscriptions/credits/redeem',
        {
          'itemKey': itemKey,
          'actionType': cooldownActionType,
        },
      );
      final payload = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : <String, dynamic>{};

      if (response.statusCode != 200) {
        final err = (payload['error'] ?? payload['message'] ?? '')
            .toString();
        return (ok: false, message: err.isEmpty ? null : err);
      }
      final msg = (payload['message'] as String?)?.trim();
      return (ok: true, message: msg);
    } catch (_) {
      return (ok: false, message: null);
    }
  }
}
