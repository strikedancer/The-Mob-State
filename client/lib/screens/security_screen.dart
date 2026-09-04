import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/formatters.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final ApiClient _apiClient = ApiClient();
  static const Color _activeArmorBackground = Color(0xFF314734);
  static const Color _activeArmorBorder = Color(0xFF7EC17B);
  static const Color _activeArmorText = Color(0xFFF6F2E8);
  static const Color _activeArmorMutedText = Color(0xFFD6E6D1);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.security),
        centerTitle: true,
      ),
      body: _isLoading
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
                padding: const EdgeInsets.all(16),
                children: [
                  // Status Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currentDefense,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 24,
                            runSpacing: 16,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.totalDefense),
                                  Text(
                                    '${_calculateDefense()}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.currentArmor),
                                  Text(
                                    '${_securityStatus['armor'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if ((_securityStatus['baseArmor'] ?? 0) > 0)
                                    Text(
                                      l10n.armorConditionLine(
                                        '${_armorCondition()}',
                                        '${_securityStatus['baseArmor']}',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.bodyguards),
                                  Text(
                                    '${_securityStatus['bodyguards'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    l10n.dailyWageAmount(
                                      formatCurrency(
                                        _securityStatus['bodyguardDailyCost'] ??
                                            0,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bodyguards Section
                  Text(
                    l10n.buyBodyguards,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.protectorsFollow,
                          ),
                          Text(
                            l10n.eachGivesDefense,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.dailySystemCostLine(
                              formatCurrency(
                                _securityStatus['bodyguardDailyCost'] ?? 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.nextPayrollAt(
                              _formatDateTime(
                                _securityStatus['bodyguardUpkeepDueAt']
                                    as String?,
                              ),
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.bodyguardsLeaveIfUnpaid,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.bodyguardPrice,
                                  ),
                                  const Text(
                                    '€10.000',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: _buyBodyguard,
                                icon: const Icon(Icons.person_add),
                                label: Text(l10n.buy),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Armor Section
                  Text(
                    l10n.armor,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.armorOneAtATimeHint,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: armorTypes.map((armor) {
                      final isCurrentArmor =
                          _securityStatus['armorType'] == armor['id'];
                      final hasActiveArmor = _hasActiveArmor();
                      final canRefreshCurrentArmor =
                          isCurrentArmor && _isArmorDamaged();
                      final primaryTextColor = isCurrentArmor
                          ? _activeArmorText
                          : null;
                      final secondaryTextColor = isCurrentArmor
                          ? _activeArmorMutedText
                          : Colors.grey;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          color: isCurrentArmor ? _activeArmorBackground : null,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: isCurrentArmor
                                  ? _activeArmorBorder
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                              armor['name'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
                                              ),
                                            ),
                                            ),
                                            if (isCurrentArmor)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: _activeArmorBorder,
                                                  size: 16,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          armor['description'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                        if (armor['resistsStab'] == true ||
                                            armor['resistsBallistic'] == true ||
                                            armor['resistsArmorPiercing'] ==
                                                true) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            [
                                              if (armor['resistsStab'] == true)
                                                l10n.vestProtectsStab,
                                              if (armor['resistsBallistic'] ==
                                                  true)
                                                l10n.vestProtectsBullets,
                                              if (armor['resistsArmorPiercing'] ==
                                                  true)
                                                l10n.vestProtectsAp,
                                            ].join(' · '),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: secondaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.shield,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          '+${armor['armor']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryTextColor,
                                          ),
                                        ),
                                        if (isCurrentArmor &&
                                            (_securityStatus['baseArmor'] ??
                                                    0) >
                                                0)
                                          Text(
                                            l10n.armorDefenseNowAtCondition(
                                              '${_securityStatus['armor']}',
                                              '${_armorCondition()}',
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: _activeArmorMutedText,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatCurrency(armor['price']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    if (!isCurrentArmor ||
                                        canRefreshCurrentArmor)
                                      ElevatedButton(
                                        onPressed: () => _buyArmor(armor['id']),
                                        child: Text(
                                          _armorActionLabel(
                                            isCurrentArmor: isCurrentArmor,
                                            isCurrentArmorDamaged:
                                                canRefreshCurrentArmor,
                                            hasActiveArmor: hasActiveArmor,
                                            l10n: l10n,
                                          ),
                                        ),
                                      )
                                    else
                                      Chip(
                                        label: Text(
                                          l10n.worn,
                                          style: const TextStyle(
                                            color: _activeArmorText,
                                          ),
                                        ),
                                        backgroundColor: _activeArmorBorder,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
