import prisma from '../lib/prisma';

async function columnExists(tableName: string, columnName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: bigint | number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND COLUMN_NAME = ${columnName}
  `;

  return Number(rows?.[0]?.count ?? 0) > 0;
}

/**
 * One-time–safe backfill: voor elke garage zonder motorcycle-track upgrade
 * een rij toevoegen zodat motor-capaciteit niet daalt t.o.v. de oude formule
 * (motor = max(2, ceil(carTotal * 0.4))).
 */
export async function ensureGarageMotorcycleTrackBackfill(): Promise<void> {
  if (!(await columnExists('garage_upgrades', 'track'))) {
    console.warn('[GarageTrack] column track missing; skip motorcycle backfill');
    return;
  }

  const garages = await prisma.garage.findMany({
    include: { upgrades: true },
  });

  const upgradeCosts = [0, 50000, 100000, 200000, 400000, 800000];

  for (const g of garages) {
    const hasMotorcycle = g.upgrades.some(
      (u) => (u.track ?? 'car').toLowerCase() === 'motorcycle',
    );
    if (hasMotorcycle) continue;

    const carUpgrades = g.upgrades.filter(
      (u) => (u.track ?? 'car').toLowerCase() !== 'motorcycle',
    );
    const carLevel =
      carUpgrades.length === 0
        ? 0
        : Math.max(...carUpgrades.map((u) => u.upgradeLevel));
    const carBonus =
      carLevel === 0
        ? 0
        : Math.max(
            ...carUpgrades
              .filter((u) => u.upgradeLevel === carLevel)
              .map((u) => u.capacityBonus),
          );

    const carTotal = g.capacity + carBonus;
    const legacyMotoTarget = Math.max(2, Math.ceil(carTotal * 0.4));
    const motoLevel = Math.min(
      5,
      Math.max(0, Math.ceil((legacyMotoTarget - 2) / 3)),
    );

    if (motoLevel <= 0) continue;

    const motoBonus = motoLevel * 3;
    const upgradeCost = upgradeCosts[motoLevel] ?? 0;

    await prisma.garageUpgrade.create({
      data: {
        garageId: g.id,
        upgradeLevel: motoLevel,
        capacityBonus: motoBonus,
        upgradeCost,
        track: 'motorcycle',
      },
    });

    console.log(
      `[GarageTrack] Backfilled motorcycle track garage=${g.id} level=${motoLevel} (legacy target ${legacyMotoTarget})`,
    );
  }
}
