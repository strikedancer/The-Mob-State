import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import 'carried_inventory_tab.dart';
import 'storage_tab.dart';
import 'loadouts_tab.dart';
import '../l10n/app_localizations.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();
  List<Map<String, dynamic>> _weaponInventory = [];
  String? _selectedCrimeWeaponId;
  bool _loadingWeaponSelection = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCrimeWeaponSelection();
  }

  Future<void> _loadCrimeWeaponSelection() async {
    try {
      final inventoryResponse = await _apiClient.get('/weapons/inventory');
      if (inventoryResponse.statusCode == 200) {
        final data = jsonDecode(inventoryResponse.body);
        final weapons = (data['weapons'] as List<dynamic>? ?? [])
            .map((w) => (w as Map<String, dynamic>))
            .where((w) => ((w['condition'] as num?)?.toInt() ?? 0) > 0)
            .toList();

        String? selectedId;
        final selectedResponse = await _apiClient.get('/weapons/crime-weapon');
        if (selectedResponse.statusCode == 200) {
          final selectedData = jsonDecode(selectedResponse.body);
          selectedId = selectedData['weapon']?['weaponId'] as String?;
        }

        if (!mounted) return;
        setState(() {
          _weaponInventory = weapons;
          _selectedCrimeWeaponId = selectedId;
          _loadingWeaponSelection = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingWeaponSelection = false;
      });
    }
  }

  Future<void> _setCrimeWeapon(String weaponId) async {
    try {
      final response = await _apiClient.post('/weapons/crime-weapon', {
        'weaponId': weaponId,
      });
      if (response.statusCode != 200) return;

      if (!mounted) return;
      setState(() {
        _selectedCrimeWeaponId = weaponId;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventory),
        backgroundColor: Colors.grey[900],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: [
            Tab(icon: const Icon(Icons.backpack), text: l10n.carried),
            Tab(icon: const Icon(Icons.warehouse), text: l10n.storage),
            Tab(
              icon: const Icon(Icons.dashboard_customize),
              text: l10n.loadouts,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4AF37), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Geselecteerd wapen voor misdaden',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                if (_loadingWeaponSelection)
                  const SizedBox(
                    height: 36,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  DropdownButtonFormField<String>(
                    value: _selectedCrimeWeaponId,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2A2A2A),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade700),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    hint: const Text(
                      'Selecteer verplicht een wapen',
                      style: TextStyle(color: Colors.white70),
                    ),
                    items: _weaponInventory
                        .map(
                          (weapon) => DropdownMenuItem<String>(
                            value: weapon['weaponId'] as String,
                            child: Text(
                              '${weapon['name'] ?? weapon['weaponId']} (${weapon['condition']}%)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _setCrimeWeapon(value);
                      }
                    },
                  ),
                if (!_loadingWeaponSelection &&
                    _weaponInventory.isNotEmpty &&
                    _selectedCrimeWeaponId == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Kies eerst een wapen voordat je misdaden doet.',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ),
                if (!_loadingWeaponSelection && _weaponInventory.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Geen bruikbare wapens in inventory. Koop eerst een wapen.',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CarriedInventoryTab(
                  playerId: authProvider.currentPlayer?.id ?? 0,
                ),
                StorageTab(playerId: authProvider.currentPlayer?.id ?? 0),
                LoadoutsTab(playerId: authProvider.currentPlayer?.id ?? 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
