import prisma from '../lib/prisma';
import { notificationService } from './notificationService';
import {
  consumeAndWearMissionStorage,
  loadCrewMissionStorageSnapshot,
  parseMissionRequirements,
  quoteMissionRequirements,
  serializeMissionRequirements,
  tradeRequirementsFromParsed,
  clampMissionSuccessChance,
  type MissionRequirement,
} from './crewMissionRequirements';
import * as casinoOwnershipService from './casinoOwnershipService';

type CrewMissionTier = 1 | 2 | 3;
type CrewMissionOutcome = 'success' | 'partial' | 'fail';
type CrewMissionRunStatus = 'in_progress' | 'completed';

type TradeRequirement = {
  goodType: string;
  quantity: number;
};

type CrewMissionTemplate = {
  id: number;
  missionKey: string;
  tier: CrewMissionTier;
  titleNl: string;
  titleEn: string;
  descriptionNl: string | null;
  descriptionEn: string | null;
  durationSeconds: number;
  cooldownSeconds: number;
  successChance: number;
  rewardCashMin: number;
  rewardCashMax: number;
  rewardCrewXp: number;
  rewardPersonalXp: number;
  failPenaltyPct: number;
  isActive: number;
  sortOrder: number;
  imageCardPath: string | null;
  imageScenePath: string | null;
  tradeRequirements: TradeRequirement[];
  storageRequirements: MissionRequirement[];
};

type CrewMissionTemplateRow = CrewMissionTemplate & {
  requirementsJson: string | null;
};

type CrewMissionRun = {
  id: number;
  crewId: number;
  templateId: number;
  startedByPlayerId: number;
  status: CrewMissionRunStatus;
  startedAt: Date;
  endsAt: Date;
  resolvedAt: Date | null;
  cooldownUntil: Date | null;
  outcome: CrewMissionOutcome | null;
  progressPct: number;
  successRoll: number | null;
  successChance: number | null;
  rewardMultiplier: number;
  rewardCrewCash: number;
  rewardCrewXp: number;
  rewardPersonalXp: number;
  rewardsClaimedAt: Date | null;
  rewardsClaimedByPlayerId: number | null;
  metadataJson: string | null;
  missionKey: string;
  tier: CrewMissionTier;
  titleNl: string;
  titleEn: string;
};

type MissionContributionRow = {
  id: number;
  runId: number;
  playerId: number;
  roleKey: string;
  contributionScore: number;
};

type MissionContributionViewRow = {
  runId: number;
  playerId: number;
  roleKey: string;
  contributionScore: number;
  payoutMultiplier: number | null;
  rewardCash: number | null;
  rewardXp: number | null;
  username: string | null;
};

type RuntimeCrewMissionConfig = {
  t1CreditsPerMinute: number;
  t2CreditsPerMinute: number;
  t3CreditsPerMinute: number;
  repeatWindowMinutes: number;
  repeat2Multiplier: number;
  repeat3Multiplier: number;
  repeat4Multiplier: number;
  crewLevelBaseXp: number;
  crewLevelStepXp: number;
  crewLevelCashBonusPerLevelPct: number;
  crewLevelCashBonusCapPct: number;
  /** 0 = disabled. When >0, clearing_house_vault_run also requires this crew mission level. */
  clearingHouseMinMissionLevel: number;
};

type MissionSeed = {
  missionKey: string;
  tier: CrewMissionTier;
  titleNl: string;
  titleEn: string;
  descriptionNl: string;
  descriptionEn: string;
  durationSeconds: number;
  cooldownSeconds: number;
  successChance: number;
  rewardCashMin: number;
  rewardCashMax: number;
  rewardCrewXp: number;
  rewardPersonalXp: number;
  failPenaltyPct: number;
  sortOrder: number;
  imageCardPath: string;
  imageScenePath: string;
  tradeRequirements?: TradeRequirement[];
  storageRequirements?: MissionRequirement[];
};

const CREW_MISSION_RUNTIME_SETTING_DEFAULTS = {
  CREW_MISSION_T1_CREDITS_PER_MINUTE: process.env.CREW_MISSION_T1_CREDITS_PER_MINUTE || '5',
  CREW_MISSION_T2_CREDITS_PER_MINUTE: process.env.CREW_MISSION_T2_CREDITS_PER_MINUTE || '6',
  CREW_MISSION_T3_CREDITS_PER_MINUTE: process.env.CREW_MISSION_T3_CREDITS_PER_MINUTE || '7',
  CREW_MISSION_REPEAT_WINDOW_MINUTES: process.env.CREW_MISSION_REPEAT_WINDOW_MINUTES || '90',
  CREW_MISSION_REPEAT_2_MULTIPLIER: process.env.CREW_MISSION_REPEAT_2_MULTIPLIER || '0.93',
  CREW_MISSION_REPEAT_3_MULTIPLIER: process.env.CREW_MISSION_REPEAT_3_MULTIPLIER || '0.86',
  CREW_MISSION_REPEAT_4_MULTIPLIER: process.env.CREW_MISSION_REPEAT_4_MULTIPLIER || '0.80',
  CREW_MISSION_CREW_LEVEL_BASE_XP: process.env.CREW_MISSION_CREW_LEVEL_BASE_XP || '400',
  CREW_MISSION_CREW_LEVEL_STEP_XP: process.env.CREW_MISSION_CREW_LEVEL_STEP_XP || '150',
  CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT:
    process.env.CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT || '1.0',
  CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT:
    process.env.CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT || '15.0',
  // Code default stays 0. Prod live value is runtime `3` (user enable 2026-09-08).
  CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL:
    process.env.CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL || '0',
} as const;

export const CREW_MISSION_RUNTIME_SETTING_KEYS = Object.keys(CREW_MISSION_RUNTIME_SETTING_DEFAULTS);
export { CREW_MISSION_RUNTIME_SETTING_DEFAULTS };

