import prisma from '../lib/prisma';
import countries from '../../content/countries.json';
import drugService from './drugService';
import { drugFacilityService } from './drugFacilityService';
import { drugCountryLabel, getDrugRuntimeConfig } from './drugRuntimeConfig';
import { smugglingService } from './smugglingService';
import { countryPoliceService } from './countryPoliceService';
import * as fbiService from './fbiService';
import { NotificationService } from './notificationService';

type WholesaleMeta = {
  wholesale?: boolean;
  unitPrice?: number;
  payout?: number;
  destinationCountry?: string;
  drugType?: string;
  quality?: string;
  quantity?: number;
  settledAt?: string;
};

function parseMeta(raw: string | null): WholesaleMeta {
  try {
    return raw ? (JSON.parse(raw) as WholesaleMeta) : {};
  } catch {
    return {};
  }
}

function isWholesale(meta: WholesaleMeta): boolean {
  return meta.wholesale === true;
}

function hasSettled(meta: WholesaleMeta): boolean {
  return Boolean(meta.settledAt);
}

function streetUnit(drugType: string, quality: string, countryId: string): number {
  const drug = drugService.getDrugDefinition(drugType);
  if (!drug) return 0;
  const qualityMultiplier = drugFacilityService.getQualityPriceMultiplier(quality as any);
  const countryPrice = drug.countryPricing[countryId] || drug.basePrice;
  return Math.round(countryPrice * qualityMultiplier);
}

async function recentWholesaleGrams(destinationCountry: string, drugType: string, windowH: number): Promise<number> {
  const since = new Date(Date.now() - Math.max(1, windowH) * 60 * 60 * 1000);
  const rows = await prisma.$queryRaw<
    Array<{ quantity: number; item_key: string; metadata_json: string | null }>
  >`
    SELECT quantity, item_key, metadata_json
    FROM smuggling_shipments
    WHERE category = 'drug'
      AND destination_country = ${destinationCountry}
      AND status IN ('claimed', 'ready', 'seized')
      AND delivered_at IS NOT NULL
      AND delivered_at >= ${since}
    LIMIT 400
  `;
  let grams = 0;
  for (const row of rows) {
    const meta = parseMeta(row.metadata_json);
    if (!isWholesale(meta)) continue;
    const type = String(meta.drugType || row.item_key || '');
    if (type !== drugType) continue;
    grams += Number(row.quantity || 0);
  }
  return grams;
}

function wholesaleUnitPrice(params: {
  street: number;
  quantity: number;
  scarcityGrams: number;
  spreadBps: number;
  volumeBpsPerKg: number;
  volumeCapBps: number;
  scarcityCapBps: number;
}): number {
  const kg = params.quantity / 1000;
  const volumeBps = Math.min(params.volumeCapBps, Math.floor(kg * params.volumeBpsPerKg));
  const scarcityKg = params.scarcityGrams / 1000;
  const scarcityBps = Math.min(params.scarcityCapBps, Math.floor(scarcityKg * 50));
  const factor =
    (1 - params.spreadBps / 10000) * (1 + volumeBps / 10000) * (1 - scarcityBps / 10000);
  return Math.max(1, Math.round(params.street * factor));
}

function formatDestinations(rows: Array<{ id: string; streetUnit: number }>) {
  return rows.map((row) => ({
    id: row.id,
    streetUnit: row.streetUnit,
    labelNl: drugCountryLabel(row.id, 'nl'),
    labelEn: drugCountryLabel(row.id, 'en'),
  }));
}

function destinationOptions(drugType: string, quality: string, originCountry: string) {
  const drug = drugService.getDrugDefinition(drugType);
  if (!drug) return [];
  return Object.keys(drug.countryPricing)
    .filter((id) => id !== originCountry)
    .map((id) => ({
      id,
      streetUnit: streetUnit(drugType, quality, id),
    }))
    .sort((a, b) => b.streetUnit - a.streetUnit);
}

