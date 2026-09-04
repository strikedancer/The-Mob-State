import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';
import '../widgets/market_compact.dart';
class WeaponsMarketScreen extends StatefulWidget {
  const WeaponsMarketScreen({super.key});

  @override
  State<WeaponsMarketScreen> createState() => _WeaponsMarketScreenState();
}

class _WeaponsMarketScreenState extends State<WeaponsMarketScreen> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _weapons = [];
  List<dynamic> _inventory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
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

    return Image.asset(image, width: 44, height: 44, fit: BoxFit.contain);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final ammoLabel = l10n?.ammoGeneric ?? 'Ammo';
    final perCrime = l10n?.ammoPerCrimeSuffix ?? 'per crime';
    final unknownName = l10n?.unknown ?? 'Unknown';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/weapon_shop_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: marketListPadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            for (final weapon in _weapons)
              _buildShopWeaponRow(
                weapon,
                authProvider: authProvider,
                l10n: l10n,
                unknownName: unknownName,
                ammoLabel: ammoLabel,
                perCrime: perCrime,
              ),
            marketSectionHeader(
              context,
              label: l10n?.inventory ?? 'Inventory',
            ),
            if (_inventory.isEmpty)
              marketEmptyHint(l10n?.noItemsInInventory ?? 'No items')
            else
              for (final weapon in _inventory)
                _buildOwnedWeaponRow(
                  weapon,
                  l10n: l10n,
                  unknownName: unknownName,
                  ammoLabel: ammoLabel,
                  perCrime: perCrime,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopWeaponRow(
    dynamic weapon, {
    required AuthProvider authProvider,
    required AppLocalizations? l10n,
    required String unknownName,
    required String ammoLabel,
    required String perCrime,
  }) {
    final canBuy = _canBuyWeapon(weapon, authProvider);
    final vipOnly = weapon['vipOnly'] == true;
    final requiredRank = weapon['requiredRank'] ?? 1;
    final requiresAmmo = weapon['requiresAmmo'] == true;
    final ammoType = weapon['ammoType']?.toString();
    final ammoPerCrime = weapon['ammoPerCrime'];
    final price = weapon['price'] ?? 0;
    final rankLabel =
        l10n?.weaponRankRequired(requiredRank.toString()) ??
        'Rank $requiredRank';
    final ammoHint = requiresAmmo && ammoType != null
        ? ammoPerCrime != null
            ? '$ammoLabel: $ammoType ($ammoPerCrime $perCrime)'
            : '$ammoLabel: $ammoType'
        : null;

    return MarketCompactRow(
      tooltip: weapon['description']?.toString(),
      leading: _buildWeaponImage(weapon),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weapon['name'] ?? unknownName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: rankLabel,
                color: Colors.blueGrey.shade700,
                icon: Icons.military_tech,
              ),
              if (vipOnly)
                MarketInfoPill(
                  label: l10n?.vipOnly ?? 'VIP',
                  color: Colors.amber.shade800,
                  icon: Icons.star,
                ),
              if (ammoHint != null)
                MarketInfoPill(
                  label: ammoType!,
                  color: Colors.brown.shade700,
                  icon: Icons.bolt,
                  tooltip: ammoHint,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        '€$price',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: FilledButton(
        onPressed: canBuy ? () => _buyWeapon(weapon['id']) : null,
        style: marketBuyButtonStyle(),
        child: Text(l10n?.buyWeapon ?? 'Buy'),
      ),
    );
  }

  Widget _buildOwnedWeaponRow(
    dynamic weapon, {
    required AppLocalizations? l10n,
    required String unknownName,
    required String ammoLabel,
    required String perCrime,
  }) {
    final condition = weapon['condition'] ?? 100;
    final quantity = weapon['quantity'] ?? 1;
    final requiresAmmo = weapon['requiresAmmo'] == true;
    final ammoType = weapon['ammoType']?.toString();
    final ammoPerCrime = weapon['ammoPerCrime'];
    final ammoHint = requiresAmmo && ammoType != null
        ? ammoPerCrime != null
            ? '$ammoLabel: $ammoType ($ammoPerCrime $perCrime)'
            : '$ammoLabel: $ammoType'
        : null;

    return MarketCompactRow(
      leading: _buildWeaponImage(weapon),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weapon['name'] ?? weapon['weaponName'] ?? unknownName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 3,
            children: [
              MarketInfoPill(
                label: '${l10n?.condition ?? 'Condition'} $condition%',
                color: condition < 50 ? Colors.red.shade700 : Colors.teal.shade700,
                icon: Icons.health_and_safety,
              ),
              if (ammoHint != null)
                MarketInfoPill(
                  label: ammoType!,
                  color: Colors.brown.shade700,
                  icon: Icons.bolt,
                  tooltip: ammoHint,
                ),
            ],
          ),
        ],
      ),
      meta: Text(
        'x$quantity',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