const MISSION_SEEDS: MissionSeed[] = [
  {
    missionKey: 'safehouse_supply_run',
    tier: 1,
    titleNl: 'Safehouse Supply Run',
    titleEn: 'Safehouse Supply Run',
    descriptionNl: 'Beveilig bevoorrading naar een verborgen safehouse.',
    descriptionEn: 'Secure supplies to a hidden safehouse.',
    durationSeconds: 8 * 60,
    cooldownSeconds: 10 * 60,
    successChance: 0.74,
    rewardCashMin: 45000,
    rewardCashMax: 70000,
    rewardCrewXp: 55,
    rewardPersonalXp: 28,
    failPenaltyPct: 0.08,
    sortOrder: 10,
    imageCardPath: 'images/crew_missions/cards/safehouse_supply_run.png',
    imageScenePath: 'images/crew_missions/scenes/safehouse_supply_run.png',
  },
  {
    missionKey: 'street_intel_sweep',
    tier: 1,
    titleNl: 'Street Intel Sweep',
    titleEn: 'Street Intel Sweep',
    descriptionNl: 'Verzamel straatinformatie voor komende operations.',
    descriptionEn: 'Gather street intelligence for upcoming operations.',
    durationSeconds: 9 * 60,
    cooldownSeconds: 11 * 60,
    successChance: 0.7,
    rewardCashMin: 52000,
    rewardCashMax: 82000,
    rewardCrewXp: 62,
    rewardPersonalXp: 32,
    failPenaltyPct: 0.1,
    sortOrder: 20,
    imageCardPath: 'images/crew_missions/cards/street_intel_sweep.png',
    imageScenePath: 'images/crew_missions/scenes/street_intel_sweep.png',
  },
  {
    missionKey: 'armory_smuggle_chain',
    tier: 2,
    titleNl: 'Armory Smuggle Chain',
    titleEn: 'Armory Smuggle Chain',
    descriptionNl: 'Smokkel wapenkratten via meerdere veilige routes.',
    descriptionEn: 'Smuggle weapon crates through multiple safe routes.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.62,
    rewardCashMin: 100000,
    rewardCashMax: 150000,
    rewardCrewXp: 105,
    rewardPersonalXp: 52,
    failPenaltyPct: 0.14,
    sortOrder: 30,
    imageCardPath: 'images/crew_missions/cards/armory_smuggle_chain.png',
    imageScenePath: 'images/crew_missions/scenes/armory_smuggle_chain.png',
  },
  {
    missionKey: 'port_hijack_window',
    tier: 2,
    titleNl: 'Port Hijack Window',
    titleEn: 'Port Hijack Window',
    descriptionNl: 'Kraak een korte haven-window met precisietiming.',
    descriptionEn: 'Hijack a short harbor window with precise timing.',
    durationSeconds: 18 * 60,
    cooldownSeconds: 20 * 60,
    successChance: 0.58,
    rewardCashMin: 118000,
    rewardCashMax: 178000,
    rewardCrewXp: 122,
    rewardPersonalXp: 60,
    failPenaltyPct: 0.16,
    sortOrder: 40,
    imageCardPath: 'images/crew_missions/cards/port_hijack_window.png',
    imageScenePath: 'images/crew_missions/scenes/port_hijack_window.png',
  },
  {
    missionKey: 'casino_ledger_raid',
    tier: 3,
    titleNl: 'Casino Ledger Raid',
    titleEn: 'Casino Ledger Raid',
    descriptionNl: 'Steel gevoelige ledgerdata uit een zwaar beveiligde kluis.',
    descriptionEn: 'Steal sensitive ledger data from a heavily guarded vault.',
    durationSeconds: 30 * 60,
    cooldownSeconds: 28 * 60,
    successChance: 0.52,
    rewardCashMin: 230000,
    rewardCashMax: 340000,
    rewardCrewXp: 220,
    rewardPersonalXp: 105,
    failPenaltyPct: 0.2,
    sortOrder: 50,
    imageCardPath: 'images/crew_missions/cards/casino_ledger_raid.png',
    imageScenePath: 'images/crew_missions/scenes/casino_ledger_raid.png',
  },
  {
    missionKey: 'federal_convoy_break',
    tier: 3,
    titleNl: 'Federal Convoy Break',
    titleEn: 'Federal Convoy Break',
    descriptionNl: 'Doorbreek een federale convoy onder hoge druk.',
    descriptionEn: 'Break through a federal convoy under high pressure.',
    durationSeconds: 34 * 60,
    cooldownSeconds: 32 * 60,
    successChance: 0.48,
    rewardCashMin: 290000,
    rewardCashMax: 430000,
    rewardCrewXp: 265,
    rewardPersonalXp: 130,
    failPenaltyPct: 0.24,
    sortOrder: 60,
    imageCardPath: 'images/crew_missions/cards/federal_convoy_break.png',
    imageScenePath: 'images/crew_missions/scenes/federal_convoy_break.png',
  },
  {
    missionKey: 'night_deposit_grab',
    tier: 1,
    titleNl: 'Night Deposit Kraak',
    titleEn: 'Night Deposit Grab',
    descriptionNl: 'Grijp een korte nachtelijke stortingswindow bij een klein filiaal.',
    descriptionEn: 'Hit a tight after-hours deposit window at a small branch office.',
    durationSeconds: 7 * 60,
    cooldownSeconds: 9 * 60,
    successChance: 0.72,
    rewardCashMin: 48000,
    rewardCashMax: 76000,
    rewardCrewXp: 50,
    rewardPersonalXp: 25,
    failPenaltyPct: 0.09,
    sortOrder: 61,
    imageCardPath: 'images/crew_missions/cards/night_deposit_grab.png',
    imageScenePath: 'images/crew_missions/scenes/night_deposit_grab.png',
  },
  {
    missionKey: 'skim_network_rollout',
    tier: 1,
    titleNl: 'Pin-skim Netwerk',
    titleEn: 'Skim Network Rollout',
    descriptionNl: 'Rol een skim-operatie uit over meerdere pinzuilen zonder alarm.',
    descriptionEn: 'Roll out a skim operation across multiple ATMs without tripping alarms.',
    durationSeconds: 10 * 60,
    cooldownSeconds: 12 * 60,
    successChance: 0.71,
    rewardCashMin: 46000,
    rewardCashMax: 74000,
    rewardCrewXp: 56,
    rewardPersonalXp: 28,
    failPenaltyPct: 0.095,
    sortOrder: 62,
    imageCardPath: 'images/crew_missions/cards/skim_network_rollout.png',
    imageScenePath: 'images/crew_missions/scenes/skim_network_rollout.png',
  },
  {
    missionKey: 'armored_pivot_route',
    tier: 2,
    titleNl: 'Pantserroute Intercept',
    titleEn: 'Armored Pivot Route',
    descriptionNl: 'Forceer een pantserwagen om te routeren en grijp het intercept-window.',
    descriptionEn: 'Force an armored truck reroute and seize the intercept window.',
    durationSeconds: 17 * 60,
    cooldownSeconds: 19 * 60,
    successChance: 0.59,
    rewardCashMin: 105000,
    rewardCashMax: 158000,
    rewardCrewXp: 108,
    rewardPersonalXp: 54,
    failPenaltyPct: 0.15,
    sortOrder: 63,
    imageCardPath: 'images/crew_missions/cards/armored_pivot_route.png',
    imageScenePath: 'images/crew_missions/scenes/armored_pivot_route.png',
  },
  {
    missionKey: 'subsidiary_vault_window',
    tier: 2,
    titleNl: 'Dochterbank Kluiswindow',
    titleEn: 'Subsidiary Vault Window',
    descriptionNl: 'Kraak een beperkt kluiswindow bij een regionale dochterbank.',
    descriptionEn: 'Crack a limited vault window at a regional subsidiary branch.',
    durationSeconds: 19 * 60,
    cooldownSeconds: 21 * 60,
    successChance: 0.57,
    rewardCashMin: 120000,
    rewardCashMax: 182000,
    rewardCrewXp: 116,
    rewardPersonalXp: 58,
    failPenaltyPct: 0.175,
    sortOrder: 64,
    imageCardPath: 'images/crew_missions/cards/subsidiary_vault_window.png',
    imageScenePath: 'images/crew_missions/scenes/subsidiary_vault_window.png',
  },
  {
    missionKey: 'reserve_vault_breach',
    tier: 3,
    titleNl: 'Reservekluis Inbraak',
    titleEn: 'Reserve Vault Breach',
    descriptionNl: 'Doorbreek een centrale reservekluis met zware respons en korte ademruimte.',
    descriptionEn: 'Breach a central reserve vault under heavy response and tight margins.',
    durationSeconds: 38 * 60,
    cooldownSeconds: 36 * 60,
    successChance: 0.46,
    rewardCashMin: 305000,
    rewardCashMax: 455000,
    rewardCrewXp: 275,
    rewardPersonalXp: 138,
    failPenaltyPct: 0.25,
    sortOrder: 65,
    imageCardPath: 'images/crew_missions/cards/reserve_vault_breach.png',
    imageScenePath: 'images/crew_missions/scenes/reserve_vault_breach.png',
  },
  {
    missionKey: 'clearing_house_vault_run',
    tier: 3,
    titleNl: 'Clearing House Kluisrun',
    titleEn: 'Clearing House Vault Run',
    descriptionNl:
      'Infiltreer een afgesloten settlement-rail: sabotage sessies, cold-storage exfil, geen rooftocht op spaarders.',
    descriptionEn:
      'Infiltrate a sealed settlement rail: sabotage sessions, cold-storage exfil, no looting of players savings.',
    durationSeconds: 36 * 60,
    cooldownSeconds: 38 * 60,
    successChance: 0.44,
    rewardCashMin: 320000,
    rewardCashMax: 480000,
    rewardCrewXp: 285,
    rewardPersonalXp: 142,
    failPenaltyPct: 0.26,
    sortOrder: 66,
    imageCardPath: 'images/crew_missions/cards/clearing_house_vault_run.png',
    imageScenePath: 'images/crew_missions/scenes/clearing_house_vault_run.png',
  },
  {
    missionKey: 'courier_intercept',
    tier: 1,
    titleNl: 'Koerier Intercept',
    titleEn: 'Courier Intercept',
    descriptionNl: 'Onderschep een snelle koerier met gevoelige documenten in de stad.',
    descriptionEn: 'Intercept a fast courier carrying sensitive documents across the city.',
    durationSeconds: 8 * 60,
    cooldownSeconds: 10 * 60,
    successChance: 0.73,
    rewardCashMin: 44000,
    rewardCashMax: 68000,
    rewardCrewXp: 52,
    rewardPersonalXp: 26,
    failPenaltyPct: 0.09,
    sortOrder: 67,
    imageCardPath: 'images/crew_missions/cards/courier_intercept.png',
    imageScenePath: 'images/crew_missions/scenes/courier_intercept.png',
  },
  {
    missionKey: 'city_vault_prep',
    tier: 2,
    titleNl: 'Stedelijke Kluis Prep',
    titleEn: 'City Vault Prep',
    descriptionNl: 'Bereid een stedelijke kluisoperatie voor met routes, timing en afleiding.',
    descriptionEn: 'Prep a city vault job with routes, timing and diversion work.',
    durationSeconds: 17 * 60,
    cooldownSeconds: 19 * 60,
    successChance: 0.6,
    rewardCashMin: 98000,
    rewardCashMax: 148000,
    rewardCrewXp: 110,
    rewardPersonalXp: 55,
    failPenaltyPct: 0.15,
    sortOrder: 68,
    imageCardPath: 'images/crew_missions/cards/city_vault_prep.png',
    imageScenePath: 'images/crew_missions/scenes/city_vault_prep.png',
  },
  {
    missionKey: 'port_contraband_manifest',
    tier: 2,
    titleNl: 'Haven Contraband Manifest',
    titleEn: 'Port Contraband Manifest',
    descriptionNl:
      'Vervalst havenmanifesten met crew-handelswaren. Stort tabak en koffie in crew-opslag vóór start.',
    descriptionEn:
      'Forge port manifests using crew trade cargo. Deposit tobacco and coffee in crew storage before starting.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.61,
    rewardCashMin: 102000,
    rewardCashMax: 152000,
    rewardCrewXp: 108,
    rewardPersonalXp: 54,
    failPenaltyPct: 0.14,
    sortOrder: 32,
    imageCardPath: 'images/crew_missions/cards/port_contraband_manifest.png',
    imageScenePath: 'images/crew_missions/scenes/port_contraband_manifest.png',
    tradeRequirements: [
      { goodType: 'contraband_tobacco', quantity: 35 },
      { goodType: 'contraband_coffee', quantity: 20 },
    ],
  },
  {
    missionKey: 'warehouse_luxury_offload',
    tier: 2,
    titleNl: 'Magazijn Luxe Offload',
    titleEn: 'Warehouse Luxury Offload',
    descriptionNl:
      'Sla luxe contraband via een frontbedrijf in het crew-magazijn. Parfum en horloges uit crew-opslag vereist.',
    descriptionEn:
      'Offload luxury contraband through a front warehouse. Requires perfume and watches from crew storage.',
    durationSeconds: 18 * 60,
    cooldownSeconds: 20 * 60,
    successChance: 0.58,
    rewardCashMin: 115000,
    rewardCashMax: 172000,
    rewardCrewXp: 118,
    rewardPersonalXp: 59,
    failPenaltyPct: 0.16,
    sortOrder: 33,
    imageCardPath: 'images/crew_missions/cards/warehouse_luxury_offload.png',
    imageScenePath: 'images/crew_missions/scenes/warehouse_luxury_offload.png',
    tradeRequirements: [
      { goodType: 'contraband_perfume', quantity: 12 },
      { goodType: 'contraband_luxury_watches', quantity: 5 },
    ],
  },
  {
    missionKey: 'territory_blackout_push',
    tier: 3,
    titleNl: 'Territory Blackout Push',
    titleEn: 'Territory Blackout Push',
    descriptionNl:
      'Dwing een tijdelijke blackout op een hot territory-front: sensors, relays en rival intel platleggen.',
    descriptionEn:
      'Force a temporary blackout on a hot territory front: knock out sensors, relays and rival intel.',
    durationSeconds: 32 * 60,
    cooldownSeconds: 34 * 60,
    successChance: 0.5,
    rewardCashMin: 250000,
    rewardCashMax: 380000,
    rewardCrewXp: 240,
    rewardPersonalXp: 120,
    failPenaltyPct: 0.22,
    sortOrder: 69,
    imageCardPath: 'images/crew_missions/cards/territory_blackout_push.png',
    imageScenePath: 'images/crew_missions/scenes/territory_blackout_push.png',
  },
  {
    missionKey: 'chop_shop_handoff',
    tier: 1,
    titleNl: 'Chop Shop Overdracht',
    titleEn: 'Chop Shop Handoff',
    descriptionNl: 'Lever een crew-auto af bij de chop shop. Conditie en brandstof uit de gedeelde stalling tellen mee.',
    descriptionEn: 'Drop a crew car at the chop shop. Shared-storage condition and fuel affect the odds.',
    durationSeconds: 8 * 60,
    cooldownSeconds: 10 * 60,
    successChance: 0.72,
    rewardCashMin: 48000,
    rewardCashMax: 75000,
    rewardCrewXp: 56,
    rewardPersonalXp: 28,
    failPenaltyPct: 0.08,
    sortOrder: 80,
    imageCardPath: 'images/crew_missions/cards/chop_shop_handoff.png',
    imageScenePath: 'images/crew_missions/scenes/chop_shop_handoff.png',
    storageRequirements: [
      { kind: 'vehicle', quantity: 1, vehicleCategory: 'car', minCondition: 40, minFuel: 30 },
    ],
  },
  {
    missionKey: 'lockbox_crowbar_shift',
    tier: 1,
    titleNl: 'Kluis Koevoetshift',
    titleEn: 'Lockbox Crowbar Shift',
    descriptionNl: 'Wrik een straatkluis open met een koevoet uit de gereedschapopslag.',
    descriptionEn: 'Crack a street lockbox with a crowbar from crew tool storage.',
    durationSeconds: 8 * 60,
    cooldownSeconds: 10 * 60,
    successChance: 0.74,
    rewardCashMin: 45000,
    rewardCashMax: 70000,
    rewardCrewXp: 54,
    rewardPersonalXp: 27,
    failPenaltyPct: 0.08,
    sortOrder: 81,
    imageCardPath: 'images/crew_missions/cards/lockbox_crowbar_shift.png',
    imageScenePath: 'images/crew_missions/scenes/lockbox_crowbar_shift.png',
    storageRequirements: [{ kind: 'tool', quantity: 1, toolId: 'crowbar', minDurability: 25 }],
  },
  {
    missionKey: 'alley_tag_run',
    tier: 1,
    titleNl: 'Steeg Tag Run',
    titleEn: 'Alley Tag Run',
    descriptionNl: 'Zet crew-tags in drie stegen. Eén spuitbus uit de gereedschapopslag gaat op.',
    descriptionEn: 'Tag three alleys for the crew. One spray can from tool storage is spent.',
    durationSeconds: 8 * 60,
    cooldownSeconds: 10 * 60,
    successChance: 0.76,
    rewardCashMin: 42000,
    rewardCashMax: 65000,
    rewardCrewXp: 50,
    rewardPersonalXp: 24,
    failPenaltyPct: 0.07,
    sortOrder: 82,
    imageCardPath: 'images/crew_missions/cards/alley_tag_run.png',
    imageScenePath: 'images/crew_missions/scenes/alley_tag_run.png',
    storageRequirements: [{ kind: 'tool', quantity: 1, toolId: 'spray_paint', minDurability: 1 }],
  },
  {
    missionKey: 'bike_drop_off',
    tier: 1,
    titleNl: 'Motor Drop-off',
    titleEn: 'Bike Drop-Off',
    descriptionNl: 'Zet een crew-motor neer voor een stille wissel. Gedeelde stalling, geen privé-garage.',
    descriptionEn: 'Park a crew motorcycle for a quiet swap. Shared storage only, not your private garage.',
    durationSeconds: 9 * 60,
    cooldownSeconds: 11 * 60,
    successChance: 0.71,
    rewardCashMin: 50000,
    rewardCashMax: 78000,
    rewardCrewXp: 58,
    rewardPersonalXp: 29,
    failPenaltyPct: 0.09,
    sortOrder: 83,
    imageCardPath: 'images/crew_missions/cards/bike_drop_off.png',
    imageScenePath: 'images/crew_missions/scenes/bike_drop_off.png',
    storageRequirements: [
      { kind: 'vehicle', quantity: 1, vehicleCategory: 'motorcycle', minCondition: 30, minFuel: 20 },
    ],
  },
  {
    missionKey: 'dock_rowboat_nudge',
    tier: 1,
    titleNl: 'Haven Roeibootduw',
    titleEn: 'Dock Rowboat Nudge',
    descriptionNl: 'Schuif een crew-boot langs de kade voor een nachtelijke overdracht.',
    descriptionEn: 'Nudge a crew boat along the dock for a night handoff.',
    durationSeconds: 9 * 60,
    cooldownSeconds: 11 * 60,
    successChance: 0.7,
    rewardCashMin: 52000,
    rewardCashMax: 80000,
    rewardCrewXp: 60,
    rewardPersonalXp: 30,
    failPenaltyPct: 0.09,
    sortOrder: 84,
    imageCardPath: 'images/crew_missions/cards/dock_rowboat_nudge.png',
    imageScenePath: 'images/crew_missions/scenes/dock_rowboat_nudge.png',
    storageRequirements: [
      { kind: 'vehicle', quantity: 1, vehicleCategory: 'boat', minCondition: 30, minFuel: 20 },
    ],
  },
  {
    missionKey: 'street_stash_move',
    tier: 1,
    titleNl: 'Straatstash Verplaatsen',
    titleEn: 'Street Stash Move',
    descriptionNl: 'Verplaats 80 gram drugs uit de crew-opslag. Kwaliteit stuurt de slagingskans.',
    descriptionEn: 'Move 80g of drugs from crew storage. Quality changes the success chance.',
    durationSeconds: 10 * 60,
    cooldownSeconds: 12 * 60,
    successChance: 0.69,
    rewardCashMin: 55000,
    rewardCashMax: 82000,
    rewardCrewXp: 64,
    rewardPersonalXp: 32,
    failPenaltyPct: 0.1,
    sortOrder: 85,
    imageCardPath: 'images/crew_missions/cards/street_stash_move.png',
    imageScenePath: 'images/crew_missions/scenes/street_stash_move.png',
    storageRequirements: [{ kind: 'drug', quantity: 80 }],
  },
  {
    missionKey: 'pistol_night_run',
    tier: 2,
    titleNl: 'Pistool Nachtrit',
    titleEn: 'Pistol Night Run',
    descriptionNl: 'Nachtelijke escort met een pistool uit de wapenopslag plus bijpassende munitie.',
    descriptionEn: 'Night escort with a crew handgun plus matching ammo from storage.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.62,
    rewardCashMin: 100000,
    rewardCashMax: 150000,
    rewardCrewXp: 105,
    rewardPersonalXp: 52,
    failPenaltyPct: 0.14,
    sortOrder: 90,
    imageCardPath: 'images/crew_missions/cards/pistol_night_run.png',
    imageScenePath: 'images/crew_missions/scenes/pistol_night_run.png',
    storageRequirements: [
      { kind: 'weapon', quantity: 1, weaponType: 'handgun', minCondition: 40 },
      { kind: 'ammo', quantity: 24, matchWeapon: true },
    ],
  },
  {
    missionKey: 'shotgun_door_kick',
    tier: 2,
    titleNl: 'Shotgun Deurtrap',
    titleEn: 'Shotgun Door Kick',
    descriptionNl: 'Breek een magazijndeur met een shotgun en 12-gauge uit crew-opslag.',
    descriptionEn: 'Kick a warehouse door with a crew shotgun and 12-gauge ammo.',
    durationSeconds: 17 * 60,
    cooldownSeconds: 19 * 60,
    successChance: 0.6,
    rewardCashMin: 108000,
    rewardCashMax: 158000,
    rewardCrewXp: 112,
    rewardPersonalXp: 56,
    failPenaltyPct: 0.15,
    sortOrder: 91,
    imageCardPath: 'images/crew_missions/cards/shotgun_door_kick.png',
    imageScenePath: 'images/crew_missions/scenes/shotgun_door_kick.png',
    storageRequirements: [
      { kind: 'weapon', quantity: 1, weaponType: 'shotgun', minCondition: 45 },
      { kind: 'ammo', quantity: 12, ammoType: '12gauge' },
    ],
  },
  {
    missionKey: 'harbor_skiff_lift',
    tier: 2,
    titleNl: 'Haven Skiff Lift',
    titleEn: 'Harbor Skiff Lift',
    descriptionNl: 'Til lading met een stille crew-boot. Stealth en cargo van de catalogus tellen mee.',
    descriptionEn: 'Lift cargo with a quiet crew boat. Catalog stealth and cargo change the odds.',
    durationSeconds: 18 * 60,
    cooldownSeconds: 20 * 60,
    successChance: 0.58,
    rewardCashMin: 115000,
    rewardCashMax: 168000,
    rewardCrewXp: 118,
    rewardPersonalXp: 58,
    failPenaltyPct: 0.16,
    sortOrder: 92,
    imageCardPath: 'images/crew_missions/cards/harbor_skiff_lift.png',
    imageScenePath: 'images/crew_missions/scenes/harbor_skiff_lift.png',
    storageRequirements: [
      {
        kind: 'vehicle',
        quantity: 1,
        vehicleCategory: 'boat',
        minCondition: 45,
        minFuel: 45,
        minStealth: 30,
        minCargo: 30,
      },
    ],
  },
  {
    missionKey: 'courier_bike_cut',
    tier: 2,
    titleNl: 'Koerier Motor Cut',
    titleEn: 'Courier Bike Cut',
    descriptionNl: 'Snijd een koerier af met een snelle, stille crew-motor.',
    descriptionEn: 'Cut off a courier with a fast, quiet crew motorcycle.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.61,
    rewardCashMin: 102000,
    rewardCashMax: 152000,
    rewardCrewXp: 108,
    rewardPersonalXp: 54,
    failPenaltyPct: 0.14,
    sortOrder: 93,
    imageCardPath: 'images/crew_missions/cards/courier_bike_cut.png',
    imageScenePath: 'images/crew_missions/scenes/courier_bike_cut.png',
    storageRequirements: [
      {
        kind: 'vehicle',
        quantity: 1,
        vehicleCategory: 'motorcycle',
        minCondition: 40,
        minFuel: 30,
        minSpeed: 40,
        minStealth: 30,
      },
    ],
  },
  {
    missionKey: 'burglary_kit_window',
    tier: 2,
    titleNl: 'Inbraakset Raam',
    titleEn: 'Burglary Kit Window',
    descriptionNl: 'Open een kantoorraam met de inbrekersset uit de gereedschapopslag.',
    descriptionEn: 'Open an office window with a burglary kit from crew tool storage.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.63,
    rewardCashMin: 98000,
    rewardCashMax: 148000,
    rewardCrewXp: 104,
    rewardPersonalXp: 52,
    failPenaltyPct: 0.14,
    sortOrder: 94,
    imageCardPath: 'images/crew_missions/cards/burglary_kit_window.png',
    imageScenePath: 'images/crew_missions/scenes/burglary_kit_window.png',
    storageRequirements: [{ kind: 'tool', quantity: 1, toolId: 'burglary_kit', minDurability: 35 }],
  },
  {
    missionKey: 'bolt_cutter_fence',
    tier: 2,
    titleNl: 'Betonschaar Hek',
    titleEn: 'Bolt Cutter Fence',
    descriptionNl: 'Knip het haventerrein open met een betonschaar uit de crew-opslag.',
    descriptionEn: 'Cut the harbor fence with bolt cutters from crew storage.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.64,
    rewardCashMin: 95000,
    rewardCashMax: 145000,
    rewardCrewXp: 102,
    rewardPersonalXp: 50,
    failPenaltyPct: 0.13,
    sortOrder: 95,
    imageCardPath: 'images/crew_missions/cards/bolt_cutter_fence.png',
    imageScenePath: 'images/crew_missions/scenes/bolt_cutter_fence.png',
    storageRequirements: [{ kind: 'tool', quantity: 1, toolId: 'bolt_cutter', minDurability: 30 }],
  },
  {
    missionKey: 'weed_van_run',
    tier: 2,
    titleNl: 'Wietbus Rit',
    titleEn: 'Weed Van Run',
    descriptionNl: 'Rij 200 gram wiet weg in een crew-auto. Cargo van de auto telt mee.',
    descriptionEn: 'Move 200g of weed in a crew car. The car catalog cargo rating matters.',
    durationSeconds: 18 * 60,
    cooldownSeconds: 20 * 60,
    successChance: 0.57,
    rewardCashMin: 118000,
    rewardCashMax: 172000,
    rewardCrewXp: 120,
    rewardPersonalXp: 60,
    failPenaltyPct: 0.16,
    sortOrder: 96,
    imageCardPath: 'images/crew_missions/cards/weed_van_run.png',
    imageScenePath: 'images/crew_missions/scenes/weed_van_run.png',
    storageRequirements: [
      { kind: 'drug', quantity: 200, drugType: 'weed' },
      { kind: 'vehicle', quantity: 1, vehicleCategory: 'car', minCondition: 35, minFuel: 25, minCargo: 35 },
    ],
  },
  {
    missionKey: 'ammo_cache_shuffle',
    tier: 2,
    titleNl: 'Munitiecache Shuffle',
    titleEn: 'Ammo Cache Shuffle',
    descriptionNl: 'Verplaats 80 stuks 9mm uit de crew-munitieopslag. Die munitie gaat op.',
    descriptionEn: 'Shuffle 80 rounds of 9mm from crew ammo storage. The ammo is spent.',
    durationSeconds: 16 * 60,
    cooldownSeconds: 18 * 60,
    successChance: 0.62,
    rewardCashMin: 100000,
    rewardCashMax: 148000,
    rewardCrewXp: 106,
    rewardPersonalXp: 53,
    failPenaltyPct: 0.14,
    sortOrder: 97,
    imageCardPath: 'images/crew_missions/cards/ammo_cache_shuffle.png',
    imageScenePath: 'images/crew_missions/scenes/ammo_cache_shuffle.png',
    storageRequirements: [{ kind: 'ammo', quantity: 80, ammoType: '9mm' }],
  },
  {
    missionKey: 'armored_payroll_escort',
    tier: 3,
    titleNl: 'Pantser Payroll Escort',
    titleEn: 'Armored Payroll Escort',
    descriptionNl: 'Escort een payroll met een gepantserde crew-auto, een geweer en bijpassende munitie.',
    descriptionEn: 'Escort a payroll with an armored crew car, a rifle, and matching ammo.',
    durationSeconds: 32 * 60,
    cooldownSeconds: 34 * 60,
    successChance: 0.5,
    rewardCashMin: 280000,
    rewardCashMax: 410000,
    rewardCrewXp: 250,
    rewardPersonalXp: 125,
    failPenaltyPct: 0.22,
    sortOrder: 110,
    imageCardPath: 'images/crew_missions/cards/armored_payroll_escort.png',
    imageScenePath: 'images/crew_missions/scenes/armored_payroll_escort.png',
    storageRequirements: [
      {
        kind: 'vehicle',
        quantity: 1,
        vehicleCategory: 'car',
        minCondition: 55,
        minFuel: 50,
        minArmor: 45,
      },
      { kind: 'weapon', quantity: 1, weaponType: 'rifle', minCondition: 50 },
      { kind: 'ammo', quantity: 40, matchWeapon: true },
    ],
  },
  {
    missionKey: 'lab_grade_swap',
    tier: 3,
    titleNl: 'Lab Grade Swap',
    titleEn: 'Lab-Grade Swap',
    descriptionNl: 'Wissel 150 gram cocaïne van minstens kwaliteit B met een laptop of glassnijder uit de opslag.',
    descriptionEn: 'Swap 150g of cocaine at quality B or better with a laptop or glass cutter from storage.',
    durationSeconds: 30 * 60,
    cooldownSeconds: 32 * 60,
    successChance: 0.52,
    rewardCashMin: 260000,
    rewardCashMax: 390000,
    rewardCrewXp: 235,
    rewardPersonalXp: 118,
    failPenaltyPct: 0.2,
    sortOrder: 111,
    imageCardPath: 'images/crew_missions/cards/lab_grade_swap.png',
    imageScenePath: 'images/crew_missions/scenes/lab_grade_swap.png',
    storageRequirements: [
      { kind: 'drug', quantity: 150, drugType: 'cocaine', minQuality: 'B' },
      { kind: 'tool', quantity: 1, toolIds: ['hacking_laptop', 'glass_cutter'], minDurability: 25 },
    ],
  },
  {
    missionKey: 'yacht_glass_cut',
    tier: 3,
    titleNl: 'Jacht Glassnede',
    titleEn: 'Yacht Glass Cut',
    descriptionNl: 'Snijd een jachtvitrine open vanaf een stille, ruime crew-boot.',
    descriptionEn: 'Cut a yacht display case from a quiet, high-cargo crew boat.',
    durationSeconds: 34 * 60,
    cooldownSeconds: 36 * 60,
    successChance: 0.48,
    rewardCashMin: 300000,
    rewardCashMax: 420000,
    rewardCrewXp: 260,
    rewardPersonalXp: 130,
    failPenaltyPct: 0.22,
    sortOrder: 112,
    imageCardPath: 'images/crew_missions/cards/yacht_glass_cut.png',
    imageScenePath: 'images/crew_missions/scenes/yacht_glass_cut.png',
    storageRequirements: [
      {
        kind: 'vehicle',
        quantity: 1,
        vehicleCategory: 'boat',
        minCondition: 50,
        minFuel: 45,
        minCargo: 50,
        minStealth: 45,
      },
      { kind: 'tool', quantity: 1, toolId: 'glass_cutter', minDurability: 30 },
    ],
  },
  {
    missionKey: 'hotwire_convoy_cut',
    tier: 3,
    titleNl: 'Hotwire Convoy Cut',
    titleEn: 'Hotwire Convoy Cut',
    descriptionNl: 'Snijd een convoy af met een snelle crew-auto en autodiefstal-gereedschap.',
    descriptionEn: 'Cut a convoy with a high-speed crew car and car-theft tools.',
    durationSeconds: 30 * 60,
    cooldownSeconds: 32 * 60,
    successChance: 0.51,
    rewardCashMin: 255000,
    rewardCashMax: 380000,
    rewardCrewXp: 230,
    rewardPersonalXp: 115,
    failPenaltyPct: 0.2,
    sortOrder: 113,
    imageCardPath: 'images/crew_missions/cards/hotwire_convoy_cut.png',
    imageScenePath: 'images/crew_missions/scenes/hotwire_convoy_cut.png',
    storageRequirements: [
      {
        kind: 'vehicle',
        quantity: 1,
        vehicleCategory: 'car',
        minCondition: 50,
        minFuel: 45,
        minSpeed: 55,
      },
      { kind: 'tool', quantity: 1, toolId: 'car_theft_tools', minDurability: 30 },
    ],
  },
  {
    missionKey: 'smg_warehouse_push',
    tier: 3,
    titleNl: 'SMG Magazijn Push',
    titleEn: 'SMG Warehouse Push',
    descriptionNl: 'Duw een magazijn leeg met een automatisch wapen en 60 bijpassende patronen.',
    descriptionEn: 'Push a warehouse with an automatic weapon and 60 matching rounds.',
    durationSeconds: 32 * 60,
    cooldownSeconds: 34 * 60,
    successChance: 0.49,
    rewardCashMin: 270000,
    rewardCashMax: 400000,
    rewardCrewXp: 245,
    rewardPersonalXp: 122,
    failPenaltyPct: 0.21,
    sortOrder: 114,
    imageCardPath: 'images/crew_missions/cards/smg_warehouse_push.png',
    imageScenePath: 'images/crew_missions/scenes/smg_warehouse_push.png',
    storageRequirements: [
      { kind: 'weapon', quantity: 1, weaponType: 'automatic', minCondition: 50 },
      { kind: 'ammo', quantity: 60, matchWeapon: true },
    ],
  },
  {
    missionKey: 'precursor_boat_run',
    tier: 3,
    titleNl: 'Precursor Boot Run',
    titleEn: 'Precursor Boat Run',
    descriptionNl: 'Vaar 250 gram drugs van minstens kwaliteit A weg op een ruime crew-boot.',
    descriptionEn: 'Ship 250g of drugs at quality A or better on a high-cargo crew boat.',
    durationSeconds: 36 * 60,
    cooldownSeconds: 38 * 60,
    successChance: 0.46,
    rewardCashMin: 310000,
    rewardCashMax: 420000,
    rewardCrewXp: 270,
    rewardPersonalXp: 135,
    failPenaltyPct: 0.24,
    sortOrder: 115,
    imageCardPath: 'images/crew_missions/cards/precursor_boat_run.png',
    imageScenePath: 'images/crew_missions/scenes/precursor_boat_run.png',
    storageRequirements: [
      { kind: 'drug', quantity: 250, minQuality: 'A' },
      {
        kind: 'vehicle',
        quantity: 1,
        vehicleCategory: 'boat',
        minCondition: 50,
        minFuel: 45,
        minCargo: 55,
      },
    ],
  },
];

