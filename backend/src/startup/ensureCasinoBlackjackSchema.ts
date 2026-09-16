import prisma from '../lib/prisma';

export async function ensureCasinoBlackjackSchema(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS casino_active_hands (
      id INT NOT NULL AUTO_INCREMENT,
      playerId INT NOT NULL,
      casinoId VARCHAR(100) NOT NULL,
      betAmount INT NOT NULL,
      playerHand LONGTEXT NOT NULL,
      dealerHand LONGTEXT NOT NULL,
      createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
      PRIMARY KEY (id),
      UNIQUE KEY casino_active_hands_playerId_key (playerId),
      CONSTRAINT casino_active_hands_playerId_fkey FOREIGN KEY (playerId) REFERENCES players(id)
        ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}
