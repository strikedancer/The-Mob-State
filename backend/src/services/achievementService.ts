import { activityService } from './activityService';
import { directMessageService } from './directMessageService';
import { PrismaClient } from '@prisma/client';
import crimesData from '../../content/crimes.json';
import jobsData from '../../content/jobs.json';
import { educationService } from './educationService';

const prisma = new PrismaClient();
const CRIME_DEFINITIONS = (crimesData as { crimes?: Array<any> }).crimes ?? [];
const CRIME_TYPES_COUNT = CRIME_DEFINITIONS.length;
const WEAPON_CRIME_IDS = CRIME_DEFINITIONS
  .filter((crime) => Boolean(crime.requiredWeapon))
  .map((crime) => String(crime.id));
const VEHICLE_WEAPON_TOOL_CRIME_IDS = CRIME_DEFINITIONS
  .filter(
    (crime) =>
      Boolean(crime.requiredVehicle) &&
      Boolean(crime.requiredWeapon) &&
      Array.isArray(crime.requiredTools) &&
      crime.requiredTools.length > 0
  )
  .map((crime) => String(crime.id));
const JOB_DEFINITIONS = (jobsData as Array<any>) ?? [];
const JOB_TYPES_COUNT = JOB_DEFINITIONS.length;
const JOB_REQUIREMENT_TYPES_TO_VALIDATE = new Set([
  'jobs_completed',
  'unique_jobs_completed',
  'jobs_with_education_requirements_completed',
  'unique_education_jobs_completed',
  'specific_job_completed',
]);
const EDUCATION_GATED_JOB_IDS = educationService
  .getEducationGates()
  .filter((gate) => gate.targetType === 'job')
  .map((gate) => String(gate.targetId));
const EDUCATION_GATED_JOB_TYPES_COUNT = EDUCATION_GATED_JOB_IDS.length;

export interface AchievementDefinition {
  id: string;
  title: string;
  description: string;
  category:
    | 'progression'
    | 'wealth'
    | 'power'
    | 'social'
    | 'mastery'
    | 'prostitution'
    | 'rld'
    | 'crimes'
    | 'jobs'
    | 'school'
    | 'vehicles'
    | 'travel'
    | 'drugs'
    | 'trade';
  requirementType: string;
  requirementValue: number;
  requirementJobId?: string;
  requirementDrugId?: string;
  requirementFacilityType?: string;
  rewardMoney?: number;
  rewardXp?: number;
  icon: string;
}

export interface ClientAchievementPayload {
  id: string;
  title: string;
  description: string;
  category: AchievementDefinition['category'];
  requirementType: string;
  requirementValue: number;
  rewardMoney?: number;
  rewardXp?: number;
  icon: string;
}

/**
 * Achievement Definitions
 * All available achievements with their requirements and rewards
 */
