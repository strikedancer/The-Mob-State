/**
 * Human-readable event reward lines for winner inbox / push copy.
 */

import type { SupportedPlayerLanguage } from '../config/supportedLanguages';
import { getEventItemDefinition, parseEventItemGrants } from './eventItemService';
import { parseExtendedEventRewards } from './eventRewardFulfillmentService';

function toPositiveInt(value: unknown): number {
  const n = Number(value);
  if (!Number.isFinite(n) || n <= 0) return 0;
  return Math.floor(n);
}

function parseRewardsRecord(raw: unknown): Record<string, unknown> {
  if (!raw) return {};
  if (typeof raw === 'object' && !Array.isArray(raw)) {
    return raw as Record<string, unknown>;
  }
  if (typeof raw === 'string' && raw.trim()) {
    try {
      const parsed = JSON.parse(raw);
      if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
        return parsed as Record<string, unknown>;
      }
    } catch {
      return {};
    }
  }
  return {};
}

function moneyLocale(lang: SupportedPlayerLanguage): string {
  if (lang === 'nl') return 'nl-NL';
  if (lang === 'de') return 'de-DE';
  if (lang === 'fr') return 'fr-FR';
  if (lang === 'es') return 'es-ES';
  if (lang === 'it') return 'it-IT';
  if (lang === 'pl') return 'pl-PL';
  if (lang === 'pt') return 'pt-PT';
  return 'en-US';
}

function formatCash(amount: number, lang: SupportedPlayerLanguage): string {
  return `€${amount.toLocaleString(moneyLocale(lang))}`;
}

function humanizeId(id: string): string {
  return id
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (ch) => ch.toUpperCase())
    .trim();
}

function creditsLabel(lang: SupportedPlayerLanguage, amount: number): string {
  const n = amount.toLocaleString(moneyLocale(lang));
  if (lang === 'nl') return `${n} credits`;
  if (lang === 'de') return `${n} Credits`;
  if (lang === 'fr') return `${n} crédits`;
  if (lang === 'es') return `${n} créditos`;
  if (lang === 'it') return `${n} crediti`;
  if (lang === 'pl') return `${n} kredytów`;
  if (lang === 'pt') return `${n} créditos`;
  return `${n} credits`;
}

function itemName(lang: SupportedPlayerLanguage, itemKey: string): string {
  const def = getEventItemDefinition(itemKey);
  if (def) {
    return lang === 'nl' ? def.nameNl : def.nameEn;
  }
  return humanizeId(itemKey);
}

function qtySuffix(quantity: number): string {
  return quantity > 1 ? ` ×${quantity}` : '';
}

/**
 * Merge one or more rewardsJson blobs into a single player-facing summary line.
 * Returns empty string when nothing grantable is present.
 */
export function formatEventRewardSummary(
  lang: SupportedPlayerLanguage,
  rewardsList: unknown[],
): string {
  let cash = 0;
  let xp = 0;
  let premiumCredits = 0;
  const itemTotals = new Map<string, number>();
  const ammoTotals = new Map<string, number>();
  const toolTotals = new Map<string, number>();
  const weaponTotals = new Map<string, number>();
  const vehicleIds: string[] = [];
  let carParts = 0;
  let motorcycleParts = 0;
  let boatParts = 0;

  for (const raw of rewardsList) {
    const rewards = parseRewardsRecord(raw);
    cash += toPositiveInt(rewards.cash);
    xp += toPositiveInt(rewards.xp);
    premiumCredits += toPositiveInt(rewards.premiumCredits);

    for (const grant of parseEventItemGrants(rewards)) {
      itemTotals.set(grant.itemKey, (itemTotals.get(grant.itemKey) ?? 0) + grant.quantity);
    }

    const extended = parseExtendedEventRewards(rewards);
    for (const row of extended.ammo) {
      ammoTotals.set(row.ammoType, (ammoTotals.get(row.ammoType) ?? 0) + row.quantity);
    }
    for (const row of extended.tools) {
      toolTotals.set(row.toolId, (toolTotals.get(row.toolId) ?? 0) + row.quantity);
    }
    for (const row of extended.weapons) {
      const qty = Math.max(1, row.quantity || 1);
      weaponTotals.set(row.weaponId, (weaponTotals.get(row.weaponId) ?? 0) + qty);
    }
    for (const row of extended.vehicles) {
      vehicleIds.push(row.vehicleId);
    }
    carParts += extended.vehicleParts.car;
    motorcycleParts += extended.vehicleParts.motorcycle;
    boatParts += extended.vehicleParts.boat;
  }

  const parts: string[] = [];
  if (cash > 0) parts.push(formatCash(cash, lang));
  if (xp > 0) parts.push(`${xp.toLocaleString(moneyLocale(lang))} XP`);
  if (premiumCredits > 0) parts.push(creditsLabel(lang, premiumCredits));

  for (const [itemKey, quantity] of itemTotals) {
    parts.push(`${itemName(lang, itemKey)}${qtySuffix(quantity)}`);
  }
  for (const [ammoType, quantity] of ammoTotals) {
    parts.push(`${humanizeId(ammoType)}${qtySuffix(quantity)}`);
  }
  for (const [toolId, quantity] of toolTotals) {
    parts.push(`${humanizeId(toolId)}${qtySuffix(quantity)}`);
  }
  for (const [weaponId, quantity] of weaponTotals) {
    parts.push(`${humanizeId(weaponId)}${qtySuffix(quantity)}`);
  }
  for (const vehicleId of vehicleIds) {
    parts.push(humanizeId(vehicleId));
  }
  if (carParts > 0) {
    parts.push(lang === 'nl' ? `Auto-onderdelen ×${carParts}` : `Car parts ×${carParts}`);
  }
  if (motorcycleParts > 0) {
    parts.push(
      lang === 'nl' ? `Motor-onderdelen ×${motorcycleParts}` : `Motorcycle parts ×${motorcycleParts}`,
    );
  }
  if (boatParts > 0) {
    parts.push(lang === 'nl' ? `Boot-onderdelen ×${boatParts}` : `Boat parts ×${boatParts}`);
  }

  return parts.join(' · ');
}

export function rewardHeading(lang: SupportedPlayerLanguage): string {
  if (lang === 'nl') return 'Beloning';
  if (lang === 'de') return 'Belohnung';
  if (lang === 'fr') return 'Récompense';
  if (lang === 'es') return 'Recompensa';
  if (lang === 'it') return 'Premio';
  if (lang === 'pl') return 'Nagroda';
  if (lang === 'pt') return 'Recompensa';
  return 'Reward';
}
