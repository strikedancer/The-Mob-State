/**
 * Hit List Service - Phase C.4
 * 
 * Handles hit list creation, bounties, combat, and security system
 */

import prisma from '../lib/prisma';
import { ammoFactoryService } from './ammoFactoryService';
import weaponService from './weaponService';
import { weaponSelectionService } from './weaponSelectionService';
import { directMessageService } from './directMessageService';
import { getActiveEventBoostEffects } from './premiumCreditsService';
import fs from 'fs';
import path from 'path';

const BODYGUARD_DAILY_UPKEEP = 10000;
const BODYGUARD_DEFENSE = 10;
const DAY_IN_MS = 24 * 60 * 60 * 1000;
const MURDER_CASE_ACTIVITY_TYPE = 'HITLIST_MURDER_CASE';
const MURDER_CASE_WINDOW_MS = 24 * 60 * 60 * 1000;
const MURDER_CASE_SOLVE_CHANCE = 0.65;
const MURDER_CASE_MIN_REPORT_DELAY_MS = 15 * 60 * 1000;
const MURDER_CASE_MAX_REPORT_DELAY_MS = 12 * 60 * 60 * 1000;
const HITLIST_LOOT_CASH_PERCENT_KEY = 'HITLIST_LOOT_CASH_PERCENT';
const HITLIST_LOOT_ITEM_PERCENT_KEY = 'HITLIST_LOOT_ITEM_PERCENT';
const HITLIST_LOOT_CASH_PERCENT_DEFAULT = 60;
const HITLIST_LOOT_ITEM_PERCENT_DEFAULT = 50;

interface HitLootSettings {
  cashShare: number;
  itemShare: number;
}

let runtimeConfigTableReady = false;

interface SecurityArmorDefinition {
  id: string;
  name: string;
  price: number;
  armor: number;
  description: string;
}

interface PlayerSecurityState {
  id: number;
  playerId: number;
  bodyguards: number;
  bodyguardUpkeepDueAt: Date | null;
  armor: number;
  armorCondition: number;
  armorType: string | null;
}

let cachedArmorDefinitions: SecurityArmorDefinition[] | null = null;

interface HitListItem {
  id: number;
  targetId: number;
  placedById: number;
  bounty: number;
  counterBounty?: number;
  status: string;
  createdAt: Date;
  completedAt?: Date;
  completedBy?: number;
}

interface HitLootSummary {
  cashTaken: number;
  cashAwarded: number;
  itemsTaken: number;
  itemsAwarded: number;
}

interface MurderCaseDetails {
  caseId: number;
  hitId: number;
  victimId: number;
  victimUsername: string;
  killerId: number;
  killerUsername: string;
  createdAt: string;
  expiresAt: string;
  investigationRequestedAt: string | null;
  investigationResolveAt: string | null;
  resolvedAt: string | null;
  solved: boolean | null;
}

interface MurderCaseActionResult {
  caseId: number;
  expiresAt: string;
}

async function ensureRuntimeConfigTable(): Promise<void> {
  if (runtimeConfigTableReady) {
    return;
  }

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS runtime_config (
      configKey VARCHAR(120) NOT NULL PRIMARY KEY,
      configValue VARCHAR(255) NOT NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);

  runtimeConfigTableReady = true;
}

function parseLootPercent(rawValue: string | undefined, fallback: number): number {
  if (rawValue == null || rawValue === '') {
    return fallback;
  }

  const parsed = Number(rawValue);
  if (!Number.isFinite(parsed)) {
    return fallback;
  }

  // Backward compatibility: allow legacy share format (0-1)
  if (parsed >= 0 && parsed <= 1) {
    return Math.round(parsed * 100);
  }

  return Math.max(0, Math.min(100, Math.round(parsed)));
}

async function getHitLootSettings(): Promise<HitLootSettings> {
  try {
    await ensureRuntimeConfigTable();
    const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `
        SELECT configKey, configValue
        FROM runtime_config
        WHERE configKey IN (?, ?)
      `,
      HITLIST_LOOT_CASH_PERCENT_KEY,
      HITLIST_LOOT_ITEM_PERCENT_KEY,
    );

    const valueMap = rows.reduce<Record<string, string>>((acc, row) => {
      acc[row.configKey] = String(row.configValue ?? '');
      return acc;
    }, {});

    const cashPercent = parseLootPercent(
      valueMap[HITLIST_LOOT_CASH_PERCENT_KEY],
      HITLIST_LOOT_CASH_PERCENT_DEFAULT,
    );
    const itemPercent = parseLootPercent(
      valueMap[HITLIST_LOOT_ITEM_PERCENT_KEY],
      HITLIST_LOOT_ITEM_PERCENT_DEFAULT,
    );

    return {
      cashShare: cashPercent / 100,
      itemShare: itemPercent / 100,
    };
  } catch (error) {
    console.warn('Hitlist loot settings fallback to defaults:', error);
    return {
      cashShare: HITLIST_LOOT_CASH_PERCENT_DEFAULT / 100,
      itemShare: HITLIST_LOOT_ITEM_PERCENT_DEFAULT / 100,
    };
  }
}

function parseMurderCaseDetails(rawDetails: string | null | undefined): MurderCaseDetails | null {
  if (!rawDetails) {
    return null;
  }

  try {
    const parsed = JSON.parse(rawDetails) as Partial<MurderCaseDetails>;
    if (!parsed || typeof parsed !== 'object') {
      return null;
    }

    const caseId = Number(parsed.caseId || 0);
    const hitId = Number(parsed.hitId || 0);
    const victimId = Number(parsed.victimId || 0);
    const killerId = Number(parsed.killerId || 0);
    const victimUsername = String(parsed.victimUsername || '');
    const killerUsername = String(parsed.killerUsername || '');
    const createdAt = String(parsed.createdAt || '');
    const expiresAt = String(parsed.expiresAt || '');

    if (!caseId || !hitId || !victimId || !killerId || !createdAt || !expiresAt) {
      return null;
    }

    return {
      caseId,
      hitId,
      victimId,
      victimUsername,
      killerId,
      killerUsername,
      createdAt,
      expiresAt,
      investigationRequestedAt: parsed.investigationRequestedAt || null,
      investigationResolveAt: parsed.investigationResolveAt || null,
      resolvedAt: parsed.resolvedAt || null,
      solved: typeof parsed.solved === 'boolean' ? parsed.solved : null,
    };
  } catch {
    return null;
  }
}

function buildMurderCaseNotification(
  language: 'nl' | 'en',
  caseInfo: MurderCaseActionResult,
  victimUsername: string,
): string {
  const marker = `[[hitlist_murder_case:${caseInfo.caseId}:${caseInfo.expiresAt}]]`;

  if (language === 'nl') {
    return [
      'Moordlijst melding',
      `${victimUsername}, je bent zojuist vermoord via de moordlijst.`,
      'Je accountprogress is hard gereset naar basisstatus, maar je banktegoed en crew-leiderschap blijven behouden.',
      'Je kunt binnen 24 uur een detective-onderzoek starten via de knop in dit bericht.',
      'Detective Bureau stuurt daarna een nieuw rapport en kan de moordenaar mogelijk identificeren.',
      marker,
    ].join('\n');
  }

  return [
    'Hitlist notice',
    `${victimUsername}, you were just killed through the hitlist.`,
    'Your account progress was hard-reset to baseline status, but your bank balance and crew leadership are preserved.',
    'You can start a detective investigation within 24 hours using the button in this message.',
    'Detective Bureau will then send a follow-up report and may identify the killer.',
    marker,
  ].join('\n');
}

