import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

const kAchievementCategoryOrder = [
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

String achievementBadgeCategoryFolder(String category) {
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

String achievementBadgeAssetPath(String category, String id) {
  return 'assets/images/achievements/badges/${achievementBadgeCategoryFolder(category)}/$id.png';
}

String achievementLegacyBadgeAssetPath(String id) {
  return 'assets/images/achievements/badges/$id.png';
}

Widget achievementBadgeImage({
  required String id,
  required String category,
  String? fallbackIcon,
  double width = 56,
  double height = 62,
}) {
  return Image.asset(
    achievementBadgeAssetPath(category, id),
    width: width,
    height: height,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.high,
    errorBuilder: (_, _, _) => Image.asset(
      achievementLegacyBadgeAssetPath(id),
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, _, _) => fallbackIcon == null || fallbackIcon.isEmpty
          ? Icon(Icons.military_tech, color: const Color(0xFFFFD700), size: width * 0.7)
          : Text(fallbackIcon, style: TextStyle(fontSize: width * 0.7)),
    ),
  );
}

String localizedAchievementCategory(AppLocalizations t, String category) {
  switch (category) {
    case 'progression':
      return t.achievementsCategoryProgression;
    case 'wealth':
      return t.achievementsCategoryWealth;
    case 'power':
      return t.achievementsCategoryPower;
    case 'social':
      return t.achievementsCategorySocial;
    case 'mastery':
      return t.achievementsCategoryMastery;
    case 'prostitution':
      return t.achievementsCategoryNameProstitution;
    case 'rld':
      return t.achievementsCategoryNameRld;
    case 'crimes':
      return t.achievementsCategoryNameCrimes;
    case 'jobs':
      return t.achievementsCategoryNameJobs;
    case 'school':
      return t.achievementsCategoryNameSchool;
    case 'vehicles':
      return t.achievementsCategoryNameVehicles;
    case 'travel':
      return t.achievementsCategoryNameTravel;
    case 'drugs':
      return t.achievementsCategoryNameDrugs;
    case 'trade':
      return t.achievementsCategoryNameTrade;
    default:
      return t.achievementsCategoryNameGeneral;
  }
}

String localizedAchievementTitle(
  AppLocalizations t,
  String id, [
  String? fallback,
]) {
  switch (id) {
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
      return (fallback != null && fallback.isNotEmpty) ? fallback : id;
  }
}
