import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

const Color kCountryPolicePanelBg = Color(0xFF151B28);
const Color kCountryPolicePanelBorder = Color(0xFF2A3344);
const Color kCountryPoliceGold = Color(0xFFD4AF37);

Color countryPoliceBandColor(String? band) {
  switch ((band ?? '').toLowerCase()) {
    case 'lockdown':
      return const Color(0xFFE85D4C);
    case 'hot':
      return const Color(0xFFE67E22);
    case 'watchful':
      return const Color(0xFFF1C40F);
    case 'calm':
    default:
      return const Color(0xFF2ECC71);
  }
}

String countryPoliceBandLabel(AppLocalizations l10n, String? band) {
  switch ((band ?? '').toLowerCase()) {
    case 'lockdown':
      return l10n.countryPoliceBandLockdown;
    case 'hot':
      return l10n.countryPoliceBandHot;
    case 'watchful':
      return l10n.countryPoliceBandWatchful;
    case 'calm':
    default:
      return l10n.countryPoliceBandCalm;
  }
}

String countryPoliceActionName(AppLocalizations l10n, String actionType) {
  switch (actionType) {
    case 'corruption':
      return l10n.countryPoliceDisruptCorruption;
    case 'distract':
      return l10n.countryPoliceDisruptDistract;
    case 'raid':
      return l10n.countryPoliceDisruptRaid;
    default:
      return actionType;
  }
}

String countryPoliceActionDesc(AppLocalizations l10n, String actionType) {
  switch (actionType) {
    case 'corruption':
      return l10n.countryPoliceDisruptCorruptionDesc;
    case 'distract':
      return l10n.countryPoliceDisruptDistractDesc;
    case 'raid':
      return l10n.countryPoliceDisruptRaidDesc;
    default:
      return '';
  }
}

String countryPoliceFormatMoney(int amount) {
  return amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}

bool countryPoliceIsCoolActive(dynamic coolUntil) {
  if (coolUntil == null) return false;
  final raw = coolUntil.toString();
  if (raw.isEmpty) return false;
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return false;
  return parsed.toUtc().isAfter(DateTime.now().toUtc());
}

Widget countryPoliceBandChip({
  required AppLocalizations l10n,
  required String? band,
  int? pressure,
  bool compact = false,
}) {
  final color = countryPoliceBandColor(band);
  final label = countryPoliceBandLabel(l10n, band);
  final text = pressure == null
      ? label
      : '$label · ${l10n.countryPolicePressureValue(pressure)}';

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 7 : 9,
      vertical: compact ? 3 : 4,
    ),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: 0.7)),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: compact ? 11 : 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

/// Compact noir strip for crime screen when country police is enabled.
class CountryPoliceStrip extends StatelessWidget {
  const CountryPoliceStrip({
    super.key,
    required this.countryPolice,
    required this.disruptActions,
    required this.onDisrupt,
  });

  final Map<String, dynamic> countryPolice;
  final List<Map<String, dynamic>> disruptActions;
  final VoidCallback onDisrupt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (countryPolice['enabled'] != true) {
      return const SizedBox.shrink();
    }

