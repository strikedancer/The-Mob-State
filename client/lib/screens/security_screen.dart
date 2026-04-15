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

  // Armor types
  late final List<Map<String, dynamic>> armorTypes;

  @override
  void initState() {
    super.initState();
    _loadSecurityStatus();
  }

  void _initializeArmorTypes() {
    final l10n = AppLocalizations.of(context);
    armorTypes = [
      {
        'id': 'light_armor',
        'name': l10n?.lightArmor ?? 'Light Armor',
        'description': l10n?.basicProtection ?? 'Basic protection',
        'price': 5000,
        'armor': 20,
      },
      {
        'id': 'heavy_armor',
        'name': l10n?.heavyArmor ?? 'Heavy Armor',
        'description': l10n?.strongProtection ?? 'Strong protection',
        'price': 20000,
        'armor': 50,
      },
      {
        'id': 'bulletproof_vest',
        'name': l10n?.bulletproofVest ?? 'Bulletproof Vest',
        'description': l10n?.veryStrongProtection ?? 'Very strong protection',
        'price': 50000,
        'armor': 100,
      },
      {
        'id': 'tactical_suit',
        'name': l10n?.tacticalSuit ?? 'Tactical Outfit',
        'description': l10n?.premiumProtection ?? 'Premium protection',
        'price': 75000,
        'armor': 150,
      },
    ];
  }

  String _tr(String nl, String en) {
    return Localizations.localeOf(context).languageCode == 'nl' ? nl : en;
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
    return '$day/$month ${hour}:$minute';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeArmorTypes();
  }

  Future<void> _loadSecurityStatus() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/security/status');
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          _securityStatus = data['security'];
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n?.hitlistLoadError(e.toString()) ?? 'Error: $e'),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buyBodyguard() async {
    final l10n = AppLocalizations.of(context);

    try {
      final response = await _apiClient.post('/security/buy-bodyguards', {
        'quantity': 1,
      });
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _loadSecurityStatus();
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n?.defenseIncrease('Bodyguard', '10') ??
                    'Bodyguard bought! +10 defense',
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(data['message'] ?? 'Could not buy bodyguard'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg =
            AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, SnackBar(content: Text(errorMsg)));
      }
    }
  }

  Future<void> _buyArmor(String armorId) async {
    final l10n = AppLocalizations.of(context);
    final armor = armorTypes.firstWhere((a) => a['id'] == armorId);

    try {
      final response = await _apiClient.post(
        '/security/buy-armor/$armorId',
        {},
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _loadSecurityStatus();
        if (mounted) {
          final msg =
              l10n?.defenseIncrease(armor['name'], armor['armor'].toString()) ??
              '${armor['name']} bought! +${armor['armor']} defense';
          showTopRightFromSnackBar(context, SnackBar(content: Text(msg)));
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(_armorErrorMessage(data) ?? 'Could not buy armor'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg =
            AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
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

  String? _armorErrorMessage(dynamic data) {
    final errorCode = data['error']?.toString();
    if (errorCode == 'ARMOR_ALREADY_EQUIPPED') {
      return _tr(
        'Je draagt dit vest al. Je kunt maar 1 armor tegelijk dragen.',
        'You already wear this armor. You can only wear 1 armor at a time.',
      );
    }

    return data['message']?.toString();
  }

  String _armorActionLabel({
    required bool isCurrentArmor,
    required bool isCurrentArmorDamaged,
    required bool hasActiveArmor,
    required AppLocalizations? l10n,
  }) {
    if (isCurrentArmorDamaged) {
      return _tr('Vervangen', 'Replace');
    }

    if (!isCurrentArmor && hasActiveArmor) {
      return _tr('Vervangen', 'Replace');
    }

    return l10n?.buy ?? 'Buy';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.security ?? 'Security'),
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
                  Text(l10n?.currentDefenseStatus ?? 'Error loading security'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _loadSecurityStatus,
                    child: Text(l10n?.refresh ?? 'Try again'),
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
                            l10n?.currentDefense ?? 'Current Defense',
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
                                  Text(l10n?.totalDefense ?? 'Total Defense'),
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
                                  Text(l10n?.currentArmor ?? 'Current Armor'),
                                  Text(
                                    '${_securityStatus['armor'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if ((_securityStatus['baseArmor'] ?? 0) > 0)
                                    Text(
                                      _tr(
                                        'Conditie ${_armorCondition()}% · basis ${_securityStatus['baseArmor']}',
                                        'Condition ${_armorCondition()}% · base ${_securityStatus['baseArmor']}',
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
                                  Text(l10n?.bodyguards ?? 'Bodyguards'),
                                  Text(
                                    '${_securityStatus['bodyguards'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _tr(
                                      'Dagloon ${formatCurrency(_securityStatus['bodyguardDailyCost'] ?? 0)}',
                                      'Daily wage ${formatCurrency(_securityStatus['bodyguardDailyCost'] ?? 0)}',
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
                    l10n?.buyBodyguards ?? 'Buy Bodyguards',
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
                            l10n?.protectorsFollow ??
                                'Protectors that follow you',
                          ),
                          Text(
                            l10n?.eachGivesDefense ?? 'Each gives +10 defense',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _tr(
                              'Dagelijkse systeemkost: ${formatCurrency(_securityStatus['bodyguardDailyCost'] ?? 0)}',
                              'Daily system cost: ${formatCurrency(_securityStatus['bodyguardDailyCost'] ?? 0)}',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _tr(
                              'Volgende afschrijving: ${_formatDateTime(_securityStatus['bodyguardUpkeepDueAt'] as String?)}',
                              'Next payroll: ${_formatDateTime(_securityStatus['bodyguardUpkeepDueAt'] as String?)}',
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _tr(
                              'Kun je het dagloon niet betalen, dan lopen alle lijfwachten weg.',
                              'If you cannot pay the daily wage, all bodyguards leave.',
                            ),
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
                                    l10n?.bodyguardPrice ??
                                        'Price per Bodyguard',
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
                                label: Text(l10n?.buy ?? 'Buy'),
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
                    l10n?.armor ?? 'Armor',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _tr(
                      'Je kunt maar 1 armor tegelijk dragen. Een nieuw vest vervangt altijd je huidige vest.',
                      'You can only wear 1 armor at a time. A new armor always replaces your current one.',
                    ),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              armor['name'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
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
                                      ],
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
                                            _tr(
                                              'Nu +${_securityStatus['armor']} bij ${_armorCondition()}%',
                                              'Now +${_securityStatus['armor']} at ${_armorCondition()}%',
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
                                          l10n?.worn ?? 'Worn',
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
