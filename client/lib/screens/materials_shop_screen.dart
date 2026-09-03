import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../providers/auth_provider.dart';
import '../services/drug_service.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/market_compact.dart';
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

  Widget _materialThumb(String assetPath) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2A),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: WebAssetHelper.image(
        assetPath,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.science,
          size: 22,
        ),
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

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              children: [
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                      childrenPadding:
                          const EdgeInsets.fromLTRB(12, 0, 12, 10),
                      title: Text(
                        l10n.materialsShopRulesTitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.materialsShopBackpackSlots(
                          '${_snapshot.backpackUsed}',
                          '${_snapshot.backpackCapacity}',
                        ),
                        style: const TextStyle(fontSize: 11),
                      ),
                      children: [
                        Text(
                          l10n.materialsShopRulesBody,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.materialsShopCurrentCountry(country),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_materials.isEmpty)
                  Center(child: Text(l10n.materialsShopEmpty))
                else
                  ..._materials.map((material) {
                    final depot = _snapshot.depotQty(material.id);
                    final carried = _snapshot.carriedQty(material.id);
                    final busy = _busyMaterialId == material.id;
                    return MarketCompactRow(
                      tooltip: material.description,
                      leading: _materialThumb(material.getImagePath()),
                      info: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material.name,
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
                                label: l10n.materialsShopStockLine(
                                  depot,
                                  carried,
                                ),
                                color: Colors.blue.shade700,
                                icon: Icons.inventory_2,
                              ),
                            ],
                          ),
                        ],
                      ),
                      meta: Text(
                        '€${_formatMoney(material.price)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      action: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.end,
                        children: [
                          FilledButton(
                            onPressed:
                                busy ? null : () => _buyMaterial(material),
                            style: marketBuyButtonStyle(),
                            child: Text(l10n.materialsShopBuy),
                          ),
                          OutlinedButton(
                            onPressed: busy || depot <= 0
                                ? null
                                : () => _transfer(
                                      material,
                                      direction: 'to_backpack',
                                      maxQty: depot,
                                    ),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              minimumSize: const Size(0, 34),
                            ),
                            child: Text(l10n.materialsShopToBackpack),
                          ),
                          OutlinedButton(
                            onPressed: busy || carried <= 0
                                ? null
                                : () => _transfer(
                                      material,
                                      direction: 'to_depot',
                                      maxQty: carried,
                                    ),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              minimumSize: const Size(0, 34),
                            ),
                            child: Text(l10n.materialsShopToDepot),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
  }
}