const ROLE_KEYS = ['planner', 'enforcer', 'logistics', 'tech'] as const;
const MAX_ROLE_SUCCESS_BONUS = 0.12;
const MAX_ROLE_DURATION_REDUCTION = 0.08;

function toDate(value: unknown): Date {
  if (value instanceof Date) return value;
  return new Date(String(value));
}

function toInt(value: unknown, fallback = 0): number {
  const parsed = Number.parseInt(String(value ?? ''), 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function toFloat(value: unknown, fallback = 0): number {
  const parsed = Number.parseFloat(String(value ?? ''));
  return Number.isFinite(parsed) ? parsed : fallback;
}

function clamp(value: number, min: number, max: number): number {
  return Math.min(max, Math.max(min, value));
}

function serializeSeedRequirements(seed: MissionSeed): string {
  if (seed.storageRequirements?.length) {
    return serializeMissionRequirements(seed.storageRequirements);
  }
  return serializeMissionRequirements(
    (seed.tradeRequirements ?? []).map((item) => ({
      kind: 'trade' as const,
      goodType: item.goodType,
      quantity: item.quantity,
    }))
  );
}

function computeHqGlobalLevel(
  style: string | null | undefined,
  level: number | null | undefined
): number {
  const normalizedStyle = (style || 'camping').toLowerCase();
  const normalizedLevel = Math.max(0, level ?? 0);
  if (normalizedStyle === 'vip') {
    return 16 + normalizedLevel;
  }
  const styleOrder = ['camping', 'rural', 'city', 'villa'];
  const index = styleOrder.indexOf(normalizedStyle);
  return (index >= 0 ? index : 0) * 4 + normalizedLevel;
}

async function ensureRuntimeConfigTable(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS runtime_config (
      configKey VARCHAR(120) NOT NULL PRIMARY KEY,
      configValue VARCHAR(255) NOT NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
}

async function getRuntimeConfig(): Promise<RuntimeCrewMissionConfig> {
  const defaults = { ...CREW_MISSION_RUNTIME_SETTING_DEFAULTS };
  try {
    await ensureRuntimeConfigTable();
    const placeholders = CREW_MISSION_RUNTIME_SETTING_KEYS.map(() => '?').join(', ');
    const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...CREW_MISSION_RUNTIME_SETTING_KEYS
    );

    for (const row of rows) {
      defaults[row.configKey as keyof typeof defaults] = String(row.configValue ?? '');
    }
  } catch {
    // Keep defaults only when runtime config table is unavailable.
  }

  return {
    t1CreditsPerMinute: clamp(toInt(defaults.CREW_MISSION_T1_CREDITS_PER_MINUTE, 5), 1, 20),
    t2CreditsPerMinute: clamp(toInt(defaults.CREW_MISSION_T2_CREDITS_PER_MINUTE, 6), 1, 20),
    t3CreditsPerMinute: clamp(toInt(defaults.CREW_MISSION_T3_CREDITS_PER_MINUTE, 7), 1, 20),
    repeatWindowMinutes: clamp(toInt(defaults.CREW_MISSION_REPEAT_WINDOW_MINUTES, 90), 15, 360),
    repeat2Multiplier: clamp(toFloat(defaults.CREW_MISSION_REPEAT_2_MULTIPLIER, 0.93), 0.5, 1),
    repeat3Multiplier: clamp(toFloat(defaults.CREW_MISSION_REPEAT_3_MULTIPLIER, 0.86), 0.5, 1),
    repeat4Multiplier: clamp(toFloat(defaults.CREW_MISSION_REPEAT_4_MULTIPLIER, 0.8), 0.5, 1),
    crewLevelBaseXp: clamp(toInt(defaults.CREW_MISSION_CREW_LEVEL_BASE_XP, 400), 100, 20000),
    crewLevelStepXp: clamp(toInt(defaults.CREW_MISSION_CREW_LEVEL_STEP_XP, 150), 10, 5000),
    crewLevelCashBonusPerLevelPct: clamp(
      toFloat(defaults.CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT, 1),
      0,
      10
    ),
    crewLevelCashBonusCapPct: clamp(
      toFloat(defaults.CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT, 15),
      0,
      100
    ),
    clearingHouseMinMissionLevel: clamp(
      toInt(defaults.CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL, 0),
      0,
      50
    ),
  };
}

type CrewMissionProgress = {
  level: number;
  totalXp: number;
  xpIntoLevel: number;
  xpForNextLevel: number;
  progressPct: number;
  cashRewardBonusPct: number;
  nextLevelCashRewardBonusPct: number;
};

function xpNeededForCrewMissionNextLevel(
  level: number,
  cfg: Pick<RuntimeCrewMissionConfig, 'crewLevelBaseXp' | 'crewLevelStepXp'>
): number {
  const safeLevel = Math.max(1, level);
  return Math.max(100, cfg.crewLevelBaseXp + (safeLevel - 1) * cfg.crewLevelStepXp);
}

function getCrewMissionCashBonusPct(
  level: number,
  cfg: Pick<RuntimeCrewMissionConfig, 'crewLevelCashBonusPerLevelPct' | 'crewLevelCashBonusCapPct'>
): number {
  if (level <= 1) return 0;
  const raw = (level - 1) * cfg.crewLevelCashBonusPerLevelPct;
  return clamp(raw, 0, cfg.crewLevelCashBonusCapPct);
}

function computeCrewMissionProgress(
  totalXpRaw: number,
  cfg: Pick<
    RuntimeCrewMissionConfig,
    | 'crewLevelBaseXp'
    | 'crewLevelStepXp'
    | 'crewLevelCashBonusPerLevelPct'
    | 'crewLevelCashBonusCapPct'
  >
): CrewMissionProgress {
  const totalXp = Math.max(0, Math.trunc(totalXpRaw));
  let level = 1;
  let xpInLevel = totalXp;
  let needed = xpNeededForCrewMissionNextLevel(level, cfg);

  while (xpInLevel >= needed && level < 250) {
    xpInLevel -= needed;
    level += 1;
    needed = xpNeededForCrewMissionNextLevel(level, cfg);
  }

  const currentBonus = getCrewMissionCashBonusPct(level, cfg);
  const nextBonus = getCrewMissionCashBonusPct(level + 1, cfg);

  return {
    level,
    totalXp,
    xpIntoLevel: xpInLevel,
    xpForNextLevel: needed,
    progressPct: needed > 0 ? clamp((xpInLevel / needed) * 100, 0, 100) : 100,
    cashRewardBonusPct: currentBonus,
    nextLevelCashRewardBonusPct: nextBonus,
  };
}

async function upsertRuntimeConfigValues(updates: Record<string, string>): Promise<void> {
  await ensureRuntimeConfigTable();
  for (const [key, value] of Object.entries(updates)) {
    await prisma.$executeRawUnsafe(
      `
        INSERT INTO runtime_config (configKey, configValue)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE configValue = VALUES(configValue)
      `,
      key,
      String(value)
    );
  }
}

async function getCrewMembership(playerId: number): Promise<{ crewId: number; role: string }> {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });

  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }
  return membership;
}