async function resetKilledPlayerProgressInTransaction(tx: any, playerId: number): Promise<void> {
  const crewMembership = await tx.crewMember.findUnique({
    where: { playerId },
    select: { crewId: true, role: true },
  });
  const wasCrewLeader = crewMembership?.role === 'leader';

  await tx.actionCooldown.deleteMany({ where: { playerId } });
  await tx.crimeAttempt.deleteMany({ where: { playerId } });
  await tx.jobAttempt.deleteMany({ where: { playerId } });
  await tx.inventory.deleteMany({ where: { playerId } });
  await tx.vehicleInventory.deleteMany({ where: { playerId } });
  await tx.ammoInventory.deleteMany({ where: { playerId } });
  await tx.weaponInventory.deleteMany({ where: { playerId } });
  await tx.playerTools.deleteMany({ where: { playerId } });
  await tx.property.deleteMany({ where: { playerId } });
  await tx.prostitute.deleteMany({ where: { playerId } });
  await tx.drugProduction.deleteMany({ where: { playerId } });
  await tx.productionMaterial.deleteMany({ where: { playerId } });
  await tx.playerActivity.deleteMany({ where: { playerId } });
  await tx.worldEvent.deleteMany({ where: { playerId } });
  await tx.crypto_orders.deleteMany({ where: { player_id: playerId } });
  await tx.crypto_transactions.deleteMany({ where: { player_id: playerId } });
  await tx.crypto_holdings.deleteMany({ where: { player_id: playerId } });
  await tx.crypto_mission_progress.deleteMany({ where: { player_id: playerId } });
  await tx.crypto_leaderboard_rewards.deleteMany({ where: { player_id: playerId } });
  await tx.playerBackpack.deleteMany({ where: { playerId } }).catch(() => undefined);
  await tx.playerSelectedVehicle.deleteMany({ where: { playerId } }).catch(() => undefined);

  await tx.player.update({
    where: { id: playerId },
    data: {
      money: 0,
      health: 100,
      hunger: 100,
      thirst: 100,
      rank: 1,
      xp: 0,
      currentCountry: 'netherlands',
      fbiHeat: 0,
      wantedLevel: 0,
      travelingTo: null,
      travelRoute: null,
      currentTravelLeg: 0,
      travelStartedAt: null,
      killCount: 0,
      isHunted: false,
      hitCount: 0,
      jailRelease: null,
      intensiveCareUntil: null,
      inventory_slots_used: 0,
      max_inventory_slots: 5,
      lastAmmoPurchaseAt: null,
      lastHospitalVisit: null,
      reputation: 0,
      lastProstituteRecruitment: null,
      drugHeat: 0,
      autoCollectDrugs: false,
      lastDrugActionAt: null,
    },
  });

  // Keep crew ownership stable for leaders so crew systems do not orphan or break.
  if (wasCrewLeader && crewMembership) {
    await tx.crewMember.upsert({
      where: { playerId },
      update: {
        crewId: crewMembership.crewId,
        role: 'leader',
      },
      create: {
        playerId,
        crewId: crewMembership.crewId,
        role: 'leader',
      },
    });
  }
}

function buildMurderCaseReport(
  language: 'nl' | 'en',
  solved: boolean,
  killerUsername: string,
): string {
  if (language === 'nl') {
    if (solved) {
      return [
        'Detective Bureau rapport',
        `Onderzoek afgerond: we hebben je moordenaar kunnen identificeren.`,
        `Dader: ${killerUsername}`,
      ].join('\n');
    }

    return [
      'Detective Bureau rapport',
      'Onderzoek afgerond: het spoor werd koud en de dader kon niet met zekerheid worden vastgesteld.',
      'Je kunt dit dossier niet opnieuw openen.',
    ].join('\n');
  }

  if (solved) {
    return [
      'Detective Bureau report',
      'Investigation complete: we were able to identify your killer.',
      `Killer: ${killerUsername}`,
    ].join('\n');
  }

  return [
    'Detective Bureau report',
    'Investigation complete: the trail went cold and we could not identify the killer with certainty.',
    'This case cannot be reopened.',
  ].join('\n');
}

function getMurderCaseRequestDelayRatio(caseDetails: MurderCaseDetails, requestedAt: Date): number {
  const createdAtMs = Date.parse(caseDetails.createdAt);
  if (!Number.isFinite(createdAtMs)) {
    return 1;
  }

  const elapsedMs = Math.max(0, requestedAt.getTime() - createdAtMs);
  return Math.max(0, Math.min(1, elapsedMs / MURDER_CASE_WINDOW_MS));
}

function getMurderCaseReportDelayMs(caseDetails: MurderCaseDetails, requestedAt: Date): number {
  const ratio = getMurderCaseRequestDelayRatio(caseDetails, requestedAt);
  const dynamicDelay =
    MURDER_CASE_MIN_REPORT_DELAY_MS +
    (MURDER_CASE_MAX_REPORT_DELAY_MS - MURDER_CASE_MIN_REPORT_DELAY_MS) * ratio;

  return Math.round(dynamicDelay);
}

function buildMurderCaseQueuedMessage(
  language: 'nl' | 'en',
  resolveAt: Date,
): { message: string; etaMinutes: number } {
  const etaMinutes = Math.max(1, Math.ceil((resolveAt.getTime() - Date.now()) / 60000));
  const resolveAtIso = resolveAt.toISOString();

  if (language === 'nl') {
    return {
      etaMinutes,
      message:
        `Onderzoek gestart. Detective Bureau werkt dit dossier asynchroon af. ` +
        `Hoe eerder je aanvraagt, hoe sneller je rapport. Verwachte rapporttijd: ${resolveAtIso}.`,
    };
  }

  return {
    etaMinutes,
    message:
      `Investigation started. Detective Bureau will process this case asynchronously. ` +
      `The earlier you request, the faster your report. Expected report time: ${resolveAtIso}.`,
  };
}

function buildHitPlacedOnMeMessage(
  language: 'nl' | 'en',
  placedByUsername: string,
  bounty: number,
): string {
  if (language === 'nl') {
    return [
      'Er is een moordlijst-contract op je geplaatst.',
      `Bounty: €${bounty.toLocaleString('nl-NL')}`,
      `Geplaatst door: ${placedByUsername}`,
      'Tip: overweeg direct extra beveiliging of een tegen-bounty.',
    ].join('\n');
  }

  return [
    'A hitlist contract was placed on you.',
    `Bounty: €${bounty.toLocaleString('en-US')}`,
    `Placed by: ${placedByUsername}`,
    'Tip: consider buying extra protection or placing a counter-bounty immediately.',
  ].join('\n');
}

