import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';

class WeaponsMarketScreen extends StatefulWidget {
  const WeaponsMarketScreen({super.key});

  @override
  State<WeaponsMarketScreen> createState() => _WeaponsMarketScreenState();
}

class _WeaponsMarketScreenState extends State<WeaponsMarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _weapons = [];
  List<dynamic> _inventory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final weaponsResponse = await _apiClient.get('/weapons');
      final inventoryResponse = await _apiClient.get('/weapons/inventory');
      final weaponsData = jsonDecode(weaponsResponse.body);
      final inventoryData = jsonDecode(inventoryResponse.body);

      setState(() {
        _weapons = (weaponsData['weapons'] as List<dynamic>? ?? []);
        _inventory = (inventoryData['weapons'] as List<dynamic>? ?? []);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buyWeapon(String weaponId) async {
    final l10n = AppLocalizations.of(context);
    try {
      final response = await _apiClient.post('/weapons/buy/$weaponId', {});
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n?.weaponPurchased ?? 'Weapon purchased'),
            ),
          );
        }
        _loadData();
      } else if (mounted) {
        final message =
            data['params']?['message']?.toString() ??
            (l10n?.hitError(data.toString()) ?? 'Error: $data');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(l10n?.unknownError ?? 'Er is een fout opgetreden')),
        );
      }
    }
  }

  bool _canBuyWeapon(dynamic weapon, AuthProvider authProvider) {
    final requiredRank = weapon['requiredRank'] ?? 1;
    final vipOnly = weapon['vipOnly'] == true;
    final rank = authProvider.currentPlayer?.rank ?? 1;
    final isVip = authProvider.currentPlayer?.isVip ?? false;

    if (vipOnly && !isVip) {
      return false;
    }

    if (rank >= 15) {
      return true;
    }

    return rank >= requiredRank;
  }

  Widget _buildWeaponImage(dynamic weapon) {
    final image = weapon['image']?.toString();
    if (image == null || image.isEmpty) {
      return const Icon(Icons.gavel, size: 32);
    }

    return Image.asset(image, width: 48, height: 48, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/backgrounds/weapon_shop_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n?.weaponShop ?? 'Shop'),
              Tab(text: l10n?.myWeapons ?? 'My Weapons'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _weapons.length,
                  itemBuilder: (context, index) {
                    final weapon = _weapons[index];
                    final canBuy = _canBuyWeapon(weapon, authProvider);
                    final vipOnly = weapon['vipOnly'] == true;
                    final requiredRank = weapon['requiredRank'] ?? 1;
                    final requiresAmmo = weapon['requiresAmmo'] == true;
                    final ammoType = weapon['ammoType']?.toString();
                    final ammoPerCrime = weapon['ammoPerCrime'];
                    final price = weapon['price'] ?? 0;

                    String subtitle =
                        '€$price • ${l10n?.weaponRankRequired(requiredRank.toString()) ?? 'Rank required: $requiredRank'}';
                    if (vipOnly) {
                      subtitle += ' • ${l10n?.vipOnly ?? 'VIP only'}';
                    }
                    if (requiresAmmo && ammoType != null) {
                      subtitle += '\n${Localizations.localeOf(context).languageCode == 'nl' ? 'Munitie' : 'Ammo'}: $ammoType';
                      if (ammoPerCrime != null) {
                        subtitle += ' ($ammoPerCrime ${Localizations.localeOf(context).languageCode == 'nl' ? 'per misdaad' : 'per crime'})';
                      }
                    }

                    return Card(
                      child: ListTile(
                        leading: _buildWeaponImage(weapon),
                        title: Text(
                          weapon['name'] ??
                              (Localizations.localeOf(context).languageCode == 'nl'
                                  ? 'Onbekend'
                                  : 'Unknown'),
                        ),
                        subtitle: Text(subtitle),
                        trailing: ElevatedButton(
                          onPressed: canBuy
                              ? () => _buyWeapon(weapon['id'])
                              : null,
                          child: Text(l10n?.buyWeapon ?? 'Buy'),
                        ),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _inventory.length,
                  itemBuilder: (context, index) {
                    final weapon = _inventory[index];
                    final condition = weapon['condition'] ?? 100;
                    final quantity = weapon['quantity'] ?? 1;
                    final requiresAmmo = weapon['requiresAmmo'] == true;
                    final ammoType = weapon['ammoType']?.toString();
                    final ammoPerCrime = weapon['ammoPerCrime'];

                    String subtitle =
                        '${l10n?.condition ?? 'Condition'}: $condition%';
                    if (requiresAmmo && ammoType != null) {
                      subtitle += '\n${Localizations.localeOf(context).languageCode == 'nl' ? 'Munitie' : 'Ammo'}: $ammoType';
                      if (ammoPerCrime != null) {
                        subtitle += ' ($ammoPerCrime ${Localizations.localeOf(context).languageCode == 'nl' ? 'per misdaad' : 'per crime'})';
                      }
                    }

                    return Card(
                      child: ListTile(
                        leading: _buildWeaponImage(weapon),
                        title: Text(
                          weapon['name'] ?? weapon['weaponName'] ?? (Localizations.localeOf(context).languageCode == 'nl' ? 'Onbekend' : 'Unknown'),
                        ),
                        subtitle: Text(subtitle),
                        trailing: Text('x$quantity'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