export const ACHIEVEMENT_DEFINITIONS: Record<string, AchievementDefinition> = {
  first_steps: {
    id: 'first_steps',
    title: 'First Steps',
    description: 'Recruit your first prostitute',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 1,
    rewardMoney: 5000,
    rewardXp: 100,
    icon: '👠',
  },
  
  growing_empire: {
    id: 'growing_empire',
    title: 'Growing Empire',
    description: 'Recruit 5 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 5,
    rewardMoney: 25000,
    rewardXp: 500,
    icon: '👥',
  },

  prostitute_lineup: {
    id: 'prostitute_lineup',
    title: 'Lineup Built',
    description: 'Recruit 10 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 900,
    icon: '👠',
  },

  prostitute_network: {
    id: 'prostitute_network',
    title: 'Street Network',
    description: 'Recruit 25 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 25,
    rewardMoney: 120000,
    rewardXp: 1800,
    icon: '🕸️',
  },

  prostitute_syndicate: {
    id: 'prostitute_syndicate',
    title: 'Syndicate',
    description: 'Recruit 50 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 50,
    rewardMoney: 220000,
    rewardXp: 3000,
    icon: '🏙️',
  },

  prostitute_dynasty: {
    id: 'prostitute_dynasty',
    title: 'Dynasty',
    description: 'Recruit 100 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 100,
    rewardMoney: 420000,
    rewardXp: 5000,
    icon: '👑',
  },

  prostitute_empire_250: {
    id: 'prostitute_empire_250',
    title: 'Empire 250',
    description: 'Recruit 250 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 250,
    rewardMoney: 900000,
    rewardXp: 9000,
    icon: '🏛️',
  },

  prostitute_cartel_500: {
    id: 'prostitute_cartel_500',
    title: 'Cartel 500',
    description: 'Recruit 500 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 500,
    rewardMoney: 1600000,
    rewardXp: 14000,
    icon: '💠',
  },

  prostitute_legend_1000: {
    id: 'prostitute_legend_1000',
    title: 'Legend 1000',
    description: 'Recruit 1000 prostitutes',
    category: 'prostitution',
    requirementType: 'prostitutes_count',
    requirementValue: 1000,
    rewardMoney: 3200000,
    rewardXp: 22000,
    icon: '🌟',
  },
  
  first_district: {
    id: 'first_district',
    title: 'First District',
    description: 'Purchase your first red light district',
    category: 'prostitution',
    requirementType: 'districts_count',
    requirementValue: 1,
    rewardMoney: 10000,
    rewardXp: 200,
    icon: '🏛️',
  },
  
  leveling_master: {
    id: 'leveling_master',
    title: 'Leveling Master',
    description: 'Max out a prostitute to level 10',
    category: 'prostitution',
    requirementType: 'max_level',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 1500,
    icon: '⭐',
  },

  vip_prostitute_level_10: {
    id: 'vip_prostitute_level_10',
    title: 'VIP Beginner',
    description: 'Reach level 3 with a VIP prostitute',
    category: 'prostitution',
    requirementType: 'vip_prostitute_level_reached',
    requirementValue: 3,
    rewardMoney: 40000,
    rewardXp: 600,
    icon: '💎',
  },

  vip_prostitute_level_25: {
    id: 'vip_prostitute_level_25',
    title: 'VIP Headliner',
    description: 'Reach level 5 with a VIP prostitute',
    category: 'prostitution',
    requirementType: 'vip_prostitute_level_reached',
    requirementValue: 5,
    rewardMoney: 80000,
    rewardXp: 1200,
    icon: '👑',
  },

  vip_prostitute_level_50: {
    id: 'vip_prostitute_level_50',
    title: 'VIP Icon',
    description: 'Reach level 7 with a VIP prostitute',
    category: 'prostitution',
    requirementType: 'vip_prostitute_level_reached',
    requirementValue: 7,
    rewardMoney: 160000,
    rewardXp: 2400,
    icon: '🌟',
  },

  vip_prostitute_level_100: {
    id: 'vip_prostitute_level_100',
    title: 'VIP Legend',
    description: 'Reach level 10 with a VIP prostitute',
    category: 'prostitution',
    requirementType: 'vip_prostitute_level_reached',
    requirementValue: 10,
    rewardMoney: 350000,
    rewardXp: 5000,
    icon: '🏆',
  },
  
  untouchable: {
    id: 'untouchable',
    title: 'Untouchable',
    description: 'Never get busted for 7 consecutive days',
    category: 'prostitution',
    requirementType: 'days_not_busted',
    requirementValue: 7,
    rewardMoney: 75000,
    rewardXp: 2000,
    icon: '🛡️',
  },
  
  millionaire: {
    id: 'millionaire',
    title: 'Millionaire',
    description: 'Accumulate €1,000,000 total earnings',
    category: 'trade',
    requirementType: 'total_earnings',
    requirementValue: 1000000,
    rewardMoney: 100000,
    rewardXp: 3000,
    icon: '💰',
  },
  
  high_roller: {
    id: 'high_roller',
    title: 'High Roller',
    description: 'Accumulate €5,000,000 total earnings',
    category: 'trade',
    requirementType: 'total_earnings',
    requirementValue: 5000000,
    rewardMoney: 500000,
    rewardXp: 5000,
    icon: '💎',
  },

  crypto_first_trade: {
    id: 'crypto_first_trade',
    title: 'First Block',
    description: 'Complete your first crypto trade',
    category: 'trade',
    requirementType: 'crypto_trades_count',
    requirementValue: 1,
    rewardMoney: 5000,
    rewardXp: 200,
    icon: '🪙',
  },

  crypto_day_trader: {
    id: 'crypto_day_trader',
    title: 'Day Trader',
    description: 'Complete 25 crypto trades',
    category: 'trade',
    requirementType: 'crypto_trades_count',
    requirementValue: 25,
    rewardMoney: 30000,
    rewardXp: 900,
    icon: '📈',
  },

  crypto_whale: {
    id: 'crypto_whale',
    title: 'Crypto Whale',
    description: 'Complete 100 crypto trades',
    category: 'trade',
    requirementType: 'crypto_trades_count',
    requirementValue: 100,
    rewardMoney: 120000,
    rewardXp: 2200,
    icon: '🐋',
  },

  crypto_profit_hunter: {
    id: 'crypto_profit_hunter',
    title: 'Profit Hunter',
    description: 'Earn €25,000 realized crypto profit',
    category: 'trade',
    requirementType: 'crypto_realized_profit',
    requirementValue: 25000,
    rewardMoney: 50000,
    rewardXp: 1200,
    icon: '💹',
  },

  crypto_bull_master: {
    id: 'crypto_bull_master',
    title: 'Bull Master',
    description: 'Earn €200,000 realized crypto profit',
    category: 'trade',
    requirementType: 'crypto_realized_profit',
    requirementValue: 200000,
    rewardMoney: 250000,
    rewardXp: 3200,
    icon: '🚀',
  },

  crypto_portfolio_lord: {
    id: 'crypto_portfolio_lord',
    title: 'Portfolio Lord',
    description: 'Reach €500,000 crypto portfolio value',
    category: 'trade',
    requirementType: 'crypto_portfolio_value',
    requirementValue: 500000,
    rewardMoney: 300000,
    rewardXp: 4000,
    icon: '🏦',
  },
  
  vip_service: {
    id: 'vip_service',
    title: 'VIP Service',
    description: 'Complete 10 VIP events',
    category: 'social',
    requirementType: 'vip_events_completed',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 1000,
    icon: '🎭',
  },
  
  event_enthusiast: {
    id: 'event_enthusiast',
    title: 'Event Enthusiast',
    description: 'Complete 25 VIP events',
    category: 'social',
    requirementType: 'vip_events_completed',
    requirementValue: 25,
    rewardMoney: 150000,
    rewardXp: 2500,
    icon: '🎪',
  },
  
  security_expert: {
    id: 'security_expert',
    title: 'Security Expert',
    description: 'Maximize security level on all owned districts',
    category: 'mastery',
    requirementType: 'max_security_all',
    requirementValue: 1,
    rewardMoney: 100000,
    rewardXp: 2000,
    icon: '🔒',
  },
  
  luxury_provider: {
    id: 'luxury_provider',
    title: 'Luxury Provider',
    description: 'Upgrade 3 districts to VIP tier',
    category: 'power',
    requirementType: 'vip_districts',
    requirementValue: 3,
    rewardMoney: 200000,
    rewardXp: 3000,
    icon: '✨',
  },
  
  rivalry_victor: {
    id: 'rivalry_victor',
    title: 'Rivalry Victor',
    description: 'Successfully sabotage rivals 10 times',
    category: 'social',
    requirementType: 'successful_sabotages',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 1500,
    icon: '⚔️',
  },
  
  untouchable_rival: {
    id: 'untouchable_rival',
    title: 'Untouchable Rival',
    description: 'Defend against 20 sabotage attempts',
    category: 'mastery',
    requirementType: 'sabotages_defended',
    requirementValue: 20,
    rewardMoney: 75000,
    rewardXp: 2000,
    icon: '🛡️',
  },

  crime_first_blood: {
    id: 'crime_first_blood',
    title: 'Crime First Blood',
    description: 'Successfully complete your first crime',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 1,
    rewardMoney: 15000,
    rewardXp: 200,
    icon: '🥷',
  },

  crime_hustler: {
    id: 'crime_hustler',
    title: 'Crime Hustler',
    description: 'Successfully complete 5 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 5,
    rewardMoney: 30000,
    rewardXp: 350,
    icon: '🕶️',
  },

  crime_novice: {
    id: 'crime_novice',
    title: 'Crime Novice',
    description: 'Successfully complete 10 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 500,
    icon: '🚨',
  },

  crime_operator: {
    id: 'crime_operator',
    title: 'Crime Operator',
    description: 'Successfully complete 25 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 25,
    rewardMoney: 120000,
    rewardXp: 1800,
    icon: '🎯',
  },

  crime_wave: {
    id: 'crime_wave',
    title: 'Crime Wave',
    description: 'Successfully complete 50 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 50,
    rewardMoney: 200000,
    rewardXp: 3000,
    icon: '🔥',
  },

  crime_mastermind: {
    id: 'crime_mastermind',
    title: 'Crime Mastermind',
    description: 'Successfully complete 100 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 100,
    rewardMoney: 300000,
    rewardXp: 4500,
    icon: '🧠',
  },

  the_godfather: {
    id: 'the_godfather',
    title: 'The Godfather',
    description: 'Successfully complete 250 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 250,
    rewardMoney: 500000,
    rewardXp: 8000,
    icon: '👑',
  },

  crime_emperor: {
    id: 'crime_emperor',
    title: 'Crime Emperor',
    description: 'Successfully complete 500 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 500,
    rewardMoney: 900000,
    rewardXp: 12000,
    icon: '🏛️',
  },

  crime_legend: {
    id: 'crime_legend',
    title: 'Crime Legend',
    description: 'Successfully complete 1000 crimes',
    category: 'crimes',
    requirementType: 'crimes_completed',
    requirementValue: 1000,
    rewardMoney: 2000000,
    rewardXp: 20000,
    icon: '🌟',
  },

  crime_getaway_driver: {
    id: 'crime_getaway_driver',
    title: 'Getaway Driver',
    description: 'Successfully complete your first crime with a vehicle',
    category: 'crimes',
    requirementType: 'crimes_with_vehicle',
    requirementValue: 1,
    rewardMoney: 50000,
    rewardXp: 700,
    icon: '🚘',
  },

  crime_armed_and_ready: {
    id: 'crime_armed_and_ready',
    title: 'Armed & Ready',
    description: 'Successfully complete your first crime that requires a weapon',
    category: 'crimes',
    requirementType: 'crimes_with_weapon',
    requirementValue: 1,
    rewardMoney: 60000,
    rewardXp: 900,
    icon: '🔫',
  },

  crime_full_loadout: {
    id: 'crime_full_loadout',
    title: 'Full Loadout',
    description: 'Successfully complete a crime requiring vehicle, weapon, and tools',
    category: 'crimes',
    requirementType: 'crimes_with_vehicle_weapon_tools',
    requirementValue: 1,
    rewardMoney: 120000,
    rewardXp: 1800,
    icon: '🧰',
  },

  crime_completionist: {
    id: 'crime_completionist',
    title: 'Crime Completionist',
    description: 'Successfully complete every crime type at least once',
    category: 'crimes',
    requirementType: 'unique_crimes_completed',
    requirementValue: CRIME_TYPES_COUNT,
    rewardMoney: 1500000,
    rewardXp: 15000,
    icon: '✅',
  },

  job_first_shift: {
    id: 'job_first_shift',
    title: 'First Shift',
    description: 'Successfully complete your first job',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 1,
    rewardMoney: 10000,
    rewardXp: 150,
    icon: '🧾',
  },

  job_hustler: {
    id: 'job_hustler',
    title: 'Job Hustler',
    description: 'Successfully complete 5 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 5,
    rewardMoney: 25000,
    rewardXp: 300,
    icon: '🛠️',
  },

  job_starter: {
    id: 'job_starter',
    title: 'Job Starter',
    description: 'Successfully complete 10 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 500,
    icon: '💼',
  },

  job_operator: {
    id: 'job_operator',
    title: 'Job Operator',
    description: 'Successfully complete 25 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 25,
    rewardMoney: 90000,
    rewardXp: 1200,
    icon: '🧰',
  },

  job_grinder: {
    id: 'job_grinder',
    title: 'Job Grinder',
    description: 'Successfully complete 50 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 50,
    rewardMoney: 150000,
    rewardXp: 2200,
    icon: '⚙️',
  },

  job_master: {
    id: 'job_master',
    title: 'Job Master',
    description: 'Successfully complete 100 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 100,
    rewardMoney: 250000,
    rewardXp: 4000,
    icon: '🎯',
  },

  job_expert: {
    id: 'job_expert',
    title: 'Job Expert',
    description: 'Successfully complete 250 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 250,
    rewardMoney: 500000,
    rewardXp: 7000,
    icon: '📋',
  },

  job_elite: {
    id: 'job_elite',
    title: 'Job Elite',
    description: 'Successfully complete 500 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 500,
    rewardMoney: 900000,
    rewardXp: 12000,
    icon: '🧠',
  },

  job_legend: {
    id: 'job_legend',
    title: 'Job Legend',
    description: 'Successfully complete 1000 jobs',
    category: 'jobs',
    requirementType: 'jobs_completed',
    requirementValue: 1000,
    rewardMoney: 1800000,
    rewardXp: 18000,
    icon: '🏆',
  },

  job_completionist: {
    id: 'job_completionist',
    title: 'Job Completionist',
    description: 'Successfully complete every job type at least once',
    category: 'jobs',
    requirementType: 'unique_jobs_completed',
    requirementValue: JOB_TYPES_COUNT,
    rewardMoney: 1200000,
    rewardXp: 14000,
    icon: '✅',
  },

  job_educated_worker: {
    id: 'job_educated_worker',
    title: 'Educated Worker',
    description: 'Complete 1 job that has education requirements',
    category: 'jobs',
    requirementType: 'jobs_with_education_requirements_completed',
    requirementValue: 1,
    rewardMoney: 50000,
    rewardXp: 800,
    icon: '📚',
  },

  job_certified_hustler: {
    id: 'job_certified_hustler',
    title: 'Certified Hustler',
    description: 'Complete 25 jobs with education requirements',
    category: 'jobs',
    requirementType: 'jobs_with_education_requirements_completed',
    requirementValue: 25,
    rewardMoney: 220000,
    rewardXp: 2800,
    icon: '🎓',
  },

  job_education_completionist: {
    id: 'job_education_completionist',
    title: 'Education Job Completionist',
    description: 'Complete every education-gated job type at least once',
    category: 'jobs',
    requirementType: 'unique_education_jobs_completed',
    requirementValue: EDUCATION_GATED_JOB_TYPES_COUNT,
    rewardMoney: 600000,
    rewardXp: 8000,
    icon: '🏅',
  },

  job_it_specialist: {
    id: 'job_it_specialist',
    title: 'IT Specialist',
    description: 'Complete your first shift as a Programmer',
    category: 'jobs',
    requirementType: 'specific_job_completed',
    requirementValue: 1,
    requirementJobId: 'programmer',
    rewardMoney: 80000,
    rewardXp: 1000,
    icon: '💻',
  },

  job_lawyer: {
    id: 'job_lawyer',
    title: 'Street Lawyer',
    description: 'Complete your first shift as a Lawyer',
    category: 'jobs',
    requirementType: 'specific_job_completed',
    requirementValue: 1,
    requirementJobId: 'lawyer',
    rewardMoney: 120000,
    rewardXp: 1500,
    icon: '⚖️',
  },

  job_doctor: {
    id: 'job_doctor',
    title: 'Underground Doctor',
    description: 'Complete your first shift as a Doctor',
    category: 'jobs',
    requirementType: 'specific_job_completed',
    requirementValue: 1,
    requirementJobId: 'doctor',
    rewardMoney: 150000,
    rewardXp: 2000,
    icon: '🩺',
  },

  school_certified: {
    id: 'school_certified',
    title: 'Certified Student',
    description: 'Earn 3 school certifications',
    category: 'school',
    requirementType: 'school_certifications_earned',
    requirementValue: 3,
    rewardMoney: 90000,
    rewardXp: 1200,
    icon: '📗',
  },

  school_multi_certified: {
    id: 'school_multi_certified',
    title: 'Multi-Certified',
    description: 'Earn 6 school certifications',
    category: 'school',
    requirementType: 'school_certifications_earned',
    requirementValue: 6,
    rewardMoney: 220000,
    rewardXp: 3200,
    icon: '🏅',
  },

  school_track_specialist: {
    id: 'school_track_specialist',
    title: 'Track Specialist',
    description: 'Max out 3 school tracks',
    category: 'school',
    requirementType: 'school_tracks_mastered',
    requirementValue: 3,
    rewardMoney: 350000,
    rewardXp: 4500,
    icon: '🎖️',
  },

  school_freshman: {
    id: 'school_freshman',
    title: 'School Freshman',
    description: 'Reach education level 1',
    category: 'school',
    requirementType: 'education_level_reached',
    requirementValue: 1,
    rewardMoney: 20000,
    rewardXp: 300,
    icon: '📘',
  },

  school_scholar: {
    id: 'school_scholar',
    title: 'School Scholar',
    description: 'Reach education level 3',
    category: 'school',
    requirementType: 'education_level_reached',
    requirementValue: 3,
    rewardMoney: 60000,
    rewardXp: 900,
    icon: '🎓',
  },

  school_graduate: {
    id: 'school_graduate',
    title: 'School Graduate',
    description: 'Reach education level 5',
    category: 'school',
    requirementType: 'education_level_reached',
    requirementValue: 5,
    rewardMoney: 140000,
    rewardXp: 1800,
    icon: '🏅',
  },

  school_mastermind: {
    id: 'school_mastermind',
    title: 'Academic Mastermind',
    description: 'Reach education level 10',
    category: 'school',
    requirementType: 'education_level_reached',
    requirementValue: 10,
    rewardMoney: 400000,
    rewardXp: 5000,
    icon: '🧠',
  },

  school_doctorate: {
    id: 'school_doctorate',
    title: 'Street Doctorate',
    description: 'Reach education level 20',
    category: 'school',
    requirementType: 'education_level_reached',
    requirementValue: 20,
    rewardMoney: 1200000,
    rewardXp: 12000,
    icon: '📜',
  },

  road_bandit: {
    id: 'road_bandit',
    title: 'Road Bandit',
    description: 'Steal 5 cars',
    category: 'vehicles',
    requirementType: 'cars_stolen_count',
    requirementValue: 5,
    rewardMoney: 40000,
    rewardXp: 600,
    icon: '🚗',
  },

  grand_theft_fleet: {
    id: 'grand_theft_fleet',
    title: 'Grand Theft Fleet',
    description: 'Steal 25 cars',
    category: 'vehicles',
    requirementType: 'cars_stolen_count',
    requirementValue: 25,
    rewardMoney: 200000,
    rewardXp: 2500,
    icon: '🏎️',
  },

  sea_raider: {
    id: 'sea_raider',
    title: 'Sea Raider',
    description: 'Steal 3 boats',
    category: 'vehicles',
    requirementType: 'boats_stolen_count',
    requirementValue: 3,
    rewardMoney: 60000,
    rewardXp: 800,
    icon: '🚤',
  },

  captain_of_smugglers: {
    id: 'captain_of_smugglers',
    title: 'Captain of Smugglers',
    description: 'Steal 12 boats',
    category: 'vehicles',
    requirementType: 'boats_stolen_count',
    requirementValue: 12,
    rewardMoney: 220000,
    rewardXp: 3200,
    icon: '🛥️',
  },

  globe_trotter: {
    id: 'globe_trotter',
    title: 'Globe Trotter',
    description: 'Complete 5 journeys',
    category: 'travel',
    requirementType: 'journeys_completed_count',
    requirementValue: 5,
    rewardMoney: 35000,
    rewardXp: 500,
    icon: '✈️',
  },

  jet_setter: {
    id: 'jet_setter',
    title: 'Jet Setter',
    description: 'Complete 25 journeys',
    category: 'travel',
    requirementType: 'journeys_completed_count',
    requirementValue: 25,
    rewardMoney: 180000,
    rewardXp: 2400,
    icon: '🧳',
  },

  chemist_apprentice: {
    id: 'chemist_apprentice',
    title: 'Chemist Apprentice',
    description: 'Complete 10 drug productions',
    category: 'drugs',
    requirementType: 'drugs_produced_count',
    requirementValue: 10,
    rewardMoney: 50000,
    rewardXp: 750,
    icon: '🧪',
  },

  narco_chemist: {
    id: 'narco_chemist',
    title: 'Narco Chemist',
    description: 'Complete 100 drug productions',
    category: 'drugs',
    requirementType: 'drugs_produced_count',
    requirementValue: 100,
    rewardMoney: 300000,
    rewardXp: 4200,
    icon: '⚗️',
  },

  // Facility ownership achievements
  greenhouse_owner: {
    id: 'greenhouse_owner',
    title: 'Kas Eigenaar',
    description: 'Koop je eerste kas',
    category: 'drugs',
    requirementType: 'drug_facility_owned',
    requirementValue: 1,
    requirementFacilityType: 'greenhouse',
    rewardMoney: 75000,
    rewardXp: 1000,
    icon: '🌿',
  },

  drug_lab_owner: {
    id: 'drug_lab_owner',
    title: 'Lab Eigenaar',
    description: 'Koop je eerste drugslab',
    category: 'drugs',
    requirementType: 'drug_facility_owned',
    requirementValue: 1,
    requirementFacilityType: 'drug_lab',
    rewardMoney: 150000,
    rewardXp: 2000,
    icon: '🔬',
  },

  // Quality achievement
  drug_quality_premium: {
    id: 'drug_quality_premium',
    title: 'Premium Producent',
    description: 'Produceer 10 drugs met kwaliteit A of S',
    category: 'drugs',
    requirementType: 'drug_high_quality_produced',
    requirementValue: 10,
    rewardMoney: 200000,
    rewardXp: 2800,
    icon: '⭐',
  },

  drug_quality_supreme: {
    id: 'drug_quality_supreme',
    title: 'Supreme Kwaliteit',
    description: 'Produceer 50 drugs met kwaliteit A of S',
    category: 'drugs',
    requirementType: 'drug_high_quality_produced',
    requirementValue: 50,
    rewardMoney: 600000,
    rewardXp: 8000,
    icon: '💎',
  },

  // White Widow quantities
  drug_white_widow_100: {
    id: 'drug_white_widow_100',
    title: 'Wiet Beginner',
    description: 'Produceer 100 White Widow',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'white_widow',
    rewardMoney: 35000,
    rewardXp: 500,
    icon: '🌱',
  },
  drug_white_widow_200: {
    id: 'drug_white_widow_200',
    title: 'Wiet Operator',
    description: 'Produceer 200 White Widow',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'white_widow',
    rewardMoney: 80000,
    rewardXp: 1100,
    icon: '🌱',
  },
  drug_white_widow_300: {
    id: 'drug_white_widow_300',
    title: 'Wiet Specialist',
    description: 'Produceer 300 White Widow',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'white_widow',
    rewardMoney: 160000,
    rewardXp: 2200,
    icon: '🌿',
  },
  drug_white_widow_500: {
    id: 'drug_white_widow_500',
    title: 'Wiet Expert',
    description: 'Produceer 500 White Widow',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'white_widow',
    rewardMoney: 350000,
    rewardXp: 4500,
    icon: '🌿',
  },
  drug_white_widow_1000: {
    id: 'drug_white_widow_1000',
    title: 'Wiet Meester',
    description: 'Produceer 1000 White Widow',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'white_widow',
    rewardMoney: 750000,
    rewardXp: 9000,
    icon: '🎋',
  },

  // Amnesia Haze quantities
  drug_amnesia_haze_100: {
    id: 'drug_amnesia_haze_100',
    title: 'Haze Beginner',
    description: 'Produceer 100 Amnesia Haze',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'amnesia_haze',
    rewardMoney: 40000,
    rewardXp: 550,
    icon: '🌱',
  },
  drug_amnesia_haze_200: {
    id: 'drug_amnesia_haze_200',
    title: 'Haze Operator',
    description: 'Produceer 200 Amnesia Haze',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'amnesia_haze',
    rewardMoney: 90000,
    rewardXp: 1200,
    icon: '🌱',
  },
  drug_amnesia_haze_300: {
    id: 'drug_amnesia_haze_300',
    title: 'Haze Specialist',
    description: 'Produceer 300 Amnesia Haze',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'amnesia_haze',
    rewardMoney: 175000,
    rewardXp: 2400,
    icon: '🌿',
  },
  drug_amnesia_haze_500: {
    id: 'drug_amnesia_haze_500',
    title: 'Haze Expert',
    description: 'Produceer 500 Amnesia Haze',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'amnesia_haze',
    rewardMoney: 380000,
    rewardXp: 4800,
    icon: '🌿',
  },
  drug_amnesia_haze_1000: {
    id: 'drug_amnesia_haze_1000',
    title: 'Haze Meester',
    description: 'Produceer 1000 Amnesia Haze',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'amnesia_haze',
    rewardMoney: 800000,
    rewardXp: 9500,
    icon: '🎋',
  },

  // OG Kush quantities
  drug_og_kush_100: {
    id: 'drug_og_kush_100',
    title: 'Kush Beginner',
    description: 'Produceer 100 OG Kush',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'og_kush',
    rewardMoney: 45000,
    rewardXp: 600,
    icon: '🌱',
  },
  drug_og_kush_200: {
    id: 'drug_og_kush_200',
    title: 'Kush Operator',
    description: 'Produceer 200 OG Kush',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'og_kush',
    rewardMoney: 100000,
    rewardXp: 1350,
    icon: '🌱',
  },
  drug_og_kush_300: {
    id: 'drug_og_kush_300',
    title: 'Kush Specialist',
    description: 'Produceer 300 OG Kush',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'og_kush',
    rewardMoney: 190000,
    rewardXp: 2600,
    icon: '🌿',
  },
  drug_og_kush_500: {
    id: 'drug_og_kush_500',
    title: 'Kush Expert',
    description: 'Produceer 500 OG Kush',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'og_kush',
    rewardMoney: 420000,
    rewardXp: 5200,
    icon: '🌿',
  },
  drug_og_kush_1000: {
    id: 'drug_og_kush_1000',
    title: 'Kush Meester',
    description: 'Produceer 1000 OG Kush',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'og_kush',
    rewardMoney: 900000,
    rewardXp: 10000,
    icon: '🎋',
  },

  // Cocaine quantities
  drug_cocaine_100: {
    id: 'drug_cocaine_100',
    title: 'Coke Beginner',
    description: 'Produceer 100 Cocaïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'cocaine',
    rewardMoney: 60000,
    rewardXp: 800,
    icon: '🤍',
  },
  drug_cocaine_200: {
    id: 'drug_cocaine_200',
    title: 'Coke Operator',
    description: 'Produceer 200 Cocaïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'cocaine',
    rewardMoney: 140000,
    rewardXp: 1800,
    icon: '🤍',
  },
  drug_cocaine_300: {
    id: 'drug_cocaine_300',
    title: 'Coke Specialist',
    description: 'Produceer 300 Cocaïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'cocaine',
    rewardMoney: 270000,
    rewardXp: 3500,
    icon: '💊',
  },
  drug_cocaine_500: {
    id: 'drug_cocaine_500',
    title: 'Coke Expert',
    description: 'Produceer 500 Cocaïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'cocaine',
    rewardMoney: 550000,
    rewardXp: 6500,
    icon: '💊',
  },
  drug_cocaine_1000: {
    id: 'drug_cocaine_1000',
    title: 'Coke Meester',
    description: 'Produceer 1000 Cocaïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'cocaine',
    rewardMoney: 1200000,
    rewardXp: 13000,
    icon: '💎',
  },

  // Speed quantities
  drug_speed_100: {
    id: 'drug_speed_100',
    title: 'Speed Beginner',
    description: 'Produceer 100 Speed',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'speed',
    rewardMoney: 55000,
    rewardXp: 750,
    icon: '⚡',
  },
  drug_speed_200: {
    id: 'drug_speed_200',
    title: 'Speed Operator',
    description: 'Produceer 200 Speed',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'speed',
    rewardMoney: 125000,
    rewardXp: 1650,
    icon: '⚡',
  },
  drug_speed_300: {
    id: 'drug_speed_300',
    title: 'Speed Specialist',
    description: 'Produceer 300 Speed',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'speed',
    rewardMoney: 240000,
    rewardXp: 3200,
    icon: '💊',
  },
  drug_speed_500: {
    id: 'drug_speed_500',
    title: 'Speed Expert',
    description: 'Produceer 500 Speed',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'speed',
    rewardMoney: 500000,
    rewardXp: 6000,
    icon: '💊',
  },
  drug_speed_1000: {
    id: 'drug_speed_1000',
    title: 'Speed Meester',
    description: 'Produceer 1000 Speed',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'speed',
    rewardMoney: 1100000,
    rewardXp: 12000,
    icon: '💎',
  },

  // Heroin quantities
  drug_heroin_100: {
    id: 'drug_heroin_100',
    title: 'Heroine Beginner',
    description: 'Produceer 100 Heroïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'heroin',
    rewardMoney: 70000,
    rewardXp: 900,
    icon: '💉',
  },
  drug_heroin_200: {
    id: 'drug_heroin_200',
    title: 'Heroine Operator',
    description: 'Produceer 200 Heroïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'heroin',
    rewardMoney: 160000,
    rewardXp: 2100,
    icon: '💉',
  },
  drug_heroin_300: {
    id: 'drug_heroin_300',
    title: 'Heroine Specialist',
    description: 'Produceer 300 Heroïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'heroin',
    rewardMoney: 300000,
    rewardXp: 4000,
    icon: '🩸',
  },
  drug_heroin_500: {
    id: 'drug_heroin_500',
    title: 'Heroine Expert',
    description: 'Produceer 500 Heroïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'heroin',
    rewardMoney: 650000,
    rewardXp: 7500,
    icon: '🩸',
  },
  drug_heroin_1000: {
    id: 'drug_heroin_1000',
    title: 'Heroine Meester',
    description: 'Produceer 1000 Heroïne',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'heroin',
    rewardMoney: 1400000,
    rewardXp: 15000,
    icon: '💎',
  },

  // XTC quantities
  drug_xtc_100: {
    id: 'drug_xtc_100',
    title: 'XTC Beginner',
    description: 'Produceer 100 XTC',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 100,
    requirementDrugId: 'xtc',
    rewardMoney: 50000,
    rewardXp: 700,
    icon: '💊',
  },
  drug_xtc_200: {
    id: 'drug_xtc_200',
    title: 'XTC Operator',
    description: 'Produceer 200 XTC',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 200,
    requirementDrugId: 'xtc',
    rewardMoney: 115000,
    rewardXp: 1500,
    icon: '💊',
  },
  drug_xtc_300: {
    id: 'drug_xtc_300',
    title: 'XTC Specialist',
    description: 'Produceer 300 XTC',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 300,
    requirementDrugId: 'xtc',
    rewardMoney: 220000,
    rewardXp: 3000,
    icon: '💊',
  },
  drug_xtc_500: {
    id: 'drug_xtc_500',
    title: 'XTC Expert',
    description: 'Produceer 500 XTC',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 500,
    requirementDrugId: 'xtc',
    rewardMoney: 460000,
    rewardXp: 5500,
    icon: '💊',
  },
  drug_xtc_1000: {
    id: 'drug_xtc_1000',
    title: 'XTC Meester',
    description: 'Produceer 1000 XTC',
    category: 'drugs',
    requirementType: 'drug_quantity_produced',
    requirementValue: 1000,
    requirementDrugId: 'xtc',
    rewardMoney: 1000000,
    rewardXp: 11000,
    icon: '💎',
  },

  street_merchant: {
    id: 'street_merchant',
    title: 'Street Merchant',
    description: 'Complete 25 trades',
    category: 'trade',
    requirementType: 'trades_completed_count',
    requirementValue: 25,
    rewardMoney: 65000,
    rewardXp: 900,
    icon: '📦',
  },

  trade_tycoon: {
    id: 'trade_tycoon',
    title: 'Trade Tycoon',
    description: 'Complete 150 trades',
    category: 'trade',
    requirementType: 'trades_completed_count',
    requirementValue: 150,
    rewardMoney: 350000,
    rewardXp: 5000,
    icon: '📈',
  },

  nightclub_opening_night: {
    id: 'nightclub_opening_night',
    title: 'Opening Night',
    description: 'Open your first nightclub venue',
    category: 'social',
    requirementType: 'nightclub_venues_count',
    requirementValue: 1,
    rewardMoney: 20000,
    rewardXp: 250,
    icon: '🌃',
  },

  nightclub_headliner: {
    id: 'nightclub_headliner',
    title: 'Headliner Booker',
    description: 'Book 10 DJ shifts for your nightclub empire',
    category: 'social',
    requirementType: 'nightclub_dj_hires_count',
    requirementValue: 10,
    rewardMoney: 75000,
    rewardXp: 1200,
    icon: '🎧',
  },

  nightclub_full_house: {
    id: 'nightclub_full_house',
    title: 'Full House',
    description: 'Push a nightclub crowd to 90% capacity',
    category: 'social',
    requirementType: 'nightclub_peak_crowd',
    requirementValue: 90,
    rewardMoney: 60000,
    rewardXp: 900,
    icon: '🔥',
  },

  nightclub_cash_machine: {
    id: 'nightclub_cash_machine',
    title: 'Cash Machine',
    description: 'Earn €250,000 total nightclub revenue',
    category: 'trade',
    requirementType: 'nightclub_total_revenue',
    requirementValue: 250000,
    rewardMoney: 120000,
    rewardXp: 1700,
    icon: '💸',
  },

  nightclub_empire: {
    id: 'nightclub_empire',
    title: 'Nightlife Empire',
    description: 'Earn €1,000,000 total nightclub revenue',
    category: 'trade',
    requirementType: 'nightclub_total_revenue',
    requirementValue: 1000000,
    rewardMoney: 240000,
    rewardXp: 3200,
    icon: '🏙️',
  },

  nightclub_staffing_boss: {
    id: 'nightclub_staffing_boss',
    title: 'Staffing Boss',
    description: 'Run 3 active nightclub crew members at the same time',
    category: 'power',
    requirementType: 'nightclub_active_staff_count',
    requirementValue: 3,
    rewardMoney: 90000,
    rewardXp: 1300,
    icon: '👥',
  },

  nightclub_vip_room: {
    id: 'nightclub_vip_room',
    title: 'VIP Room',
    description: 'Assign 2 VIP crew members to your nightclub',
    category: 'power',
    requirementType: 'nightclub_vip_staff_count',
    requirementValue: 2,
    rewardMoney: 140000,
    rewardXp: 2000,
    icon: '🥂',
  },

  nightclub_head_of_security: {
    id: 'nightclub_head_of_security',
    title: 'Head of Security',
    description: 'Hire nightclub security for 10 shifts',
    category: 'mastery',
    requirementType: 'nightclub_security_hires_count',
    requirementValue: 10,
    rewardMoney: 80000,
    rewardXp: 1250,
    icon: '🛡️',
  },

  nightclub_podium_finish: {
    id: 'nightclub_podium_finish',
    title: 'Podium Finish',
    description: 'Finish in the top 3 of a weekly nightclub season',
    category: 'power',
    requirementType: 'nightclub_best_season_rank',
    requirementValue: 3,
    rewardMoney: 180000,
    rewardXp: 2500,
    icon: '🥉',
  },

  nightclub_season_champion: {
    id: 'nightclub_season_champion',
    title: 'Season Champion',
    description: 'Win a weekly nightclub season',
    category: 'power',
    requirementType: 'nightclub_best_season_rank',
    requirementValue: 1,
    rewardMoney: 300000,
    rewardXp: 4500,
    icon: '🏆',
  },

  jailbreak_first: {
    id: 'jailbreak_first',
    title: 'First Breakout',
    description: 'Successfully free 1 prisoner',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 1,
    rewardMoney: 8000,
    rewardXp: 150,
    icon: '🧱',
  },

  jailbreak_5: {
    id: 'jailbreak_5',
    title: 'Tunnel Starter',
    description: 'Successfully free 5 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 5,
    rewardMoney: 35000,
    rewardXp: 500,
    icon: '⛏️',
  },

  jailbreak_10: {
    id: 'jailbreak_10',
    title: 'Cell Cracker',
    description: 'Successfully free 10 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 10,
    rewardMoney: 70000,
    rewardXp: 900,
    icon: '🔓',
  },

  jailbreak_25: {
    id: 'jailbreak_25',
    title: 'Midnight Rescue',
    description: 'Successfully free 25 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 25,
    rewardMoney: 170000,
    rewardXp: 1800,
    icon: '🌙',
  },

  jailbreak_50: {
    id: 'jailbreak_50',
    title: 'Escape Architect',
    description: 'Successfully free 50 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 50,
    rewardMoney: 300000,
    rewardXp: 3200,
    icon: '🗺️',
  },

  jailbreak_100: {
    id: 'jailbreak_100',
    title: 'Warden Nightmare',
    description: 'Successfully free 100 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 100,
    rewardMoney: 550000,
    rewardXp: 5200,
    icon: '😈',
  },

  jailbreak_250: {
    id: 'jailbreak_250',
    title: 'King of Escapes',
    description: 'Successfully free 250 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 250,
    rewardMoney: 1100000,
    rewardXp: 9000,
    icon: '👑',
  },

  jailbreak_500: {
    id: 'jailbreak_500',
    title: 'Ghost Locksmith',
    description: 'Successfully free 500 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 500,
    rewardMoney: 1900000,
    rewardXp: 14000,
    icon: '👻',
  },

  jailbreak_1000: {
    id: 'jailbreak_1000',
    title: 'Prison Legend',
    description: 'Successfully free 1000 prisoners',
    category: 'social',
    requirementType: 'jailbreaks_success_count',
    requirementValue: 1000,
    rewardMoney: 3400000,
    rewardXp: 22000,
    icon: '🌟',
  },

  buyout_first: {
    id: 'buyout_first',
    title: 'First Buyout',
    description: 'Buy out 1 prisoner',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 1,
    rewardMoney: 8000,
    rewardXp: 150,
    icon: '💸',
  },

  buyout_5: {
    id: 'buyout_5',
    title: 'Street Lawyer',
    description: 'Buy out 5 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 5,
    rewardMoney: 35000,
    rewardXp: 500,
    icon: '📑',
  },

  buyout_10: {
    id: 'buyout_10',
    title: 'Legal Fixer',
    description: 'Buy out 10 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 10,
    rewardMoney: 70000,
    rewardXp: 900,
    icon: '💼',
  },

  buyout_25: {
    id: 'buyout_25',
    title: 'Bail Broker',
    description: 'Buy out 25 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 25,
    rewardMoney: 170000,
    rewardXp: 1800,
    icon: '🏛️',
  },

  buyout_50: {
    id: 'buyout_50',
    title: 'Freedom Supplier',
    description: 'Buy out 50 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 50,
    rewardMoney: 300000,
    rewardXp: 3200,
    icon: '🗝️',
  },

  buyout_100: {
    id: 'buyout_100',
    title: 'Bail Tycoon',
    description: 'Buy out 100 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 100,
    rewardMoney: 550000,
    rewardXp: 5200,
    icon: '🏦',
  },

  buyout_250: {
    id: 'buyout_250',
    title: 'Freedom Cartel',
    description: 'Buy out 250 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 250,
    rewardMoney: 1100000,
    rewardXp: 9000,
    icon: '📊',
  },

  buyout_500: {
    id: 'buyout_500',
    title: 'Liberation Mogul',
    description: 'Buy out 500 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 500,
    rewardMoney: 1900000,
    rewardXp: 14000,
    icon: '💎',
  },

  buyout_1000: {
    id: 'buyout_1000',
    title: 'Patron of Freedom',
    description: 'Buy out 1000 prisoners',
    category: 'social',
    requirementType: 'prisoner_buyouts_count',
    requirementValue: 1000,
    rewardMoney: 3400000,
    rewardXp: 22000,
    icon: '🕊️',
  },
};