function ensureMissionManagerRole(role: string): void {
  if (role !== 'leader' && role !== 'co_leader') {
    throw new Error('MISSION_PERMISSION_DENIED');
  }
}

async function getCrewContext(
  crewId: number,
  cfg: RuntimeCrewMissionConfig
): Promise<{ hqGlobalLevel: number; memberCount: number; crewProgress: CrewMissionProgress }> {
  const [hq, memberCount, crew] = await Promise.all([
    prisma.crewHqBuilding.findUnique({
      where: { crewId },
      select: { style: true, level: true },
    }),
    prisma.crewMember.count({ where: { crewId } }),
    prisma.crew.findUnique({
      where: { id: crewId },
      select: { missionXp: true, missionLevel: true },
    }),
  ]);

  const storedXp = Math.max(0, toInt(crew?.missionXp, 0));
  const computedProgress = computeCrewMissionProgress(storedXp, cfg);
  const normalizedLevel = Math.max(toInt(crew?.missionLevel, 1), computedProgress.level);
  const crewProgress =
    normalizedLevel === computedProgress.level
      ? computedProgress
      : {
          ...computedProgress,
          level: normalizedLevel,
          cashRewardBonusPct: getCrewMissionCashBonusPct(normalizedLevel, cfg),
          nextLevelCashRewardBonusPct: getCrewMissionCashBonusPct(normalizedLevel + 1, cfg),
        };

  return {
    hqGlobalLevel: computeHqGlobalLevel(hq?.style, hq?.level),
    memberCount,
    crewProgress,
  };
}

