import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/tool_service.dart';
import '../services/inventory_service.dart';
import '../models/crime_tool.dart';
import '../models/player_tool.dart';
import '../models/storage_info.dart';
import '../l10n/app_localizations.dart';
import '../widgets/market_compact.dart';
import '../utils/top_right_notification.dart';
import '../utils/tool_display_name.dart';
String _toolsPurchaseErrorMessage(
  ToolPurchaseResult result,
  AppLocalizations l10n,
) {
  switch (result.errorCode) {
    case 'TOOL_NOT_FOUND':
      return l10n.toolsErrToolNotFound;
    case 'INSUFFICIENT_MONEY':
      return l10n.toolsNotEnoughMoney;
    case 'INVENTORY_FULL':
      return l10n.toolsErrInventoryFullBuy;
    case 'DATABASE_ERROR':
      return l10n.toolsErrPurchaseServer;
    case 'NETWORK':
      return l10n.toolsNetworkError(result.error ?? '');
    default:
      return result.error ?? l10n.toolsBuyError;
  }
}

String _toolsRepairErrorMessage(
  ToolRepairResult result,
  AppLocalizations l10n,
) {
  switch (result.errorCode) {
    case 'TOOL_NOT_FOUND':
      return l10n.toolsErrToolNotFound;
    case 'TOOL_NOT_OWNED':
      return l10n.toolsErrToolNotOwned;
    case 'TOOL_ALREADY_MAX':
      return l10n.toolsErrAlreadyMaxDurability;
    case 'INSUFFICIENT_MONEY':
      return l10n.toolsNotEnoughMoneyRepair;
    case 'DATABASE_ERROR':
      return l10n.toolsErrRepairServer;
    case 'NETWORK':
      return l10n.toolsNetworkError(result.error ?? '');
    default:
      return result.error ?? l10n.toolsRepairError;
  }
}

class ToolsScreen extends StatefulWidget {
  final bool embedded;

  const ToolsScreen({super.key, this.embedded = false});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final ToolService _toolService = ToolService();
  final InventoryService _inventoryService = InventoryService();

  List<CrimeTool> _availableTools = [];
  List<PlayerTool> _myTools = [];
  bool _isLoading = false;
  String? _error;
  int _inventoryUsed = 0;
  int _inventoryMax = 0;
  bool _inventoryFull = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tools = await _toolService.getAllTools();
      final inventory = await _toolService.getInventory();

      // Load inventory capacity
      final carriedResult = await _inventoryService.getCarriedTools();

