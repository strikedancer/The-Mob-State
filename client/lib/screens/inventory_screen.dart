import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'inventory_paper_doll_tab.dart';
import 'loadouts_tab.dart';
import '../widgets/game_page_info.dart';
import '../widgets/empire_page_hero.dart';

class InventoryScreen extends StatefulWidget {
  final int? initialPropertyId;
  final bool embedded;

  const InventoryScreen({
    super.key,
    this.initialPropertyId,
    this.embedded = false,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GamePageInfoHost(
      topicId: 'inventory',
      showOverlay: false,
      child: _buildPageInfoChild(context),
    );
  }

  Widget _buildPageInfoChild(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    return EmpireHubScaffold(
      embedded: widget.embedded,
      title: l10n.inventory,
      imageAsset: 'assets/images/ui/materials_inventory.png',
      topicId: 'inventory',
      fallbackIcon: Icons.backpack,
      tabBar: empireGoldTabBar(
        controller: _tabController,
        tabs: [
          Tab(text: l10n.inventoryPaperDoll),
          Tab(text: l10n.loadouts),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          InventoryPaperDollTab(initialPropertyId: widget.initialPropertyId),
          LoadoutsTab(playerId: authProvider.currentPlayer?.id ?? 0),
        ],
      ),
    );
  }
}
