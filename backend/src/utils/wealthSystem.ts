/**
 * Wealth/Money Status System - Based on Mafiawar
 * Determines player's wealth status based on total money
 */

export interface WealthStatus {
  title: string;
  icon: string;
  minMoney: number;
  maxMoney: number;
}

export const WEALTH_STATUSES: WealthStatus[] = [
  { title: 'Sloeber', icon: '🚫', minMoney: 0, maxMoney: 999_999 },
  { title: 'Ars', icon: '💸', minMoney: 1_000_000, maxMoney: 4_999_999 },
  { title: 'Modaal', icon: '💵', minMoney: 5_000_000, maxMoney: 9_999_999 },
  { title: 'Rijk', icon: '💰', minMoney: 10_000_000, maxMoney: 49_999_999 },
  { title: 'Erg Rijk', icon: '💎', minMoney: 50_000_000, maxMoney: 99_999_999 },
  { title: 'Te Rijk om Waar te Zijn', icon: '👑', minMoney: 100_000_000, maxMoney: 999_999_999 },
  { title: 'Rijker dan God', icon: '🌟', minMoney: 1_000_000_000, maxMoney: Infinity },
];

/**
 * Get wealth status based on money amount
 */
export function getWealthStatus(money: number): WealthStatus {
  const status = WEALTH_STATUSES.find(w => money >= w.minMoney && money <= w.maxMoney);
  return status || WEALTH_STATUSES[0]; // Default to Sloeber if not found
}

/**
 * Get wealth status title
 */
export function getWealthTitle(money: number): string {
  return getWealthStatus(money).title;
}

/**
 * Get wealth status icon
 */
export function getWealthIcon(money: number): string {
  return getWealthStatus(money).icon;
}