export function serializeAchievementForClient(
  achievement: AchievementDefinition
): ClientAchievementPayload {
  return {
    id: achievement.id,
    title: achievement.title,
    description: achievement.description,
    category: achievement.category,
    requirementType: achievement.requirementType,
    requirementValue: achievement.requirementValue,
    rewardMoney: achievement.rewardMoney,
    rewardXp: achievement.rewardXp,
    icon: achievement.icon,
  };
}

interface AchievementSnapshot {
  playerMoney: number;
  prostitutes: Array<{ level: number; isBusted: boolean; variant: number }>;
  oldestProstituteRecruitedAt: Date | null;
  activeBustedProstitutesCount: number;
  districts: Array<{ tier: string | number; securityLevel: number }>;
  eventParticipations: number;
  sabotages: number;
  defenses: number;
  crimeCount: number;
  jobCount: number;
  carsStolenCount: number;
  boatsStolenCount: number;
  journeysCompletedCount: number;
  drugsProducedCount: number;
  tradesCompletedCount: number;
  crimeWithVehicleCount: number;
  crimeWithWeaponCount: number;
  crimeWithVehicleWeaponToolCount: number;
  uniqueCrimeTypesCompletedCount: number;
  uniqueJobTypesCompletedCount: number;
  jobsWithEducationRequirementsCount: number;
  uniqueEducationJobTypesCompletedCount: number;
  educationLevel: number;
  maxVipProstituteLevel: number;
  specificJobsCount: Record<string, number>;
  certificationsEarnedCount: number;
  maxedSchoolTracksCount: number;
  jailbreaksSuccessCount: number;
  prisonerBuyoutsCount: number;
  drugQuantitiesProduced: Record<string, number>;
  drugFacilitiesOwned: string[];
  highQualityDrugsProduced: number;
  nightclubVenuesCount: number;
  nightclubTotalRevenue: number;
  nightclubSalesCount: number;
  nightclubActiveStaffCount: number;
  nightclubVipStaffCount: number;
  nightclubDjHiresCount: number;
  nightclubSecurityHiresCount: number;
  nightclubPeakCrowd: number;
  nightclubBestSeasonRank: number | null;
  cryptoTradesCount: number;
  cryptoRealizedProfit: number;
  cryptoPortfolioValue: number;
}

