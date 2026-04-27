import prisma from '../lib/prisma';

/**
 * Zorgt dat Kraak de Kluis tabellen bestaan.
 * Vangt productie zonder prisma migrate deploy af (zie ensure-patroon).
 */
export async function ensureVaultSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS vault_seasons (
      id INT NOT NULL AUTO_INCREMENT,
      seasonKey VARCHAR(10) NOT NULL,
      startsAt DATETIME(3) NOT NULL,
      endsAt DATETIME(3) NOT NULL,
      codeHash VARCHAR(128) NOT NULL,
      createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      PRIMARY KEY (id),
      UNIQUE KEY vault_seasons_seasonKey_key (seasonKey),
      INDEX vault_seasons_startsAt_idx (startsAt),
      INDEX vault_seasons_endsAt_idx (endsAt)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS vault_attempts (
      id INT NOT NULL AUTO_INCREMENT,
      seasonId INT NOT NULL,
      playerId INT NOT NULL,
      stakeTier INT NOT NULL,
      guess VARCHAR(8) NULL,
      isCorrect TINYINT(1) NOT NULL DEFAULT 0,
      createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      PRIMARY KEY (id),
      INDEX vault_attempts_playerId_seasonId_createdAt_idx (playerId, seasonId, createdAt),
      INDEX vault_attempts_seasonId_isCorrect_idx (seasonId, isCorrect),
      CONSTRAINT vault_attempts_playerId_fkey FOREIGN KEY (playerId) REFERENCES players(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
      CONSTRAINT vault_attempts_seasonId_fkey FOREIGN KEY (seasonId) REFERENCES vault_seasons(id)
        ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}

