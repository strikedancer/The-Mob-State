const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

function uniqueSuffix() {
  return `${Date.now()}_${Math.floor(Math.random() * 1_000_000)}`;
}

async function main() {
  const suffix = uniqueSuffix();
  const username = `cm_cd_guard_${suffix}`.slice(0, 50);
  const crewName = `CM_CD_${suffix}`.slice(0, 50);
  const missionKey = `cm_cd_guard_${suffix}`.slice(0, 100);

  let playerId = null;
  let crewId = null;
  let templateId = null;
  let runId = null;

  try {
    const player = await prisma.player.create({
      data: {
        username,
        passwordHash: 'integration-test',
      },
      select: { id: true },
    });
    playerId = player.id;

    const crew = await prisma.crew.create({
      data: {
        name: crewName,
      },
      select: { id: true },
    });
    crewId = crew.id;

    await prisma.crewMember.create({
      data: {
        crewId,
        playerId,
        role: 'leader',
      },
    });

    await prisma.crewHqBuilding.upsert({
      where: { crewId },
      create: { crewId, style: 'camping', level: 1 },
      update: { level: 1 },
    });

    await prisma.$executeRawUnsafe(
      `
        INSERT INTO crew_mission_templates
          (missionKey, tier, titleNl, titleEn, descriptionNl, descriptionEn,
           durationSeconds, cooldownSeconds, successChance,
           rewardCashMin, rewardCashMax, rewardCrewXp, rewardPersonalXp,
           failPenaltyPct, isActive, sortOrder, imageCardPath, imageScenePath)
        VALUES (?, 1, 'CD Guard', 'CD Guard', 'CD Guard', 'CD Guard',
                300, 600, 0.7,
                1000, 1200, 10, 5,
                0.1, 1, 999999, 'images/crew_missions/cards/safehouse_supply_run.png', 'images/crew_missions/scenes/safehouse_supply_run.png')
      `,
      missionKey,
    );

    const template = await prisma.$queryRawUnsafe(
      `SELECT id FROM crew_mission_templates WHERE missionKey = ? LIMIT 1`,
      missionKey,
    );
    templateId = Number(template?.[0]?.id || 0);
    if (!templateId) {
      throw new Error('Failed to create test mission template');
    }

    const now = new Date();
    const startedAt = new Date(now.getTime() - 10 * 60 * 1000);
    const endsAt = new Date(now.getTime() - 8 * 60 * 1000);
    const resolvedAt = new Date(now.getTime() - 8 * 60 * 1000);
    const cooldownUntil = new Date(now.getTime() + 9 * 60 * 1000);

    await prisma.$executeRawUnsafe(
      `
        INSERT INTO crew_mission_runs
          (crewId, templateId, startedByPlayerId, status, startedAt, endsAt, resolvedAt,
           cooldownUntil, outcome, progressPct, successRoll, successChance,
           rewardMultiplier, rewardCrewCash, rewardCrewXp, rewardPersonalXp)
        VALUES
          (?, ?, ?, 'completed', ?, ?, ?, ?, 'success', 100, 0.1, 0.7, 1.0, 1200, 10, 5)
      `,
      crewId,
      templateId,
      playerId,
      startedAt,
      endsAt,
      resolvedAt,
      cooldownUntil,
    );

    const runRows = await prisma.$queryRawUnsafe(
      `SELECT id FROM crew_mission_runs WHERE crewId = ? AND templateId = ? ORDER BY id DESC LIMIT 1`,
      crewId,
      templateId,
    );
    runId = Number(runRows?.[0]?.id || 0);
    if (!runId) {
      throw new Error('Failed to create test mission run');
    }

    const activeRows = await prisma.$queryRawUnsafe(
      `
        SELECT r.id, r.status, r.cooldownUntil
        FROM crew_mission_runs r
        WHERE r.crewId = ?
          AND (
            r.status = 'in_progress'
            OR (r.status = 'completed' AND r.cooldownUntil IS NOT NULL AND r.cooldownUntil > NOW(3))
          )
        ORDER BY r.id DESC
        LIMIT 1
      `,
      crewId,
    );

    if (!activeRows?.length) {
      throw new Error('REGRESSION: completed run with active cooldown is not treated as blocking run');
    }

    const row = activeRows[0];
    if (String(row.status) !== 'completed') {
      throw new Error(`Unexpected status for blocking run: ${row.status}`);
    }

    const cooldownTs = new Date(row.cooldownUntil).getTime();
    if (!Number.isFinite(cooldownTs) || cooldownTs <= Date.now()) {
      throw new Error('Blocking run cooldownUntil is not in the future');
    }

    console.log('PASS test-crew-mission-cooldown-guard');
  } finally {
    if (runId) {
      await prisma.$executeRawUnsafe(`DELETE FROM crew_mission_contributions WHERE runId = ?`, runId).catch(() => undefined);
      await prisma.$executeRawUnsafe(`DELETE FROM crew_mission_runs WHERE id = ?`, runId).catch(() => undefined);
    }
    if (templateId) {
      await prisma.$executeRawUnsafe(`DELETE FROM crew_mission_templates WHERE id = ?`, templateId).catch(() => undefined);
    }
    if (crewId) {
      await prisma.crewMember.deleteMany({ where: { crewId } }).catch(() => undefined);
      await prisma.crewHqBuilding.deleteMany({ where: { crewId } }).catch(() => undefined);
      await prisma.crew.deleteMany({ where: { id: crewId } }).catch(() => undefined);
    }
    if (playerId) {
      await prisma.player.deleteMany({ where: { id: playerId } }).catch(() => undefined);
    }
  }
}

main()
  .catch((error) => {
    console.error('FAIL test-crew-mission-cooldown-guard');
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