function missionTierUnlocked(
  tier: CrewMissionTier,
  hqGlobalLevel: number,
  memberCount: number
): boolean {
  if (tier === 1) {
    return hqGlobalLevel >= 1;
  }
  if (tier === 2) {
    return hqGlobalLevel >= 5 && memberCount >= 2;
  }
  return hqGlobalLevel >= 9 && memberCount >= 3;
}

function getTierUnlockReason(tier: CrewMissionTier): string {
  if (tier === 2) return 'TIER2_REQUIRES_HQ5_AND_2_MEMBERS';
  if (tier === 3) return 'TIER3_REQUIRES_HQ9_AND_3_MEMBERS';
  return 'TIER1_REQUIRES_HQ1';
}

/** Tier gates + optional per-mission Phase-2 gates (Clearing House mission level). */
function getMissionUnlockState(
  template: Pick<CrewMissionTemplate, 'missionKey' | 'tier'>,
  crewContext: { hqGlobalLevel: number; memberCount: number; crewProgress: CrewMissionProgress },
  cfg: RuntimeCrewMissionConfig
): { unlocked: boolean; lockedReason: string | null } {
  if (!missionTierUnlocked(template.tier, crewContext.hqGlobalLevel, crewContext.memberCount)) {
    return { unlocked: false, lockedReason: getTierUnlockReason(template.tier) };
  }

  if (template.missionKey === 'clearing_house_vault_run') {
    const minLevel = cfg.clearingHouseMinMissionLevel;
    if (minLevel > 0 && crewContext.crewProgress.level < minLevel) {
      return {
        unlocked: false,
        lockedReason: `CLEARING_HOUSE_REQUIRES_MISSION_LEVEL_${minLevel}`,
      };
    }
  }

  return { unlocked: true, lockedReason: null };
}

async function getCrewMemberIds(crewId: number): Promise<number[]> {
  const members = await prisma.crewMember.findMany({
    where: { crewId },
    select: { playerId: true },
  });
  return members.map((member) => member.playerId);
}

async function getMissionContributionsByRunIds(
  runIds: number[]
): Promise<Record<number, MissionContributionViewRow[]>> {
  const safeRunIds = Array.from(new Set(runIds.map((id) => toInt(id, 0)).filter((id) => id > 0)));
  if (safeRunIds.length === 0) {
    return {};
  }

  const placeholders = safeRunIds.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<MissionContributionViewRow[]>(
    `
      SELECT
        c.runId,
        c.playerId,
        c.roleKey,
        c.contributionScore,
        c.payoutMultiplier,
        c.rewardCash,
        c.rewardXp,
        p.username
      FROM crew_mission_contributions c
      LEFT JOIN players p ON p.id = c.playerId
      WHERE c.runId IN (${placeholders})
      ORDER BY c.runId ASC, c.contributionScore DESC, c.id ASC
    `,
    ...safeRunIds
  );

  const byRunId: Record<number, MissionContributionViewRow[]> = {};
  for (const row of rows) {
    const normalized: MissionContributionViewRow = {
      runId: toInt(row.runId),
      playerId: toInt(row.playerId),
      roleKey: String(row.roleKey || ''),
      contributionScore: toFloat(row.contributionScore, 1),
      payoutMultiplier: row.payoutMultiplier === null ? null : toFloat(row.payoutMultiplier, 1),
      rewardCash: row.rewardCash === null ? null : toInt(row.rewardCash, 0),
      rewardXp: row.rewardXp === null ? null : toInt(row.rewardXp, 0),
      username: row.username ?? null,
    };
    if (!byRunId[normalized.runId]) {
      byRunId[normalized.runId] = [];
    }
    byRunId[normalized.runId].push(normalized);
  }

  return byRunId;
}

async function sendCrewMissionStartedNotifications(
  crewId: number,
  run: CrewMissionRun,
  startedByPlayerId: number
): Promise<void> {
  const [crew, startedBy, memberIds] = await Promise.all([
    prisma.crew.findUnique({
      where: { id: crewId },
      select: { name: true },
    }),
    prisma.player.findUnique({
      where: { id: startedByPlayerId },
      select: { username: true },
    }),
    getCrewMemberIds(crewId),
  ]);

  if (memberIds.length === 0) {
    return;
  }

  const crewName = crew?.name ?? `#${crewId}`;
  const starterName = startedBy?.username ?? `#${startedByPlayerId}`;

  await Promise.allSettled(
    memberIds.map((playerId) =>
      notificationService.sendCrewMissionStartedNotification(
        playerId,
        run.id,
        crewName,
        run.titleNl,
        run.titleEn,
        starterName,
        run.endsAt
      )
    )
  );
}

async function sendCrewMissionResolvedNotifications(
  crewId: number,
  run: CrewMissionRun
): Promise<void> {
  const [crew, memberIds] = await Promise.all([
    prisma.crew.findUnique({
      where: { id: crewId },
      select: { name: true },
    }),
    getCrewMemberIds(crewId),
  ]);

  if (memberIds.length === 0 || !run.outcome) {
    return;
  }

  const crewName = crew?.name ?? `#${crewId}`;

  await Promise.allSettled(
    memberIds.map((playerId) =>
      notificationService.sendCrewMissionResolvedNotification(
        playerId,
        run.id,
        crewName,
        run.titleNl,
        run.titleEn,
        run.outcome,
        run.rewardCrewCash,
        run.rewardCrewXp,
        run.cooldownUntil
      )
    )
  );
}

async function sendCrewMissionCooldownReadyNotifications(
  crewId: number,
  runId: number,
  missionTitleNl: string,
  missionTitleEn: string
): Promise<void> {
  const [crew, memberIds] = await Promise.all([
    prisma.crew.findUnique({
      where: { id: crewId },
      select: { name: true },
    }),
    getCrewMemberIds(crewId),
  ]);

  if (memberIds.length === 0) {
    return;
  }

  const crewName = crew?.name ?? `#${crewId}`;

  await Promise.allSettled(
    memberIds.map((playerId) =>
      notificationService.sendCrewMissionCooldownReadyNotification(
        playerId,
        runId,
        crewName,
        missionTitleNl,
        missionTitleEn
      )
    )
  );
}

async function getActiveRunForCrew(crewId: number): Promise<CrewMissionRun | null> {
  const rows = await prisma.$queryRawUnsafe<CrewMissionRun[]>(
    `
      SELECT
        r.id, r.crewId, r.templateId, r.startedByPlayerId, r.status, r.startedAt, r.endsAt, r.resolvedAt,
        r.cooldownUntil, r.outcome, r.progressPct, r.successRoll, r.successChance, r.rewardMultiplier,
        r.rewardCrewCash, r.rewardCrewXp, r.rewardPersonalXp, r.rewardsClaimedAt, r.rewardsClaimedByPlayerId,
        r.metadataJson,
        t.missionKey, t.tier, t.titleNl, t.titleEn
      FROM crew_mission_runs r
      INNER JOIN crew_mission_templates t ON t.id = r.templateId
      WHERE r.crewId = ?
        AND (
          r.status = 'in_progress'
          OR (r.status = 'completed' AND r.cooldownUntil IS NOT NULL AND r.cooldownUntil > NOW(3))
        )
      ORDER BY r.id DESC
      LIMIT 1
    `,
    crewId
  );

  if (!rows[0]) return null;
  return normalizeRunRow(rows[0]);
}

function normalizeRunRow(row: CrewMissionRun): CrewMissionRun {
  return {
    ...row,
    startedAt: toDate(row.startedAt),
    endsAt: toDate(row.endsAt),
    resolvedAt: row.resolvedAt ? toDate(row.resolvedAt) : null,
    cooldownUntil: row.cooldownUntil ? toDate(row.cooldownUntil) : null,
    rewardsClaimedAt: row.rewardsClaimedAt ? toDate(row.rewardsClaimedAt) : null,
    progressPct: toInt(row.progressPct),
    successRoll: row.successRoll === null ? null : toFloat(row.successRoll),
    successChance: row.successChance === null ? null : toFloat(row.successChance),
    rewardMultiplier: toFloat(row.rewardMultiplier, 1),
    rewardCrewCash: toInt(row.rewardCrewCash),
    rewardCrewXp: toInt(row.rewardCrewXp),
    rewardPersonalXp: toInt(row.rewardPersonalXp),
    tier: toInt(row.tier) as CrewMissionTier,
  };
}

function computeRoleBonuses(roleKeys: string[]): {
  successBonus: number;
  durationReduction: number;
} {
  const uniqueValidRoles = Array.from(
    new Set(
      roleKeys.map((role) => role.toLowerCase()).filter((role) => ROLE_KEYS.includes(role as any))
    )
  );

  const successBonus = clamp(uniqueValidRoles.length * 0.03, 0, MAX_ROLE_SUCCESS_BONUS);
  const durationReduction = clamp(uniqueValidRoles.length * 0.02, 0, MAX_ROLE_DURATION_REDUCTION);
  return { successBonus, durationReduction };
}

function randomInt(min: number, max: number): number {
  const safeMin = Math.min(min, max);
  const safeMax = Math.max(min, max);
  return Math.floor(Math.random() * (safeMax - safeMin + 1)) + safeMin;
}

function getRepeatMultiplier(previousRunsInWindow: number, cfg: RuntimeCrewMissionConfig): number {
  if (previousRunsInWindow <= 0) return 1;
  if (previousRunsInWindow === 1) return cfg.repeat2Multiplier;
  if (previousRunsInWindow === 2) return cfg.repeat3Multiplier;
  return cfg.repeat4Multiplier;
}

function computeCooldownSpeedupCost(
  run: Pick<CrewMissionRun, 'tier' | 'cooldownUntil'>,
  cfg: RuntimeCrewMissionConfig
): { remainingMinutes: number; credits: number; tierRate: number } {
  if (!run.cooldownUntil || run.cooldownUntil.getTime() <= Date.now()) {
    throw new Error('MISSION_COOLDOWN_NOT_ACTIVE');
  }

  const remainingMinutes = Math.max(
    1,
    Math.ceil((run.cooldownUntil.getTime() - Date.now()) / 60000)
  );
  const tierRate =
    run.tier === 1
      ? cfg.t1CreditsPerMinute
      : run.tier === 2
        ? cfg.t2CreditsPerMinute
        : cfg.t3CreditsPerMinute;
  const credits = clamp(Math.ceil(remainingMinutes * tierRate), 6, 240);

  return { remainingMinutes, credits, tierRate };
}

async function getMissionTemplates(): Promise<CrewMissionTemplate[]> {
  const rows = await prisma.$queryRawUnsafe<CrewMissionTemplateRow[]>(
    `
      SELECT
        id, missionKey, tier, titleNl, titleEn, descriptionNl, descriptionEn,
        durationSeconds, cooldownSeconds, successChance, rewardCashMin, rewardCashMax,
        rewardCrewXp, rewardPersonalXp, failPenaltyPct, isActive, sortOrder,
        imageCardPath, imageScenePath, requirementsJson
      FROM crew_mission_templates
      WHERE isActive = 1
      ORDER BY sortOrder ASC, id ASC
    `
  );

  return rows.map((row) => {
    const storageRequirements = parseMissionRequirements(row.requirementsJson);
    const tradeRequirements = tradeRequirementsFromParsed(storageRequirements);
    return {
      id: toInt(row.id),
      missionKey: row.missionKey,
      tier: toInt(row.tier, 1) as CrewMissionTier,
      titleNl: row.titleNl,
      titleEn: row.titleEn,
      descriptionNl: row.descriptionNl,
      descriptionEn: row.descriptionEn,
      durationSeconds: toInt(row.durationSeconds),
      cooldownSeconds: toInt(row.cooldownSeconds),
      successChance: clamp(toFloat(row.successChance), 0.05, 0.99),
      rewardCashMin: toInt(row.rewardCashMin),
      rewardCashMax: toInt(row.rewardCashMax),
      rewardCrewXp: toInt(row.rewardCrewXp),
      rewardPersonalXp: toInt(row.rewardPersonalXp),
      failPenaltyPct: clamp(toFloat(row.failPenaltyPct), 0, 0.9),
      isActive: toInt(row.isActive, 1),
      sortOrder: toInt(row.sortOrder, 0),
      imageCardPath: row.imageCardPath,
      imageScenePath: row.imageScenePath,
      tradeRequirements,
      storageRequirements,
    };
  });
}

