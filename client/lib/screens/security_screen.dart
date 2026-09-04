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

  String _bodyguardName(AppLocalizations l10n, String id) {
    switch (id) {
      case 'street':
        return l10n.bodyguardStreet;
      case 'elite':
        return l10n.bodyguardElite;
      default:
        return l10n.bodyguardStandard;
    }
  }

  String _bodyguardDescription(AppLocalizations l10n, String id) {
    switch (id) {
      case 'street':
        return l10n.bodyguardStreetDesc;
      case 'elite':
        return l10n.bodyguardEliteDesc;
      default:
        return l10n.bodyguardStandardDesc;
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

  List<Map<String, dynamic>> _bodyguardCatalog() {
    final catalog = _securityStatus?['bodyguardCatalog'];
    if (catalog is List && catalog.isNotEmpty) {
      return catalog
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .toList();
    }
    return const [
      {'id': 'street', 'hireCost': 6000, 'defense': 8, 'dailyCost': 4000},
      {'id': 'standard', 'hireCost': 10000, 'defense': 10, 'dailyCost': 10000},
      {'id': 'elite', 'hireCost': 35000, 'defense': 22, 'dailyCost': 18000},
    ];
  }

  int _asInt(dynamic value, [int fallback = 0]) {
    if (value is num) return value.toInt();
    return int.tryParse('${value ?? ''}') ?? fallback;
  }

  int _bodyguardCount(String typeId) {
    final counts = _securityStatus?['bodyguardCounts'];
    if (counts is Map) {
      return _asInt(counts[typeId]);
    }
    if (typeId == 'standard') {
      return _asInt(_securityStatus?['bodyguards']);
    }
    return 0;
  }

  String _securityFailureMessage(
    AppLocalizations l10n,
    Map<String, dynamic> data, {
    required String fallback,
  }) {
    switch (data['error']?.toString()) {
      case 'INSUFFICIENT_MONEY':
        return l10n.moneyNotEnough;
      case 'INVALID_QUANTITY':
        return l10n.securityErrorMinQuantity;
      case 'ARMOR_NOT_FOUND':
        return l10n.securityErrorArmorNotFound;
      case 'ARMOR_ALREADY_EQUIPPED':
        return l10n.armorAlreadyEquippedLong;
      case 'NO_ARMOR':
        return l10n.securityErrorNoArmor;
      case 'ARMOR_NOT_DAMAGED':
        return l10n.securityErrorArmorNotDamaged;
      case 'BODYGUARD_CAP_REACHED':
        return l10n.securityErrorBodyguardCap;
      case 'INVALID_BODYGUARD_TYPE':
        return l10n.securityErrorInvalidBodyguardType;
      case 'NOT_ENOUGH_BODYGUARDS':
        return l10n.securityErrorNotEnoughBodyguards;
      default:
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) {
          return message;
        }
        return fallback;
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

  Future<void> _postSecurityAction({
    required String path,
    required Map<String, dynamic> body,
    required String successMessage,
    required String fallbackError,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final response = await _apiClient.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        await _loadSecurityStatus();
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(successMessage)),
          );
        }
      } else if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _securityFailureMessage(l10n, data, fallback: fallbackError),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(AppLocalizations.of(context)!.hitError(e.toString()))),
        );
      }
    }
  }

  Future<void> _buyBodyguard(String typeId, String name) {
    final l10n = AppLocalizations.of(context)!;
    return _postSecurityAction(
      path: '/security/buy-bodyguards',
      body: {'quantity': 1, 'type': typeId},
      successMessage: l10n.bodyguardHired(name),
      fallbackError: l10n.couldNotBuyBodyguard,
    );
  }

  Future<void> _dismissBodyguard(String typeId, String name) {
    final l10n = AppLocalizations.of(context)!;
    return _postSecurityAction(
      path: '/security/dismiss-bodyguards',
      body: {'quantity': 1, 'type': typeId},
      successMessage: l10n.bodyguardDismissed(name),
      fallbackError: l10n.couldNotDismissBodyguard,
    );
  }

  Future<void> _buyArmor(String armorId) {
    final l10n = AppLocalizations.of(context)!;
    final armor = armorTypes.firstWhere((item) => item['id'] == armorId);
    return _postSecurityAction(
      path: '/security/buy-armor/$armorId',
      body: {},
      successMessage: l10n.defenseIncrease(
        armor['name'] as String,
        '${armor['armor']}',
      ),
      fallbackError: l10n.couldNotBuyArmor,
    );
  }

  Future<void> _repairArmor() {
    final l10n = AppLocalizations.of(context)!;
    return _postSecurityAction(
      path: '/security/repair-armor',
      body: {},
      successMessage: l10n.armorRepaired,
      fallbackError: l10n.couldNotRepairArmor,
    );
  }

  int _calculateDefense() {
    if (_securityStatus == null) return 0;
    final armorRating = _asInt(_securityStatus['armor']);
    final bodyguardDefense = _asInt(
      _securityStatus['bodyguardDefense'],
      _asInt(_securityStatus['bodyguards']) * 10,
    );
    return armorRating + bodyguardDefense;
  }

  int _armorCondition() {
    if (_securityStatus == null) return 100;
    return _asInt(_securityStatus['armorCondition'], 100);
  }

  bool _isArmorDamaged() {
    return _asInt(_securityStatus?['baseArmor']) > 0 && _armorCondition() < 100;
  }

  bool _hasActiveArmor() {
    return _asInt(_securityStatus?['baseArmor']) > 0;
  }

  Widget _vestThumb(String armorId, {required bool active}) {
    return marketThumbBox(
      child: Image.asset(
        'assets/images/security/$armorId.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.shield,
          color: active ? _activeArmorBorder : Colors.blue,
        ),
      ),
    );
  }

  Widget _buildArmorRow(Map<String, dynamic> armor, AppLocalizations l10n) {
    final isCurrentArmor = _securityStatus['armorType'] == armor['id'];
    final hasActiveArmor = _hasActiveArmor();
    final canRepair = isCurrentArmor && _isArmorDamaged();
    final shopPrice = _asInt(armor['shopPrice'] ?? armor['price']);
    final netPrice = _asInt(armor['netPrice'] ?? shopPrice, shopPrice);
    final tradeInCredit = _asInt(armor['tradeInCredit']);
    final repairCost = _asInt(
      armor['repairCost'] ?? _securityStatus?['armorRepairCost'],
    );
    final weaknesses = _securityStatus?['armorWeaknesses'];
    final weakStab = weaknesses is Map && weaknesses['weakVsStab'] == true;
    final weakBullets = weaknesses is Map && weaknesses['weakVsBullets'] == true;
    final weakAp = weaknesses is Map && weaknesses['weakVsAp'] == true;

    Widget? action;
    if (canRepair) {
      action = FilledButton(
        onPressed: _repairArmor,
        style: marketBuyButtonStyle(),
        child: Text(l10n.repairArmor),
      );
    } else if (!isCurrentArmor) {
      action = FilledButton(
        onPressed: () => _buyArmor(armor['id'] as String),
        style: marketBuyButtonStyle(),
        child: Text(hasActiveArmor ? l10n.upgradeArmor : l10n.buy),
      );
    }

    return MarketCompactRow(
      tooltip: armor['description']?.toString(),
      color: isCurrentArmor ? _activeArmorBackground : null,
      leading: _vestThumb(armor['id'].toString(), active: isCurrentArmor),
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
              if (isCurrentArmor && _hasActiveArmor())
                MarketInfoPill(
                  label: l10n.armorDefenseNowAtCondition(
                    '${_securityStatus['armor']}',
                    '${_armorCondition()}',
                  ),
                  color: Colors.teal.shade700,
                ),
              if (isCurrentArmor && weakStab)
                MarketInfoPill(
                  label: l10n.vestWeakVsStab,
                  color: Colors.red.shade800,
                ),
              if (isCurrentArmor && weakBullets)
                MarketInfoPill(
                  label: l10n.vestWeakVsBullets,
                  color: Colors.red.shade800,
                ),
              if (isCurrentArmor && weakAp)
                MarketInfoPill(
                  label: l10n.vestWeakVsAp,
                  color: Colors.red.shade800,
                ),
              if (canRepair && repairCost > 0)
                MarketInfoPill(
                  label: formatCurrency(repairCost),
                  color: Colors.orange.shade800,
                ),
              if (!isCurrentArmor && tradeInCredit > 0)
                MarketInfoPill(
                  label: l10n.vestTradeInCredit(formatCurrency(tradeInCredit)),
                  color: Colors.teal.shade800,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        formatCurrency(canRepair ? repairCost : netPrice),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: action,
    );
  }

  Widget _buildBodyguardRow(Map<String, dynamic> item, AppLocalizations l10n) {
    final typeId = '${item['id'] ?? 'standard'}';
    final name = _bodyguardName(l10n, typeId);
    final count = _bodyguardCount(typeId);
    final hireCost = _asInt(item['hireCost'], 10000);
    final defense = _asInt(item['defense'], 10);
    final dailyCost = _asInt(item['dailyCost'], 10000);
    final canHire = _securityStatus?['canHireBodyguards'] != false;

    return MarketCompactRow(
      tooltip: _bodyguardDescription(l10n, typeId),
      leading: Icon(
        typeId == 'elite'
            ? Icons.shield
            : typeId == 'street'
            ? Icons.visibility
            : Icons.person,
        size: 28,
        color: typeId == 'elite' ? Colors.amber.shade700 : Colors.orange.shade800,
      ),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: l10n.eachGivesDefenseAmount('$defense'),
                color: Colors.teal.shade700,
              ),
              MarketInfoPill(
                label: l10n.dailyWageAmount(formatCurrency(dailyCost)),
                color: Colors.orange.shade800,
              ),
              if (count > 0)
                MarketInfoPill(
                  label: '${l10n.bodyguards} $count',
                  color: Colors.blueGrey.shade700,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        formatCurrency(hireCost),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 0) ...[
            OutlinedButton(
              onPressed: () => _dismissBodyguard(typeId, name),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                minimumSize: const Size(0, 34),
              ),
              child: Text(l10n.bodyguardDismiss),
            ),
            const SizedBox(width: 6),
          ],
          FilledButton(
            onPressed: canHire ? () => _buyBodyguard(typeId, name) : null,
            style: marketBuyButtonStyle(),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final condition = _armorCondition();
    final cap = _asInt(_securityStatus?['bodyguardCap'], 10);
    final used = _asInt(
      _securityStatus?['bodyguardSlotsUsed'],
      _bodyguardCount('street') +
          _bodyguardCount('standard') +
          _bodyguardCount('elite'),
    );

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
                            label:
                                '${l10n.currentArmor} ${_securityStatus['armor'] ?? 0}',
                            color: Colors.blueGrey.shade700,
                            icon: Icons.health_and_safety,
                          ),
                          if (_hasActiveArmor())
                            MarketInfoPill(
                              label: l10n.armorConditionLine(
                                '$condition',
                                '${_securityStatus['baseArmor']}',
                              ),
                              color: Colors.teal.shade700,
                            ),
                          MarketInfoPill(
                            label: l10n.bodyguardCapLine('$used', '$cap'),
                            color: Colors.orange.shade800,
                            icon: Icons.group,
                          ),
                          MarketInfoPill(
                            label: l10n.dailySystemCostLine(
                              formatCurrency(
                                _securityStatus['bodyguardDailyCost'] ?? 0,
                              ),
                            ),
                            color: Colors.orange.shade800,
                          ),
                        ],
                      ),
                      if (_hasActiveArmor()) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: condition / 100,
                            minHeight: 6,
                            backgroundColor: Colors.black26,
                            color: condition >= 70
                                ? Colors.green
                                : condition >= 40
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                marketSectionHeader(
                  context,
                  label: l10n.buyBodyguards,
                  icon: Icons.person_add,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.bodyguardsLeaveIfUnpaid,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                for (final item in _bodyguardCatalog())
                  _buildBodyguardRow(item, l10n),
                if (_securityStatus['bodyguardUpkeepDueAt'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.nextPayrollAt(
                        _formatDateTime(
                          _securityStatus['bodyguardUpkeepDueAt'] as String?,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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
                    l10n.vestTradeInHint,
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
