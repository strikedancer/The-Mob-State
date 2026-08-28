import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../providers/auth_provider.dart';
import '../services/drug_service.dart';
import '../utils/top_right_notification.dart';
import '../widgets/responsive_modal.dart';

class MaterialsShopScreen extends StatefulWidget {
  const MaterialsShopScreen({super.key});

  @override
  State<MaterialsShopScreen> createState() => _MaterialsShopScreenState();
}

class _MaterialsShopScreenState extends State<MaterialsShopScreen> {
  final DrugService _drugService = DrugService();
  List<MaterialDefinition> _materials = [];
  PlayerMaterialsSnapshot _snapshot = PlayerMaterialsSnapshot.empty();
  bool _isLoading = true;
  String? _busyMaterialId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final materials = await _drugService.getMaterials();
      final snapshot = await _drugService.getPlayerMaterials();
      if (!mounted) return;
      setState(() {
        _materials = materials;
        _snapshot = snapshot;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.materialsShopLoadError('$e'))),
      );
    }
  }

  Future<void> _buyMaterial(MaterialDefinition material) async {
    final l10n = AppLocalizations.of(context)!;
    final quantity = await _showQuantityDialog(
      title: material.name,
      subtitle: material.description,
      confirmLabel: l10n.materialsShopBuy,
      unitPrice: material.price,
    );
    if (quantity == null || quantity <= 0) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final totalCost = material.price * quantity;
    if ((authProvider.currentPlayer?.money ?? 0) < totalCost) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.materialsShopNeedMoney(_formatMoney(totalCost))),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _busyMaterialId = material.id);
    final result = await _drugService.buyMaterial(material.id, quantity);
    if (!mounted) return;
    setState(() => _busyMaterialId = null);

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ??
              (result['success'] == true
                  ? l10n.materialsShopBuyOk
                  : l10n.materialsShopBuyFailed),
        ),
        backgroundColor:
            result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) {
      await authProvider.refreshPlayer();
      await _loadData();
    }
  }

  Future<void> _transfer(
    MaterialDefinition material, {
    required String direction,
    required int maxQty,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    if (maxQty <= 0) return;
    final quantity = await _showQuantityDialog(
      title: material.name,
      subtitle: direction == 'to_backpack'
          ? l10n.materialsShopTransferToBackpackHint
          : l10n.materialsShopTransferToDepotHint,
      confirmLabel: direction == 'to_backpack'
          ? l10n.materialsShopToBackpack
          : l10n.materialsShopToDepot,
      unitPrice: null,
      initialQty: maxQty > 1 ? 1 : maxQty,
      maxQty: maxQty,
    );
    if (quantity == null || quantity <= 0) return;

    setState(() => _busyMaterialId = material.id);
    final result = await _drugService.transferMaterial(
      materialId: material.id,
      quantity: quantity,
      direction: direction,
    );
    if (!mounted) return;
    setState(() => _busyMaterialId = null);

    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message']?.toString() ??
              (result['success'] == true
                  ? l10n.materialsShopTransferOk
                  : l10n.materialsShopTransferFailed),
        ),
        backgroundColor:
            result['success'] == true ? Colors.green : Colors.orange,
      ),
    );
    if (result['success'] == true) await _loadData();
  }

  Future<int?> _showQuantityDialog({
    required String title,
    required String subtitle,
    required String confirmLabel,
    int? unitPrice,
    int initialQty = 1,
    int? maxQty,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: '$initialQty');
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: ResponsiveDialogContent(
          phoneMaxWidth: 340,
          tabletMaxWidth: 420,
          desktopMaxWidth: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle),
              if (unitPrice != null) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.materialsShopPriceEach(_formatMoney(unitPrice)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              if (maxQty != null) ...[
                const SizedBox(height: 8),
                Text(l10n.materialsShopMaxQty(maxQty)),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.materialsShopQuantity,
                  border: const OutlineInputBorder(),
                ),
              ),
              if (unitPrice != null) ...[
                const SizedBox(height: 8),
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final qty = int.tryParse(value.text) ?? 0;
                    return Text(
                      l10n.materialsShopTotal(_formatMoney(unitPrice * qty)),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              var qty = int.tryParse(controller.text) ?? 0;
              if (maxQty != null && qty > maxQty) qty = maxQty;
              Navigator.pop(context, qty);
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final country = _snapshot.currentCountry.isEmpty
        ? (authProvider.currentPlayer?.currentCountry ?? '—')
        : _snapshot.currentCountry;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.materialsShopTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                '€${_formatMoney(authProvider.currentPlayer?.money ?? 0)}',
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
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: const Color(0xFF151B28),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.materialsShopRulesTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.materialsShopRulesBody,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.materialsShopBackpackSlots(
                              '${_snapshot.backpackUsed}',
                              '${_snapshot.backpackCapacity}',
                            ),
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            l10n.materialsShopCurrentCountry(country),
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_materials.isEmpty)
                    Center(child: Text(l10n.materialsShopEmpty))
                  else
                    ..._materials.map((material) {
                      final depot = _snapshot.depotQty(material.id);
                      final carried = _snapshot.carriedQty(material.id);
                      final busy = _busyMaterialId == material.id;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.grey[200],
                                    child: Image.asset(
                                      material.getImagePath(),
                                      width: 36,
                                      height: 36,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.science),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          material.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(material.description),
                                        Text(
                                          l10n.materialsShopPriceEach(
                                            _formatMoney(material.price),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.materialsShopStockLine(depot, carried),
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed:
                                        busy ? null : () => _buyMaterial(material),
                                    icon: const Icon(Icons.shopping_cart, size: 18),
                                    label: Text(l10n.materialsShopBuy),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: busy || depot <= 0
                                        ? null
                                        : () => _transfer(
                                              material,
                                              direction: 'to_backpack',
                                              maxQty: depot,
                                            ),
                                    icon: const Icon(Icons.backpack, size: 18),
                                    label: Text(l10n.materialsShopToBackpack),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: busy || carried <= 0
                                        ? null
                                        : () => _transfer(
                                              material,
                                              direction: 'to_depot',
                                              maxQty: carried,
                                            ),
                                    icon: const Icon(Icons.warehouse, size: 18),
                                    label: Text(l10n.materialsShopToDepot),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