function buildKillerSuccessMessage(
  language: 'nl' | 'en',
  victimUsername: string,
  bounty: number,
  loot: HitLootSummary,
): string {
  if (language === 'nl') {
    const lines = [
      `Je hebt ${victimUsername} geëlimineerd via de moordlijst.`,
      `Bounty ontvangen: €${bounty.toLocaleString('nl-NL')}`,
    ];
    if (loot.cashAwarded > 0) {
      lines.push(`Contant geld buit: €${loot.cashAwarded.toLocaleString('nl-NL')} (${loot.cashTaken > 0 ? Math.round((loot.cashAwarded / loot.cashTaken) * 100) : 0}% van ${loot.cashTaken.toLocaleString('nl-NL')})`);
    }
    if (loot.itemsAwarded > 0) {
      lines.push(`Items buit: ${loot.itemsAwarded} voorwerp(en) overgenomen.`);
    }
    lines.push('Je stats zijn bijgewerkt. Goed werk, moordenaar.');
    return lines.join('\n');
  }

  const lines = [
    `You eliminated ${victimUsername} via the hitlist.`,
    `Bounty received: €${bounty.toLocaleString('en-US')}`,
  ];
  if (loot.cashAwarded > 0) {
    lines.push(`Cash looted: €${loot.cashAwarded.toLocaleString('en-US')} (${loot.cashTaken > 0 ? Math.round((loot.cashAwarded / loot.cashTaken) * 100) : 0}% of €${loot.cashTaken.toLocaleString('en-US')})`);
  }
  if (loot.itemsAwarded > 0) {
    lines.push(`Items looted: ${loot.itemsAwarded} item(s) transferred to your inventory.`);
  }
  lines.push('Your stats have been updated. Good work, hitman.');
  return lines.join('\n');
}

async function createMurderCaseForVictim(
  victimId: number,
  killerId: number,
  hitId: number,
): Promise<MurderCaseActionResult | null> {
  const [victim, killer] = await Promise.all([
    prisma.player.findUnique({
      where: { id: victimId },
      select: { username: true, preferredLanguage: true },
    }),
    prisma.player.findUnique({
      where: { id: killerId },
      select: { username: true },
    }),
  ]);

  if (!victim || !killer) {
    return null;
  }

  const now = new Date();
  const expiresAt = new Date(now.getTime() + MURDER_CASE_WINDOW_MS);

  const activity = await prisma.playerActivity.create({
    data: {
      playerId: victimId,
      activityType: MURDER_CASE_ACTIVITY_TYPE,
      description: 'Hitlist murder case',
      details: '{}',
      isPublic: false,
    },
    select: { id: true },
  });

  const caseDetails: MurderCaseDetails = {
    caseId: activity.id,
    hitId,
    victimId,
    victimUsername: victim.username,
    killerId,
    killerUsername: killer.username,
    createdAt: now.toISOString(),
    expiresAt: expiresAt.toISOString(),
    investigationRequestedAt: null,
    investigationResolveAt: null,
    resolvedAt: null,
    solved: null,
  };

  await prisma.playerActivity.update({
    where: { id: activity.id },
    data: {
      details: JSON.stringify(caseDetails),
    },
  });

  const language: 'nl' | 'en' = victim.preferredLanguage?.toLowerCase().startsWith('nl') ? 'nl' : 'en';
  await directMessageService.sendSystemMessage(
    victimId,
    buildMurderCaseNotification(language, { caseId: activity.id, expiresAt: caseDetails.expiresAt }, victim.username),
    {
      senderName: language === 'nl' ? 'Moordlijst Bureau' : 'Hitlist Bureau',
      sendPush: true,
    },
  );

  return {
    caseId: activity.id,
    expiresAt: caseDetails.expiresAt,
  };
}

function calculateLootAmount(quantity: number, share: number): number {
  if (quantity <= 0) return 0;
  return Math.max(1, Math.floor(quantity * share));
}

async function transferHitLoot(
  tx: any,
  killerId: number,
  victimId: number,
  lootSettings: HitLootSettings,
): Promise<HitLootSummary> {
  const summary: HitLootSummary = {
    cashTaken: 0,
    cashAwarded: 0,
    itemsTaken: 0,
    itemsAwarded: 0,
  };

  const victim = await tx.player.findUnique({
    where: { id: victimId },
    select: { money: true },
  });

  const victimCash = Math.max(0, Number(victim?.money || 0));
  summary.cashTaken = victimCash;
  summary.cashAwarded = Math.floor(victimCash * lootSettings.cashShare);

  const victimGoods = await tx.inventory.findMany({
    where: { playerId: victimId, quantity: { gt: 0 } },
  });
  for (const row of victimGoods) {
    const transferQty = calculateLootAmount(Number(row.quantity || 0), lootSettings.itemShare);
    summary.itemsTaken += Number(row.quantity || 0);
    summary.itemsAwarded += transferQty;
    if (transferQty > 0) {
      await tx.inventory.upsert({
        where: {
          playerId_goodType: {
            playerId: killerId,
            goodType: row.goodType,
          },
        },
        update: {
          quantity: { increment: transferQty },
        },
        create: {
          playerId: killerId,
          goodType: row.goodType,
          quantity: transferQty,
          condition: row.condition,
          purchasePrice: row.purchasePrice,
        },
      });
    }
  }
  if (victimGoods.length > 0) {
    await tx.inventory.deleteMany({ where: { playerId: victimId } });
  }

  const victimAmmo = await tx.ammoInventory.findMany({
    where: { playerId: victimId, quantity: { gt: 0 } },
  });
  for (const row of victimAmmo) {
    const transferQty = calculateLootAmount(Number(row.quantity || 0), lootSettings.itemShare);
    summary.itemsTaken += Number(row.quantity || 0);
    summary.itemsAwarded += transferQty;
    if (transferQty > 0) {
      await tx.ammoInventory.upsert({
        where: {
          playerId_ammoType: {
            playerId: killerId,
            ammoType: row.ammoType,
          },
        },
        update: {
          quantity: { increment: transferQty },
          quality: Math.max(Number(row.quality || 1), 1),
        },
        create: {
          playerId: killerId,
          ammoType: row.ammoType,
          quantity: transferQty,
          quality: row.quality,
        },
      });
    }
  }
  if (victimAmmo.length > 0) {
    await tx.ammoInventory.deleteMany({ where: { playerId: victimId } });
  }

  const victimWeapons = await tx.weaponInventory.findMany({
    where: { playerId: victimId, quantity: { gt: 0 } },
  });
  for (const row of victimWeapons) {
    const transferQty = calculateLootAmount(Number(row.quantity || 0), lootSettings.itemShare);
    summary.itemsTaken += Number(row.quantity || 0);
    summary.itemsAwarded += transferQty;
    if (transferQty > 0) {
      await tx.weaponInventory.upsert({
        where: {
          playerId_weaponId: {
            playerId: killerId,
            weaponId: row.weaponId,
          },
        },
        update: {
          quantity: { increment: transferQty },
          condition: Math.max(1, Number(row.condition || 1)),
        },
        create: {
          playerId: killerId,
          weaponId: row.weaponId,
          quantity: transferQty,
          condition: row.condition,
        },
      });
    }
  }
  if (victimWeapons.length > 0) {
    await tx.weaponInventory.deleteMany({ where: { playerId: victimId } });
  }

  const victimTools = await tx.playerTools.findMany({
    where: { playerId: victimId, location: 'carried', quantity: { gt: 0 } },
  });
  for (const row of victimTools) {
    const transferQty = calculateLootAmount(Number(row.quantity || 0), lootSettings.itemShare);
    summary.itemsTaken += Number(row.quantity || 0);
    summary.itemsAwarded += transferQty;
    if (transferQty > 0) {
      const existingTool = await tx.playerTools.findFirst({
        where: {
          playerId: killerId,
          toolId: row.toolId,
          location: 'carried',
          durability: row.durability,
        },
      });

      if (existingTool) {
        await tx.playerTools.update({
          where: { id: existingTool.id },
          data: { quantity: { increment: transferQty } },
        });
      } else {
        await tx.playerTools.create({
          data: {
            playerId: killerId,
            toolId: row.toolId,
            durability: row.durability,
            location: 'carried',
            quantity: transferQty,
          },
        });
      }
    }
  }
  if (victimTools.length > 0) {
    await tx.playerTools.deleteMany({ where: { playerId: victimId, location: 'carried' } });
  }

  return summary;
}

