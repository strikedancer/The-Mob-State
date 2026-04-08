import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final ApiClient _apiClient = ApiClient();
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
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(l10n?.hitlistLoadError(e.toString()) ?? 'Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buyBodyguard() async {
    final l10n = AppLocalizations.of(context);

    try {
      final response = await _apiClient.post(
        '/security/buy-bodyguards',
        {'quantity': 1},
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        _loadSecurityStatus();
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n?.defenseIncrease('Bodyguard', '10') ?? 'Bodyguard bought! +10 defense'),
            ),
          );
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(data['message'] ?? 'Could not buy bodyguard'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
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
          final msg = l10n?.defenseIncrease(armor['name'], armor['armor'].toString()) ?? 
            '${armor['name']} bought! +${armor['armor']} defense';
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text(msg)),
          );
        }
      } else {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(data['message'] ?? 'Could not buy armor'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMsg = AppLocalizations.of(context)?.hitError(e.toString()) ?? 'Error: $e';
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  int _calculateDefense() {
    if (_securityStatus == null) return 0;
    final armorRating = _securityStatus['armor'] ?? 0;
    final bodyguards = _securityStatus['bodyguards'] ?? 0;
    return armorRating + (bodyguards * 10);
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n?.currentArmor ?? 'Current Armor'),
                                      Text(
                                        '${_securityStatus['armor'] ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n?.bodyguards ?? 'Bodyguards'),
                                      Text(
                                        '${_securityStatus['bodyguards'] ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
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
                              Text(l10n?.protectorsFollow ?? 'Protectors that follow you'),
                              Text(
                                l10n?.eachGivesDefense ?? 'Each gives +10 defense',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n?.bodyguardPrice ?? 'Price per Bodyguard'),
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
                      const SizedBox(height: 12),
                      Column(
                        children: armorTypes.map((armor) {
                          final isCurrentArmor =
                              _securityStatus['armorType'] == armor['id'];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              color: isCurrentArmor ? Colors.green[50] : null,
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
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (isCurrentArmor)
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.only(left: 8),
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 16,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Text(
                                              armor['description'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Icon(Icons.shield,
                                                color: Colors.blue),
                                            Text(
                                              '+${armor['armor']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
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
                                          '€${armor['price'].toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        if (!isCurrentArmor)
                                          ElevatedButton(
                                            onPressed: () =>
                                                _buyArmor(armor['id']),
                                            child: Text(l10n?.buy ?? 'Buy'),
                                          )
                                        else
                                          Chip(
                                            label: Text(l10n?.worn ?? 'Worn'),
                                            backgroundColor: Colors.green,
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