async function safeCount(
  label: string,
  operation: () => Promise<number>
): Promise<number> {
  try {
    return await operation();
  } catch (error) {
    console.warn(`[Achievements] ${label} unavailable, defaulting to 0`, error);
    return 0;
  }
}

async function safeArray<T>(
  label: string,
  operation: () => Promise<T[]>
): Promise<T[]> {
  try {
    return await operation();
  } catch (error) {
    console.warn(`[Achievements] ${label} unavailable, defaulting to []`, error);
    return [];
  }
}

async function safeValue<T>(
  label: string,
  operation: () => Promise<T>,
  fallback: T
): Promise<T> {
  try {
    return await operation();
  } catch (error) {
    console.warn(`[Achievements] ${label} unavailable, using fallback`, error);
    return fallback;
  }
}

interface AchievementEvaluation {
  meetsRequirement: boolean;
  currentValue: number;
  progressPercent: number;
  data: Record<string, unknown>;
}

async function getAchievementSnapshot(playerId: number): Promise<AchievementSnapshot> {
  const [
    player,
    prostitutes,
    oldestProstituteRecruitedAt,
    activeBustedProstitutesCount,
    districts,
    eventParticipations,
    sabotages,
    defenses,
    crimeCount,
    jobCount,
    carsStolenCount,
    boatsStolenCount,
    journeysCompletedCount,
    drugsProducedCount,
    tradesCompletedCount,
    crimeWithVehicleCount,
    crimeWithWeaponCount,
    crimeWithVehicleWeaponToolCount,
    uniqueCrimeTypesCompletedCount,
    uniqueJobTypesCompletedCount,
    jobsWithEducationRequirementsCount,
    uniqueEducationJobTypesCompletedCount,
    educationLevel,
    specificJobsCount,
    educationProfile,
    jailbreaksSuccessCount,
    prisonerBuyoutsCount,
  ] = await Promise.all([
    safeValue(
      'player.money',
      () =>
        prisma.player.findUnique({
          where: { id: playerId },
          select: { money: true },
        }),
      null
    ),
    safeArray('prostitutes', () =>
      prisma.prostitute.findMany({
        where: { playerId },
        select: { level: true, isBusted: true, variant: true },
      })
    ),
    safeValue(
      'oldestProstituteRecruitedAt',
      () =>
        prisma.prostitute.findFirst({
          where: { playerId },
          orderBy: { recruitedAt: 'asc' },
          select: { recruitedAt: true },
        }),
      null
    ).then((record) => record?.recruitedAt ?? null),
    safeCount('activeBustedProstitutesCount', () =>
      prisma.prostitute.count({
        where: {
          playerId,
          isBusted: true,
          OR: [{ bustedUntil: null }, { bustedUntil: { gte: new Date() } }],
        },
      })
    ),
    safeArray('redLightDistricts', () =>
      prisma.redLightDistrict.findMany({
        where: { ownerId: playerId },
        select: { tier: true, securityLevel: true },
      })
    ),
    safeCount('eventParticipations', () =>
      prisma.eventParticipation.count({
        where: { playerId, status: 'completed' },
      })
    ),
    safeCount('successfulSabotages', () =>
      prisma.sabotageAction.count({
        where: { attackerId: playerId, success: true },
      })
    ),
    safeCount('sabotagesDefended', () =>
      prisma.sabotageAction.count({
        where: { victimId: playerId },
      })
    ),
    safeCount('crimeCount', () =>
      prisma.crimeAttempt.count({
        where: { playerId, success: true },
      })
    ),
    safeCount('jobCount', () =>
      prisma.jobAttempt.count({
        where: { playerId, earnings: { gt: 0 } },
      })
    ),
    safeCount('carsStolenCount', () =>
      prisma.vehicleInventory.count({
        where: { playerId, vehicleType: 'car' },
      })
    ),
    safeCount('boatsStolenCount', () =>
      prisma.vehicleInventory.count({
        where: { playerId, vehicleType: 'boat' },
      })
    ),
    safeCount('journeysCompletedCount', () =>
      prisma.worldEvent.count({
        where: { playerId, eventKey: 'travel.journey_complete' },
      })
    ),
    safeCount('drugsProducedCount', () =>
      prisma.drugProduction.count({
        where: { playerId, completed: true },
      })
    ),
    safeCount('tradesCompletedCount', () =>
      prisma.worldEvent.count({
        where: { playerId, eventKey: 'trade.sold' },
      })
    ),
    safeCount('crimeWithVehicleCount', () =>
      prisma.crimeAttempt.count({
        where: {
          playerId,
          success: true,
          NOT: { vehicleId: null },
        },
      })
    ),
    safeCount('crimeWithWeaponCount', () =>
      prisma.crimeAttempt.count({
        where: {
          playerId,
          success: true,
          crimeId: { in: WEAPON_CRIME_IDS },
        },
      })
    ),
    safeCount('crimeWithVehicleWeaponToolCount', () =>
      prisma.crimeAttempt.count({
        where: {
          playerId,
          success: true,
          crimeId: { in: VEHICLE_WEAPON_TOOL_CRIME_IDS },
        },
      })
    ),
    safeValue('uniqueCrimeTypesCompletedCount', async () => {
      const uniqueCompleted = await prisma.crimeAttempt.findMany({
        where: { playerId, success: true },
        select: { crimeId: true },
        distinct: ['crimeId'],
      });

      return uniqueCompleted.length;
    }, 0),
    safeValue('uniqueJobTypesCompletedCount', async () => {
      const uniqueCompleted = await prisma.jobAttempt.findMany({
        where: { playerId, earnings: { gt: 0 } },
        select: { jobId: true },
        distinct: ['jobId'],
      });

      return uniqueCompleted.length;
    }, 0),
    safeCount('jobsWithEducationRequirementsCount', () =>
      prisma.jobAttempt.count({
        where: {
          playerId,
          earnings: { gt: 0 },
          jobId: { in: EDUCATION_GATED_JOB_IDS },
        },
      })
    ),
    safeValue('uniqueEducationJobTypesCompletedCount', async () => {
      const uniqueCompleted = await prisma.jobAttempt.findMany({
        where: {
          playerId,
          earnings: { gt: 0 },
          jobId: { in: EDUCATION_GATED_JOB_IDS },
        },
        select: { jobId: true },
        distinct: ['jobId'],
      });

      return uniqueCompleted.length;
    }, 0),
    safeValue('educationLevel', async () => {
      const schoolLevelEvents = await prisma.worldEvent.findMany({
        where: {
          playerId,
          eventKey: 'school.level_up',
        },
        select: { params: true },
      });

      let maxSchoolLevel = 0;
      for (const event of schoolLevelEvents) {
        const params = (event.params || {}) as any;
        const trackId = String(params.trackId ?? '');
        if (!trackId) {
          continue;
        }

        const rawLevel = params.newLevel ?? params.level ?? params.educationLevel ?? 0;
        const parsedLevel = Number(rawLevel);
        if (Number.isFinite(parsedLevel) && parsedLevel > maxSchoolLevel) {
          maxSchoolLevel = Math.floor(parsedLevel);
        }
      }

      return maxSchoolLevel > 0 ? maxSchoolLevel : 0;
    }, 0),
    safeValue('specificJobsCount', async () => {
      const specificJobIds = Object.values(ACHIEVEMENT_DEFINITIONS)
        .filter((def) => def.requirementType === 'specific_job_completed' && def.requirementJobId)
        .map((def) => def.requirementJobId as string);

      const uniqueJobIds = [...new Set(specificJobIds)];
      const counts: Record<string, number> = {};

      await Promise.all(
        uniqueJobIds.map(async (jobId) => {
          counts[jobId] = await prisma.jobAttempt.count({
            where: { playerId, jobId, earnings: { gt: 0 } },
          });
        })
      );

      return counts;
    }, {} as Record<string, number>),
    safeValue('educationProfile', () => educationService.getPlayerEducationProfile(playerId), {
      playerId,
      tracks: {},
      certifications: [],
    }),
    safeCount('jailbreaksSuccessCount', () =>
      prisma.worldEvent.count({
        where: { playerId, eventKey: 'prison.jailbreak_success' },
      })
    ),
    safeCount('prisonerBuyoutsCount', () =>
      prisma.worldEvent.count({
        where: { playerId, eventKey: 'prison.buyout_success' },
      })
    ),
  ]);

  const certificationsEarnedCount = Array.isArray(educationProfile.certifications)
    ? educationProfile.certifications.length
    : 0;

  const maxedSchoolTracksCount = Object.entries(educationProfile.tracks || {}).reduce(
    (count, [trackId, progress]) => {
      const track = educationService.getTrack(trackId);
      if (!track) {
        return count;
      }

      const currentLevel = Math.max(0, Math.floor(progress?.level ?? 0));
      return currentLevel >= track.maxLevel ? count + 1 : count;
    },
    0
  );

  // Drug quantity per type (sum of collected quantities from completed productions)
  const drugQuantitiesProduced: Record<string, number> = {};
  try {
    const drugGroups = await prisma.drugProduction.groupBy({
      by: ['drugType'],
      where: { playerId, completed: true },
      _sum: { quantity: true },
    });
    for (const g of drugGroups) {
      drugQuantitiesProduced[g.drugType] = g._sum.quantity ?? 0;
    }
  } catch (_e) { /* ignore */ }

  // Owned drug facilities
  const drugFacilitiesOwned: string[] = [];
  try {
    const facilities = await prisma.drugFacility.findMany({
      where: { playerId },
      select: { facilityType: true },
    });
    for (const f of facilities) drugFacilitiesOwned.push(f.facilityType);
  } catch (_e) { /* ignore */ }

  // High quality productions (A or S)
  let highQualityDrugsProduced = 0;
  try {
    highQualityDrugsProduced = await prisma.drugProduction.count({
      where: { playerId, completed: true, quality: { in: ['A', 'S'] } },
    });
  } catch (_e) { /* ignore */ }

  const [
    nightclubVenuesCount,
    nightclubRevenueAggregate,
    nightclubSalesCount,
    nightclubActiveStaffCount,
    nightclubVipStaffCount,
    nightclubDjHiresCount,
    nightclubSecurityHiresCount,
    nightclubPeakCrowdRecord,
    nightclubBestSeasonReward,
  ] = await Promise.all([
    safeCount('nightclubVenuesCount', () =>
      prisma.nightclubVenue.count({
        where: { playerId },
      })
    ),
    safeValue(
      'nightclubTotalRevenue',
      () =>
        prisma.nightclubVenue.aggregate({
          where: { playerId },
          _sum: { totalRevenueAllTime: true },
        }),
      { _sum: { totalRevenueAllTime: BigInt(0) } }
    ),
    safeCount('nightclubSalesCount', () =>
      prisma.nightclubSale.count({
        where: { venue: { playerId } },
      })
    ),
    safeCount('nightclubActiveStaffCount', () =>
      prisma.prostitute.count({
        where: {
          playerId,
          location: 'nightclub',
          isBusted: false,
        },
      })
    ),
    safeCount('nightclubVipStaffCount', () =>
      prisma.prostitute.count({
        where: {
          playerId,
          location: 'nightclub',
          isBusted: false,
          variant: { gte: 6 },
        },
      })
    ),
    safeCount('nightclubDjHiresCount', () =>
      prisma.nightclubDJShift.count({
        where: { venue: { playerId } },
      })
    ),
    safeCount('nightclubSecurityHiresCount', () =>
      prisma.nightclubSecurityShift.count({
        where: { venue: { playerId } },
      })
    ),
    safeValue(
      'nightclubPeakCrowd',
      () =>
        prisma.nightclubVenue.findFirst({
          where: { playerId },
          orderBy: { crowdSize: 'desc' },
          select: { crowdSize: true },
        }),
      null
    ),
    safeValue(
      'nightclubBestSeasonRank',
      () =>
        prisma.nightclubSeasonReward.findFirst({
          where: { playerId },
          orderBy: [{ rank: 'asc' }, { paidAt: 'asc' }],
          select: { rank: true },
        }),
      null
    ),
  ]);

  const nightclubTotalRevenue = Number(nightclubRevenueAggregate._sum.totalRevenueAllTime ?? 0n);

  const [cryptoTradesCount, cryptoRealizedProfit, cryptoPortfolioValue] = await Promise.all([
    safeCount('cryptoTradesCount', () =>
      prisma.worldEvent.count({
        where: {
          playerId,
          eventKey: { in: ['crypto.buy', 'crypto.sell'] },
        },
      })
    ),
    safeValue('cryptoRealizedProfit', async () => {
      const rows = await prisma.$queryRawUnsafe<Array<{ realized_profit: string | number }>>(
        `
        SELECT COALESCE(SUM(realized_profit), 0) AS realized_profit
        FROM crypto_transactions
        WHERE player_id = ? AND side = 'SELL'
        `,
        playerId
      );

      const raw = Number(rows[0]?.realized_profit ?? 0);
      return Number.isFinite(raw) ? raw : 0;
    }, 0),
    safeValue('cryptoPortfolioValue', async () => {
      const rows = await prisma.$queryRawUnsafe<Array<{ portfolio_value: string | number }>>(
        `
        SELECT COALESCE(SUM(h.quantity * a.current_price), 0) AS portfolio_value
        FROM crypto_holdings h
        INNER JOIN crypto_assets a ON a.symbol = h.asset_symbol
        WHERE h.player_id = ?
        `,
        playerId
      );

      const raw = Number(rows[0]?.portfolio_value ?? 0);
      return Number.isFinite(raw) ? raw : 0;
    }, 0),
  ]);

  return {
    playerMoney: player?.money ?? 0,
    prostitutes,
    oldestProstituteRecruitedAt,
    activeBustedProstitutesCount,
    districts,
    eventParticipations,
    sabotages,
    defenses,
    crimeCount,
    jobCount,
    carsStolenCount,
    boatsStolenCount,
    journeysCompletedCount,
    drugsProducedCount,
    tradesCompletedCount,
    crimeWithVehicleCount,
    crimeWithWeaponCount,
    crimeWithVehicleWeaponToolCount,
    uniqueCrimeTypesCompletedCount,
    uniqueJobTypesCompletedCount,
    jobsWithEducationRequirementsCount,
    uniqueEducationJobTypesCompletedCount,
    educationLevel: educationLevel > 0 ? educationLevel : 0,
    maxVipProstituteLevel:
      prostitutes.length > 0
        ? prostitutes
            .filter((prostitute) => prostitute.variant >= 6)
            .reduce(
              (maxLevel, prostitute) =>
                prostitute.level > maxLevel ? prostitute.level : maxLevel,
              0
            )
        : 0,
    specificJobsCount,
    certificationsEarnedCount,
    maxedSchoolTracksCount,
    jailbreaksSuccessCount,
    prisonerBuyoutsCount,
    drugQuantitiesProduced,
    drugFacilitiesOwned,
    highQualityDrugsProduced,
    nightclubVenuesCount,
    nightclubTotalRevenue,
    nightclubSalesCount,
    nightclubActiveStaffCount,
    nightclubVipStaffCount,
    nightclubDjHiresCount,
    nightclubSecurityHiresCount,
    nightclubPeakCrowd: nightclubPeakCrowdRecord?.crowdSize ?? 0,
    nightclubBestSeasonRank: nightclubBestSeasonReward?.rank ?? null,
    cryptoTradesCount,
    cryptoRealizedProfit,
    cryptoPortfolioValue,
  };
}

