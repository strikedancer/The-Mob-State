import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class CasinoManagementScreen extends StatefulWidget {
  final String countryId;
  final Map<String, dynamic> initialStats;

  /// When true (opened from casino hub dialog), uses an inline header + close instead of a full [Scaffold] route.
  final bool embeddedInDialog;

  const CasinoManagementScreen({
    super.key,
    required this.countryId,
    required this.initialStats,
    this.embeddedInDialog = false,
  });

  @override
  State<CasinoManagementScreen> createState() => _CasinoManagementScreenState();
}

class _CasinoManagementScreenState extends State<CasinoManagementScreen> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _catalog = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stats = widget.initialStats;
    // Auto-refresh stats on init to ensure latest data
    Future.delayed(Duration.zero, () {
      _refreshStats();
      _loadCatalog();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Full-route only: avoid double-fetch when shown inside a dialog (initState already refreshes).
    if (!widget.embeddedInDialog) {
      _refreshStats();
    }
  }

  Future<void> _refreshStats() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/casino/stats/${widget.countryId}');
      final data = jsonDecode(response.body);
      
      if (data['event'] == 'casino.stats' && data['params'] != null) {
        setState(() {
          _stats = data['params'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[CasinoManagement] Error loading stats: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCatalog() async {
    try {
      final response = await _apiClient.get('/casino/staff/catalog');
      final data = jsonDecode(response.body);
      if (data['event'] == 'casino.staff.catalog' && data['params']?['catalog'] is List) {
        setState(() {
          _catalog = (data['params']['catalog'] as List)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
      }
    } catch (e) {
      print('[CasinoManagement] Catalog error: $e');
    }
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _floorLabel(AppLocalizations l10n, int floorLevel) {
    switch (floorLevel) {
      case 2:
        return l10n.casinoFloorVip;
      case 3:
        return l10n.casinoFloorPrivate;
      default:
        return l10n.casinoFloorPublic;
    }
  }

  String _roleLabel(AppLocalizations l10n, String role) {
    switch (role) {
      case 'dealer':
        return l10n.casinoStaffDealer;
      case 'security':
        return l10n.casinoStaffSecurity;
      case 'promoter':
        return l10n.casinoStaffPromoter;
      default:
        return role;
    }
  }

  String _staffName(Map<String, dynamic> item) {
    final isNl = Localizations.localeOf(context).languageCode == 'nl';
    final name = isNl ? item['nameNl'] : item['nameEn'];
    return (name ?? item['staffKey'] ?? '').toString();
  }

  Future<void> _upgradeFloor() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      setState(() => _isLoading = true);
      final response = await _apiClient.post(
        '/casino/upgrade-floor/${widget.countryId}',
        {},
      );
      final data = jsonDecode(response.body);
      if (data['event'] == 'casino.floor.upgraded') {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.refreshPlayer();
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.casinoUpgradeSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _refreshStats();
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(data['params']?['reason'] ?? l10n.casinoUpgradeFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.casinoUpgradeFailed), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _hireStaff(int catalogId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      setState(() => _isLoading = true);
      final response = await _apiClient.post(
        '/casino/staff/hire/${widget.countryId}',
        {'catalogId': catalogId},
      );
      final data = jsonDecode(response.body);
      if (data['event'] == 'casino.staff.hired') {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.casinoStaffHireSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _refreshStats();
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(data['params']?['reason'] ?? l10n.casinoStaffHireFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.casinoStaffHireFailed), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fireStaff(String role) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      setState(() => _isLoading = true);
      final response = await _apiClient.post(
        '/casino/staff/fire/${widget.countryId}',
        {'role': role},
      );
      final data = jsonDecode(response.body);
      if (data['event'] == 'casino.staff.fired') {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.casinoStaffFireSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _refreshStats();
      } else {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(data['params']?['reason'] ?? l10n.casinoStaffFireFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.casinoStaffFireFailed), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showDepositDialog() async {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    
    final amount = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.casinoDepositTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixText: '€',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            child: Text(l10n.deposit),
          ),
        ],
      ),
    );

    if (amount == null || amount <= 0) return;

    try {
      setState(() => _isLoading = true);
      
      final response = await _apiClient.post('/casino/deposit/${widget.countryId}', {
        'amount': amount,
      });
      final data = jsonDecode(response.body);
      
      if (data['event'] == 'casino.deposited') {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.refreshPlayer();
        
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n.casinoDepositSuccess(amount.toString())),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _refreshStats();
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(data['params']['reason'] ?? l10n.casinoDepositError),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('[CasinoManagement] Deposit error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(l10n.casinoDepositError), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showWithdrawDialog() async {
    final controller = TextEditingController();
    final maxWithdraw = (_stats?['bankroll'] ?? 0) - 10000;
    final l10n = AppLocalizations.of(context)!;
    
    if (maxWithdraw <= 0) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.casinoMinBankroll),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final amount = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.casinoWithdrawTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.casinoMaxWithdraw(maxWithdraw.toStringAsFixed(0))),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.amount,
                prefixText: '€',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(l10n.withdraw),
          ),
        ],
      ),
    );

    if (amount == null || amount <= 0) return;

    try {
      setState(() => _isLoading = true);
      
      final response = await _apiClient.post('/casino/withdraw/${widget.countryId}', {
        'amount': amount,
      });
      final data = jsonDecode(response.body);
      
      if (data['event'] == 'casino.withdrawn') {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.refreshPlayer();
        
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n.casinoWithdrawSuccess(amount.toString())),
              backgroundColor: Colors.green,
            ),
          );
        }
        await _refreshStats();
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(data['params']['reason'] ?? l10n.casinoWithdrawError),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('[CasinoManagement] Withdraw error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text(l10n.casinoWithdrawError), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Widget _buildManagementBody(AppLocalizations l10n) {
    final bankroll = _stats?['bankroll'] ?? 0;
    final totalReceived = _stats?['totalReceived'] ?? 0;
    final totalPaidOut = _stats?['totalPaidOut'] ?? 0;
    final netProfit = _stats?['netProfit'] ?? 0;
    final profitMargin = _stats?['profitMargin'] ?? '0.00';
    final isBankrupt = _stats?['isBankrupt'] ?? false;
    final floorLevel = _asInt(_stats?['floorLevel']);
    final maxBet = _asInt(_stats?['maxBet']);
    final rakeBps = _asInt(_stats?['rakeBps']);
    final totalRake = _asInt(_stats?['totalRake']);
    final nextFloorCost = _stats?['nextFloorCost'];
    final raidDrainPct = _stats?['raidDrainPct']?.toString() ?? '18';
    final raidDefensePct = _stats?['raidDefensePct']?.toString() ?? '0';
    final lastRaidAt = _stats?['lastRaidAt']?.toString();
    final hiredStaff = (_stats?['staff'] as List?)
            ?.whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList() ??
        <Map<String, dynamic>>[];
    final hiredByRole = {
      for (final item in hiredStaff) item['role']?.toString() ?? '': item,
    };

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  if (isBankrupt)
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/casino/bankrupt.png',
                            width: 32,
                            height: 32,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.casinoBankruptWarning((10000 - bankroll).toStringAsFixed(0)),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Bankroll Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            l10n.casinoBankroll,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '€${bankroll.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: bankroll < 10000 ? Colors.red : Colors.green,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _showDepositDialog,
                                  icon: Icon(Icons.add),
                                  label: Text(l10n.deposit),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: bankroll > 10000 ? _showWithdrawDialog : null,
                                  icon: Icon(Icons.remove),
                                  label: Text(l10n.withdraw),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Statistics
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.casinoStatsTitle,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          _buildStatRow(l10n.casinoTotalReceived, totalReceived, Colors.blue),
                          _buildStatRow(l10n.casinoTotalPaidOut, totalPaidOut, Colors.orange),
                          _buildStatRow(l10n.casinoTotalRake, totalRake, Colors.purple),
                          Divider(),
                          _buildStatRow(
                            l10n.casinoNetProfit,
                            netProfit,
                            netProfit >= 0 ? Colors.green : Colors.red,
                            isLarge: true,
                          ),
                          SizedBox(height: 8),
                          Text(
                            l10n.casinoProfitMargin(profitMargin),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.casinoUpgradeFloor,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.casinoHouseRulesLine(
                              _floorLabel(l10n, floorLevel),
                              maxBet.toString(),
                              (rakeBps / 100).toStringAsFixed(1),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(l10n.casinoRaidDrain(raidDrainPct)),
                          Text(l10n.casinoRaidDefense(raidDefensePct)),
                          if (lastRaidAt != null && lastRaidAt.isNotEmpty)
                            Text(l10n.casinoLastRaid(lastRaidAt)),
                          if (nextFloorCost != null) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _upgradeFloor,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[800],
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  l10n.casinoUpgradeFloorTo(
                                    _floorLabel(l10n, floorLevel + 1),
                                    _asInt(nextFloorCost).toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.casinoStaffTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...['dealer', 'security', 'promoter'].map((role) {
                            final hired = hiredByRole[role];
                            final options = _catalog
                                .where((item) => item['role']?.toString() == role)
                                .toList();
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _roleLabel(l10n, role),
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 6),
                                    if (hired != null) ...[
                                      Text(_staffName(hired)),
                                      Text(
                                        l10n.casinoStaffSalaryPerTick(
                                          _asInt(hired['salaryPerTick']).toString(),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: _isLoading ? null : () => _fireStaff(role),
                                          child: Text(l10n.casinoStaffFire),
                                        ),
                                      ),
                                    ] else if (options.isEmpty)
                                      Text(l10n.casinoNoStaffHired)
                                    else
                                      ...options.map((option) {
                                        return ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(_staffName(option)),
                                          subtitle: Text(
                                            l10n.casinoStaffSalaryPerTick(
                                              _asInt(option['salaryPerTick']).toString(),
                                            ),
                                          ),
                                          trailing: ElevatedButton(
                                            onPressed: _isLoading
                                                ? null
                                                : () => _hireStaff(_asInt(option['id'])),
                                            child: Text(l10n.casinoStaffHire),
                                          ),
                                        );
                                      }),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Info Card
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue[700]),
                              SizedBox(width: 8),
                              Text(
                                l10n.casinoManagementInfoTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            l10n.casinoInfo1,
                            style: TextStyle(color: Colors.blue[900], fontSize: 14),
                          ),
                          Text(
                            l10n.casinoInfo2,
                            style: TextStyle(color: Colors.blue[900], fontSize: 14),
                          ),
                          Text(
                            l10n.casinoInfo4,
                            style: TextStyle(color: Colors.blue[900], fontSize: 14),
                          ),
                          Text(
                            l10n.casinoInfo5,
                            style: TextStyle(color: Colors.blue[900], fontSize: 14),
                          ),
                          Text(
                            l10n.casinoManagementInfo5,
                            style: TextStyle(color: Colors.blue[900], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.embeddedInDialog) {
      return Material(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Colors.purple[900],
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          l10n.casinoManagementTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        tooltip: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
                        onPressed: _isLoading ? null : _refreshStats,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _buildManagementBody(l10n)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.casinoManagementTitle),
        backgroundColor: Colors.purple[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStats,
          ),
        ],
      ),
      body: _buildManagementBody(l10n),
    );
  }

  Widget _buildStatRow(String label, int value, Color color, {bool isLarge = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isLarge ? 18 : 16,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '€${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: TextStyle(
              fontSize: isLarge ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