async function fetchRunForCrew(crewId: number, runId: number): Promise<CrewMissionRun | null> {
  const rows = await prisma.$queryRawUnsafe<CrewMissionRun[]>(
    `
      SELECT
        r.id, r.crewId, r.templateId, r.startedByPlayerId, r.status, r.startedAt, r.endsAt, r.resolvedAt,
        r.cooldownUntil, r.outcome, r.progressPct, r.successRoll, r.successChance, r.rewardMultiplier,
        r.rewardCrewCash, r.rewardCrewXp, r.rewardPersonalXp, r.rewardsClaimedAt, r.rewardsClaimedByPlayerId,
        r.metadataJson,
        t.missionKey, t.tier, t.titleNl, t.titleEn
      FROM crew_mission_runs r
      INNER JOIN crew_mission_templates t ON t.id = r.templateId
      WHERE r.id = ? AND r.crewId = ?
      LIMIT 1
    `,
    runId,
    crewId
  );
  if (!rows[0]) return null;
  return normalizeRunRow(rows[0]);
}

async function ensureSeededTemplates(): Promise<void> {
  for (const seed of MISSION_SEEDS) {
    await prisma.$executeRawUnsafe(
      `
        INSERT INTO crew_mission_templates
          (missionKey, tier, titleNl, titleEn, descriptionNl, descriptionEn, durationSeconds, cooldownSeconds,
           successChance, rewardCashMin, rewardCashMax, rewardCrewXp, rewardPersonalXp, failPenaltyPct,
           isActive, sortOrder, imageCardPath, imageScenePath, requirementsJson)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
          tier = VALUES(tier),
          titleNl = VALUES(titleNl),
          titleEn = VALUES(titleEn),
          descriptionNl = VALUES(descriptionNl),
          descriptionEn = VALUES(descriptionEn),
          durationSeconds = VALUES(durationSeconds),
          cooldownSeconds = VALUES(cooldownSeconds),
          successChance = VALUES(successChance),
          rewardCashMin = VALUES(rewardCashMin),
          rewardCashMax = VALUES(rewardCashMax),
          rewardCrewXp = VALUES(rewardCrewXp),
          rewardPersonalXp = VALUES(rewardPersonalXp),
          failPenaltyPct = VALUES(failPenaltyPct),
          sortOrder = VALUES(sortOrder),
          imageCardPath = VALUES(imageCardPath),
          imageScenePath = VALUES(imageScenePath),
          requirementsJson = VALUES(requirementsJson)
      `,
      seed.missionKey,
      seed.tier,
      seed.titleNl,
      seed.titleEn,
      seed.descriptionNl,
      seed.descriptionEn,
      seed.durationSeconds,
      seed.cooldownSeconds,
      seed.successChance,
      seed.rewardCashMin,
      seed.rewardCashMax,
      seed.rewardCrewXp,
      seed.rewardPersonalXp,
      seed.failPenaltyPct,
      seed.sortOrder,
      seed.imageCardPath,
      seed.imageScenePath,
      serializeSeedRequirements(seed)
    );
  }
}

/** Boot / ops: sync MISSION_SEEDS into DB without requiring a player overview hit. */
export async function seedCrewMissionTemplatesIfNeeded(): Promise<void> {
  await ensureSeededTemplates();
}

