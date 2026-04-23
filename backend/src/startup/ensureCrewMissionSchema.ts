import prisma from '../lib/prisma';

export async function ensureCrewMissionSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_mission_templates (
      id INT NOT NULL AUTO_INCREMENT,
      missionKey VARCHAR(80) NOT NULL,
      tier TINYINT NOT NULL,
      titleNl VARCHAR(120) NOT NULL,
      titleEn VARCHAR(120) NOT NULL,
      descriptionNl TEXT NULL,
      descriptionEn TEXT NULL,
      durationSeconds INT NOT NULL,
      cooldownSeconds INT NOT NULL,
      successChance DECIMAL(6,4) NOT NULL,
      rewardCashMin INT NOT NULL,
      rewardCashMax INT NOT NULL,
      rewardCrewXp INT NOT NULL DEFAULT 0,
      rewardPersonalXp INT NOT NULL DEFAULT 0,
      failPenaltyPct DECIMAL(6,4) NOT NULL DEFAULT 0.1000,
      isActive TINYINT(1) NOT NULL DEFAULT 1,
      sortOrder INT NOT NULL DEFAULT 0,
      imageCardPath VARCHAR(255) NULL,
      imageScenePath VARCHAR(255) NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_mission_templates_key (missionKey),
      INDEX idx_crew_mission_templates_tier_active (tier, isActive),
      INDEX idx_crew_mission_templates_sort (sortOrder)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_mission_runs (
      id INT NOT NULL AUTO_INCREMENT,
      crewId INT NOT NULL,
      templateId INT NOT NULL,
      startedByPlayerId INT NOT NULL,
      status VARCHAR(20) NOT NULL DEFAULT 'in_progress',
      startedAt DATETIME NOT NULL,
      endsAt DATETIME NOT NULL,
      resolvedAt DATETIME NULL,
      cooldownUntil DATETIME NULL,
      outcome VARCHAR(20) NULL,
      progressPct INT NOT NULL DEFAULT 0,
      successRoll DECIMAL(8,6) NULL,
      successChance DECIMAL(8,6) NULL,
      rewardMultiplier DECIMAL(8,6) NOT NULL DEFAULT 1.000000,
      rewardCrewCash INT NOT NULL DEFAULT 0,
      rewardCrewXp INT NOT NULL DEFAULT 0,
      rewardPersonalXp INT NOT NULL DEFAULT 0,
      rewardsClaimedAt DATETIME NULL,
      rewardsClaimedByPlayerId INT NULL,
      metadataJson LONGTEXT NULL,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      INDEX idx_crew_mission_runs_crew_status (crewId, status),
      INDEX idx_crew_mission_runs_template_started (templateId, startedAt),
      INDEX idx_crew_mission_runs_cooldown (cooldownUntil),
      INDEX idx_crew_mission_runs_created (createdAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS crew_mission_contributions (
      id INT NOT NULL AUTO_INCREMENT,
      runId INT NOT NULL,
      playerId INT NOT NULL,
      roleKey VARCHAR(30) NOT NULL,
      contributionScore DECIMAL(8,4) NOT NULL DEFAULT 1.0000,
      payoutMultiplier DECIMAL(8,4) NOT NULL DEFAULT 1.0000,
      rewardCash INT NOT NULL DEFAULT 0,
      rewardXp INT NOT NULL DEFAULT 0,
      createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (id),
      UNIQUE KEY uq_crew_mission_contrib_run_player (runId, playerId),
      INDEX idx_crew_mission_contrib_player (playerId),
      INDEX idx_crew_mission_contrib_role (roleKey)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  console.log('[StartupSchema] Crew mission schema check complete');
}
