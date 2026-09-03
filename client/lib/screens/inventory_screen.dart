import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'inventory_paper_doll_tab.dart';
import 'loadouts_tab.dart';

class InventoryScreen extends StatefulWidget {
  final int? initialPropertyId;

  const InventoryScreen({super.key, this.initialPropertyId});

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
            Tab(icon: const Icon(Icons.person), text: l10n.inventoryPaperDoll),
            Tab(
              icon: const Icon(Icons.dashboard_customize),
              text: l10n.loadouts,
            ),
          ],
        ),
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
