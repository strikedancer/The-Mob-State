import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drug_models.dart';
import '../providers/auth_provider.dart';
import '../services/drug_service.dart';
import 'drug_facility_screen.dart';
import 'drug_inventory_screen.dart';
import 'drug_production_screen.dart';

class DrugEnvironmentScreen extends StatefulWidget {
  const DrugEnvironmentScreen({super.key});

  @override
  State<DrugEnvironmentScreen> createState() => _DrugEnvironmentScreenState();
}

class _DrugEnvironmentScreenState extends State<DrugEnvironmentScreen> {
  final DrugService _drugService = DrugService();
  _DrugWebSubview _webSubview = _DrugWebSubview.hub;
  bool _isLoadingStats = true;
  List<DrugProduction> _activeProductions = const [];
  List<DrugFacilityInfo> _facilities = const [];
  List<DrugInventory> _inventory = const [];
  List<DrugDefinition> _drugCatalog = const [];
  DrugHeatInfo? _heatInfo;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  String _backgroundAsset(double width) {
    if (width < 700) {
      return 'assets/images/backgrounds/drug_environment_mobile.png';
    }
    if (width < 1100) {
      return 'assets/images/backgrounds/drug_environment_tablet.png';
    }
    return 'assets/images/backgrounds/drug_environment_desktop.png';
  }