export async function quoteExport(params: {
  playerId: number;
  drugType: string;
  quality: string;
  quantity: number;
  destinationCountry?: string;
}) {
  await settleDueExports();
  const runtime = await getDrugRuntimeConfig();
  const quantity = Math.floor(params.quantity);
  const quality = (params.quality || 'C').toUpperCase();
  const drugType = params.drugType;

  const drug = drugService.getDrugDefinition(drugType);
  if (!drug) {
    return { success: false, message: 'Onbekend drugtype' };
  }

  const player = await prisma.player.findUnique({
    where: { id: params.playerId },
    select: { currentCountry: true, money: true },
  });
  if (!player) {
    return { success: false, message: 'Speler niet gevonden' };
  }

  const destinations = destinationOptions(drugType, quality, player.currentCountry);
  const destList = formatDestinations(destinations);
  if (destinations.length === 0) {
    return { success: false, message: 'Geen bestemmingsland beschikbaar' };
  }

  const destinationCountry = params.destinationCountry || destinations[0].id;
  if (!destinationCountry || destinationCountry === player.currentCountry) {
    return { success: false, message: 'Kies een ander land dan waar je nu bent', destinations: destList };
  }

  const destExists = (countries as Array<{ id: string }>).some((c) => c.id === destinationCountry);
  if (!destExists) {
    return { success: false, message: 'Bestemmingsland bestaat niet', destinations: destList };
  }

  if (quantity < runtime.wholesaleMinGrams) {
    return {
      success: false,
      message: `Minimale export is ${runtime.wholesaleMinGrams}g`,
      minGrams: runtime.wholesaleMinGrams,
      destinations: destList,
    };
  }

  const lot = await prisma.drugInventory.findUnique({
    where: {
      playerId_drugType_quality: {
        playerId: params.playerId,
        drugType,
        quality,
      },
    },
    select: { quantity: true },
  });
  if (!lot || lot.quantity < quantity) {
    return { success: false, message: 'Niet genoeg voorraad', destinations: destList, minGrams: runtime.wholesaleMinGrams };
  }

  const smuggleQuote = await smugglingService.quoteShipment(params.playerId, {
    category: 'drug',
    itemKey: `${drugType}:${quality}`,
    quantity,
    destinationCountry,
    channel: 'container',
    networkScope: 'personal',
    transportMode: 'commercial',
    metadata: { quality },
  });
  if (!smuggleQuote.success) {
    return { success: false, message: smuggleQuote.message, destinations: destList, minGrams: runtime.wholesaleMinGrams };
  }

  const destStreet = streetUnit(drugType, quality, destinationCountry);
  const originStreet = streetUnit(drugType, quality, player.currentCountry);
  const scarcityGrams = await recentWholesaleGrams(
    destinationCountry,
    drugType,
    runtime.wholesaleScarcityWindowH,
  );
  const unitPrice = wholesaleUnitPrice({
    street: destStreet,
    quantity,
    scarcityGrams,
    spreadBps: runtime.wholesaleSpreadBps,
    volumeBpsPerKg: runtime.wholesaleVolumeBonusBpsPerKg,
    volumeCapBps: runtime.wholesaleVolumeBonusCapBps,
    scarcityCapBps: runtime.wholesaleScarcityCapBps,
  });
  const payout = Math.max(0, unitPrice * quantity);
  const fbiHeat = Math.max(1, Math.ceil((quantity / 1000) * runtime.wholesaleFbiHeatPerKg));

  return {
    success: true,
    originCountry: player.currentCountry,
    destinationCountry,
    drugType,
    quality,
    quantity,
    minGrams: runtime.wholesaleMinGrams,
    destStreetUnit: destStreet,
    originStreetUnit: originStreet,
    wholesaleUnit: unitPrice,
    payout,
    shippingFee: smuggleQuote.shippingFee ?? 0,
    etaMinutes: smuggleQuote.etaMinutes,
    seizureChance: smuggleQuote.seizureChance,
    harborBonus: smuggleQuote.harborBonus === true,
    canAfford: smuggleQuote.canAfford,
    cooldownRemainingSeconds: smuggleQuote.cooldownRemainingSeconds ?? 0,
    availableQuantity: lot.quantity,
    drugHeat: runtime.wholesaleDrugHeat,
    fbiHeat,
    policeGain: 1,
    destinations: destList,
  };
}

