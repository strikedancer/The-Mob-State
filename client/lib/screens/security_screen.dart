import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/formatters.dart';
import '../widgets/market_compact.dart';

class SecurityScreen extends StatefulWidget {
  final bool embedded;

  const SecurityScreen({super.key, this.embedded = false});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final ApiClient _apiClient = ApiClient();
  static const Color _activeArmorBackground = Color(0xFF314734);
  static const Color _activeArmorBorder = Color(0xFF7EC17B);
  static const Color _activeArmorText = Color(0xFFF6F2E8);
  dynamic _securityStatus;
  bool _isLoading = false;
  List<Map<String, dynamic>> _armorCatalog = [];

  List<Map<String, dynamic>> get armorTypes => _localizedArmorTypes();

  @override
  void initState() {
    super.initState();
    _loadSecurityStatus();
  }

  String _armorName(AppLocalizations l10n, String id, String fallback) {
    switch (id) {
      case 'stab_vest':
        return l10n.stabVest;
      case 'bulletproof_vest':
        return l10n.bulletproofVest;
      case 'bulletproof_vest_premium':
        return l10n.bulletproofVestPremium;
      case 'ceramic_ap_vest':
        return l10n.ceramicApVest;
      case 'light_armor':
        return l10n.lightArmor;
      case 'heavy_armor':
        return l10n.heavyArmor;
      case 'tactical_suit':
        return l10n.tacticalSuit;
      default:
        return fallback;
    }
  }

  String _armorDescription(AppLocalizations l10n, String id, String fallback) {
    switch (id) {
      case 'stab_vest':
        return l10n.stabVestDesc;
      case 'bulletproof_vest':
        return l10n.bulletproofVestDesc;
      case 'bulletproof_vest_premium':
        return l10n.bulletproofVestPremiumDesc;
      case 'ceramic_ap_vest':
        return l10n.ceramicApVestDesc;
      default:
        return fallback;
    }
  }

  List<Map<String, dynamic>> _localizedArmorTypes() {
    final l10n = AppLocalizations.of(context)!;
    final source = _armorCatalog.isNotEmpty
        ? _armorCatalog
        : <Map<String, dynamic>>[
            {
              'id': 'stab_vest',
              'name': l10n.stabVest,
              'description': l10n.stabVestDesc,
              'price': 7500,
              'armor': 22,
              'resistsStab': true,
              'resistsBallistic': false,
              'resistsArmorPiercing': false,
            },
            {
              'id': 'bulletproof_vest',
              'name': l10n.bulletproofVest,
              'description': l10n.bulletproofVestDesc,
              'price': 50000,
              'armor': 100,
              'resistsStab': false,
              'resistsBallistic': true,
              'resistsArmorPiercing': false,
            },
            {
              'id': 'bulletproof_vest_premium',
              'name': l10n.bulletproofVestPremium,
              'description': l10n.bulletproofVestPremiumDesc,
              'price': 125000,
              'armor': 155,
              'resistsStab': false,
              'resistsBallistic': true,
              'resistsArmorPiercing': false,
            },
            {
              'id': 'ceramic_ap_vest',
              'name': l10n.ceramicApVest,
              'description': l10n.ceramicApVestDesc,
              'price': 280000,
              'armor': 145,
              'resistsStab': true,
              'resistsBallistic': true,
              'resistsArmorPiercing': true,
            },
          ];
    return source
        .map((row) {
          final id = '${row['id']}';
          return {
            ...row,
            'name': _armorName(l10n, id, '${row['name'] ?? id}'),
            'description': _armorDescription(
              l10n,
              id,
              '${row['description'] ?? ''}',
            ),
          };
        })
        .toList();
  }

  String _securityBuyFailureMessage(
    AppLocalizations l10n,
    Map<String, dynamic> data, {
    required bool armorPurchase,
  }) {
    final code = data['error']?.toString();
    switch (code) {
      case 'INSUFFICIENT_MONEY':
        return l10n.moneyNotEnough;
      case 'INVALID_QUANTITY':
        return l10n.securityErrorMinQuantity;
      case 'ARMOR_NOT_FOUND':
        return l10n.securityErrorArmorNotFound;
      case 'ARMOR_ALREADY_EQUIPPED':
        return l10n.armorAlreadyEquippedLong;
      default:
        final m = data['message']?.toString();
        if (m != null && m.isNotEmpty) {
          return m;
        }
        return armorPurchase
            ? l10n.couldNotBuyArmor
            : l10n.couldNotBuyBodyguard;
    }
  }