function loadArmorDefinitions(): SecurityArmorDefinition[] {
  if (cachedArmorDefinitions) {
    return cachedArmorDefinitions;
  }

  const filePath = path.resolve(process.cwd(), 'content', 'security.json');
  const raw = fs.readFileSync(filePath, 'utf8');
  const parsed = JSON.parse(raw) as SecurityArmorDefinition[];
  cachedArmorDefinitions = parsed;
  return parsed;
}

function getArmorDefinition(armorId: string): SecurityArmorDefinition {
  const definitions = loadArmorDefinitions();
  const armor = definitions.find((item) => item.id === armorId);
  if (!armor) {
    throw new Error('ARMOR_NOT_FOUND');
  }

  return armor;
}

function getArmorConditionValue(condition?: number | null): number {
  const normalized = typeof condition === 'number' ? condition : 100;
  return Math.max(0, Math.min(100, normalized));
}

function getEffectiveArmor(security?: Pick<PlayerSecurityState, 'armor' | 'armorCondition'> | null): number {
  if (!security || !security.armor) {
    return 0;
  }

  return Math.max(0, Math.round(security.armor * (getArmorConditionValue(security.armorCondition) / 100)));
}

function calculateArmorConditionLoss(attackerPower: number): number {
  return Math.max(6, Math.min(35, Math.round(Math.sqrt(Math.max(1, attackerPower)) * 1.5)));
}

async function settleBodyguardUpkeep(db: any, playerId: number): Promise<PlayerSecurityState | null> {
  const security = await db.playerSecurity.findUnique({
    where: { playerId },
  });

  if (!security) {
    return null;
  }

  const now = new Date();
  let bodyguards = Number(security.bodyguards || 0);
  let upkeepDueAt = security.bodyguardUpkeepDueAt ? new Date(security.bodyguardUpkeepDueAt) : null;
  let changedSecurity = false;

  if (bodyguards <= 0) {
    if (upkeepDueAt !== null) {
      upkeepDueAt = null;
      changedSecurity = true;
    }
  } else if (!upkeepDueAt) {
    upkeepDueAt = new Date(now.getTime() + DAY_IN_MS);
    changedSecurity = true;
  } else {
    const player = await db.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    let balance = Number(player?.money || 0);
    let changedMoney = false;

    while (bodyguards > 0 && upkeepDueAt && upkeepDueAt.getTime() <= now.getTime()) {
      const cycleCost = bodyguards * BODYGUARD_DAILY_UPKEEP;
      if (balance >= cycleCost) {
        balance -= cycleCost;
        upkeepDueAt = new Date(upkeepDueAt.getTime() + DAY_IN_MS);
        changedMoney = true;
      } else {
        bodyguards = 0;
        upkeepDueAt = null;
        changedSecurity = true;
        break;
      }
    }

    if (changedMoney) {
      await db.player.update({
        where: { id: playerId },
        data: { money: balance },
      });
      changedSecurity = true;
    }
  }

  if (!changedSecurity) {
    return {
      ...security,
      armorCondition: getArmorConditionValue(security.armorCondition),
      bodyguardUpkeepDueAt: upkeepDueAt,
      bodyguards,
    };
  }

  return db.playerSecurity.update({
    where: { playerId },
    data: {
      bodyguards,
      bodyguardUpkeepDueAt: upkeepDueAt,
      armorCondition: getArmorConditionValue(security.armorCondition),
    },
  });
}

async function applyArmorWearInTransaction(
  tx: any,
  targetSecurity: PlayerSecurityState | null,
  conditionLoss: number,
) {
  if (!targetSecurity || !targetSecurity.armor || conditionLoss <= 0) {
    return;
  }

  const currentCondition = getArmorConditionValue(targetSecurity.armorCondition);
  const nextCondition = Math.max(0, currentCondition - conditionLoss);

  if (nextCondition <= 0) {
    await tx.playerSecurity.update({
      where: { playerId: targetSecurity.playerId },
      data: {
        armor: 0,
        armorCondition: 100,
        armorType: null,
      },
    });
    return;
  }

  await tx.playerSecurity.update({
    where: { playerId: targetSecurity.playerId },
    data: {
      armorCondition: nextCondition,
    },
  });
}

export async function placeHit(
  playerId: number,
  targetId: number,
  bounty: number
): Promise<HitListItem> {
  // Validate
  if (bounty < 50000) {
    throw new Error('BOUNTY_TOO_LOW');
  }

  if (playerId === targetId) {
    throw new Error('CANNOT_HIT_YOURSELF');
  }

  // Check if player already has active hit on target
  const existing = await prisma.hitList.findFirst({
    where: {
      placedById: playerId,
      targetId,
      status: 'ACTIVE',
    },
  });

  if (existing) {
    throw new Error('HIT_ALREADY_EXISTS');
  }

  // Check if player can afford bounty
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true, username: true },
  });

  if (!player || player.money < bounty) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct bounty from player
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - bounty },
  });

  // Create hit
  const hit = await prisma.hitList.create({
    data: {
      targetId,
      placedById: playerId,
      bounty,
      status: 'ACTIVE',
    },
  });

  // Mark target as hunted
  const target = await prisma.player.update({
    where: { id: targetId },
    data: { isHunted: true },
    select: {
      preferredLanguage: true,
    },
  });

  try {
    const language: 'nl' | 'en' = target.preferredLanguage?.toLowerCase().startsWith('nl') ? 'nl' : 'en';
    await directMessageService.sendSystemMessage(
      targetId,
      buildHitPlacedOnMeMessage(language, player.username, bounty),
      {
        senderName: language === 'nl' ? 'Moordlijst Bureau' : 'Hitlist Bureau',
        sendPush: true,
      },
    );
  } catch (error) {
    console.error('[Hitlist] Failed to send hit placed notification:', error);
  }

  return hit as any;
}