export async function startExport(params: {
  playerId: number;
  drugType: string;
  quality: string;
  quantity: number;
  destinationCountry: string;
}) {
  const quoted = await quoteExport(params);
  if (!quoted.success) {
    return quoted;
  }

  const send = await smugglingService.sendShipment(params.playerId, {
    category: 'drug',
    itemKey: `${params.drugType}:${params.quality}`,
    quantity: params.quantity,
    destinationCountry: params.destinationCountry,
    channel: 'container',
    networkScope: 'personal',
    transportMode: 'commercial',
    metadata: {
      wholesale: true,
      unitPrice: quoted.wholesaleUnit,
      payout: quoted.payout,
      destinationCountry: params.destinationCountry,
      drugType: params.drugType,
      quality: (params.quality || 'C').toUpperCase(),
      quantity: Math.floor(params.quantity),
    },
  });

  if (!send.success || !send.shipmentId) {
    return { success: false, message: send.message };
  }

  const runtime = await getDrugRuntimeConfig();
  const extraHeat = Math.max(0, runtime.wholesaleDrugHeat - 2);
  if (extraHeat > 0) {
    await drugService.applyDrugHeat(params.playerId, extraHeat);
  }

  const player = await prisma.player.findUnique({
    where: { id: params.playerId },
    select: { currentCountry: true },
  });
  if (player?.currentCountry) {
    await countryPoliceService.recordActivityGain({
      playerId: params.playerId,
      countryCode: player.currentCountry,
      source: 'drug_wholesale',
    });
  }

  return {
    success: true,
    message: send.message,
    shipmentId: send.shipmentId,
    etaMinutes: send.etaMinutes,
    shippingFee: send.shippingFee,
    seizureChance: send.seizureChance,
    payout: quoted.payout,
    wholesaleUnit: quoted.wholesaleUnit,
    harborBonus: quoted.harborBonus,
  };
}

export async function completeWholesaleArrival(params: {
  id: number;
  playerId: number;
  quantity: number;
  destinationCountry: string;
  itemKey: string;
  metadataJson: string | null;
  seized: boolean;
}): Promise<void> {
  const meta = parseMeta(params.metadataJson);
  if (!isWholesale(meta) || hasSettled(meta)) {
    return;
  }

  const settledAt = new Date().toISOString();
  const nextMeta = { ...meta, settledAt };
  const payout = Math.max(0, Math.floor(Number(meta.payout ?? 0)));
  const drugType = String(meta.drugType || params.itemKey);
  const quantity = Number(meta.quantity || params.quantity || 0);
  const metadataJson = JSON.stringify(nextMeta);

  if (params.seized) {
    const locked = await prisma.$executeRaw`
      UPDATE smuggling_shipments
      SET status = 'seized',
          delivered_at = COALESCE(delivered_at, NOW()),
          metadata_json = ${metadataJson}
      WHERE id = ${params.id}
        AND (metadata_json IS NULL OR metadata_json NOT LIKE '%"settledAt"%')
    `;
    if (Number(locked) === 0) return;
    await NotificationService.getInstance().sendDrugWholesaleSettledNotification(params.playerId, false, {
      destinationCountry: params.destinationCountry,
      quantity,
      payout: 0,
      drugType,
    });
    return;
  }

  const credited = await prisma.$transaction(async (tx) => {
    const locked = await tx.$executeRaw`
      UPDATE smuggling_shipments
      SET status = 'claimed',
          claimed_at = NOW(),
          delivered_at = COALESCE(delivered_at, NOW()),
          metadata_json = ${metadataJson}
      WHERE id = ${params.id}
        AND claimed_at IS NULL
        AND (metadata_json IS NULL OR metadata_json NOT LIKE '%"settledAt"%')
    `;
    if (Number(locked) === 0) {
      return false;
    }
    if (payout > 0) {
      await tx.player.update({
        where: { id: params.playerId },
        data: { money: { increment: payout } },
      });
    }
    return true;
  });

  if (!credited) return;

  const runtime = await getDrugRuntimeConfig();
  const fbiHeat = Math.max(1, Math.ceil((quantity / 1000) * runtime.wholesaleFbiHeatPerKg));
  await fbiService.increaseFBIHeat(params.playerId, fbiHeat);
  await countryPoliceService.recordActivityGain({
    playerId: params.playerId,
    countryCode: params.destinationCountry,
    source: 'drug_wholesale',
  });
  await NotificationService.getInstance().sendDrugWholesaleSettledNotification(params.playerId, true, {
    destinationCountry: params.destinationCountry,
    quantity,
    payout,
    drugType,
  });
}