export const crewMissionService = {
  async getCooldownRemainingSeconds(crewId: number): Promise<number> {
    const run = await getActiveRunForCrew(crewId);
    if (run?.status !== 'completed' || !run.cooldownUntil) {
      return 0;
    }
    return Math.max(0, Math.ceil((run.cooldownUntil.getTime() - Date.now()) / 1000));
  },

  async getOverview(playerId: number) {
    await ensureSeededTemplates();
    const membership = await getCrewMembership(playerId);
    const runtimeConfig = await getRuntimeConfig();
    const [templates, activeRun, crewContext, storageSnapshot] = await Promise.all([
      getMissionTemplates(),
      getActiveRunForCrew(membership.crewId),
      getCrewContext(membership.crewId, runtimeConfig),
      loadCrewMissionStorageSnapshot(membership.crewId),
    ]);

    const now = new Date();
    const recentRunsRaw = await prisma.$queryRawUnsafe<CrewMissionRun[]>(
      `
        SELECT
          r.id, r.crewId, r.templateId, r.startedByPlayerId, r.status, r.startedAt, r.endsAt, r.resolvedAt,
          r.cooldownUntil, r.outcome, r.progressPct, r.successRoll, r.successChance, r.rewardMultiplier,
          r.rewardCrewCash, r.rewardCrewXp, r.rewardPersonalXp, r.rewardsClaimedAt, r.rewardsClaimedByPlayerId,
          r.metadataJson,
          t.missionKey, t.tier, t.titleNl, t.titleEn
        FROM crew_mission_runs r
        INNER JOIN crew_mission_templates t ON t.id = r.templateId
        WHERE r.crewId = ? AND (r.resolvedAt IS NOT NULL OR r.cooldownUntil IS NOT NULL)
        ORDER BY r.id DESC
        LIMIT 15
      `,
      membership.crewId
    );

    const normalizedRecentRuns = recentRunsRaw.map(normalizeRunRow);
    const contributionMap = await getMissionContributionsByRunIds([
      ...(activeRun ? [activeRun.id] : []),
      ...normalizedRecentRuns.map((run) => run.id),
    ]);

    return {
      crewId: membership.crewId,
      role: membership.role,
      hqGlobalLevel: crewContext.hqGlobalLevel,
      memberCount: crewContext.memberCount,
      crewProgress: crewContext.crewProgress,
      templates: templates.map((template) => {
        const unlock = getMissionUnlockState(template, crewContext, runtimeConfig);
        const requirementQuote = quoteMissionRequirements(
          template.storageRequirements,
          storageSnapshot,
          template.successChance
        );
        return {
          ...template,
          unlocked: unlock.unlocked,
          lockedReason: unlock.lockedReason,
          requirementQuote,
          quotedSuccessChance: requirementQuote.quotedSuccessChance,
          storageReady: requirementQuote.canStart,
        };
      }),
      activeRun: activeRun
        ? {
            ...activeRun,
            missionContributions: contributionMap[activeRun.id] ?? [],
          }
        : null,
      recentRuns: normalizedRecentRuns.map((run) => ({
        ...run,
        missionContributions: contributionMap[run.id] ?? [],
      })),
      serverTime: now.toISOString(),
    };
  },

  async startMission(
    playerId: number,
    missionKey: string,
    assignments: Array<{ playerId: number; roleKey: string }> = []
  ) {
    await ensureSeededTemplates();
    const membership = await getCrewMembership(playerId);
    ensureMissionManagerRole(membership.role);
    const runtimeConfig = await getRuntimeConfig();

    const [templates, crewContext, activeRun] = await Promise.all([
      getMissionTemplates(),
      getCrewContext(membership.crewId, runtimeConfig),
      getActiveRunForCrew(membership.crewId),
    ]);

    if (activeRun) {
      if (
        activeRun.status === 'completed' &&
        activeRun.cooldownUntil &&
        activeRun.cooldownUntil.getTime() > Date.now()
      ) {
        throw new Error('MISSION_COOLDOWN_ACTIVE');
      }
      throw new Error('MISSION_ALREADY_IN_PROGRESS');
    }

    const template = templates.find((item) => item.missionKey === missionKey);
    if (!template) {
      throw new Error('MISSION_TEMPLATE_NOT_FOUND');
    }

    const unlock = getMissionUnlockState(template, crewContext, runtimeConfig);
    if (!unlock.unlocked) {
      if (unlock.lockedReason?.startsWith('CLEARING_HOUSE_REQUIRES_MISSION_LEVEL_')) {
        throw new Error('MISSION_CLEARING_HOUSE_LOCKED');
      }
      throw new Error('MISSION_TIER_LOCKED');
    }

    const storageRequirements = template.storageRequirements ?? [];
    let gearBonus = 0;
    if (storageRequirements.length > 0) {
      const quote = await consumeAndWearMissionStorage(membership.crewId, storageRequirements);
      gearBonus = quote.gearBonus;
    }

    const cleanAssignments = assignments
      .filter((item) => Number.isFinite(item.playerId) && item.playerId > 0 && item.roleKey)
      .map((item) => ({ playerId: item.playerId, roleKey: item.roleKey.toLowerCase().trim() }))
      .filter((item) => ROLE_KEYS.includes(item.roleKey as any));

    const [crewMembers, now] = await Promise.all([
      prisma.crewMember.findMany({
        where: { crewId: membership.crewId },
        select: { playerId: true },
      }),
      Promise.resolve(new Date()),
    ]);
    const crewPlayerSet = new Set(crewMembers.map((member) => member.playerId));

    const validAssignments = cleanAssignments.filter((item) => crewPlayerSet.has(item.playerId));
    if (!validAssignments.some((item) => item.playerId === playerId)) {
      validAssignments.push({ playerId, roleKey: 'planner' });
    }

    const roleBonuses = computeRoleBonuses(validAssignments.map((item) => item.roleKey));
    const computedDurationSeconds = Math.max(
      60,
      Math.round(template.durationSeconds * (1 - roleBonuses.durationReduction))
    );
    const successChance = clampMissionSuccessChance(
      template.successChance + roleBonuses.successBonus + gearBonus
    );
    const endsAt = new Date(now.getTime() + computedDurationSeconds * 1000);
    const starter = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    const startCountry = (starter?.currentCountry || 'netherlands').toLowerCase();

    await prisma.$executeRawUnsafe(
      `
        INSERT INTO crew_mission_runs
          (crewId, templateId, startedByPlayerId, status, startedAt, endsAt, progressPct, successChance, metadataJson)
        VALUES (?, ?, ?, 'in_progress', ?, ?, 0, ?, ?)
      `,
      membership.crewId,
      template.id,
      playerId,
      now,
      endsAt,
      successChance,
      JSON.stringify({
        roles: validAssignments,
        roleBonus: roleBonuses,
        gearBonus,
        startCountry,
      })
    );

    const latest = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
      `SELECT id FROM crew_mission_runs WHERE crewId = ? ORDER BY id DESC LIMIT 1`,
      membership.crewId
    );
    if (!latest[0]) {
      throw new Error('MISSION_START_FAILED');
    }
    const runId = latest[0].id;

    for (const item of validAssignments) {
      await prisma.$executeRawUnsafe(
        `
          INSERT INTO crew_mission_contributions
            (runId, playerId, roleKey, contributionScore, payoutMultiplier, rewardCash, rewardXp)
          VALUES (?, ?, ?, 1.0, 1.0, 0, 0)
          ON DUPLICATE KEY UPDATE roleKey = VALUES(roleKey)
        `,
        runId,
        item.playerId,
        item.roleKey
      );
    }

    const createdRun = await this.getRun(playerId, runId);

    void sendCrewMissionStartedNotifications(membership.crewId, createdRun, playerId).catch(
      (error) => {
        console.error('[Crew Missions] Failed to send mission started notifications:', error);
      }
    );

    return createdRun;
  },

  async getRun(playerId: number, runId: number) {
    const membership = await getCrewMembership(playerId);
    const run = await fetchRunForCrew(membership.crewId, runId);
    if (!run) {
      throw new Error('MISSION_RUN_NOT_FOUND');
    }
    const contributionMap = await getMissionContributionsByRunIds([run.id]);
    return {
      ...run,
      missionContributions: contributionMap[run.id] ?? [],
    };
  },

  async resolveMission(
    playerId: number,
    runId: number,
    options?: { outcome?: CrewMissionOutcome; progressPct?: number }
  ) {
    const membership = await getCrewMembership(playerId);
    ensureMissionManagerRole(membership.role);

    const run = await fetchRunForCrew(membership.crewId, runId);
    if (!run) {
      throw new Error('MISSION_RUN_NOT_FOUND');
    }
    if (run.status !== 'in_progress') {
      throw new Error('MISSION_ALREADY_RESOLVED');
    }

    const runtimeConfig = await getRuntimeConfig();
    const windowStart = new Date(Date.now() - runtimeConfig.repeatWindowMinutes * 60_000);
    const previousRows = await prisma.$queryRawUnsafe<Array<{ count: number }>>(
      `
        SELECT COUNT(*) AS count
        FROM crew_mission_runs
        WHERE crewId = ? AND templateId = ? AND resolvedAt IS NOT NULL AND resolvedAt >= ?
      `,
      run.crewId,
      run.templateId,
      windowStart
    );
    const previousCount = Number(previousRows?.[0]?.count ?? 0);
    const repeatMultiplier = getRepeatMultiplier(previousCount, runtimeConfig);

    const forcedOutcome = options?.outcome;
    const roll = Math.random();
    const autoOutcome: CrewMissionOutcome = roll <= (run.successChance ?? 0.5) ? 'success' : 'fail';
    const outcome = forcedOutcome ?? autoOutcome;
    const progressPct = clamp(
      toInt(options?.progressPct, outcome === 'partial' ? 70 : outcome === 'success' ? 100 : 35),
      0,
      100
    );

    const templateRows = await prisma.$queryRawUnsafe<CrewMissionTemplate[]>(
      `SELECT * FROM crew_mission_templates WHERE id = ? LIMIT 1`,
      run.templateId
    );
    const template = templateRows[0];
    if (!template) {
      throw new Error('MISSION_TEMPLATE_NOT_FOUND');
    }

    const baseCash = randomInt(toInt(template.rewardCashMin), toInt(template.rewardCashMax));
    const baseCrewXp = toInt(template.rewardCrewXp);
    const basePersonalXp = toInt(template.rewardPersonalXp);

    const outcomeFactor = outcome === 'success' ? 1 : outcome === 'partial' ? 0.65 : 0;
    const crewXpFactor = outcome === 'success' ? 1 : outcome === 'partial' ? 0.7 : 0;
    const personalXpFactor = outcome === 'success' ? 1 : outcome === 'partial' ? 1 : 0.4;

    const failPenaltyCash =
      outcome === 'fail'
        ? Math.round(baseCash * repeatMultiplier * toFloat(template.failPenaltyPct))
        : 0;
    const rewardCrewCash =
      outcome === 'fail'
        ? -failPenaltyCash
        : Math.round(baseCash * repeatMultiplier * outcomeFactor);
    const rewardCrewXp = Math.round(baseCrewXp * repeatMultiplier * crewXpFactor);
    const rewardPersonalXp = Math.round(basePersonalXp * repeatMultiplier * personalXpFactor);

    const now = new Date();
    const cooldownUntil = new Date(now.getTime() + toInt(template.cooldownSeconds) * 1000);

    await prisma.$executeRawUnsafe(
      `
        UPDATE crew_mission_runs
        SET status = 'completed',
            resolvedAt = ?,
            cooldownUntil = ?,
            outcome = ?,
            progressPct = ?,
            successRoll = ?,
            rewardMultiplier = ?,
            rewardCrewCash = ?,
            rewardCrewXp = ?,
            rewardPersonalXp = ?,
            updatedAt = NOW(3)
        WHERE id = ?
      `,
      now,
      cooldownUntil,
      outcome,
      progressPct,
      roll,
      repeatMultiplier,
      rewardCrewCash,
      rewardCrewXp,
      rewardPersonalXp,
      run.id
    );

    if (failPenaltyCash > 0) {
      await prisma.$executeRawUnsafe(
        `UPDATE crews SET bankBalance = GREATEST(0, bankBalance - ?) WHERE id = ?`,
        failPenaltyCash,
        run.crewId
      );
    }

    // Fail still never jails players (crew-bank penalty only), but write a
    // court/criminal-record note like failed heists so Rechtbank shows it.
    if (outcome === 'fail') {
      const contributionRows = await prisma.$queryRawUnsafe<MissionContributionRow[]>(
        `
          SELECT id, runId, playerId, roleKey, contributionScore
          FROM crew_mission_contributions
          WHERE runId = ?
        `,
        run.id
      );
      const recordPlayerIds = [
        ...new Set(
          (contributionRows.length > 0
            ? contributionRows.map((row) => toInt(row.playerId))
            : [toInt(run.startedByPlayerId)]
          ).filter((id) => id > 0)
        ),
      ];
      const tierNum = toInt(template.tier, 1);
      const recordMinutes = tierNum >= 3 ? 45 : tierNum >= 2 ? 30 : 15;
      const crimeId = `crew_mission:${template.missionKey}`;
      if (recordPlayerIds.length > 0) {
        await prisma.crimeAttempt.createMany({
          data: recordPlayerIds.map((recordPlayerId) => ({
            playerId: recordPlayerId,
            crimeId,
            success: false,
            reward: 0,
            xpGained: 0,
            jailed: false,
            jailTime: recordMinutes,
          })),
        });
      }
    }

    const resolvedRun = await this.getRun(playerId, run.id);

    if (outcome === 'success' && template.missionKey === 'casino_ledger_raid') {
      let startCountry = '';
      try {
        const meta = JSON.parse(run.metadataJson || '{}') as { startCountry?: string };
        startCountry = String(meta.startCountry || '').toLowerCase();
      } catch {
        startCountry = '';
      }
      if (!startCountry) {
        const starter = await prisma.player.findUnique({
          where: { id: run.startedByPlayerId },
          select: { currentCountry: true },
        });
        startCountry = (starter?.currentCountry || 'netherlands').toLowerCase();
      }
      try {
        await casinoOwnershipService.applyCasinoLedgerRaid({
          countryId: startCountry,
          crewId: membership.crewId,
        });
      } catch (error) {
        console.error('[Crew Missions] casino ledger raid drain failed', error);
      }
    }

    void sendCrewMissionResolvedNotifications(membership.crewId, resolvedRun).catch((error) => {
      console.error('[Crew Missions] Failed to send mission resolved notifications:', error);
    });

    return resolvedRun;
  },

  async claimRewards(playerId: number, runId: number) {
    const membership = await getCrewMembership(playerId);
    const runtimeConfig = await getRuntimeConfig();
    const run = await fetchRunForCrew(membership.crewId, runId);
    if (!run) {
      throw new Error('MISSION_RUN_NOT_FOUND');
    }
    if (run.status !== 'completed') {
      throw new Error('MISSION_NOT_COMPLETED');
    }
    if (run.rewardsClaimedAt) {
      throw new Error('MISSION_REWARDS_ALREADY_CLAIMED');
    }

    const contributionRows = await prisma.$queryRawUnsafe<MissionContributionRow[]>(
      `
        SELECT id, runId, playerId, roleKey, contributionScore
        FROM crew_mission_contributions
        WHERE runId = ?
      `,
      run.id
    );

    const rowsToUse =
      contributionRows.length > 0
        ? contributionRows
        : [
            {
              id: 0,
              runId: run.id,
              playerId: run.startedByPlayerId,
              roleKey: 'planner',
              contributionScore: 1,
            },
          ];

    const avgContribution =
      rowsToUse.reduce((sum, row) => sum + toFloat(row.contributionScore, 1), 0) / rowsToUse.length;
    const floorThreshold = avgContribution * 0.55;

    const rewardCrewXp = Math.max(0, toInt(run.rewardCrewXp, 0));

    await prisma.$transaction(async (tx) => {
      const crew = await tx.crew.findUnique({
        where: { id: run.crewId },
        select: { missionXp: true, missionLevel: true },
      });
      if (!crew) {
        throw new Error('CREW_NOT_FOUND');
      }

      const currentProgress = computeCrewMissionProgress(toInt(crew.missionXp, 0), runtimeConfig);
      const normalizedCrewLevel = Math.max(toInt(crew.missionLevel, 1), currentProgress.level);
      const cashBonusPct = getCrewMissionCashBonusPct(normalizedCrewLevel, runtimeConfig);
      const boostedCrewCash = Math.round(
        Math.max(0, run.rewardCrewCash) * (1 + cashBonusPct / 100)
      );
      const newCrewXp = Math.max(0, toInt(crew.missionXp, 0)) + rewardCrewXp;
      const newProgress = computeCrewMissionProgress(newCrewXp, runtimeConfig);
      const targetCrewLevel = Math.max(normalizedCrewLevel, newProgress.level);

      await tx.crew.update({
        where: { id: run.crewId },
        data: {
          bankBalance: { increment: boostedCrewCash },
          missionXp: newCrewXp,
          missionLevel: targetCrewLevel,
        },
      });

      for (const row of rowsToUse) {
        const contribution = toFloat(row.contributionScore, 1);
        const payoutMultiplier = contribution < floorThreshold ? 0.55 : 1;
        const playerXp = Math.round(run.rewardPersonalXp * payoutMultiplier);

        if (playerXp > 0) {
          await tx.player.update({
            where: { id: row.playerId },
            data: { xp: { increment: playerXp } },
          });
        }

        if (row.id > 0) {
          await tx.$executeRawUnsafe(
            `
              UPDATE crew_mission_contributions
              SET payoutMultiplier = ?, rewardXp = ?, updatedAt = NOW(3)
              WHERE id = ?
            `,
            payoutMultiplier,
            playerXp,
            row.id
          );
        } else {
          await tx.$executeRawUnsafe(
            `
              INSERT INTO crew_mission_contributions
                (runId, playerId, roleKey, contributionScore, payoutMultiplier, rewardCash, rewardXp)
              VALUES (?, ?, ?, ?, ?, 0, ?)
            `,
            run.id,
            row.playerId,
            row.roleKey,
            contribution,
            payoutMultiplier,
            playerXp
          );
        }
      }

      await tx.$executeRawUnsafe(
        `
          UPDATE crew_mission_runs
          SET rewardsClaimedAt = ?,
              rewardsClaimedByPlayerId = ?,
              rewardCrewCash = ?,
              rewardCrewXp = ?,
              updatedAt = NOW(3)
          WHERE id = ?
        `,
        new Date(),
        playerId,
        boostedCrewCash,
        rewardCrewXp,
        run.id
      );
    });

    return this.getRun(playerId, run.id);
  },

  async speedupCooldown(playerId: number, runId: number) {
    const membership = await getCrewMembership(playerId);
    const run = await fetchRunForCrew(membership.crewId, runId);
    if (!run) {
      throw new Error('MISSION_RUN_NOT_FOUND');
    }

    const cfg = await getRuntimeConfig();
    const quote = computeCooldownSpeedupCost(run, cfg);
    const creditCost = quote.credits;
    const remainingMinutes = quote.remainingMinutes;

    const result = await prisma.$transaction(async (tx) => {
      const player = await tx.player.findUnique({
        where: { id: playerId },
        select: { premiumCredits: true },
      });
      if (!player) {
        throw new Error('PLAYER_NOT_FOUND');
      }
      if (player.premiumCredits < creditCost) {
        throw new Error('INSUFFICIENT_CREDITS');
      }

      const balanceAfter = player.premiumCredits - creditCost;
      await tx.player.update({
        where: { id: playerId },
        data: { premiumCredits: balanceAfter },
      });

      await tx.playerCreditTransaction.create({
        data: {
          playerId,
          delta: -creditCost,
          balanceAfter,
          reasonType: 'REDEEM',
          reasonKey: 'crew_mission_cooldown_reset',
          metadataJson: JSON.stringify({
            runId: run.id,
            tier: run.tier,
            missionKey: run.missionKey,
            remainingMinutes,
            creditCost,
          }),
        },
      });

      await tx.$executeRawUnsafe(
        `
          UPDATE crew_mission_runs
          SET cooldownUntil = ?, cooldownNotifiedAt = NOW(3), updatedAt = NOW(3)
          WHERE id = ?
        `,
        new Date(),
        run.id
      );

      return { balanceAfter };
    });

    return {
      runId: run.id,
      creditsSpent: creditCost,
      balanceAfter: result.balanceAfter,
      cooldownUntil: new Date().toISOString(),
    };
  },

  async getSpeedupQuote(playerId: number, runId: number) {
    const membership = await getCrewMembership(playerId);
    const run = await fetchRunForCrew(membership.crewId, runId);
    if (!run) {
      throw new Error('MISSION_RUN_NOT_FOUND');
    }

    const cfg = await getRuntimeConfig();
    const quote = computeCooldownSpeedupCost(run, cfg);
    return {
      runId: run.id,
      tier: run.tier,
      missionKey: run.missionKey,
      remainingMinutes: quote.remainingMinutes,
      credits: quote.credits,
      tierRate: quote.tierRate,
      cooldownUntil: run.cooldownUntil?.toISOString() ?? null,
      serverTime: new Date().toISOString(),
    };
  },

  async getTelemetry(hours: number) {
    // Allow up to 90 days so admin can review sparse mission activity without raw SQL.
    const safeHours = clamp(toInt(hours, 24), 1, 2160);
    const from = new Date(Date.now() - safeHours * 60 * 60 * 1000);

    const [
      summaryRows,
      byMissionRows,
      speedupRows,
      contributionSummaryRows,
      byRoleRows,
      topContributorRows,
    ] = await Promise.all([
      prisma.$queryRawUnsafe<
        Array<{
          started: number;
          completed: number;
          successCount: number;
          partialCount: number;
          failCount: number;
          rewardCrewCash: number;
          rewardCrewXp: number;
          rewardPersonalXp: number;
        }>
      >(
        `
          SELECT
            COUNT(*) AS started,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed,
            SUM(CASE WHEN outcome = 'success' THEN 1 ELSE 0 END) AS successCount,
            SUM(CASE WHEN outcome = 'partial' THEN 1 ELSE 0 END) AS partialCount,
            SUM(CASE WHEN outcome = 'fail' THEN 1 ELSE 0 END) AS failCount,
            SUM(rewardCrewCash) AS rewardCrewCash,
            SUM(rewardCrewXp) AS rewardCrewXp,
            SUM(rewardPersonalXp) AS rewardPersonalXp
          FROM crew_mission_runs
          WHERE startedAt >= ?
        `,
        from
      ),
      prisma.$queryRawUnsafe<
        Array<{
          missionKey: string;
          tier: number;
          started: number;
          completed: number;
          successCount: number;
          partialCount: number;
          failCount: number;
          rewardCrewCash: number;
          durationSeconds: number;
        }>
      >(
        `
          SELECT
            t.missionKey,
            t.tier,
            COUNT(*) AS started,
            SUM(CASE WHEN r.status = 'completed' THEN 1 ELSE 0 END) AS completed,
            SUM(CASE WHEN r.outcome = 'success' THEN 1 ELSE 0 END) AS successCount,
            SUM(CASE WHEN r.outcome = 'partial' THEN 1 ELSE 0 END) AS partialCount,
            SUM(CASE WHEN r.outcome = 'fail' THEN 1 ELSE 0 END) AS failCount,
            SUM(r.rewardCrewCash) AS rewardCrewCash,
            SUM(TIMESTAMPDIFF(SECOND, r.startedAt, r.resolvedAt)) AS durationSeconds
          FROM crew_mission_runs r
          INNER JOIN crew_mission_templates t ON t.id = r.templateId
          WHERE r.startedAt >= ?
          GROUP BY t.missionKey, t.tier
          ORDER BY t.tier ASC, t.missionKey ASC
        `,
        from
      ),
      prisma.playerCreditTransaction.findMany({
        where: {
          reasonKey: 'crew_mission_cooldown_reset',
          createdAt: { gte: from },
        },
        select: {
          metadataJson: true,
          createdAt: true,
        },
      }),
      prisma.$queryRawUnsafe<
        Array<{
          assignments: number;
          distinctPlayers: number;
          avgContributionScore: number;
          avgPayoutMultiplier: number;
          reducedPayoutCount: number;
          totalRewardXp: number;
        }>
      >(
        `
          SELECT
            COUNT(*) AS assignments,
            COUNT(DISTINCT c.playerId) AS distinctPlayers,
            AVG(c.contributionScore) AS avgContributionScore,
            AVG(COALESCE(c.payoutMultiplier, 1)) AS avgPayoutMultiplier,
            SUM(CASE WHEN COALESCE(c.payoutMultiplier, 1) < 1 THEN 1 ELSE 0 END) AS reducedPayoutCount,
            SUM(COALESCE(c.rewardXp, 0)) AS totalRewardXp
          FROM crew_mission_contributions c
          INNER JOIN crew_mission_runs r ON r.id = c.runId
          WHERE r.startedAt >= ?
        `,
        from
      ),
      prisma.$queryRawUnsafe<
        Array<{
          roleKey: string;
          assignments: number;
          distinctPlayers: number;
          avgContributionScore: number;
          avgPayoutMultiplier: number;
          avgRewardXp: number;
        }>
      >(
        `
          SELECT
            c.roleKey,
            COUNT(*) AS assignments,
            COUNT(DISTINCT c.playerId) AS distinctPlayers,
            AVG(c.contributionScore) AS avgContributionScore,
            AVG(COALESCE(c.payoutMultiplier, 1)) AS avgPayoutMultiplier,
            AVG(COALESCE(c.rewardXp, 0)) AS avgRewardXp
          FROM crew_mission_contributions c
          INNER JOIN crew_mission_runs r ON r.id = c.runId
          WHERE r.startedAt >= ?
          GROUP BY c.roleKey
          ORDER BY assignments DESC, c.roleKey ASC
        `,
        from
      ),
      prisma.$queryRawUnsafe<
        Array<{
          playerId: number;
          username: string | null;
          assignments: number;
          avgContributionScore: number;
          avgPayoutMultiplier: number;
          totalRewardXp: number;
        }>
      >(
        `
          SELECT
            c.playerId,
            p.username,
            COUNT(*) AS assignments,
            AVG(c.contributionScore) AS avgContributionScore,
            AVG(COALESCE(c.payoutMultiplier, 1)) AS avgPayoutMultiplier,
            SUM(COALESCE(c.rewardXp, 0)) AS totalRewardXp
          FROM crew_mission_contributions c
          INNER JOIN crew_mission_runs r ON r.id = c.runId
          LEFT JOIN players p ON p.id = c.playerId
          WHERE r.startedAt >= ?
          GROUP BY c.playerId, p.username
          ORDER BY assignments DESC, avgContributionScore DESC, c.playerId ASC
          LIMIT 12
        `,
        from
      ),
    ]);

    const summary = summaryRows[0] || {
      started: 0,
      completed: 0,
      successCount: 0,
      partialCount: 0,
      failCount: 0,
      rewardCrewCash: 0,
      rewardCrewXp: 0,
      rewardPersonalXp: 0,
    };
    const contributionSummary = contributionSummaryRows[0] || {
      assignments: 0,
      distinctPlayers: 0,
      avgContributionScore: 0,
      avgPayoutMultiplier: 1,
      reducedPayoutCount: 0,
      totalRewardXp: 0,
    };

    const speedupsByTier: Record<string, number> = { tier1: 0, tier2: 0, tier3: 0 };
    for (const item of speedupRows) {
      try {
        const parsed = JSON.parse(item.metadataJson || '{}') as Record<string, unknown>;
        const tier = toInt(parsed.tier, 0);
        if (tier === 1) speedupsByTier.tier1 += 1;
        if (tier === 2) speedupsByTier.tier2 += 1;
        if (tier === 3) speedupsByTier.tier3 += 1;
      } catch {
        // ignore malformed metadata
      }
    }

    return {
      windowHours: safeHours,
      summary: {
        started: toInt(summary.started),
        completed: toInt(summary.completed),
        successCount: toInt(summary.successCount),
        partialCount: toInt(summary.partialCount),
        failCount: toInt(summary.failCount),
        successRate:
          toInt(summary.completed) > 0
            ? Number((toInt(summary.successCount) / toInt(summary.completed)).toFixed(4))
            : 0,
        rewardCrewCash: toInt(summary.rewardCrewCash),
        rewardCrewXp: toInt(summary.rewardCrewXp),
        rewardPersonalXp: toInt(summary.rewardPersonalXp),
      },
      byMission: byMissionRows.map((row) => {
        const durationMinutes = Math.max(0, toInt(row.durationSeconds) / 60);
        return {
          missionKey: row.missionKey,
          tier: toInt(row.tier),
          started: toInt(row.started),
          completed: toInt(row.completed),
          successCount: toInt(row.successCount),
          partialCount: toInt(row.partialCount),
          failCount: toInt(row.failCount),
          rewardCrewCash: toInt(row.rewardCrewCash),
          payoutPerMinute:
            durationMinutes > 0
              ? Number((toInt(row.rewardCrewCash) / durationMinutes).toFixed(2))
              : 0,
        };
      }),
      speedups: {
        total: speedupRows.length,
        byTier: speedupsByTier,
      },
      contributions: {
        assignments: toInt(contributionSummary.assignments),
        distinctPlayers: toInt(contributionSummary.distinctPlayers),
        avgContributionScore: Number(
          toFloat(contributionSummary.avgContributionScore, 0).toFixed(3)
        ),
        avgPayoutMultiplier: Number(toFloat(contributionSummary.avgPayoutMultiplier, 1).toFixed(3)),
        reducedPayoutCount: toInt(contributionSummary.reducedPayoutCount),
        totalRewardXp: toInt(contributionSummary.totalRewardXp),
        byRole: byRoleRows.map((row) => ({
          roleKey: String(row.roleKey || '')
            .trim()
            .toLowerCase(),
          assignments: toInt(row.assignments),
          distinctPlayers: toInt(row.distinctPlayers),
          avgContributionScore: Number(toFloat(row.avgContributionScore, 0).toFixed(3)),
          avgPayoutMultiplier: Number(toFloat(row.avgPayoutMultiplier, 1).toFixed(3)),
          avgRewardXp: Number(toFloat(row.avgRewardXp, 0).toFixed(2)),
        })),
        topContributors: topContributorRows.map((row) => ({
          playerId: toInt(row.playerId),
          username: row.username || `#${toInt(row.playerId)}`,
          assignments: toInt(row.assignments),
          avgContributionScore: Number(toFloat(row.avgContributionScore, 0).toFixed(3)),
          avgPayoutMultiplier: Number(toFloat(row.avgPayoutMultiplier, 1).toFixed(3)),
          totalRewardXp: toInt(row.totalRewardXp),
        })),
      },
      serverTime: new Date().toISOString(),
    };
  },

  async getRuntimeConfigView() {
    const values = await getRuntimeConfig();
    return {
      defaults: CREW_MISSION_RUNTIME_SETTING_DEFAULTS,
      values,
      keys: CREW_MISSION_RUNTIME_SETTING_KEYS,
    };
  },

  async updateRuntimeConfig(updates: Record<string, string | number>) {
    const normalized: Record<string, string> = {};
    for (const [key, value] of Object.entries(updates)) {
      if (!CREW_MISSION_RUNTIME_SETTING_KEYS.includes(key)) {
        throw new Error(`INVALID_RUNTIME_KEY:${key}`);
      }
      const asString = String(value ?? '').trim();
      const asNumber = Number(asString);
      if (!Number.isFinite(asNumber)) {
        throw new Error(`RUNTIME_VALUE_NOT_NUMERIC:${key}`);
      }

      if (key.includes('CREDITS_PER_MINUTE') && (asNumber < 1 || asNumber > 20)) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (key === 'CREW_MISSION_REPEAT_WINDOW_MINUTES' && (asNumber < 15 || asNumber > 360)) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (
        (key === 'CREW_MISSION_REPEAT_2_MULTIPLIER' ||
          key === 'CREW_MISSION_REPEAT_3_MULTIPLIER' ||
          key === 'CREW_MISSION_REPEAT_4_MULTIPLIER') &&
        (asNumber < 0.5 || asNumber > 1)
      ) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (key === 'CREW_MISSION_CREW_LEVEL_BASE_XP' && (asNumber < 100 || asNumber > 20000)) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (key === 'CREW_MISSION_CREW_LEVEL_STEP_XP' && (asNumber < 10 || asNumber > 5000)) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (
        key === 'CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT' &&
        (asNumber < 0 || asNumber > 10)
      ) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (
        key === 'CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT' &&
        (asNumber < 0 || asNumber > 100)
      ) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      if (
        key === 'CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL' &&
        (asNumber < 0 || asNumber > 50)
      ) {
        throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
      }
      normalized[key] = asString;
    }

    if (Object.keys(normalized).length > 0) {
      await upsertRuntimeConfigValues(normalized);
    }
    return this.getRuntimeConfigView();
  },
};