      setState(() {
        _availableTools = tools;
        _myTools = inventory;
        if (carriedResult['success']) {
          final slots = carriedResult['slots'] as InventorySlots?;
          _inventoryUsed = slots?.used ?? 0;
          _inventoryMax = slots?.max ?? 5;
          _inventoryFull = _inventoryUsed >= _inventoryMax;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.toolsLoadError(e.toString());
        _isLoading = false;
      });
    }
  }

  Future<void> _buyTool(CrimeTool tool) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final toolLabel = localizedToolName(l10n, tool.id, tool.name);

    // Check if inventory is full
    if (_inventoryFull) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('🎒 ${l10n.inventoryFull}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: l10n.inventory,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed('/inventory');
              },
            ),
          ),
        );
      }
      return;
    }

    // Check if player has enough money
    final playerMoney = authProvider.currentPlayer?.money ?? 0;
    if (playerMoney < tool.basePrice) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(l10n.toolsNotEnoughMoney)),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    final result = await _toolService.buyTool(tool.id);

    if (result.success) {
      // Update player money
      await authProvider.refreshPlayer();

      // Reload tool inventory
      await _loadData();

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.toolsPurchased(toolLabel)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(_toolsPurchaseErrorMessage(result, l10n)),
          ),
        );
      }
    }
  }

  Future<void> _repairTool(PlayerTool tool) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final toolLabel = localizedToolName(l10n, tool.toolId, tool.name);

    // Repair cost is 50% of base price
    final repairCost = ((tool.basePrice ?? 0) * 0.5).floor();
    final playerMoney = authProvider.currentPlayer?.money ?? 0;

    if (playerMoney < repairCost) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.toolsNotEnoughMoneyRepair),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    final result = await _toolService.repairTool(tool.toolId);

    if (result.success) {
      // Update player money
      await authProvider.refreshPlayer();

      // Reload tool inventory
      await _loadData();

      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(l10n.toolsRepaired(toolLabel, result.cost.toString())),
          ),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(_toolsRepairErrorMessage(result, l10n)),
          ),
        );
      }
    }
  }

  Widget _toolThumb(String toolId) {
    return marketThumbBox(
      child: Image.asset(
        'assets/images/tools/${toolId}_tool.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.build, size: 22),
      ),
    );
  }

  Widget _toolsBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    final playerMoney = authProvider.currentPlayer?.money ?? 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: marketListPadding,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (_inventoryUsed > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MarketInfoPill(
                label: '${l10n.inventory}: $_inventoryUsed/$_inventoryMax',
                color: _inventoryFull ? Colors.orange : Colors.teal.shade700,
                icon: Icons.backpack,
              ),
            ),
          if (_availableTools.isEmpty)
            Center(child: Text(l10n.toolsNoToolsAvailable))
          else
            for (final tool in _availableTools)
              _buildShopToolRow(tool, playerMoney >= tool.basePrice, l10n),
          marketSectionHeader(context, label: l10n.toolsTabMyTools),
          if (_myTools.isEmpty)
            marketEmptyHint(l10n.toolsEmptyInventoryHint)
          else
            for (final tool in _myTools)
              _buildOwnedToolRow(
                tool,
                playerMoney >= ((tool.basePrice ?? 0) * 0.5).floor(),
                l10n,
              ),
        ],
      ),
    );
  }

  Widget _buildShopToolRow(CrimeTool tool, bool canAfford, AppLocalizations l10n) {
    final name = localizedToolName(l10n, tool.id, tool.name);
    return MarketCompactRow(
      tooltip: tool.requiredFor.isEmpty ? null : tool.requiredFor.join(', '),
      leading: _toolThumb(tool.id),
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
              for (final crime in tool.requiredFor.take(3))
                MarketInfoPill(label: crime, color: Colors.blueGrey.shade700),
            ],
          ),
        ],
      ),
      meta: Text(
        '€${tool.basePrice}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      action: FilledButton(
        onPressed: canAfford && !_inventoryFull ? () => _buyTool(tool) : null,
        style: marketBuyButtonStyle(),
        child: Text(l10n.buy),
      ),
    );
  }

  Widget _buildOwnedToolRow(
    PlayerTool tool,
    bool canAffordRepair,
    AppLocalizations l10n,
  ) {
    final name = localizedToolName(l10n, tool.toolId, tool.name);
    final pct = tool.durabilityPercent.round();
    final repairCost = ((tool.basePrice ?? 0) * 0.5).floor();
    final needsRepair = tool.needsRepair == true || tool.isBroken == true;
    return MarketCompactRow(
      leading: _toolThumb(tool.toolId),
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
                label: '${l10n.condition} $pct%',
                color: pct < 30
                    ? Colors.red.shade700
                    : pct < 70
                    ? Colors.orange.shade800
                    : Colors.teal.shade700,
                icon: Icons.health_and_safety,
              ),
            ],
          ),
        ],
      ),
      meta: needsRepair
          ? Text(
              '€$repairCost',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            )
          : null,
      action: needsRepair
          ? FilledButton(
              onPressed: canAffordRepair ? () => _repairTool(tool) : null,
              style: marketBuyButtonStyle(background: Colors.orange),
              child: Text(l10n.toolsBadgeRepair),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = _toolsBody(l10n);
    if (widget.embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.toolsScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _loadData,
          ),
        ],
      ),
      body: body,
    );
  }
}