export async function settleDueExports(): Promise<{ settled: number; seized: number }> {
  await smugglingService.ensureReady();
  const due = await prisma.$queryRaw<
    Array<{
      id: number;
      player_id: number;
      quantity: number;
      destination_country: string;
      item_key: string;
      metadata_json: string | null;
      seizure_chance: number;
      status: string;
    }>
  >`
    SELECT id, player_id, quantity, destination_country, item_key, metadata_json, seizure_chance, status
    FROM smuggling_shipments
    WHERE category = 'drug'
      AND (
        (status = 'in_transit' AND eta_at <= NOW())
        OR (status IN ('ready', 'seized') AND claimed_at IS NULL)
      )
      AND (metadata_json IS NULL OR metadata_json NOT LIKE '%"settledAt"%')
    ORDER BY id ASC
    LIMIT 200
  `;

  let settled = 0;
  let seized = 0;
  for (const row of due) {
    const meta = parseMeta(row.metadata_json);
    if (!isWholesale(meta) || hasSettled(meta)) continue;

    let isSeized = row.status === 'seized';
    if (row.status === 'in_transit') {
      isSeized = Math.random() < Number(row.seizure_chance);
      const updated = await prisma.$executeRaw`
        UPDATE smuggling_shipments
        SET status = ${isSeized ? 'seized' : 'ready'},
            delivered_at = NOW()
        WHERE id = ${row.id} AND status = 'in_transit'
      `;
      if (Number(updated) === 0) continue;
    }

    await completeWholesaleArrival({
      id: row.id,
      playerId: row.player_id,
      quantity: row.quantity,
      destinationCountry: row.destination_country,
      itemKey: row.item_key,
      metadataJson: row.metadata_json,
      seized: isSeized,
    });
    if (isSeized) seized += 1;
    else settled += 1;
  }
  return { settled, seized };
}

export async function listExports(playerId: number) {
  await settleDueExports();
  const rows = await prisma.$queryRaw<
    Array<{
      id: number;
      item_label: string;
      quantity: number;
      origin_country: string;
      destination_country: string;
      status: string;
      shipping_fee: number;
      seizure_chance: number;
      eta_at: Date;
      delivered_at: Date | null;
      claimed_at: Date | null;
      metadata_json: string | null;
    }>
  >`
    SELECT id, item_label, quantity, origin_country, destination_country, status,
           shipping_fee, seizure_chance, eta_at, delivered_at, claimed_at, metadata_json
    FROM smuggling_shipments
    WHERE player_id = ${playerId}
      AND category = 'drug'
    ORDER BY id DESC
    LIMIT 40
  `;

  return rows
    .map((row) => {
      const meta = parseMeta(row.metadata_json);
      if (!isWholesale(meta)) return null;
      return {
        id: row.id,
        label: row.item_label,
        quantity: row.quantity,
        originCountry: row.origin_country,
        destinationCountry: row.destination_country,
        status: row.status,
        shippingFee: Number(row.shipping_fee || 0),
        seizureChance: Number(row.seizure_chance || 0),
        etaAt: row.eta_at,
        deliveredAt: row.delivered_at,
        payout: Number(meta.payout || 0),
        unitPrice: Number(meta.unitPrice || 0),
        settled: hasSettled(meta),
      };
    })
    .filter(Boolean);
}
