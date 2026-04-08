import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import '../models/achievement.dart';
import '../services/prostitution_service.dart';
import '../l10n/app_localizations.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  final ProstitutionService _service = ProstitutionService();
  final Map<String, ScrollController> _rowScrollControllers = {};

  bool _isLoading = true;
  PlayerAchievementProgress? _progress;
  String _errorMessage = '';

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  @override
  void dispose() {
    for (final controller in _rowScrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  ScrollController _getRowScrollController(String category) {
    return _rowScrollControllers.putIfAbsent(
      category,
      () => ScrollController(),
    );
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _service.getAchievementsProgress();

      if (result['success'] == true) {
        final progress = PlayerAchievementProgress.fromJson(result);

        setState(() {
          _progress = progress;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load achievements';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  String _localizedAchievementTitle(Achievement achievement) {
    final t = AppLocalizations.of(context)!;

    switch (achievement.id) {
      case 'first_steps':
        return t.achievementTitle_first_steps;
      case 'growing_empire':
        return t.achievementTitle_growing_empire;
      case 'first_district':
        return t.achievementTitle_first_district;
      case 'empire_builder':
        return t.achievementTitle_empire_builder;
      case 'district_master':
        return t.achievementTitle_district_master;
      case 'leveling_master':
        return t.achievementTitle_leveling_master;
      case 'untouchable':
        return t.achievementTitle_untouchable;
      case 'millionaire':
        return t.achievementTitle_millionaire;
      case 'high_roller':
        return t.achievementTitle_high_roller;
      case 'vip_service':
        return t.achievementTitle_vip_service;
      case 'event_enthusiast':
        return t.achievementTitle_event_enthusiast;
      case 'security_expert':
        return t.achievementTitle_security_expert;
      case 'luxury_provider':
        return t.achievementTitle_luxury_provider;
      case 'rivalry_victor':
        return t.achievementTitle_rivalry_victor;
      case 'untouchable_rival':
        return t.achievementTitle_untouchable_rival;
      case 'crime_first_blood':
        return t.achievementTitle_crime_first_blood;
      case 'crime_hustler':
        return t.achievementTitle_crime_hustler;
      case 'crime_novice':
        return t.achievementTitle_crime_novice;
      case 'crime_operator':
        return t.achievementTitle_crime_operator;
      case 'crime_wave':
        return t.achievementTitle_crime_wave;
      case 'crime_mastermind':
        return t.achievementTitle_crime_mastermind;
      case 'the_godfather':
        return t.achievementTitle_the_godfather;
      case 'crime_emperor':
        return t.achievementTitle_crime_emperor;
      case 'crime_legend':
        return t.achievementTitle_crime_legend;
      case 'crime_getaway_driver':
        return t.achievementTitle_crime_getaway_driver;
      case 'crime_armed_and_ready':
        return t.achievementTitle_crime_armed_and_ready;
      case 'crime_full_loadout':
        return t.achievementTitle_crime_full_loadout;
      case 'crime_completionist':
        return t.achievementTitle_crime_completionist;
      case 'job_first_shift':
        return t.achievementTitle_job_first_shift;
      case 'job_hustler':
        return t.achievementTitle_job_hustler;
      case 'job_starter':
        return t.achievementTitle_job_starter;
      case 'job_operator':
        return t.achievementTitle_job_operator;
      case 'job_grinder':
        return t.achievementTitle_job_grinder;
      case 'job_master':
        return t.achievementTitle_job_master;
      case 'job_expert':
        return t.achievementTitle_job_expert;
      case 'job_elite':
        return t.achievementTitle_job_elite;
      case 'job_legend':
        return t.achievementTitle_job_legend;
      case 'job_completionist':
        return t.achievementTitle_job_completionist;
      case 'job_educated_worker':
        return t.achievementTitle_job_educated_worker;
      case 'job_certified_hustler':
        return t.achievementTitle_job_certified_hustler;
      case 'job_education_completionist':
        return t.achievementTitle_job_education_completionist;
      case 'job_it_specialist':
        return t.achievementTitle_job_it_specialist;
      case 'job_lawyer':
        return t.achievementTitle_job_lawyer;
      case 'job_doctor':
        return t.achievementTitle_job_doctor;
      case 'school_certified':
        return t.achievementTitle_school_certified;
      case 'school_multi_certified':
        return t.achievementTitle_school_multi_certified;
      case 'school_track_specialist':
        return t.achievementTitle_school_track_specialist;
      case 'school_freshman':
        return t.achievementTitle_school_freshman;
      case 'school_scholar':
        return t.achievementTitle_school_scholar;
      case 'school_graduate':
        return t.achievementTitle_school_graduate;
      case 'school_mastermind':
        return t.achievementTitle_school_mastermind;
      case 'school_doctorate':
        return t.achievementTitle_school_doctorate;
      case 'road_bandit':
        return t.achievementTitle_road_bandit;
      case 'grand_theft_fleet':
        return t.achievementTitle_grand_theft_fleet;
      case 'sea_raider':
        return t.achievementTitle_sea_raider;
      case 'captain_of_smugglers':
        return t.achievementTitle_captain_of_smugglers;
      case 'globe_trotter':
        return t.achievementTitle_globe_trotter;
      case 'jet_setter':
        return t.achievementTitle_jet_setter;
      case 'chemist_apprentice':
        return t.achievementTitle_chemist_apprentice;
      case 'narco_chemist':
        return t.achievementTitle_narco_chemist;
      case 'street_merchant':
        return t.achievementTitle_street_merchant;
      case 'trade_tycoon':
        return t.achievementTitle_trade_tycoon;
      case 'nightclub_opening_night':
        return t.achievementTitle_nightclub_opening_night;
      case 'nightclub_headliner':
        return t.achievementTitle_nightclub_headliner;
      case 'nightclub_full_house':
        return t.achievementTitle_nightclub_full_house;
      case 'nightclub_cash_machine':
        return t.achievementTitle_nightclub_cash_machine;
      case 'nightclub_empire':
        return t.achievementTitle_nightclub_empire;
      case 'nightclub_staffing_boss':
        return t.achievementTitle_nightclub_staffing_boss;
      case 'nightclub_vip_room':
        return t.achievementTitle_nightclub_vip_room;
      case 'nightclub_head_of_security':
        return t.achievementTitle_nightclub_head_of_security;
      case 'nightclub_podium_finish':
        return t.achievementTitle_nightclub_podium_finish;
      case 'nightclub_season_champion':
        return t.achievementTitle_nightclub_season_champion;
      case 'prostitute_lineup':
        return t.achievementTitle_prostitute_lineup;
      case 'prostitute_network':
        return t.achievementTitle_prostitute_network;
      case 'prostitute_syndicate':
        return t.achievementTitle_prostitute_syndicate;
      case 'prostitute_dynasty':
        return t.achievementTitle_prostitute_dynasty;
      case 'prostitute_empire_250':
        return t.achievementTitle_prostitute_empire_250;
      case 'prostitute_cartel_500':
        return t.achievementTitle_prostitute_cartel_500;
      case 'prostitute_legend_1000':
        return t.achievementTitle_prostitute_legend_1000;
      case 'vip_prostitute_level_10':
        return t.achievementTitle_vip_prostitute_level_10;
      case 'vip_prostitute_level_25':
        return t.achievementTitle_vip_prostitute_level_25;
      case 'vip_prostitute_level_50':
        return t.achievementTitle_vip_prostitute_level_50;
      case 'vip_prostitute_level_100':
        return t.achievementTitle_vip_prostitute_level_100;
      default:
        return achievement.title;
    }
  }

  String _localizedAchievementDescription(Achievement achievement) {
    final t = AppLocalizations.of(context)!;

    switch (achievement.id) {
      case 'first_steps':
        return t.achievementDescription_first_steps;
      case 'growing_empire':
        return t.achievementDescription_growing_empire;
      case 'first_district':
        return t.achievementDescription_first_district;
      case 'empire_builder':
        return t.achievementDescription_empire_builder;
      case 'district_master':
        return t.achievementDescription_district_master;
      case 'leveling_master':
        return t.achievementDescription_leveling_master;
      case 'untouchable':
        return t.achievementDescription_untouchable;
      case 'millionaire':
        return t.achievementDescription_millionaire;
      case 'high_roller':
        return t.achievementDescription_high_roller;
      case 'vip_service':
        return t.achievementDescription_vip_service;
      case 'event_enthusiast':
        return t.achievementDescription_event_enthusiast;
      case 'security_expert':
        return t.achievementDescription_security_expert;
      case 'luxury_provider':
        return t.achievementDescription_luxury_provider;
      case 'rivalry_victor':
        return t.achievementDescription_rivalry_victor;
      case 'untouchable_rival':
        return t.achievementDescription_untouchable_rival;
      case 'crime_first_blood':
        return t.achievementDescription_crime_first_blood;
      case 'crime_hustler':
        return t.achievementDescription_crime_hustler;
      case 'crime_novice':
        return t.achievementDescription_crime_novice;
      case 'crime_operator':
        return t.achievementDescription_crime_operator;
      case 'crime_wave':
        return t.achievementDescription_crime_wave;
      case 'crime_mastermind':
        return t.achievementDescription_crime_mastermind;
      case 'the_godfather':
        return t.achievementDescription_the_godfather;
      case 'crime_emperor':
        return t.achievementDescription_crime_emperor;
      case 'crime_legend':
        return t.achievementDescription_crime_legend;
      case 'crime_getaway_driver':
        return t.achievementDescription_crime_getaway_driver;
      case 'crime_armed_and_ready':
        return t.achievementDescription_crime_armed_and_ready;
      case 'crime_full_loadout':
        return t.achievementDescription_crime_full_loadout;
      case 'crime_completionist':
        return t.achievementDescription_crime_completionist;
      case 'job_first_shift':
        return t.achievementDescription_job_first_shift;
      case 'job_hustler':
        return t.achievementDescription_job_hustler;
      case 'job_starter':
        return t.achievementDescription_job_starter;
      case 'job_operator':
        return t.achievementDescription_job_operator;
      case 'job_grinder':
        return t.achievementDescription_job_grinder;
      case 'job_master':
        return t.achievementDescription_job_master;
      case 'job_expert':
        return t.achievementDescription_job_expert;
      case 'job_elite':
        return t.achievementDescription_job_elite;
      case 'job_legend':
        return t.achievementDescription_job_legend;
      case 'job_completionist':
        return t.achievementDescription_job_completionist;
      case 'job_educated_worker':
        return t.achievementDescription_job_educated_worker;
      case 'job_certified_hustler':
        return t.achievementDescription_job_certified_hustler;
      case 'job_education_completionist':
        return t.achievementDescription_job_education_completionist;
      case 'job_it_specialist':
        return t.achievementDescription_job_it_specialist;
      case 'job_lawyer':
        return t.achievementDescription_job_lawyer;
      case 'job_doctor':
        return t.achievementDescription_job_doctor;
      case 'school_certified':
        return t.achievementDescription_school_certified;
      case 'school_multi_certified':
        return t.achievementDescription_school_multi_certified;
      case 'school_track_specialist':
        return t.achievementDescription_school_track_specialist;
      case 'school_freshman':
        return t.achievementDescription_school_freshman;
      case 'school_scholar':
        return t.achievementDescription_school_scholar;
      case 'school_graduate':
        return t.achievementDescription_school_graduate;
      case 'school_mastermind':
        return t.achievementDescription_school_mastermind;
      case 'school_doctorate':
        return t.achievementDescription_school_doctorate;
      case 'road_bandit':
        return t.achievementDescription_road_bandit;
      case 'grand_theft_fleet':
        return t.achievementDescription_grand_theft_fleet;
      case 'sea_raider':
        return t.achievementDescription_sea_raider;
      case 'captain_of_smugglers':
        return t.achievementDescription_captain_of_smugglers;
      case 'globe_trotter':
        return t.achievementDescription_globe_trotter;
      case 'jet_setter':
        return t.achievementDescription_jet_setter;
      case 'chemist_apprentice':
        return t.achievementDescription_chemist_apprentice;
      case 'narco_chemist':
        return t.achievementDescription_narco_chemist;
      case 'street_merchant':
        return t.achievementDescription_street_merchant;
      case 'trade_tycoon':
        return t.achievementDescription_trade_tycoon;
      case 'nightclub_opening_night':
        return t.achievementDescription_nightclub_opening_night;
      case 'nightclub_headliner':
        return t.achievementDescription_nightclub_headliner;
      case 'nightclub_full_house':
        return t.achievementDescription_nightclub_full_house;
      case 'nightclub_cash_machine':
        return t.achievementDescription_nightclub_cash_machine;
      case 'nightclub_empire':
        return t.achievementDescription_nightclub_empire;
      case 'nightclub_staffing_boss':
        return t.achievementDescription_nightclub_staffing_boss;
      case 'nightclub_vip_room':
        return t.achievementDescription_nightclub_vip_room;
      case 'nightclub_head_of_security':
        return t.achievementDescription_nightclub_head_of_security;
      case 'nightclub_podium_finish':
        return t.achievementDescription_nightclub_podium_finish;
      case 'nightclub_season_champion':
        return t.achievementDescription_nightclub_season_champion;
      case 'prostitute_lineup':
        return t.achievementDescription_prostitute_lineup;
      case 'prostitute_network':
        return t.achievementDescription_prostitute_network;
      case 'prostitute_syndicate':
        return t.achievementDescription_prostitute_syndicate;
      case 'prostitute_dynasty':
        return t.achievementDescription_prostitute_dynasty;
      case 'prostitute_empire_250':
        return t.achievementDescription_prostitute_empire_250;
      case 'prostitute_cartel_500':
        return t.achievementDescription_prostitute_cartel_500;
      case 'prostitute_legend_1000':
        return t.achievementDescription_prostitute_legend_1000;
      case 'vip_prostitute_level_10':
        return t.achievementDescription_vip_prostitute_level_10;
      case 'vip_prostitute_level_25':
        return t.achievementDescription_vip_prostitute_level_25;
      case 'vip_prostitute_level_50':
        return t.achievementDescription_vip_prostitute_level_50;
      case 'vip_prostitute_level_100':
        return t.achievementDescription_vip_prostitute_level_100;
      default:
        return achievement.description;
    }
  }

  String _categoryLabel(String category) {
    const labels = {
      'prostitution': 'Hoeren',
      'rld': 'RLD',
      'crimes': 'Crimes',
      'jobs': 'Werk',
      'school': 'School',
      'vehicles': 'Auto/Boot',
      'travel': 'Reizen',
      'drugs': 'Drugs',
      'trade': 'Handel',
      'social': 'Social',
      'mastery': 'Mastery',
      'progression': 'Progressie',
      'wealth': 'Rijkdom',
      'power': 'Macht',
    };

    return labels[category] ?? category;
  }

  List<String> _orderedCategories() {
    if (_progress == null) return [];

    const preferredOrder = [
      'crimes',
      'jobs',
      'school',
      'prostitution',
      'rld',
      'vehicles',
      'travel',
      'drugs',
      'trade',
      'social',
      'mastery',
      'progression',
      'wealth',
      'power',
    ];

    final categories = _progress!.categories;
    final ordered = <String>[];

    for (final category in preferredOrder) {
      if (categories.contains(category)) {
        ordered.add(category);
      }
    }

    for (final category in categories) {
      if (!ordered.contains(category)) {
        ordered.add(category);
      }
    }

    return ordered;
  }

  ({int unlocked, int total}) _categoryCounts(String category) {
    if (_progress == null) {
      return (unlocked: 0, total: 0);
    }

    final achievements = _progress!.achievementsByCategory(category);

    final unlocked = achievements
        .where((achievement) => achievement.unlocked)
        .length;
    return (unlocked: unlocked, total: achievements.length);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.achievementsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAchievements,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? _buildErrorView()
          : _buildAchievementsView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_errorMessage),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAchievements,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsView() {
    if (_progress == null) return const SizedBox();

    return Column(
      children: [
        _buildProgressHeader(),
        Expanded(child: _buildAchievementsList()),
      ],
    );
  }

  Widget _buildProgressHeader() {
    if (_progress == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: Theme.of(context).textTheme.titleLarge),
              Text(
                '${_progress!.unlockedCount}/${_progress!.totalAchievements}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress!.progress / 100,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_progress!.progress}% Complete',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    final categories = _orderedCategories();

    if (categories.isEmpty) {
      return Center(child: Text(_tr('Geen prestaties gevonden', 'No achievements found')));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryRow(category);
      },
    );
  }

  Widget _buildCategoryRow(String category) {
    final achievements = _progress!.achievementsByCategory(category)
      ..sort((a, b) {
        final orderA = _getAchievementOrderIndex(a);
        final orderB = _getAchievementOrderIndex(b);

        if (orderA != orderB) {
          return orderA.compareTo(orderB);
        }

        if (a.requirementValue != b.requirementValue) {
          return a.requirementValue.compareTo(b.requirementValue);
        }

        return _localizedAchievementTitle(
          a,
        ).compareTo(_localizedAchievementTitle(b));
      });

    final counts = _categoryCounts(category);
    final rowController = _getRowScrollController(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _categoryLabel(category),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getCategoryColor(category).withOpacity(0.45),
                  ),
                ),
                child: Text(
                  '${counts.unlocked}/${counts.total}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _getCategoryColor(category),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 236,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown,
                },
              ),
              child: Listener(
                onPointerSignal: (pointerSignal) {
                  if (pointerSignal is! PointerScrollEvent) return;
                  if (!rowController.hasClients) return;

                  final delta =
                      pointerSignal.scrollDelta.dy +
                      pointerSignal.scrollDelta.dx;
                  final targetOffset = (rowController.offset + delta).clamp(
                    0.0,
                    rowController.position.maxScrollExtent,
                  );
                  rowController.jumpTo(targetOffset);
                },
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbVisibility: WidgetStateProperty.all(true),
                    trackVisibility: WidgetStateProperty.all(true),
                    interactive: true,
                    thickness: WidgetStateProperty.all(3),
                    radius: const Radius.circular(4),
                    thumbColor: WidgetStateProperty.all(Colors.amber.shade600),
                    trackColor: WidgetStateProperty.all(
                      Colors.amber.withOpacity(0.18),
                    ),
                    trackBorderColor: WidgetStateProperty.all(
                      Colors.amber.withOpacity(0.35),
                    ),
                  ),
                  child: Scrollbar(
                    controller: rowController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    interactive: true,
                    child: ListView.separated(
                      controller: rowController,
                      primary: false,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: achievements.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) =>
                          _buildShieldBadge(achievements[index]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShieldBadge(Achievement achievement) {
    final isLocked = !achievement.unlocked;
    final categoryColor = _getCategoryColor(achievement.category);

    return InkWell(
      onTap: () => _showAchievementDetails(achievement),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isLocked
              ? Colors.grey.withOpacity(0.10)
              : categoryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isLocked
                ? Colors.grey.withOpacity(0.35)
                : categoryColor.withOpacity(0.55),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBadgeImage(achievement, isLocked),
            const SizedBox(height: 10),
            Text(
              _localizedAchievementTitle(achievement),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isLocked ? Colors.grey.shade500 : Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${achievement.currentValue}/${achievement.requirementValue}',
              style: TextStyle(
                fontSize: 12,
                color: isLocked ? Colors.grey.shade500 : Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: achievement.requirementValue > 0
                    ? (achievement.currentValue / achievement.requirementValue)
                          .clamp(0.0, 1.0)
                    : 0,
                minHeight: 7,
                backgroundColor: Colors.grey.shade700,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLocked ? Colors.grey : categoryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeImage(Achievement achievement, bool isLocked) {
    final assetPath = _getBadgeAssetPath(achievement);
    final legacyAssetPath = _getLegacyBadgeAssetPath(achievement);

    Widget fallback = Container(
      width: 88,
      height: 96,
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.grey.shade700
            : _getCategoryColor(achievement.category).withOpacity(0.22),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(achievement.icon, style: const TextStyle(fontSize: 42)),
    );

    Widget image = Image.asset(
      assetPath,
      width: 88,
      height: 96,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, _, _) => Image.asset(
        legacyAssetPath,
        width: 88,
        height: 96,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, _, _) => fallback,
      ),
    );

    if (isLocked) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: Opacity(opacity: 0.55, child: image),
      );
    }

    return image;
  }

  String _getBadgeAssetPath(Achievement achievement) {
    final folder = _getBadgeCategoryFolder(achievement.category);
    return 'assets/images/achievements/badges/$folder/${achievement.id}.png';
  }

  String _getLegacyBadgeAssetPath(Achievement achievement) {
    return 'assets/images/achievements/badges/${achievement.id}.png';
  }

  String _getBadgeCategoryFolder(String category) {
    switch (category) {
      case 'prostitution':
        return 'prostitution';
      case 'crimes':
        return 'crimes';
      case 'jobs':
        return 'jobs';
      case 'school':
        return 'school';
      case 'vehicles':
        return 'vehicles';
      case 'travel':
        return 'travel';
      case 'drugs':
        return 'drugs';
      case 'trade':
        return 'trade';
      case 'social':
        return 'social';
      case 'mastery':
        return 'mastery';
      case 'power':
        return 'power';
      default:
        return 'legacy';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'prostitution':
        return Colors.pinkAccent;
      case 'rld':
        return Colors.deepPurpleAccent;
      case 'crimes':
        return Colors.redAccent;
      case 'jobs':
        return Colors.tealAccent;
      case 'school':
        return Colors.amber;
      case 'vehicles':
        return Colors.orangeAccent;
      case 'travel':
        return Colors.lightBlueAccent;
      case 'drugs':
        return Colors.greenAccent;
      case 'trade':
        return Colors.amberAccent;
      case 'progression':
        return Colors.blue;
      case 'wealth':
        return Colors.green;
      case 'power':
        return Colors.purple;
      case 'social':
        return Colors.orange;
      case 'mastery':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int _getAchievementOrderIndex(Achievement achievement) {
    const prostitutionOrder = <String, int>{
      'first_steps': 1,
      'growing_empire': 2,
      'prostitute_lineup': 3,
      'prostitute_network': 4,
      'prostitute_syndicate': 5,
      'prostitute_dynasty': 6,
      'prostitute_empire_250': 7,
      'prostitute_cartel_500': 8,
      'prostitute_legend_1000': 9,
      'first_district': 15,
      'leveling_master': 20,
      'vip_prostitute_level_10': 21,
      'vip_prostitute_level_25': 22,
      'vip_prostitute_level_50': 23,
      'vip_prostitute_level_100': 24,
      'untouchable': 30,
    };
    const crimeOrder = <String, int>{
      'crime_first_blood': 1,
      'crime_hustler': 2,
      'crime_novice': 3,
      'crime_operator': 4,
      'crime_wave': 5,
      'crime_mastermind': 6,
      'the_godfather': 7,
      'crime_emperor': 8,
      'crime_legend': 9,
      'crime_getaway_driver': 20,
      'crime_armed_and_ready': 21,
      'crime_full_loadout': 22,
      'crime_completionist': 23,
    };
    const jobOrder = <String, int>{
      'job_first_shift': 1,
      'job_hustler': 2,
      'job_starter': 3,
      'job_operator': 4,
      'job_grinder': 5,
      'job_master': 6,
      'job_expert': 7,
      'job_elite': 8,
      'job_legend': 9,
      'job_educated_worker': 15,
      'job_certified_hustler': 16,
      'job_education_completionist': 17,
      'job_it_specialist': 18,
      'job_lawyer': 19,
      'job_doctor': 20,
      'job_completionist': 25,
    };
    const schoolOrder = <String, int>{
      'school_freshman': 1,
      'school_scholar': 2,
      'school_graduate': 3,
      'school_mastermind': 4,
      'school_doctorate': 5,
      'school_certified': 6,
      'school_multi_certified': 7,
      'school_track_specialist': 8,
    };

    if (achievement.category == 'prostitution') {
      return prostitutionOrder[achievement.id] ?? 999;
    }

    if (achievement.category == 'crimes') {
      return crimeOrder[achievement.id] ?? 999;
    }

    if (achievement.category == 'jobs') {
      return jobOrder[achievement.id] ?? 999;
    }

    if (achievement.category == 'school') {
      return schoolOrder[achievement.id] ?? 999;
    }

    return 999;
  }

  Color _getReadableCategoryBackground(String category) {
    final base = _getCategoryColor(category);
    final hsl = HSLColor.fromColor(base);

    if (hsl.lightness > 0.55) {
      return hsl.withLightness(0.35).toColor();
    }

    return base;
  }

  Color _getReadableOnColor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  String _formatDate(DateTime date) {
    final t = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return t.achievementsDateToday;
    } else if (diff.inDays == 1) {
      return t.achievementsDateYesterday;
    } else if (diff.inDays < 7) {
      return t.achievementsDateDaysAgo(diff.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatLocalizedNumber(int value) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.decimalPattern(locale).format(value);
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildAchievementDetailsSheet(achievement),
    );
  }

  Widget _buildAchievementDetailsSheet(Achievement achievement) {
    final t = AppLocalizations.of(context)!;
    final isLocked = !achievement.unlocked;
    final hasMoneyReward =
        achievement.rewardMoney != null && achievement.rewardMoney! > 0;
    final hasXpReward = achievement.rewardXp != null && achievement.rewardXp! > 0;
    final hasAnyReward = hasMoneyReward || hasXpReward;
    final assetPath = _getBadgeAssetPath(achievement);
    final legacyAssetPath = _getLegacyBadgeAssetPath(achievement);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryBackground = _getReadableCategoryBackground(
      achievement.category,
    );
    final categoryOnColor = _getReadableOnColor(categoryBackground);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                assetPath,
                width: 108,
                height: 120,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, _, _) => Image.asset(
                  legacyAssetPath,
                  width: 108,
                  height: 120,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, _, _) => Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey[300]
                          : _getCategoryColor(
                              achievement.category,
                            ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      achievement.icon,
                      style: const TextStyle(fontSize: 64),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _localizedAchievementTitle(achievement),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  achievement.categoryName,
                  style: TextStyle(
                    color: categoryOnColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                backgroundColor: categoryBackground,
              ),
              const SizedBox(height: 16),
              Text(
                _localizedAchievementDescription(achievement),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                t.achievementsDetailProgress(
                  achievement.currentValue,
                  achievement.requirementValue,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '🎁 ${t.achievementReward}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (hasMoneyReward)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.attach_money, color: Colors.green),
                          Text(
                            t.achievementsMoney(
                              _formatLocalizedNumber(achievement.rewardMoney!),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    if (hasXpReward)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          Text(
                            t.achievementsXp(
                              _formatLocalizedNumber(achievement.rewardXp!),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    if (!hasAnyReward)
                      Text(
                        t.achievementsNoRewardConfigured,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (isLocked && hasAnyReward) ...[
                      const SizedBox(height: 8),
                      Text(
                        t.achievementsRewardOnUnlock,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.75),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (achievement.unlockedAt != null)
                Text(
                  t.achievementsUnlockedDate(_formatDate(achievement.unlockedAt!)),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(t.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