  void _openScreen(BuildContext context, Widget screen, _DrugWebSubview webSubview) {
    if (kIsWeb) {
      setState(() => _webSubview = webSubview);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) {
      if (mounted) {
        _loadDashboardStats();
      }
    });
  }

  Future<void> _loadDashboardStats() async {
    setState(() => _isLoadingStats = true);
    try {
      final results = await Future.wait([
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugInventory(),
        _drugService.getDrugCatalog(),
      ]);
      DrugHeatInfo? heatInfo;
      try {
        heatInfo = await _drugService.getDrugHeat();
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _activeProductions = results[0] as List<DrugProduction>;
        _facilities = results[1] as List<DrugFacilityInfo>;
        _inventory = results[2] as List<DrugInventory>;
        _drugCatalog = results[3] as List<DrugDefinition>;
        _heatInfo = heatInfo;
        _isLoadingStats = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingStats = false);
    }
  }

  int _inventoryValueForCountry(String country) {
    final catalogById = {for (final drug in _drugCatalog) drug.id: drug};
    var total = 0;
    for (final row in _inventory) {
      final drug = catalogById[row.drugType];
      if (drug == null) continue;
      final base = drug.getPriceForCountry(country);
      total += (base * row.qualityMultiplier).round() * row.quantity;
    }
    return total;
  }

  int _totalSlots() {
    return _facilities.fold(0, (sum, item) => sum + item.slots);
  }

  int _usedSlots() {
    return _facilities.fold(0, (sum, item) => sum + item.activeProductions);
  }

  int _totalInventoryGrams() {
    return _inventory.fold(0, (sum, item) => sum + item.quantity);
  }

  double _efficiencyScore() {
    if (_facilities.isEmpty) return 0;
    final totalSlots = _totalSlots();
    final usedSlots = _usedSlots();
    final slotUsage = totalSlots > 0 ? usedSlots / totalSlots : 0.0;
    int totalUpgrades = 0;
    int upgradeCount = 0;
    for (final f in _facilities) {
      for (final level in f.upgrades.values) {
        totalUpgrades += level;
        upgradeCount++;
      }
    }
    final avgUpgrade = upgradeCount > 0 ? totalUpgrades / upgradeCount : 0.0;
    final upgradeRatio = (avgUpgrade / 5.0).clamp(0.0, 1.0);
    return ((slotUsage * 0.6) + (upgradeRatio * 0.4)) * 100;
  }

  Map<String, int> _qualityGramsByGrade() {
    final result = <String, int>{};
    for (final item in _inventory) {
      result[item.quality] = (result[item.quality] ?? 0) + item.quantity;
    }
    return result;
  }

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  String _webSubviewTitle(_DrugWebSubview section) {
    switch (section) {
      case _DrugWebSubview.hub:
        return _tr('Drugs Omgeving', 'Drug Environment');
      case _DrugWebSubview.production:
        return _tr('Drug Productie', 'Drug Production');
      case _DrugWebSubview.facilities:
        return _tr('Drug Faciliteiten', 'Drug Facilities');
      case _DrugWebSubview.inventory:
        return _tr('Drug Voorraad', 'Drug Inventory');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && _webSubview != _DrugWebSubview.hub) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() => _webSubview = _DrugWebSubview.hub);
              _loadDashboardStats();
            },
          ),
          title: Text(_webSubviewTitle(_webSubview)),
        ),
        body: switch (_webSubview) {
          _DrugWebSubview.production => const DrugProductionScreen(),
          _DrugWebSubview.facilities => const DrugFacilityScreen(),
          _DrugWebSubview.inventory => const DrugInventoryScreen(),
          _DrugWebSubview.hub => const SizedBox.shrink(),
        },
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;
        final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
        final backgroundAsset = _backgroundAsset(width);
        final headerPadding = isMobile ? 18.0 : (isTablet ? 22.0 : 28.0);
        final titleSize = isMobile ? 28.0 : (isTablet ? 34.0 : 40.0);
        final horizontalPadding = isMobile ? 12.0 : (isTablet ? 20.0 : 28.0);
        final heroMaxWidth = isMobile ? width : 1080.0;
        final currentCountry = authProvider.currentPlayer?.currentCountry ?? 'netherlands';
        final inventoryValue = _inventoryValueForCountry(currentCountry);
        final usedSlots = _usedSlots();
        final totalSlots = _totalSlots();
        final inventoryGrams = _totalInventoryGrams();

        return Scaffold(
          appBar: AppBar(
            title: Text(_tr('Drugs Omgeving', 'Drug Environment')),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  backgroundAsset,
                  fit: BoxFit.cover,
                  alignment: isMobile
                      ? Alignment.topCenter
                      : (isTablet ? Alignment.center : Alignment.centerRight),
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/backgrounds/crime_background.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.28),
                        Colors.black.withOpacity(0.58),
                        Colors.black.withOpacity(0.82),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: -60,
                right: -40,
                child: _AmbientOrb(size: 220, color: Color(0x6635C46A)),
              ),
              const Positioned(
                bottom: 40,
                left: -30,
                child: _AmbientOrb(size: 180, color: Color(0x4448B8FF)),
              ),
              const Positioned(
                top: 180,
                left: 40,
                child: _AmbientOrb(size: 100, color: Color(0x33F2B94B)),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 22 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxWidth: heroMaxWidth),
                          padding: EdgeInsets.all(headerPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0.54),
                                const Color(0xFF121212).withOpacity(0.72),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x55000000),
                                blurRadius: 28,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _TopTag(label: _tr('Ondergrondse Operaties', 'Underground Operations'), color: const Color(0xFF35C46A)),
                                  _TopTag(label: _tr('Mobiel Geoptimaliseerd', 'Mobile Optimized'), color: const Color(0xFF48B8FF)),
                                  _TopTag(label: _tr('Kwaliteit Gedreven', 'Quality Driven'), color: const Color(0xFFF2B94B)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _tr('Drugs Imperium', 'Drug Empire'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleSize,
                                  height: 0.95,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.8,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 760),
                                child: Text(
                                  _tr(
                                    'Beheer hier productie, faciliteiten en voorraad. Materialen koop je via de Zwarte Markt, de rest draait vanuit je eigen drugsomgeving.',
                                    'Manage production, facilities and inventory here. Buy materials on the Black Market while the rest runs in your own drug environment.',
                                  ),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.78),
                                    fontSize: isMobile ? 13 : 15,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _StatPill(
                                    label: _tr('Materiaalstroom', 'Material flow'),
                                    value: _tr('Zwarte Markt', 'Black Market'),
                                    icon: Icons.science,
                                    color: const Color(0xFF48B8FF),
                                  ),
                                  _StatPill(
                                    label: _tr('Productieketen', 'Production chain'),
                                    value: _tr('Kas + Lab + Kitchen + Darkweb', 'Greenhouse + Lab + Kitchen + Darkweb'),
                                    icon: Icons.factory_outlined,
                                    color: const Color(0xFF35C46A),
                                  ),
                                  _StatPill(
                                    label: _tr('Verkoopmodel', 'Sales model'),
                                    value: _tr('Per kwaliteit', 'Per quality'),
                                    icon: Icons.workspace_premium_outlined,
                                    color: const Color(0xFFF2B94B),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              if (_isLoadingStats)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: LinearProgressIndicator(minHeight: 3),
                                )
                              else
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    _DashboardMetricCard(
                                      label: _tr('Actieve batches', 'Active batches'),
                                      value: '${_activeProductions.length}',
                                      icon: Icons.timelapse,
                                      color: const Color(0xFF35C46A),
                                    ),
                                    _DashboardMetricCard(
                                      label: _tr('Slotgebruik', 'Slot usage'),
                                      value: totalSlots > 0 ? '$usedSlots/$totalSlots' : '0/0',
                                      icon: Icons.grid_view_rounded,
                                      color: const Color(0xFF48B8FF),
                                    ),
                                    _DashboardMetricCard(
                                      label: _tr('Voorraadwaarde', 'Inventory value'),
                                      value: '€${_formatCompactMoney(inventoryValue)}',
                                      icon: Icons.euro,
                                      color: const Color(0xFFF2B94B),
                                    ),
                                    _DashboardMetricCard(
                                      label: _tr('Voorraad gram', 'Inventory grams'),
                                      value: '$inventoryGrams g',
                                      icon: Icons.inventory_2,
                                      color: const Color(0xFFC16CFF),
                                    ),
                                    _DashboardMetricCard(
                                      label: _tr('Efficiëntie', 'Efficiency'),
                                      value: '${_efficiencyScore().round()}%',
                                      icon: Icons.auto_graph,
                                      color: const Color(0xFFFF6B6B),
                                    ),
                                    if (_heatInfo != null)
                                      _DashboardMetricCard(
                                        label: _tr('Politie Hitte', 'Police Heat'),
                                        value: '${_heatInfo!.heat} – ${_heatInfo!.level}',
                                        icon: Icons.local_fire_department,
                                        color: _heatInfo!.color,
                                      ),
                                  ],
                                ),
                              if (!_isLoadingStats && _inventory.isNotEmpty) ...[  
                                const SizedBox(height: 14),
                                _QualityDistributionSection(
                                  inventory: _inventory,
                                  gramsByGrade: _qualityGramsByGrade(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SectionLabel(
                        title: _tr('Operaties', 'Operations'),
                        subtitle: _tr('Kies een tak van je drugsimperium', 'Choose a branch of your drug empire'),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isMobile ? 2.2 : (isTablet ? 1.45 : 1.18),
                        children: [
                          _DrugEntryCard(
                            icon: Icons.precision_manufacturing,
                            eyebrow: _tr('Pijplijn', 'Pipeline'),
                            title: _tr('Productie', 'Production'),
                            subtitle: _tr('Start batches, volg timers en verzamel output met kwaliteitsrollen.', 'Start batches, track timers and collect output with quality rolls.'),
                            color: const Color(0xFF35C46A),
                            duration: const Duration(milliseconds: 520),
                            onTap: () => _openScreen(
                              context,
                              const DrugProductionScreen(),
                              _DrugWebSubview.production,
                            ),
                          ),
                          _DrugEntryCard(
                            icon: Icons.factory_outlined,
                            eyebrow: _tr('Infrastructuur', 'Infrastructure'),
                            title: _tr('Faciliteiten', 'Facilities'),
                            subtitle: _tr('Koop en upgrade kas, drugslab, crack kitchen en darkweb storefront voor meer slots, snelheid en kwaliteit.', 'Buy and upgrade greenhouse, drug lab, crack kitchen and darkweb storefront for more slots, speed and quality.'),
                            color: const Color(0xFF48B8FF),
                            duration: const Duration(milliseconds: 680),
                            onTap: () => _openScreen(
                              context,
                              const DrugFacilityScreen(),
                              _DrugWebSubview.facilities,
                            ),
                          ),
                          _DrugEntryCard(
                            icon: Icons.inventory_2,
                            eyebrow: _tr('Distributie', 'Distribution'),
                            title: _tr('Voorraad', 'Inventory'),
                            subtitle: _tr('Bekijk stacks per kwaliteit en verkoop op maximale marktwaarde.', 'View stacks by quality and sell at the best market value.'),
                            color: const Color(0xFFF2B94B),
                            duration: const Duration(milliseconds: 840),
                            onTap: () => _openScreen(
                              context,
                              const DrugInventoryScreen(),
                              _DrugWebSubview.inventory,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCompactMoney(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return '$value';
  }
}

enum _DrugWebSubview {
  hub,
  production,
  facilities,
  inventory,
}

class _TopTag extends StatelessWidget {
  final String label;
  final Color color;

  const _TopTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.42)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.16),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionLabel({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.68), fontSize: 13),
        ),
      ],
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _AmbientOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrugEntryCard extends StatelessWidget {
  final IconData icon;
  final String eyebrow;
  final String title;
  final String subtitle;
  final Color color;
  final Duration duration;
  final VoidCallback onTap;

  const _DrugEntryCard({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 26 * (1 - value)),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.52),
                color.withOpacity(0.12),
              ],
            ),
            border: Border.all(color: color.withOpacity(0.45), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: color.withOpacity(0.14),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward, color: color, size: 18),
                  ],
                ),
                const Spacer(),
                Text(
                  eyebrow,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.16),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.66),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Quality grades ordered best → worst
