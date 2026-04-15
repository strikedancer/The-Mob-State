import prisma from '../lib/prisma';

async function indexExists(tableName: string, indexName: string): Promise<boolean> {
  const rows = await prisma.$queryRaw<Array<{ count: number }>>`
    SELECT COUNT(*) AS count
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = ${tableName}
      AND INDEX_NAME = ${indexName}
  `;

  return Number(rows?.[0]?.count ?? 0) > 0;
}

async function ensureIndex(tableName: string, indexName: string, createSql: string): Promise<void> {
  const exists = await indexExists(tableName, indexName);
  if (exists) return;

  await prisma.$executeRawUnsafe(createSql);
  console.log(`[StartupSchema] Added index ${indexName} on ${tableName}`);
}

export async function ensureCrewWarSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_war_seasons (
      id INT NOT NULL AUTO_INCREMENT,
      seasonKey VARCHAR(64) NOT NULL,
      startsAt DATETIME NOT NULL,
      endsAt DATETIME NOT NULL,
      status VARCHAR(20) NOT NULL,
      rewardConfigJson LONGTEXT NULL,
      rewardsDistributedAt DATETIME NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_war_seasons_key (seasonKey),
      INDEX idx_crew_war_seasons_status (status),
      INDEX idx_crew_war_seasons_starts_at (startsAt),
      INDEX idx_crew_war_seasons_ends_at (endsAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_wars (
      id INT NOT NULL AUTO_INCREMENT,
      seasonId INT NULL,
      warType VARCHAR(32) NOT NULL,
      status VARCHAR(20) NOT NULL,
      declaredByPlayerId INT NOT NULL,
      attackerCrewId INT NOT NULL,
      defenderCrewId INT NOT NULL,
      winnerCrewId INT NULL,
      metadataJson LONGTEXT NULL,
      startTime DATETIME NOT NULL,
      activeFrom DATETIME NOT NULL,
      lockDownFrom DATETIME NOT NULL,
      endTime DATETIME NOT NULL,
      resolvedAt DATETIME NULL,
      cooldownUntil DATETIME NULL,
      entryStake INT NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_crew_wars_attacker (attackerCrewId),
      INDEX idx_crew_wars_defender (defenderCrewId),
      INDEX idx_crew_wars_status (status),
      INDEX idx_crew_wars_season (seasonId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_war_participants (
      id INT NOT NULL AUTO_INCREMENT,
      warId INT NOT NULL,
      playerId INT NOT NULL,
      crewId INT NOT NULL,
      role VARCHAR(20) NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'joined',
      joinedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      points INT NOT NULL DEFAULT 0,
      kills INT NOT NULL DEFAULT 0,
      deaths INT NOT NULL DEFAULT 0,
      assists INT NOT NULL DEFAULT 0,
      lootStolen INT NOT NULL DEFAULT 0,
      abuseFlagCount INT NOT NULL DEFAULT 0,
      actionCount INT NOT NULL DEFAULT 0,
      lastActionAt DATETIME NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_war_participants_war_player (warId, playerId),
      INDEX idx_crew_war_participants_war (warId),
      INDEX idx_crew_war_participants_player (playerId),
      INDEX idx_crew_war_participants_crew (crewId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_war_actions (
      id INT NOT NULL AUTO_INCREMENT,
      warId INT NOT NULL,
      actorId INT NULL,
      actorCrewId INT NULL,
      targetId INT NULL,
      targetCrewId INT NULL,
      territoryKey VARCHAR(50) NULL,
      actionType VARCHAR(32) NOT NULL,
      result VARCHAR(32) NOT NULL,
      pointsAwarded INT NOT NULL DEFAULT 0,
      moneyDelta INT NOT NULL DEFAULT 0,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_crew_war_actions_war (warId),
      INDEX idx_crew_war_actions_actor (actorId),
      INDEX idx_crew_war_actions_target (targetId),
      INDEX idx_crew_war_actions_type (actionType),
      INDEX idx_crew_war_actions_created (createdAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_war_standings (
      id INT NOT NULL AUTO_INCREMENT,
      warId INT NOT NULL,
      crewId INT NOT NULL,
      totalPoints INT NOT NULL DEFAULT 0,
      totalKills INT NOT NULL DEFAULT 0,
      totalDeaths INT NOT NULL DEFAULT 0,
      totalLoot INT NOT NULL DEFAULT 0,
      territoriesHeld INT NOT NULL DEFAULT 0,
      rank INT NOT NULL DEFAULT 0,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_war_standings_war_crew (warId, crewId),
      INDEX idx_crew_war_standings_war (warId),
      INDEX idx_crew_war_standings_crew (crewId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await ensureIndex(
    'crew_wars',
    'idx_crew_wars_status',
    'CREATE INDEX idx_crew_wars_status ON crew_wars(status)'
  );
  await ensureIndex(
    'crew_war_actions',
    'idx_crew_war_actions_created',
    'CREATE INDEX idx_crew_war_actions_created ON crew_war_actions(createdAt)'
  );

  console.log('[StartupSchema] Crew war schema check complete');
}