export async function placeCounterBounty(
  playerId: number,
  hitId: number,
  counterBounty: number
): Promise<HitListItem> {
  // Get hit
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  // Only target can place counter-bounty
  if (hit.targetId !== playerId) {
    throw new Error('NOT_TARGET');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  // Check if counter bounty is higher
  if (!counterBounty || counterBounty <= hit.bounty) {
    throw new Error('COUNTER_BOUNTY_MUST_BE_HIGHER');
  }

  // Check if player can afford counter bounty
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  const difference = counterBounty - hit.bounty;
  if (!player || player.money < difference) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct difference from player
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - difference },
  });

  // Update hit with counter bounty
  const updatedHit = await prisma.hitList.update({
    where: { id: hitId },
    data: { counterBounty },
  });

  return updatedHit as any;
}

export async function getActiveHits(pageSize = 20, offset = 0): Promise<any[]> {
  const hits = await prisma.hitList.findMany({
    where: { status: 'ACTIVE' },
    orderBy: { createdAt: 'desc' },
    take: pageSize,
    skip: offset,
    include: {
      target: {
        select: {
          id: true,
          username: true,
          rank: true,
          avatar: true,
          currentCountry: true,
        },
      },
      placedBy: {
        select: {
          id: true,
          username: true,
          rank: true,
          avatar: true,
        },
      },
    },
  });

  return hits.map(hit => ({
    ...hit,
    target: hit.target
      ? {
          ...hit.target,
          level: hit.target.rank,
        }
      : hit.target,
  }));
}

export async function attemptHit(
  playerId: number,
  hitId: number,
  weaponId: string,
  ammoQuantity: number
): Promise<any> {
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  const attacker = await prisma.player.findUnique({
    where: { id: playerId },
    select: { currentCountry: true, money: true, preferredLanguage: true },
  });

  if (!attacker) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const target = await prisma.player.findUnique({
    where: { id: hit.targetId },
    select: { currentCountry: true, hitProtectionExpiresAt: true },
  });

  if (!target) {
    throw new Error('TARGET_NOT_FOUND');
  }

  if (attacker.currentCountry !== target.currentCountry) {
    throw new Error('DIFFERENT_COUNTRY');
  }

  if (target.hitProtectionExpiresAt && target.hitProtectionExpiresAt > new Date()) {
    throw new Error('TARGET_UNDER_HIT_PROTECTION');
  }

  const [attackerBoosts, targetBoosts] = await Promise.all([
    getActiveEventBoostEffects(playerId),
    getActiveEventBoostEffects(hit.targetId),
  ]);

  const normalizedWeaponId = String(weaponId || '').trim();
  const weaponData = weaponService.getWeaponDefinition(normalizedWeaponId);
  if (!weaponData) {
    throw new Error('WEAPON_NOT_FOUND');
  }

  const ownedWeapon = await prisma.weaponInventory.findFirst({
    where: {
      playerId,
      weaponId: normalizedWeaponId,
      quantity: { gt: 0 },
    },
  });

  if (!ownedWeapon) {
    throw new Error('WEAPON_NOT_OWNED');
  }

  if (ownedWeapon.condition <= 0) {
    throw new Error('WEAPON_BROKEN');
  }

  const requiresAmmo = weaponData.requiresAmmo !== false;
  const ammoUsed = requiresAmmo ? Number(ammoQuantity) : 0;
  if (requiresAmmo && (!Number.isFinite(ammoUsed) || ammoUsed <= 0)) {
    throw new Error('INVALID_AMMO');
  }

  let ammoQuality = 1.0;
  let ammoInventoryId: number | null = null;
  let ammoRemaining = 0;

  if (requiresAmmo) {
    const ammoType = weaponData.ammoType;
    if (!ammoType) {
      throw new Error('WEAPON_NOT_FOUND');
    }

    const ammoInventory = await prisma.ammoInventory.findUnique({
      where: {
        playerId_ammoType: {
          playerId,
          ammoType,
        },
      },
    });

    if (!ammoInventory || ammoInventory.quantity < ammoUsed) {
      throw new Error('INSUFFICIENT_AMMO');
    }

    ammoInventoryId = ammoInventory.id;
    ammoRemaining = ammoInventory.quantity - ammoUsed;
    ammoQuality = ammoInventory.quality || 1.0;
  }

  const targetSecurity = await settleBodyguardUpkeep(prisma, hit.targetId);

  const shootingStats = await prisma.shootingRangeStats.findUnique({
    where: { playerId },
  });
  const sessionsCompleted = shootingStats?.sessionsCompleted || 0;
  const accuracy = Math.min(0.9, 0.5 + (sessionsCompleted / 100) * 0.4);
  const hitRoll = Math.random();
  const hitMultiplier = hitRoll <= accuracy ? 1 : 0.2;
  const ammoQualityMultiplier = 1 + (ammoQuality - 1) * 0.5;
  const conditionMultiplier = Math.max(0.2, ownedWeapon.condition / 100);
  const attackVolume = requiresAmmo ? ammoUsed : 1;
  const attackerPower =
    weaponData.damage *
    attackVolume *
    hitMultiplier *
    ammoQualityMultiplier *
    conditionMultiplier *
    (1 + attackerBoosts.hitAttackPct);

  const targetSelectedWeapon = await weaponSelectionService.getSelectedCrimeWeapon(
    hit.targetId,
  );
  const targetWeapon = targetSelectedWeapon?.weaponId
    ? weaponService.getWeaponDefinition(String(targetSelectedWeapon.weaponId))
    : undefined;
  const targetWeaponDamage = targetWeapon?.damage || 0;
  const targetDefense =
    (getEffectiveArmor(targetSecurity) + ((targetSecurity?.bodyguards || 0) * BODYGUARD_DEFENSE)) *
    (1 + targetBoosts.hitDefensePct);
  const targetPower = targetWeaponDamage * 5 + targetDefense;
  const armorConditionLoss = calculateArmorConditionLoss(attackerPower);

  const rawWinChance = attackerPower / Math.max(1, attackerPower + targetPower);
  const winChance = Math.min(0.95, Math.max(0.05, rawWinChance));
  const attackerWins = Math.random() < winChance;

  const bounty =
    hit.counterBounty && hit.counterBounty > hit.bounty
      ? hit.counterBounty
      : hit.bounty;
  const isCounterReversal = !!(hit.counterBounty && hit.counterBounty > hit.bounty);

  const originalPlacer = await prisma.player.findUnique({
    where: { id: hit.placedById },
    select: { money: true },
  });

  if (attackerWins) {
    const victimId = isCounterReversal ? hit.placedById : hit.targetId;
    const lootSettings = await getHitLootSettings();
    let lootSummary: HitLootSummary = {
      cashTaken: 0,
      cashAwarded: 0,
      itemsTaken: 0,
      itemsAwarded: 0,
    };

    await prisma.$transaction(async (tx) => {
      if (ammoInventoryId != null) {
        await tx.ammoInventory.update({
          where: { id: ammoInventoryId },
          data: { quantity: ammoRemaining },
        });
      }

      await applyArmorWearInTransaction(tx, targetSecurity, armorConditionLoss);

      lootSummary = await transferHitLoot(tx, playerId, victimId, lootSettings);

      await tx.player.update({
        where: { id: playerId },
        data: {
          money: attacker.money + bounty + lootSummary.cashAwarded,
          killCount: { increment: 1 },
        },
      });

      await resetKilledPlayerProgressInTransaction(tx, victimId);

      await tx.hitList.update({
        where: { id: hitId },
        data: {
          status: 'COMPLETED',
          completedBy: playerId,
          completedAt: new Date(),
        },
      });
    });

    await ammoFactoryService.revokeFactoriesForPlayer(
      isCounterReversal ? hit.placedById : hit.targetId
    );

    try {
      await createMurderCaseForVictim(victimId, playerId, hitId);
    } catch (error) {
      console.error('[Hitlist] Failed to create murder case notification:', error);
    }

    try {
      const victim = await prisma.player.findUnique({
        where: { id: victimId },
        select: { username: true },
      });
      if (victim) {
        const killerLang: 'nl' | 'en' = attacker.preferredLanguage?.toLowerCase().startsWith('nl') ? 'nl' : 'en';
        const senderName = killerLang === 'nl' ? 'Moordlijst Bureau' : 'Hitlist Bureau';
        await directMessageService.sendSystemMessage(
          playerId,
          buildKillerSuccessMessage(killerLang, victim.username, bounty, lootSummary),
          { senderName, sendPush: true },
        );
      }
    } catch (error) {
      console.error('[Hitlist] Failed to send killer loot notification:', error);
    }

    return {
      success: true,
      winner: playerId,
      bountyPaid: bounty,
      loot: lootSummary,
      message: `Hit completed! ${playerId} won €${bounty}`,
    };
  }

  await prisma.$transaction(async (tx) => {
    if (ammoInventoryId != null) {
      await tx.ammoInventory.update({
        where: { id: ammoInventoryId },
        data: { quantity: ammoRemaining },
      });
    }

    await applyArmorWearInTransaction(tx, targetSecurity, armorConditionLoss);

    if (!isCounterReversal) {
      await tx.player.update({
        where: { id: hit.placedById },
        data: { money: (originalPlacer?.money || 0) + hit.bounty },
      });

      await tx.hitList.update({
        where: { id: hitId },
        data: { status: 'CANCELLED' },
      });
    }
  });

  return {
    success: false,
    winner: hit.targetId,
    message: 'Hit failed! Target defended successfully',
  };
}