function evaluateAchievement(
  achievement: AchievementDefinition,
  snapshot: AchievementSnapshot
): AchievementEvaluation {
  let currentValue = 0;
  let data: Record<string, unknown> = {};
  let meetsRequirement = false;

  switch (achievement.requirementType) {
    case 'prostitutes_count':
      currentValue = snapshot.prostitutes.length;
      data = { prostitutesCount: currentValue };
      break;

    case 'districts_count':
      currentValue = snapshot.districts.length;
      data = { districtsCount: currentValue };
      break;

    case 'max_level':
      currentValue =
        snapshot.prostitutes.length > 0
          ? Math.max(...snapshot.prostitutes.map((prostitute) => prostitute.level))
          : 0;
      data = { maxLevel: currentValue };
      break;

    case 'vip_prostitute_level_reached':
      currentValue = snapshot.maxVipProstituteLevel;
      data = { maxVipProstituteLevel: currentValue };
      break;

    case 'total_earnings':
      currentValue = snapshot.playerMoney;
      data = { totalEarnings: currentValue };
      break;

    case 'vip_events_completed':
      currentValue = snapshot.eventParticipations;
      data = { eventsCompleted: currentValue };
      break;

    case 'successful_sabotages':
      currentValue = snapshot.sabotages;
      data = { successfulSabotages: currentValue };
      break;

    case 'sabotages_defended':
      currentValue = snapshot.defenses;
      data = { sabotagesDefended: currentValue };
      break;

    case 'crimes_completed':
      currentValue = snapshot.crimeCount;
      data = { crimesCompleted: currentValue };
      break;

    case 'crimes_with_vehicle':
      currentValue = snapshot.crimeWithVehicleCount;
      data = { crimesWithVehicle: currentValue };
      break;

    case 'crimes_with_weapon':
      currentValue = snapshot.crimeWithWeaponCount;
      data = { crimesWithWeapon: currentValue };
      break;

    case 'crimes_with_vehicle_weapon_tools':
      currentValue = snapshot.crimeWithVehicleWeaponToolCount;
      data = { crimesWithVehicleWeaponTools: currentValue };
      break;

    case 'unique_crimes_completed':
      currentValue = snapshot.uniqueCrimeTypesCompletedCount;
      data = {
        uniqueCrimesCompleted: currentValue,
        totalCrimeTypes: CRIME_TYPES_COUNT,
      };
      break;

    case 'jobs_completed':
      currentValue = snapshot.jobCount;
      data = { jobsCompleted: currentValue };
      break;

    case 'unique_jobs_completed':
      currentValue = snapshot.uniqueJobTypesCompletedCount;
      data = {
        uniqueJobsCompleted: currentValue,
        totalJobTypes: JOB_TYPES_COUNT,
      };
      break;

    case 'jobs_with_education_requirements_completed':
      currentValue = snapshot.jobsWithEducationRequirementsCount;
      data = {
        jobsWithEducationRequirementsCompleted: currentValue,
      };
      break;

    case 'unique_education_jobs_completed':
      currentValue = snapshot.uniqueEducationJobTypesCompletedCount;
      data = {
        uniqueEducationJobsCompleted: currentValue,
        totalEducationJobTypes: EDUCATION_GATED_JOB_TYPES_COUNT,
      };
      break;

    case 'education_level_reached':
      currentValue = snapshot.educationLevel;
      data = { educationLevel: currentValue };
      break;

    case 'specific_job_completed': {
      const jobId = achievement.requirementJobId ?? '';
      currentValue = jobId ? (snapshot.specificJobsCount[jobId] ?? 0) : 0;
      data = { jobId, count: currentValue };
      break;
    }

    case 'school_certifications_earned':
      currentValue = snapshot.certificationsEarnedCount;
      data = { certificationsEarned: currentValue };
      break;

    case 'school_tracks_mastered':
      currentValue = snapshot.maxedSchoolTracksCount;
      data = { maxedTracks: currentValue };
      break;

    case 'cars_stolen_count':
      currentValue = snapshot.carsStolenCount;
      data = { carsStolenCount: currentValue };
      break;

    case 'boats_stolen_count':
      currentValue = snapshot.boatsStolenCount;
      data = { boatsStolenCount: currentValue };
      break;

    case 'journeys_completed_count':
      currentValue = snapshot.journeysCompletedCount;
      data = { journeysCompletedCount: currentValue };
      break;

    case 'drugs_produced_count':
      currentValue = snapshot.drugsProducedCount;
      data = { drugsProducedCount: currentValue };
      break;

    case 'drug_quantity_produced': {
      const drugId = achievement.requirementDrugId ?? '';
      currentValue = snapshot.drugQuantitiesProduced[drugId] ?? 0;
      data = { drugQuantityProduced: currentValue, drugId };
      break;
    }

    case 'drug_facility_owned': {
      const facilityType = achievement.requirementFacilityType ?? '';
      currentValue = snapshot.drugFacilitiesOwned.includes(facilityType) ? 1 : 0;
      data = { ownsFacility: currentValue === 1, facilityType };
      break;
    }

    case 'drug_high_quality_produced':
      currentValue = snapshot.highQualityDrugsProduced;
      data = { highQualityDrugsProduced: currentValue };
      break;

    case 'trades_completed_count':
      currentValue = snapshot.tradesCompletedCount;
      data = { tradesCompletedCount: currentValue };
      break;

    case 'jailbreaks_success_count':
      currentValue = snapshot.jailbreaksSuccessCount;
      data = { jailbreaksSuccessCount: currentValue };
      break;

    case 'prisoner_buyouts_count':
      currentValue = snapshot.prisonerBuyoutsCount;
      data = { prisonerBuyoutsCount: currentValue };
      break;

    case 'nightclub_venues_count':
      currentValue = snapshot.nightclubVenuesCount;
      data = { nightclubVenuesCount: currentValue };
      break;

    case 'nightclub_total_revenue':
      currentValue = snapshot.nightclubTotalRevenue;
      data = { nightclubTotalRevenue: currentValue };
      break;

    case 'nightclub_sales_count':
      currentValue = snapshot.nightclubSalesCount;
      data = { nightclubSalesCount: currentValue };
      break;

    case 'nightclub_active_staff_count':
      currentValue = snapshot.nightclubActiveStaffCount;
      data = { nightclubActiveStaffCount: currentValue };
      break;

    case 'nightclub_vip_staff_count':
      currentValue = snapshot.nightclubVipStaffCount;
      data = { nightclubVipStaffCount: currentValue };
      break;

    case 'nightclub_dj_hires_count':
      currentValue = snapshot.nightclubDjHiresCount;
      data = { nightclubDjHiresCount: currentValue };
      break;

    case 'nightclub_security_hires_count':
      currentValue = snapshot.nightclubSecurityHiresCount;
      data = { nightclubSecurityHiresCount: currentValue };
      break;

    case 'nightclub_peak_crowd':
      currentValue = snapshot.nightclubPeakCrowd;
      data = { nightclubPeakCrowd: currentValue };
      break;

    case 'nightclub_best_season_rank': {
      const bestRank = snapshot.nightclubBestSeasonRank;
      currentValue = bestRank == null ? 0 : Math.max(0, achievement.requirementValue - bestRank + 1);
      data = {
        nightclubBestSeasonRank: bestRank,
        seasonRankProgress: currentValue,
      };
      meetsRequirement = bestRank != null && bestRank <= achievement.requirementValue;
      const progressPercent = bestRank == null
        ? 0
        : Math.min(100, Math.round((currentValue / Math.max(1, achievement.requirementValue)) * 100));

      return {
        meetsRequirement,
        currentValue,
        progressPercent,
        data,
      };
    }

    case 'crypto_trades_count':
      currentValue = snapshot.cryptoTradesCount;
      data = { cryptoTradesCount: currentValue };
      break;

    case 'crypto_realized_profit':
      currentValue = Math.max(0, Math.floor(snapshot.cryptoRealizedProfit));
      data = { cryptoRealizedProfit: snapshot.cryptoRealizedProfit };
      break;

    case 'crypto_portfolio_value':
      currentValue = Math.max(0, Math.floor(snapshot.cryptoPortfolioValue));
      data = { cryptoPortfolioValue: snapshot.cryptoPortfolioValue };
      break;

    case 'max_security_all': {
      const maxSecurityDistricts = snapshot.districts.filter(
        (district) => district.securityLevel >= 5
      ).length;
      const allMaxSecurity =
        snapshot.districts.length > 0 && maxSecurityDistricts === snapshot.districts.length;
      currentValue = allMaxSecurity ? 1 : 0;
      data = { districtsWithMaxSecurity: maxSecurityDistricts };
      break;
    }

    case 'vip_districts': {
      currentValue = snapshot.districts.filter((district) => district.tier === 'vip').length;
      data = { vipDistricts: currentValue };
      break;
    }

    case 'days_not_busted': {
      const hasProstitutes = snapshot.prostitutes.length > 0;
      const hasActiveBust = snapshot.activeBustedProstitutesCount > 0;

      if (!hasProstitutes || hasActiveBust || !snapshot.oldestProstituteRecruitedAt) {
        currentValue = 0;
      } else {
        const streakDays = Math.max(
          0,
          Math.floor(
            (Date.now() - snapshot.oldestProstituteRecruitedAt.getTime()) /
              (1000 * 60 * 60 * 24)
          )
        );

        currentValue = Math.min(achievement.requirementValue, streakDays);
      }

      data = {
        daysNotBusted: currentValue,
        hasActiveBust,
        oldestProstituteRecruitedAt: snapshot.oldestProstituteRecruitedAt,
      };
      break;
    }

    default:
      currentValue = 0;
      data = {};
  }

  meetsRequirement = currentValue >= achievement.requirementValue;
  const progressPercent = Math.min(
    100,
    Math.round((currentValue / Math.max(1, achievement.requirementValue)) * 100)
  );

  return {
    meetsRequirement,
    currentValue,
    progressPercent,
    data,
  };
}