  String _formatDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return '-';
    }

    final parsed = DateTime.tryParse(value)?.toLocal();
    if (parsed == null) {
      return '-';
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }

  Future<void> _loadSecurityStatus() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/security/status');
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _securityStatus = data['security'];
          final catalog = data['security']?['armorCatalog'];
          if (catalog is List) {
            _armorCatalog = catalog
                .whereType<Map>()
                .map((row) => Map<String, dynamic>.from(row))
                .toList();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.securityLoadError(e.toString())),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buyBodyguard() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _apiClient.post('/security/buy-bodyguards', {
        'quantity': 1,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        _loadSecurityStatus();
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n.defenseIncrease(l10n.bodyguardProductName, '10'),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                _securityBuyFailureMessage(l10n, data, armorPurchase: false),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)!.hitError(e.toString());
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    }
  }

  Future<void> _buyArmor(String armorId) async {
    final l10n = AppLocalizations.of(context)!;
    final armor = armorTypes.firstWhere((a) => a['id'] == armorId);

    try {
      final response = await _apiClient.post(
        '/security/buy-armor/$armorId',
        {},
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        _loadSecurityStatus();
        if (mounted) {
          final msg = l10n.defenseIncrease(
            armor['name'] as String,
            armor['armor'].toString(),
          );
          showTopRightFromSnackBar(context, SnackBar(content: Text(msg)));
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                _armorErrorMessage(l10n, data) ??
                    _securityBuyFailureMessage(l10n, data, armorPurchase: true),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)!.hitError(e.toString());
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    }
  }

  int _calculateDefense() {
    if (_securityStatus == null) return 0;
    final armorRating = _securityStatus['armor'] ?? 0;
    final bodyguards = _securityStatus['bodyguards'] ?? 0;
    return armorRating + (bodyguards * 10);
  }

  int _armorCondition() {
    if (_securityStatus == null) return 100;
    return _securityStatus['armorCondition'] ?? 100;
  }

  bool _isArmorDamaged() {
    return (_securityStatus?['baseArmor'] ?? 0) > 0 && _armorCondition() < 100;
  }

  bool _hasActiveArmor() {
    return (_securityStatus?['baseArmor'] ?? 0) > 0;
  }

  String? _armorErrorMessage(AppLocalizations l10n, Map<String, dynamic> data) {
    final errorCode = data['error']?.toString();
    if (errorCode == 'ARMOR_ALREADY_EQUIPPED') {
      return l10n.armorAlreadyEquippedLong;
    }

    return data['message']?.toString();
  }

  String _armorActionLabel({
    required bool isCurrentArmor,
    required bool isCurrentArmorDamaged,
    required bool hasActiveArmor,
    required AppLocalizations l10n,
  }) {
    if (isCurrentArmorDamaged) {
      return l10n.replaceArmor;
    }

    if (!isCurrentArmor && hasActiveArmor) {
      return l10n.replaceArmor;
    }

    return l10n.buy;
  }

  Widget _buildArmorRow(Map<String, dynamic> armor, AppLocalizations l10n) {
    final isCurrentArmor = _securityStatus['armorType'] == armor['id'];
    final hasActiveArmor = _hasActiveArmor();
    final canRefreshCurrentArmor = isCurrentArmor && _isArmorDamaged();
    return MarketCompactRow(
      tooltip: armor['description']?.toString(),
      color: isCurrentArmor ? _activeArmorBackground : null,
      leading: Icon(
        Icons.shield,
        color: isCurrentArmor ? _activeArmorBorder : Colors.blue,
      ),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${armor['name']}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isCurrentArmor ? _activeArmorText : null,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: '+${armor['armor']}',
                color: Colors.blue.shade700,
                icon: Icons.security,
              ),
              if (armor['resistsStab'] == true)
                MarketInfoPill(
                  label: l10n.vestProtectsStab,
                  color: Colors.brown.shade700,
                ),
              if (armor['resistsBallistic'] == true)
                MarketInfoPill(
                  label: l10n.vestProtectsBullets,
                  color: Colors.blueGrey.shade700,
                ),
              if (armor['resistsArmorPiercing'] == true)
                MarketInfoPill(
                  label: l10n.vestProtectsAp,
                  color: Colors.deepOrange.shade800,
                ),
              if (isCurrentArmor)
                MarketInfoPill(
                  label: l10n.worn,
                  color: Colors.green.shade700,
                  icon: Icons.check_circle,
                ),
              if (isCurrentArmor && (_securityStatus['baseArmor'] ?? 0) > 0)
                MarketInfoPill(
                  label: l10n.armorDefenseNowAtCondition(
                    '${_securityStatus['armor']}',
                    '${_armorCondition()}',
                  ),
                  color: Colors.teal.shade700,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        formatCurrency(armor['price']),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: !isCurrentArmor || canRefreshCurrentArmor
          ? FilledButton(
              onPressed: () => _buyArmor(armor['id']),
              style: marketBuyButtonStyle(),
              child: Text(
                _armorActionLabel(
                  isCurrentArmor: isCurrentArmor,
                  isCurrentArmorDamaged: canRefreshCurrentArmor,
                  hasActiveArmor: hasActiveArmor,
                  l10n: l10n,
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final body = _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _securityStatus == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(l10n.securityStatusLoadFailed),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _loadSecurityStatus,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadSecurityStatus,
              child: ListView(
                padding: marketListPadding,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  MarketCompactRow(
                    leading: const Icon(Icons.shield, color: Colors.green),
                    info: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.currentDefense,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 3,
                          children: [
                            MarketInfoPill(
                              label: '${l10n.totalDefense} ${_calculateDefense()}',
                              color: Colors.green.shade700,
                              icon: Icons.security,
                            ),
                            MarketInfoPill(
                              label: '${l10n.currentArmor} ${_securityStatus['armor'] ?? 0}',
                              color: Colors.blueGrey.shade700,
                              icon: Icons.health_and_safety,
                            ),
                            if ((_securityStatus['baseArmor'] ?? 0) > 0)
                              MarketInfoPill(
                                label: l10n.armorConditionLine(
                                  '${_armorCondition()}',
                                  '${_securityStatus['baseArmor']}',
                                ),
                                color: Colors.teal.shade700,
                              ),
                            MarketInfoPill(
                              label:
                                  '${l10n.bodyguards} ${_securityStatus['bodyguards'] ?? 0}',
                              color: Colors.orange.shade800,
                              icon: Icons.group,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  marketSectionHeader(
                    context,
                    label: l10n.buyBodyguards,
                    icon: Icons.person_add,
                  ),
                  MarketCompactRow(
                    tooltip: l10n.bodyguardsLeaveIfUnpaid,
                    leading: const Icon(Icons.person, size: 28),
                    info: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.bodyguardProductName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 3,
                          children: [
                            MarketInfoPill(
                              label: l10n.eachGivesDefense,
                              color: Colors.teal.shade700,
                            ),
                            MarketInfoPill(
                              label: l10n.dailySystemCostLine(
                                formatCurrency(
                                  _securityStatus['bodyguardDailyCost'] ?? 0,
                                ),
                              ),
                              color: Colors.orange.shade800,
                            ),
                            MarketInfoPill(
                              label: l10n.nextPayrollAt(
                                _formatDateTime(
                                  _securityStatus['bodyguardUpkeepDueAt']
                                      as String?,
                                ),
                              ),
                              color: Colors.blueGrey.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                    meta: const Text(
                      '€10.000',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    action: FilledButton(
                      onPressed: _buyBodyguard,
                      style: marketBuyButtonStyle(),
                      child: Text(l10n.buy),
                    ),
                  ),
                  marketSectionHeader(
                    context,
                    label: l10n.armor,
                    icon: Icons.shield,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.armorOneAtATimeHint,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  for (final armor in armorTypes) _buildArmorRow(armor, l10n),
                ],
              ),
            );

    if (widget.embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.security),
        centerTitle: true,
      ),
      body: body,
    );
  }
}