type InvestigationTier = 'quick' | 'standard' | 'deep';

type InvestigationStatus = 'pending' | 'completed' | 'cancelled';

interface InvestigationQueueRow {
  id: number;
  playerId: number;
  hitId: number;
  targetId: number;
  tier: InvestigationTier;
  cost: number;
  status: InvestigationStatus;
  requestedAt: Date;
  resolveAt: Date;
  completedAt: Date | null;
  reportValidUntil: Date | null;
  reportCountry: string | null;
  reportBodyguards: number | null;
  reportArmor: number | null;
}

const INVESTIGATION_TIER_CONFIG: Record<InvestigationTier, { cost: number; delayMs: number; nlLabel: string; enLabel: string }> = {
  quick: {
    cost: 1_000_000,
    delayMs: 60 * 60 * 1000,
    nlLabel: 'Snel',
    enLabel: 'Quick',
  },
  standard: {
    cost: 500_000,
    delayMs: 6 * 60 * 60 * 1000,
    nlLabel: 'Gemiddeld',
    enLabel: 'Standard',
  },
  deep: {
    cost: 250_000,
    delayMs: 24 * 60 * 60 * 1000,
    nlLabel: 'Langzaam',
    enLabel: 'Slow',
  },
};

let investigationSchemaEnsured = false;