export async function processPendingCrewMissionCooldownReadyNotifications(
  limit = 100
): Promise<number> {
  const safeLimit = clamp(toInt(limit, 100), 1, 500);
  const now = new Date();

  const dueRuns = await prisma.$queryRawUnsafe<
    Array<{
      id: number;
      crewId: number;
      titleNl: string;
      titleEn: string;
    }>
  >(
    `
      SELECT
        r.id,
        r.crewId,
        t.titleNl,
        t.titleEn
      FROM crew_mission_runs r
      INNER JOIN crew_mission_templates t ON t.id = r.templateId
      WHERE r.status = 'completed'
        AND r.cooldownUntil IS NOT NULL
        AND r.cooldownUntil <= ?
        AND r.cooldownNotifiedAt IS NULL
      ORDER BY r.cooldownUntil ASC
      LIMIT ?
    `,
    now,
    safeLimit
  );

  let sentCount = 0;

  for (const run of dueRuns) {
    const updateResult = await prisma.$executeRawUnsafe(
      `
        UPDATE crew_mission_runs
        SET cooldownNotifiedAt = ?, updatedAt = NOW(3)
        WHERE id = ? AND cooldownNotifiedAt IS NULL
      `,
      now,
      run.id
    );

    if (Number(updateResult) <= 0) {
      continue;
    }

    await sendCrewMissionCooldownReadyNotifications(run.crewId, run.id, run.titleNl, run.titleEn);
    sentCount += 1;
  }

  return sentCount;
}