/**
 * Check and unlock achievements for a player
 */
export async function checkAndUnlockAchievements(
  playerId: number
): Promise<Array<{ achievement: AchievementDefinition; newlyUnlocked: boolean }>> {
  try {
    console.log(`[AchievementService] Starting achievement check for player ${playerId}`);
    
    const snapshot = await getAchievementSnapshot(playerId);
    console.log(`[AchievementService] Snapshot retrieved for player ${playerId}`);
    
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { preferredLanguage: true },
    });
    const language = player?.preferredLanguage === 'nl' ? 'nl' : 'en';
    const numberLocale = language === 'nl' ? 'nl-NL' : 'en-US';

    // Get already unlocked achievements
    const existingAchievements = await prisma.prostitutionAchievement.findMany({
      where: { playerId },
      select: { achievementType: true },
    });
    const unlocked = new Set(existingAchievements.map((a: any) => a.achievementType));

    // Check each achievement
    const results: Array<{ achievement: AchievementDefinition; newlyUnlocked: boolean }> = [];
    const toUnlock: Array<{ type: string; data: any }> = [];

    for (const [key, achievement] of Object.entries(ACHIEVEMENT_DEFINITIONS)) {
      const alreadyUnlocked = unlocked.has(key);
      const evaluation = evaluateAchievement(achievement, snapshot);

      if (evaluation.meetsRequirement && !alreadyUnlocked) {
        toUnlock.push({ type: key, data: evaluation.data });
      }

      results.push({
        achievement,
        newlyUnlocked: evaluation.meetsRequirement && !alreadyUnlocked,
      });
    }

    console.log(`[AchievementService] Found ${toUnlock.length} achievements to unlock for player ${playerId}`);

    // Unlock new achievements
    if (toUnlock.length > 0) {
      try {
        await prisma.prostitutionAchievement.createMany({
          data: toUnlock.map(({ type, data }) => ({
            playerId,
            achievementType: type,
            achievementData: JSON.stringify(data),
          })),
          skipDuplicates: true,
        });
        console.log(`[AchievementService] Successfully saved ${toUnlock.length} new achievements for player ${playerId}`);
      } catch (dbError) {
        console.error(`[AchievementService] Error saving achievements to DB for player ${playerId}:`, dbError);
        throw new Error(`Failed to save achievements: ${dbError instanceof Error ? dbError.message : String(dbError)}`);
      }

      // Award rewards
      for (const { type } of toUnlock) {
        try {
          const achievement = ACHIEVEMENT_DEFINITIONS[type];
          const rewardMoney = achievement.rewardMoney ?? 0;
          const rewardXp = achievement.rewardXp ?? 0;

          if (achievement.rewardMoney || achievement.rewardXp) {
            await prisma.player.update({
              where: { id: playerId },
              data: {
                money: { increment: rewardMoney },
                xp: { increment: rewardXp },
              },
            });
          }

          await activityService.logActivity(
            playerId,
            'ACHIEVEMENT',
            language === 'nl'
              ? `Prestatie vrijgespeeld: ${achievement.title}`
              : `Achievement unlocked: ${achievement.title}`,
            {
              achievementId: achievement.id,
              achievementTitle: achievement.title,
              reward: rewardMoney,
              xpGained: rewardXp,
              language,
            },
            true
          );

          const rewardLines =
            language === 'nl'
              ? [
                  `🏆 Prestatie vrijgespeeld: ${achievement.title}`,
                  '',
                  achievement.description,
                  '',
                  'Beloning:',
                  `• Geld: €${rewardMoney.toLocaleString(numberLocale)}`,
                  `• XP: ${rewardXp.toLocaleString(numberLocale)}`,
                  '',
                  `🎖 Badge: ${achievement.icon} ${achievement.title}`,
                  `[[achievement:${achievement.category}/${achievement.id}]]`,
                ]
              : [
                  `🏆 Achievement Unlocked: ${achievement.title}`,
                  '',
                  achievement.description,
                  '',
                  'Reward:',
                  `• Money: €${rewardMoney.toLocaleString(numberLocale)}`,
                  `• XP: ${rewardXp.toLocaleString(numberLocale)}`,
                  '',
                  `🎖 Badge: ${achievement.icon} ${achievement.title}`,
                  `[[achievement:${achievement.category}/${achievement.id}]]`,
                ];

          await directMessageService.sendSystemMessage(playerId, rewardLines.join('\n'));
        } catch (rewardError) {
          console.error(`[AchievementService] Error processing reward for achievement ${type} (player ${playerId}):`, rewardError);
          // Don't throw - continue processing other achievements even if one reward fails
        }
      }
    }

    console.log(`[AchievementService] Achievement check complete for player ${playerId}: ${results.filter(r => r.newlyUnlocked).length} newly unlocked`);
    return results.filter(r => r.newlyUnlocked);
  } catch (error) {
    console.error(`[AchievementService] Fatal error in checkAndUnlockAchievements for player ${playerId}:`, error);
    throw error;
  }
}