async function ensureInvestigationSchema(): Promise<void> {
  if (investigationSchemaEnsured) {
    return;
  }

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS hitlist_investigations (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      hitId INT NOT NULL,
      targetId INT NOT NULL,
      tier VARCHAR(20) NOT NULL,
      cost INT NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'pending',
      requestedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      resolveAt DATETIME NOT NULL,
      completedAt DATETIME NULL,
      reportValidUntil DATETIME NULL,
      reportCountry VARCHAR(50) NULL,
      reportBodyguards INT NULL,
      reportArmor INT NULL,
      PRIMARY KEY (id),
      INDEX idx_hitlist_inv_player (playerId),
      INDEX idx_hitlist_inv_hit (hitId),
      INDEX idx_hitlist_inv_status_resolve (status, resolveAt),
      CONSTRAINT fk_hitlist_inv_player FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
      CONSTRAINT fk_hitlist_inv_hit FOREIGN KEY (hitId) REFERENCES hit_list(id) ON DELETE CASCADE,
      CONSTRAINT fk_hitlist_inv_target FOREIGN KEY (targetId) REFERENCES players(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  investigationSchemaEnsured = true;
}

function getTierConfig(tier: InvestigationTier) {
  const config = INVESTIGATION_TIER_CONFIG[tier];
  if (!config) {
    throw new Error('INVALID_INVESTIGATION_TIER');
  }
  return config;
}

export async function investigateHit(
  playerId: number,
  hitId: number,
  tier: InvestigationTier
): Promise<{
  success: true;
  queue: {
    id: number;
    hitId: number;
    targetId: number;
    cost: number;
    tier: InvestigationTier;
    etaMinutes: number;
    resolveAt: string;
  };
  message: string;
}> {
  await ensureInvestigationSchema();

  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  const tierConfig = getTierConfig(tier);
  const cost = tierConfig.cost;

  const existingPending = await prisma.$queryRaw<Array<{ id: number }>>`
    SELECT id
    FROM hitlist_investigations
    WHERE playerId = ${playerId}
      AND hitId = ${hitId}
      AND status = 'pending'
    LIMIT 1
  `;

  if (existingPending.length > 0) {
    throw new Error('INVESTIGATION_ALREADY_PENDING');
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < cost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  const now = new Date();
  const resolveAt = new Date(now.getTime() + tierConfig.delayMs);

  const queueId = await prisma.$transaction(async (tx) => {
    await tx.player.update({
      where: { id: playerId },
      data: { money: player.money - cost },
    });

    await tx.$executeRaw`
      INSERT INTO hitlist_investigations (
        playerId,
        hitId,
        targetId,
        tier,
        cost,
        status,
        requestedAt,
        resolveAt
      )
      VALUES (
        ${playerId},
        ${hitId},
        ${hit.targetId},
        ${tier},
        ${cost},
        'pending',
        ${now},
        ${resolveAt}
      )
    `;

    const idRows = await tx.$queryRaw<Array<{ id: number }>>`
      SELECT id
      FROM hitlist_investigations
      WHERE playerId = ${playerId}
        AND hitId = ${hitId}
        AND status = 'pending'
      ORDER BY id DESC
      LIMIT 1
    `;

    return Number(idRows[0]?.id || 0);
  });

  if (!queueId) {
    throw new Error('INVESTIGATION_QUEUE_FAILED');
  }

  const etaMinutes = Math.round(tierConfig.delayMs / 60000);

  return {
    success: true,
    queue: {
      id: queueId,
      hitId,
      targetId: hit.targetId,
      tier,
      cost,
      etaMinutes,
      resolveAt: resolveAt.toISOString(),
    },
    message:
      'Onderzoek is aangevraagd. Detective Bureau levert het rapport later in je berichten inbox.',
  };
}

function buildInvestigationMessage(
  language: 'nl' | 'en',
  investigation: InvestigationQueueRow,
  targetUsername: string,
): string {
  const validUntil = investigation.reportValidUntil?.toISOString() ?? '';
  const country = investigation.reportCountry ?? (language === 'nl' ? 'Onbekend' : 'Unknown');
  const bodyguards = investigation.reportBodyguards ?? 0;
  const armor = investigation.reportArmor ?? 0;
  const tierConfig = getTierConfig(investigation.tier);

  if (language === 'nl') {
    return [
      `Detective Bureau rapport gereed (${tierConfig.nlLabel}).`,
      `Doelwit: ${targetUsername}`,
      `Locatie: ${country}`,
      `Bodyguards: ${bodyguards} | Armor: ${armor}`,
      `Geldig tot: ${validUntil}`,
    ].join('\n');
  }

  return [
    `Detective Bureau report ready (${tierConfig.enLabel}).`,
    `Target: ${targetUsername}`,
    `Location: ${country}`,
    `Bodyguards: ${bodyguards} | Armor: ${armor}`,
    `Valid until: ${validUntil}`,
  ].join('\n');
}

export async function processPendingInvestigations(limit = 50): Promise<number> {
  await ensureInvestigationSchema();

  const pendingRows = await prisma.$queryRaw<InvestigationQueueRow[]>`
    SELECT
      id,
      playerId,
      hitId,
      targetId,
      tier,
      cost,
      status,
      requestedAt,
      resolveAt,
      completedAt,
      reportValidUntil,
      reportCountry,
      reportBodyguards,
      reportArmor
    FROM hitlist_investigations
    WHERE status = 'pending'
      AND resolveAt <= NOW()
    ORDER BY resolveAt ASC
    LIMIT ${limit}
  `;

  if (pendingRows.length === 0) {
    return 0;
  }

  let processed = 0;

  for (const row of pendingRows) {
    try {
      const hit = await prisma.hitList.findUnique({
        where: { id: row.hitId },
        select: { status: true, targetId: true },
      });

      const target = await prisma.player.findUnique({
        where: { id: row.targetId },
        select: { username: true, currentCountry: true },
      });

      const receiver = await prisma.player.findUnique({
        where: { id: row.playerId },
        select: { preferredLanguage: true },
      });

      const security = target ? await settleBodyguardUpkeep(prisma, target ? row.targetId : 0) : null;
      const now = new Date();
      const validUntil = new Date(now.getTime() + 3 * 60 * 60 * 1000);
      const language: 'nl' | 'en' = receiver?.preferredLanguage?.toLowerCase().startsWith('nl') ? 'nl' : 'en';

      if (!hit || hit.status !== 'ACTIVE' || !target) {
        const cancelledMessage = language === 'nl'
          ? 'Detective Bureau: onderzoek gesloten omdat de hit niet meer actief is.'
          : 'Detective Bureau: investigation was closed because the hit is no longer active.';

        await directMessageService.sendSystemMessage(row.playerId, cancelledMessage, {
          senderName: 'Detective Bureau',
          sendPush: true,
        });

        await prisma.$executeRaw`
          UPDATE hitlist_investigations
          SET status = 'cancelled',
              completedAt = ${now}
          WHERE id = ${row.id}
        `;

        processed += 1;
        continue;
      }

      const updatedRow: InvestigationQueueRow = {
        ...row,
        completedAt: now,
        reportValidUntil: validUntil,
        reportCountry: target.currentCountry,
        reportBodyguards: security?.bodyguards || 0,
        reportArmor: getEffectiveArmor(security),
        status: 'completed',
      };

      const reportMessage = buildInvestigationMessage(
        language,
        updatedRow,
        target.username,
      );

      await directMessageService.sendSystemMessage(row.playerId, reportMessage, {
        senderName: 'Detective Bureau',
        sendPush: true,
      });

      await prisma.$executeRaw`
        UPDATE hitlist_investigations
        SET status = 'completed',
            completedAt = ${now},
            reportValidUntil = ${validUntil},
            reportCountry = ${target.currentCountry},
            reportBodyguards = ${security?.bodyguards || 0},
            reportArmor = ${getEffectiveArmor(security)}
        WHERE id = ${row.id}
      `;

      processed += 1;
    } catch (error) {
      console.error('[Hitlist] Failed to process investigation', row.id, error);
    }
  }

  return processed;
}

export async function requestMurderCaseInvestigation(
  playerId: number,
  caseId: number,
): Promise<{
  success: true;
  caseId: number;
  resolveAt: string;
  etaMinutes: number;
  message: string;
}> {
  const activity = await prisma.playerActivity.findFirst({
    where: {
      id: caseId,
      playerId,
      activityType: MURDER_CASE_ACTIVITY_TYPE,
    },
    select: {
      id: true,
      details: true,
      player: {
        select: {
          preferredLanguage: true,
        },
      },
    },
  });

  if (!activity) {
    throw new Error('MURDER_CASE_NOT_FOUND');
  }

  const caseDetails = parseMurderCaseDetails(activity.details);
  if (!caseDetails) {
    throw new Error('MURDER_CASE_INVALID');
  }

  const expiresAt = new Date(caseDetails.expiresAt);
  if (isNaN(expiresAt.getTime()) || expiresAt.getTime() <= Date.now()) {
    throw new Error('MURDER_CASE_EXPIRED');
  }

  if (caseDetails.investigationRequestedAt) {
    throw new Error('MURDER_CASE_ALREADY_REQUESTED');
  }

  const now = new Date();
  const reportDelayMs = getMurderCaseReportDelayMs(caseDetails, now);
  const resolveAt = new Date(now.getTime() + reportDelayMs);
  const language: 'nl' | 'en' = activity.player?.preferredLanguage?.toLowerCase().startsWith('nl') ? 'nl' : 'en';

  const updatedDetails: MurderCaseDetails = {
    ...caseDetails,
    investigationRequestedAt: now.toISOString(),
    investigationResolveAt: resolveAt.toISOString(),
    resolvedAt: null,
    solved: null,
  };

  await prisma.playerActivity.update({
    where: { id: activity.id },
    data: {
      details: JSON.stringify(updatedDetails),
    },
  });

  const queued = buildMurderCaseQueuedMessage(language, resolveAt);

  return {
    success: true,
    caseId,
    resolveAt: resolveAt.toISOString(),
    etaMinutes: queued.etaMinutes,
    message: queued.message,
  };
}

export async function processPendingMurderCaseInvestigations(limit = 100): Promise<number> {
  const candidates = await prisma.playerActivity.findMany({
    where: {
      activityType: MURDER_CASE_ACTIVITY_TYPE,
      AND: [
        {
          details: {
            contains: '"investigationRequestedAt":"',
          },
        },
        {
          details: {
            contains: '"resolvedAt":null',
          },
        },
      ],
    },
    orderBy: {
      createdAt: 'asc',
    },
    take: limit,
    select: {
      id: true,
      details: true,
      playerId: true,
      player: {
        select: {
          preferredLanguage: true,
        },
      },
    },
  });

  if (candidates.length === 0) {
    return 0;
  }

  const now = new Date();
  let processed = 0;

  for (const activity of candidates) {
    try {
      const details = parseMurderCaseDetails(activity.details);
      if (!details || !details.investigationRequestedAt || details.resolvedAt) {
        continue;
      }

      const resolveAt = details.investigationResolveAt
        ? new Date(details.investigationResolveAt)
        : new Date(Date.parse(details.investigationRequestedAt));

      if (!Number.isFinite(resolveAt.getTime()) || resolveAt.getTime() > now.getTime()) {
        continue;
      }

      const solved = Math.random() < MURDER_CASE_SOLVE_CHANCE;
      const language: 'nl' | 'en' = activity.player?.preferredLanguage?.toLowerCase().startsWith('nl')
        ? 'nl'
        : 'en';

      const updatedDetails: MurderCaseDetails = {
        ...details,
        investigationResolveAt: details.investigationResolveAt || resolveAt.toISOString(),
        resolvedAt: now.toISOString(),
        solved,
      };

      await prisma.playerActivity.update({
        where: { id: activity.id },
        data: {
          details: JSON.stringify(updatedDetails),
        },
      });

      await directMessageService.sendSystemMessage(
        activity.playerId,
        buildMurderCaseReport(language, solved, details.killerUsername),
        {
          senderName: 'Detective Bureau',
          sendPush: true,
        },
      );

      processed += 1;
    } catch (error) {
      console.error('[Hitlist] Failed to process murder case investigation', activity.id, error);
    }
  }

  return processed;
}

export async function cancelHit(playerId: number, hitId: number): Promise<any> {
  const hit = await prisma.hitList.findUnique({
    where: { id: hitId },
  });

  if (!hit) {
    throw new Error('HIT_NOT_FOUND');
  }

  // Only placer can cancel
  if (hit.placedById !== playerId) {
    throw new Error('NOT_PLACER');
  }

  if (hit.status !== 'ACTIVE') {
    throw new Error('HIT_NOT_ACTIVE');
  }

  // Refund bounty
  const placer = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  await prisma.player.update({
    where: { id: playerId },
    data: { money: (placer?.money || 0) + hit.bounty },
  });

  // Update hit
  await prisma.hitList.update({
    where: { id: hitId },
    data: { status: 'CANCELLED' },
  });

  // Check if target has other active hits
  const otherHits = await prisma.hitList.count({
    where: {
      targetId: hit.targetId,
      status: 'ACTIVE',
    },
  });

  // If no other hits, mark target as no longer hunted
  if (otherHits === 0) {
    await prisma.player.update({
      where: { id: hit.targetId },
      data: { isHunted: false },
    });
  }

  return { success: true };
}

export async function buyBodyguards(
  playerId: number,
  quantity: number
): Promise<any> {
  const cost = quantity * 10000; // €10k per bodyguard

  const security = await settleBodyguardUpkeep(prisma, playerId);

  // Check if player can afford
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < cost) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct cost
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - cost },
  });

  if (security) {
    await prisma.playerSecurity.update({
      where: { playerId },
      data: {
        bodyguards: security.bodyguards + quantity,
        bodyguardUpkeepDueAt: security.bodyguards > 0
          ? security.bodyguardUpkeepDueAt
          : new Date(Date.now() + DAY_IN_MS),
      },
    });
  } else {
    await prisma.playerSecurity.create({
      data: {
        playerId,
        bodyguards: quantity,
        bodyguardUpkeepDueAt: new Date(Date.now() + DAY_IN_MS),
      },
    });
  }

  return {
    success: true,
    message: `${quantity} bodyguards hired for €${cost}`,
  };
}

