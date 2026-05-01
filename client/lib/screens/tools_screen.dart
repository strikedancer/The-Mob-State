import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/tool_service.dart';
import '../services/inventory_service.dart';
import '../models/crime_tool.dart';
import '../models/player_tool.dart';
import '../models/storage_info.dart';
import '../l10n/app_localizations.dart';
import '../widgets/shop_tool_card.dart';
import '../widgets/inventory_tool_card.dart';
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
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.toolsScreenTitle),
            if (_inventoryUsed > 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.backpack,
                    color: _inventoryFull ? Colors.orange : Colors.grey[400],
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.inventory}: $_inventoryUsed/$_inventoryMax',
                    style: TextStyle(
                      fontSize: 12,
                      color: _inventoryFull ? Colors.orange : Colors.grey[400],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.shopping_cart), text: l10n.toolsTabBuy),
            Tab(icon: const Icon(Icons.inventory), text: l10n.toolsTabMyTools),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _loadData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildShopTab(), _buildInventoryTab()],
      ),
    );
  }

  Widget _buildShopTab() {
    final l10n = AppLocalizations.of(context)!;

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
            ElevatedButton(
              onPressed: _loadData,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_availableTools.isEmpty) {
      return Center(child: Text(l10n.toolsNoToolsAvailable));
    }

    final authProvider = Provider.of<AuthProvider>(context);
    final playerMoney = authProvider.currentPlayer?.money ?? 0;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 480
            ? 2
            : MediaQuery.of(context).size.width < 900
            ? 3
            : 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: _availableTools.length,
      itemBuilder: (context, index) {
        final tool = _availableTools[index];
        final canAfford = playerMoney >= tool.basePrice;

        return ShopToolCard(
          tool: tool,
          canAfford: canAfford,
          inventoryFull: _inventoryFull,
          onBuy: () => _buyTool(tool),
        );
      },
    );
  }

  Widget _buildInventoryTab() {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_myTools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.build, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.toolsEmptyInventoryTitle),
            const SizedBox(height: 8),
            Text(
              l10n.toolsEmptyInventoryHint,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    final playerMoney = authProvider.currentPlayer?.money ?? 0;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 480
            ? 2
            : MediaQuery.of(context).size.width < 900
            ? 3
            : 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: _myTools.length,
      itemBuilder: (context, index) {
        final tool = _myTools[index];
        final repairCost = ((tool.basePrice ?? 0) * 0.5).floor();
        final canAffordRepair = playerMoney >= repairCost;

        return InventoryToolCard(
          tool: tool,
          canAffordRepair: canAffordRepair,
          onRepair: () => _repairTool(tool),
        );
      },
    );
  }
}