/**
 * Get player's achievements with definitions
 */
export async function getPlayerAchievements(playerId: number) {
  const snapshot = await getAchievementSnapshot(playerId);

  let unlocked = await prisma.prostitutionAchievement.findMany({
    where: { playerId },
    orderBy: { unlockedAt: 'desc' },
  });

  const invalidAchievementTypes = unlocked
    .map((achievement: any) => achievement.achievementType as string)
    .filter((achievementType) => {
      const definition = ACHIEVEMENT_DEFINITIONS[achievementType];
      if (!definition) {
        return false;
      }

      const shouldValidate =
        definition.requirementType === 'education_level_reached' ||
        JOB_REQUIREMENT_TYPES_TO_VALIDATE.has(definition.requirementType);

      if (!shouldValidate) {
        return false;
      }

      const evaluation = evaluateAchievement(definition, snapshot);
      return !evaluation.meetsRequirement;
    });

  if (invalidAchievementTypes.length > 0) {
    await prisma.prostitutionAchievement.deleteMany({
      where: {
        playerId,
        achievementType: { in: invalidAchievementTypes },
      },
    });

    unlocked = unlocked.filter(
      (achievement: any) => !invalidAchievementTypes.includes(achievement.achievementType)
    );
  }

  const unlockedTypes = new Set(unlocked.map((a: any) => a.achievementType));

  const achievements = Object.values(ACHIEVEMENT_DEFINITIONS).map(def => {
    const evaluation = evaluateAchievement(def, snapshot);
    const unlockedEntry = unlocked.find((achievement: any) => achievement.achievementType === def.id);
    const isUnlocked = unlockedTypes.has(def.id) || evaluation.meetsRequirement;

    return ({
    ...def,
    unlocked: isUnlocked,
    unlockedAt: unlockedEntry?.unlockedAt ?? null,
    achievementData: unlockedEntry?.achievementData ?? evaluation.data,
    currentValue: evaluation.currentValue,
    progressPercent: evaluation.progressPercent,
  });
  });

  const effectiveUnlockedCount = achievements.filter((achievement) => achievement.unlocked).length;
  const totalAchievements = Object.keys(ACHIEVEMENT_DEFINITIONS).length;

  return {
    achievements,
    totalAchievements,
    unlockedCount: effectiveUnlockedCount,
    progress: Math.round((effectiveUnlockedCount / totalAchievements) * 100),
  };
}

/**
 * Get all achievement definitions
 */
export function getAllAchievementDefinitions() {
  return Object.values(ACHIEVEMENT_DEFINITIONS);
}
