/**
 * Rank/Level System - Based on Mafiawar
 * Converts numeric rank to level titles
 */

export const RANK_TITLES = [
  { minLevel: 1, maxLevel: 1, title: 'Empty Suit', icon: '🎩' },
  { minLevel: 2, maxLevel: 2, title: 'Delivery Boy', icon: '🚚' },
  { minLevel: 3, maxLevel: 4, title: 'Picciotto', icon: '🤝' },
  { minLevel: 5, maxLevel: 6, title: 'Shoplifter', icon: '🛍️' },
  { minLevel: 7, maxLevel: 9, title: 'Pickpocket', icon: '👜' },
  { minLevel: 10, maxLevel: 14, title: 'Thief', icon: '🔓' },
  { minLevel: 15, maxLevel: 19, title: 'Associate', icon: '🤐' },
  { minLevel: 20, maxLevel: 24, title: 'Cadet', icon: '📋' },
  { minLevel: 25, maxLevel: 29, title: 'Soldier', icon: '💪' },
  { minLevel: 30, maxLevel: 34, title: 'Swindler', icon: '🎰' },
  { minLevel: 35, maxLevel: 39, title: 'Assassin', icon: '🎯' },
  { minLevel: 40, maxLevel: 44, title: 'Local Chief', icon: '⭐' },
  { minLevel: 45, maxLevel: 49, title: 'Chief', icon: '👑' },
  { minLevel: 50, maxLevel: 59, title: 'Drug-Lord', icon: '💊' },
  { minLevel: 60, maxLevel: 74, title: 'Godfather', icon: '👨‍💼' },
  { minLevel: 75, maxLevel: 89, title: 'Don', icon: '💎' },
  { minLevel: 90, maxLevel: 119, title: 'Overlord', icon: '⚡' },
  { minLevel: 120, maxLevel: 150, title: 'Legend', icon: '🏆' },
];

export function getRankTitle(level: number): { title: string; icon: string } {
  const rank = RANK_TITLES.find(r => level >= r.minLevel && level <= r.maxLevel);
  return rank ? { title: rank.title, icon: rank.icon } : { title: 'Unknown', icon: '❓' };
}

export function getNextRank(level: number): { title: string; icon: string; requiredLevel: number } | null {
  const currentRankIndex = RANK_TITLES.findIndex(r => level >= r.minLevel && level <= r.maxLevel);
  if (currentRankIndex === -1 || currentRankIndex === RANK_TITLES.length - 1) return null;
  
  const nextRank = RANK_TITLES[currentRankIndex + 1];
  return {
    title: nextRank.title,
    icon: nextRank.icon,
    requiredLevel: nextRank.minLevel,
  };
}

/**
 * Calculate reputation change based on actions
 */
export function calculateReputationChange(action: string, success: boolean): number {
  const reputationChanges: Record<string, { success: number; failure: number }> = {
    crime_success: { success: 5, failure: -2 },
    crime_caught: { success: 0, failure: -10 },
    heist_success: { success: 25, failure: -5 },
    heist_failed: { success: 0, failure: -15 },
    trade_profit: { success: 2, failure: 0 },
    crew_join: { success: 10, failure: 0 },
    crew_kicked: { success: 0, failure: -20 },
    player_helped: { success: 15, failure: 0 },
    player_betrayed: { success: 0, failure: -30 },
  };

  const change = reputationChanges[action];
  if (!change) return 0;
  
  return success ? change.success : change.failure;
}

/**
 * Available avatars
 */
export const AVATARS = {
  free: [
    // Male - Light skin
    'male_light_suit',
    'male_light_leather',
    'male_light_casual',
    
    // Male - Medium skin
    'male_medium_suit',
    'male_medium_leather',
    'male_medium_casual',
    
    // Male - Dark skin
    'male_dark_suit',
    'male_dark_leather',
    'male_dark_casual',
    
    // Female - Light skin
    'female_light_elegant',
    'female_light_business',
    'female_light_casual',
    
    // Female - Medium skin
    'female_medium_elegant',
    'female_medium_business',
    'female_medium_casual',
    
    // Female - Dark skin
    'female_dark_elegant',
    'female_dark_business',
    'female_dark_casual',
    
    // Gender Neutral
    'neutral_light_formal',
    'neutral_light_casual',
    'neutral_medium_formal',
    'neutral_medium_casual',
    'neutral_dark_formal',
    'neutral_dark_casual',
    
    // Asian
    'male_asian_formal',
    'male_asian_casual',
    'female_asian_elegant',
    'female_asian_business',
    
    // Latino
    'male_latino_formal',
    'male_latino_casual',
    'female_latino_elegant',
    'female_latino_casual',
    
    // Middle Eastern
    'male_middle_eastern_formal',
    'male_middle_eastern_casual',
    'female_middle_eastern_elegant',
    'female_middle_eastern_business',
    
    // Default
    'default_1',
  ],
  
  vip: [
    'vip_kingpin',
    'vip_queen',
    'vip_shadow',
    'vip_veteran',
    'vip_assassin',
    'vip_hacker',
    'vip_don_1920s',
    'vip_arms_dealer',
    'vip_casino_owner',
    'vip_agent',
    'vip_gang_leader',
    'vip_cartel_boss',
    
    // Asian VIP
    'vip_yakuza_boss',
    'vip_triad_leader',
    'vip_asian_matriarch',
    'vip_dragon_lady',
    
    // Latino VIP
    'vip_latin_kingpin',
    'vip_narco_boss',
    'vip_latina_queenpin',
    'vip_cartel_heiress',
    
    // Middle Eastern VIP
    'vip_oil_baron',
    'vip_arms_merchant',
    'vip_desert_queen',
    'vip_modern_sultana',
  ],
};

export function isAvatarAvailable(avatar: string, isVip: boolean): boolean {
  if (AVATARS.free.includes(avatar)) return true;
  if (AVATARS.vip.includes(avatar) && isVip) return true;
  return false;
}

export function canChangeAvatar(lastChange: Date | null): boolean {
  if (!lastChange) return true;
  const weekAgo = new Date();
  weekAgo.setDate(weekAgo.getDate() - 7);
  return lastChange < weekAgo;
}

export function canChangeUsername(lastChange: Date | null): boolean {
  if (!lastChange) return true;
  const monthAgo = new Date();
  monthAgo.setMonth(monthAgo.getMonth() - 1);
  return lastChange < monthAgo;
}
