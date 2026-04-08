import 'package:flutter/material.dart';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../utils/top_right_notification.dart';

class MaterialsShopScreen extends StatefulWidget {
  const MaterialsShopScreen({super.key});

  @override
  State<MaterialsShopScreen> createState() => _MaterialsShopScreenState();
}

class _MaterialsShopScreenState extends State<MaterialsShopScreen> {
  final DrugService _drugService = DrugService();
  List<MaterialDefinition> _materials = [];
  List<PlayerMaterial> _playerMaterials = [];
  bool _isLoading = true;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final materials = await _drugService.getMaterials();
      final playerMaterials = await _drugService.getPlayerMaterials();
      setState(() {
        _materials = materials;
        _playerMaterials = playerMaterials;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(_tr('Fout bij laden: $e', 'Error while loading: $e'))),
        );
      }
    }
  }

  int _getPlayerMaterialQuantity(String materialId) {
    final material = _playerMaterials.firstWhere(
      (m) => m.materialId == materialId,
      orElse: () => PlayerMaterial(
        id: 0,
        materialId: materialId,
        name: '',
        description: '',
        quantity: 0,
        price: 0,
      ),
    );
    return material.quantity;
  }

  Future<void> _buyMaterial(MaterialDefinition material) async {
    final quantity = await _showQuantityDialog(material);
    if (quantity == null || quantity <= 0) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final totalCost = material.price * quantity;

    if (authProvider.currentPlayer!.money < totalCost) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('${_tr('Je hebt', 'You need')} €${totalCost.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]}.',
                )} ${_tr('nodig', 'required')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final result = await _drugService.buyMaterial(material.id, quantity);

    if (mounted) {
      if (result['success'] == true) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['message'] ?? _tr('Aankoop mislukt', 'Purchase failed')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<int?> _showQuantityDialog(MaterialDefinition material) async {
    final controller = TextEditingController(text: '1');
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(material.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(material.description),
            const SizedBox(height: 16),
            Text(
              '${_tr('Prijs', 'Price')}: €${material.price.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]}.',
                  )} ${_tr('per stuk', 'each')}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr('Hoeveelheid', 'Quantity'),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Validate input (handled by ValueListenableBuilder below)
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, TextEditingValue value, _) {
                final qty = int.tryParse(value.text) ?? 0;
                final total = material.price * qty;
                return Text(
                  '${_tr('Totaal', 'Total')}: €${total.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      )}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(controller.text);
              Navigator.pop(context, qty);
            },
            child: Text(_tr('Kopen', 'Buy')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tr('Materialen Shop', 'Materials Shop')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '€${authProvider.currentPlayer?.money.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]}.',
                    ) ?? '0'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _materials.isEmpty
                  ? Center(child: Text(_tr('Geen materialen beschikbaar', 'No materials available')))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _materials.length,
                      itemBuilder: (context, index) {
                        final material = _materials[index];
                        final owned = _getPlayerMaterialQuantity(material.id);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[200],
                              child: Image.asset(
                                material.getImagePath(),
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.science),
                              ),
                            ),
                            title: Text(
                              material.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(material.description),
                                const SizedBox(height: 4),
                                Text(
                                  '${_tr('Prijs', 'Price')}: €${material.price.toString().replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]}.',
                                      )}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (owned > 0)
                                  Text(
                                    '${_tr('In bezit', 'Owned')}: $owned',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: ElevatedButton.icon(
                              onPressed: () => _buyMaterial(material),
                              icon: const Icon(Icons.shopping_cart, size: 18),
                              label: Text(_tr('Koop', 'Buy')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