    final band = countryPolice['band']?.toString() ?? 'calm';
    final pressure = (countryPolice['pressure'] as num?)?.toInt() ?? 0;
    final successPenalty =
        (countryPolice['successPenaltyPp'] as num?)?.toInt() ?? 0;
    final arrestBonus =
        (countryPolice['arrestBonusPp'] as num?)?.toInt() ?? 0;
    final coolActive = countryPoliceIsCoolActive(countryPolice['coolUntil']);
    final canDisrupt = disruptActions.isNotEmpty;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: kCountryPolicePanelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCountryPolicePanelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_police_outlined,
                color: kCountryPoliceGold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.countryPoliceStripTitle,
                  style: const TextStyle(
                    color: kCountryPoliceGold,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              countryPoliceBandChip(
                l10n: l10n,
                band: band,
                pressure: pressure,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.countryPoliceEffectLine(successPenalty, arrestBonus),
            style: const TextStyle(color: Colors.white70, fontSize: 12.5),
          ),
          if (coolActive) ...[
            const SizedBox(height: 6),
            Text(
              l10n.countryPoliceCoolActive,
              style: TextStyle(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.9),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (canDisrupt) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onDisrupt,
                style: TextButton.styleFrom(
                  foregroundColor: kCountryPoliceGold,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                icon: const Icon(Icons.bolt, size: 16),
                label: Text(l10n.countryPoliceDisruptButton),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> showCountryPoliceDisruptSheet({
  required BuildContext context,
  required ApiClient apiClient,
  required List<Map<String, dynamic>> disruptActions,
  required Future<void> Function() onCompleted,
}) async {
  if (disruptActions.isEmpty) return;
  final l10n = AppLocalizations.of(context)!;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: kCountryPolicePanelBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (sheetContext) {
      var submitting = false;

      return StatefulBuilder(
        builder: (context, setSheetState) {
          Future<void> submit(Map<String, dynamic> action) async {
            if (submitting) return;
            final actionType = action['actionType']?.toString() ?? '';
            if (actionType.isEmpty) return;

            final cost =
                (action['costMoney'] as num?)?.toInt() ?? 0;
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: kCountryPolicePanelBg,
                  title: Text(
                    countryPoliceActionName(l10n, actionType),
                    style: const TextStyle(color: kCountryPoliceGold),
                  ),
                  content: Text(
                    '${countryPoliceActionDesc(l10n, actionType)}\n\n'
                    '${l10n.countryPoliceDisruptCost(countryPoliceFormatMoney(cost))}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: kCountryPoliceGold,
                      ),
                      child: Text(l10n.confirm),
                    ),
                  ],
                );
              },
            );
            if (confirmed != true || !context.mounted) return;

            setSheetState(() => submitting = true);
            try {
              final response = await apiClient.post('/police/disrupt', {
                'actionType': actionType,
              });
              final data = response.body.isNotEmpty
                  ? jsonDecode(response.body) as Map<String, dynamic>
                  : <String, dynamic>{};
              final eventKey = data['event']?.toString() ?? '';
              final params =
                  (data['params'] as Map<String, dynamic>?) ?? {};
              final success = response.statusCode == 200 &&
                  (params['success'] == true ||
                      eventKey == 'police.disrupt.success');

              if (!context.mounted) return;
              Navigator.of(sheetContext).pop();

              final String message;
              if (success) {
                message = l10n.countryPoliceDisruptSuccess;
              } else if (eventKey == 'error.cooldown') {
                message = l10n.connectionErrorGeneric;
              } else {
                message = l10n.countryPoliceDisruptFailed;
              }

              showTopRightFromSnackBar(
                context,
                SnackBar(
                  content: Text(message),
                  backgroundColor: success ? Colors.green : Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );

              await onCompleted();
            } catch (_) {
              if (!context.mounted) return;
              setSheetState(() => submitting = false);
              showTopRightFromSnackBar(
                context,
                SnackBar(
                  content: Text(l10n.connectionErrorGeneric),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.countryPoliceDisruptTitle,
                    style: const TextStyle(
                      color: kCountryPoliceGold,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.countryPoliceDisruptHint,
                    style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                  const SizedBox(height: 14),
                  ...disruptActions.map((action) {
                    final actionType =
                        action['actionType']?.toString() ?? '';
                    final cost =
                        (action['costMoney'] as num?)?.toInt() ?? 0;
                    final drop =
                        (action['pressureDrop'] as num?)?.toInt() ?? 0;
                    final minutes =
                        (action['coolMinutes'] as num?)?.toInt() ?? 0;
                    final failWanted =
                        (action['failWanted'] as num?)?.toInt() ?? 0;
                    final failFbi =
                        (action['failFbi'] as num?)?.toInt() ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: submitting ? null : () => submit(action),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        countryPoliceActionName(
                                          l10n,
                                          actionType,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      l10n.countryPoliceDisruptCost(
                                        countryPoliceFormatMoney(cost),
                                      ),
                                      style: const TextStyle(
                                        color: kCountryPoliceGold,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  countryPoliceActionDesc(l10n, actionType),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.countryPoliceDisruptDropHint(
                                    drop,
                                    minutes,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11.5,
                                  ),
                                ),
                                Text(
                                  l10n.countryPoliceDisruptFailHint(
                                    failWanted,
                                    failFbi,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (submitting)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