const _kQualityOrder = ['S', 'A', 'B', 'C', 'D'];
final _kQualityColors = <String, Color>{
  'S': const Color(0xFFFFD700),
  'A': const Color(0xFF35C46A),
  'B': const Color(0xFF48B8FF),
  'C': const Color(0xFF888888),
  'D': const Color(0xFFFF6B6B),
};
final _kQualityLabels = <String, ({String nl, String en})>{
  'S': (nl: 'Superieur', en: 'Superior'),
  'A': (nl: 'Hoog', en: 'High'),
  'B': (nl: 'Normaal+', en: 'Standard+'),
  'C': (nl: 'Normaal', en: 'Standard'),
  'D': (nl: 'Laag', en: 'Low'),
};

class _QualityDistributionSection extends StatelessWidget {
  final List<DrugInventory> inventory;
  final Map<String, int> gramsByGrade;

  const _QualityDistributionSection({
    required this.inventory,
    required this.gramsByGrade,
  });

  @override
  Widget build(BuildContext context) {
    final totalGrams = gramsByGrade.values.fold(0, (a, b) => a + b);
    if (totalGrams == 0) return const SizedBox.shrink();
    final isNl = Localizations.localeOf(context).languageCode == 'nl';

    final presentGrades = _kQualityOrder.where((g) => gramsByGrade.containsKey(g)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isNl ? 'Kwaliteitsverdeling' : 'Quality distribution',
          style: TextStyle(
            color: Colors.white.withOpacity(0.68),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        // Segmented bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 8,
            child: Row(
              children: presentGrades.map((grade) {
                final frac = gramsByGrade[grade]! / totalGrams;
                final color = _kQualityColors[grade] ?? Colors.grey;
                return Expanded(
                  flex: (frac * 1000).round(),
                  child: ColoredBox(color: color),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Pill row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presentGrades.map((grade) {
            final grams = gramsByGrade[grade]!;
            final color = _kQualityColors[grade] ?? Colors.grey;
            final labelPack = _kQualityLabels[grade];
            final label = labelPack == null ? grade : (isNl ? labelPack.nl : labelPack.en);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: color.withOpacity(0.36)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$grade · $label  $grams g',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}