export async function buyArmor(
  playerId: number,
  armorId: string
): Promise<any> {
  const armor = getArmorDefinition(armorId);

  await settleBodyguardUpkeep(prisma, playerId);

  const security = await prisma.playerSecurity.findUnique({
    where: { playerId },
  });

  const currentArmorCondition = getArmorConditionValue(security?.armorCondition);
  const isSameArmorEquipped =
    !!security &&
    Number(security.armor || 0) > 0 &&
    security.armorType === armorId &&
    currentArmorCondition >= 100;

  if (isSameArmorEquipped) {
    throw new Error('ARMOR_ALREADY_EQUIPPED');
  }

  // Check if player can afford
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  if (!player || player.money < armor.price) {
    throw new Error('INSUFFICIENT_MONEY');
  }

  // Deduct cost
  await prisma.player.update({
    where: { id: playerId },
    data: { money: player.money - armor.price },
  });

  // Update or create security
  if (security) {
    await prisma.playerSecurity.update({
      where: { playerId },
      data: {
        armor: armor.armor,
        armorCondition: 100,
        armorType: armorId,
      },
    });
  } else {
    await prisma.playerSecurity.create({
      data: {
        playerId,
        bodyguardUpkeepDueAt: null,
        armor: armor.armor,
        armorCondition: 100,
        armorType: armorId,
      },
    });
  }

  return {
    success: true,
    message: `${armor.name} purchased for €${armor.price}`,
  };
}

export async function getSecurityStatus(
  playerId: number
): Promise<any> {
  const security = await settleBodyguardUpkeep(prisma, playerId);

  if (!security) {
    return {
      bodyguards: 0,
      armor: 0,
      baseArmor: 0,
      armorCondition: 100,
      armorDamagePercent: 0,
      armorType: null,
      bodyguardDailyCost: 0,
      bodyguardUpkeepDueAt: null,
    };
  }

  const armorCondition = security.armor > 0 ? getArmorConditionValue(security.armorCondition) : 100;
  return {
    ...security,
    armor: getEffectiveArmor(security),
    baseArmor: security.armor,
    armorCondition,
    armorDamagePercent: security.armor > 0 ? 100 - armorCondition : 0,
    bodyguardDailyCost: security.bodyguards * BODYGUARD_DAILY_UPKEEP,
    bodyguardUpkeepDueAt: security.bodyguardUpkeepDueAt?.toISOString() ?? null,
  };
}
