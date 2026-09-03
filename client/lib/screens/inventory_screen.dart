import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'inventory_paper_doll_tab.dart';
import 'loadouts_tab.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final tabs = TabBar(
      controller: _tabController,
      indicatorColor: Colors.amber,
      labelColor: const Color(0xFFD4AF37),
      unselectedLabelColor: Colors.white70,
      tabs: [
        Tab(icon: const Icon(Icons.person), text: l10n.inventoryPaperDoll),
        Tab(
          icon: const Icon(Icons.dashboard_customize),
          text: l10n.loadouts,
        ),
      ],
    );
    final body = TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        InventoryPaperDollTab(initialPropertyId: widget.initialPropertyId),
        LoadoutsTab(playerId: authProvider.currentPlayer?.id ?? 0),
      ],
    );

    if (widget.embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(color: const Color(0xFF1A1A1A), child: tabs),
          Expanded(child: body),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventory),
        backgroundColor: Colors.grey[900],
        bottom: tabs,
      ),
      body: body,
    );
  }
}
