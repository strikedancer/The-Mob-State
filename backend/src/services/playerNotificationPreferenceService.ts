import prisma from '../lib/prisma';

export type PlayerNotificationPreferences = {
  pushCryptoTrade: boolean;
  pushCryptoPriceAlert: boolean;
  pushCryptoOrder: boolean;
  pushCryptoMission: boolean;
  pushCryptoLeaderboard: boolean;
  inAppCryptoTrade: boolean;
  inAppCryptoPriceAlert: boolean;
  inAppCryptoOrder: boolean;
  inAppCryptoMission: boolean;
  inAppCryptoLeaderboard: boolean;
};

export type PlayerNotificationPreferenceUpdate = Partial<PlayerNotificationPreferences>;

const DEFAULT_PREFERENCES: PlayerNotificationPreferences = {
  pushCryptoTrade: true,
  pushCryptoPriceAlert: true,
  pushCryptoOrder: true,
  pushCryptoMission: true,
  pushCryptoLeaderboard: true,
  inAppCryptoTrade: true,
  inAppCryptoPriceAlert: true,
  inAppCryptoOrder: true,
  inAppCryptoMission: true,
  inAppCryptoLeaderboard: true,
};

let tableReady = false;
let tablePromise: Promise<void> | null = null;

async function ensureTable(): Promise<void> {
  if (tableReady) {
    return;
  }
  if (tablePromise) {
    return tablePromise;
  }

  tablePromise = prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS player_notification_preferences (
      player_id INT NOT NULL PRIMARY KEY,
      push_crypto_trade BOOLEAN NOT NULL DEFAULT TRUE,
      push_crypto_price_alert BOOLEAN NOT NULL DEFAULT TRUE,
      push_crypto_order BOOLEAN NOT NULL DEFAULT TRUE,
      push_crypto_mission BOOLEAN NOT NULL DEFAULT TRUE,
      push_crypto_leaderboard BOOLEAN NOT NULL DEFAULT TRUE,
      inapp_crypto_trade BOOLEAN NOT NULL DEFAULT TRUE,
      inapp_crypto_price_alert BOOLEAN NOT NULL DEFAULT TRUE,
      inapp_crypto_order BOOLEAN NOT NULL DEFAULT TRUE,
      inapp_crypto_mission BOOLEAN NOT NULL DEFAULT TRUE,
      inapp_crypto_leaderboard BOOLEAN NOT NULL DEFAULT TRUE,
      created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      CONSTRAINT fk_notification_preferences_player FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `).then(async () => {
    const columns = [
      { name: 'push_crypto_mission', ddl: 'ALTER TABLE player_notification_preferences ADD COLUMN push_crypto_mission BOOLEAN NOT NULL DEFAULT TRUE' },
      { name: 'inapp_crypto_mission', ddl: 'ALTER TABLE player_notification_preferences ADD COLUMN inapp_crypto_mission BOOLEAN NOT NULL DEFAULT TRUE' },
      { name: 'push_crypto_leaderboard', ddl: 'ALTER TABLE player_notification_preferences ADD COLUMN push_crypto_leaderboard BOOLEAN NOT NULL DEFAULT TRUE' },
      { name: 'inapp_crypto_leaderboard', ddl: 'ALTER TABLE player_notification_preferences ADD COLUMN inapp_crypto_leaderboard BOOLEAN NOT NULL DEFAULT TRUE' },
    ];

    for (const column of columns) {
      const rows = await prisma.$queryRawUnsafe<Array<{ total: string | number }>>(
        `
        SELECT COUNT(*) AS total
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'player_notification_preferences'
          AND column_name = ?
        `,
        column.name
      );

      if (toBool(rows[0]?.total, false) || Number(rows[0]?.total ?? 0) > 0) {
        continue;
      }

      await prisma.$executeRawUnsafe(column.ddl);
    }

    tableReady = true;
  });

  return tablePromise;
}

async function ensurePlayerRow(playerId: number): Promise<void> {
  await ensureTable();
  await prisma.$executeRawUnsafe(
    `
    INSERT INTO player_notification_preferences (player_id)
    VALUES (?)
    ON DUPLICATE KEY UPDATE player_id = VALUES(player_id)
    `,
    playerId
  );
}

function toBool(value: unknown, fallback: boolean): boolean {
  if (typeof value === 'boolean') {
    return value;
  }
  if (typeof value === 'number') {
    return value !== 0;
  }
  if (typeof value === 'string') {
    const normalized = value.trim().toLowerCase();
    if (normalized === 'true' || normalized === '1') {
      return true;
    }
    if (normalized === 'false' || normalized === '0') {
      return false;
    }
  }
  return fallback;
}

export const playerNotificationPreferenceService = {
  async getPreferences(playerId: number): Promise<PlayerNotificationPreferences> {
    await ensurePlayerRow(playerId);

    const rows = await prisma.$queryRawUnsafe<Array<Record<string, unknown>>>(
      `
      SELECT
        push_crypto_trade,
        push_crypto_price_alert,
        push_crypto_order,
        push_crypto_mission,
        push_crypto_leaderboard,
        inapp_crypto_trade,
        inapp_crypto_price_alert,
        inapp_crypto_order,
        inapp_crypto_mission,
        inapp_crypto_leaderboard
      FROM player_notification_preferences
      WHERE player_id = ?
      LIMIT 1
      `,
      playerId
    );

    const row = rows[0] ?? {};
    return {
      pushCryptoTrade: toBool(row.push_crypto_trade, DEFAULT_PREFERENCES.pushCryptoTrade),
      pushCryptoPriceAlert: toBool(row.push_crypto_price_alert, DEFAULT_PREFERENCES.pushCryptoPriceAlert),
      pushCryptoOrder: toBool(row.push_crypto_order, DEFAULT_PREFERENCES.pushCryptoOrder),
      pushCryptoMission: toBool(row.push_crypto_mission, DEFAULT_PREFERENCES.pushCryptoMission),
      pushCryptoLeaderboard: toBool(row.push_crypto_leaderboard, DEFAULT_PREFERENCES.pushCryptoLeaderboard),
      inAppCryptoTrade: toBool(row.inapp_crypto_trade, DEFAULT_PREFERENCES.inAppCryptoTrade),
      inAppCryptoPriceAlert: toBool(row.inapp_crypto_price_alert, DEFAULT_PREFERENCES.inAppCryptoPriceAlert),
      inAppCryptoOrder: toBool(row.inapp_crypto_order, DEFAULT_PREFERENCES.inAppCryptoOrder),
      inAppCryptoMission: toBool(row.inapp_crypto_mission, DEFAULT_PREFERENCES.inAppCryptoMission),
      inAppCryptoLeaderboard: toBool(row.inapp_crypto_leaderboard, DEFAULT_PREFERENCES.inAppCryptoLeaderboard),
    };
  },

  async updatePreferences(
    playerId: number,
    input: PlayerNotificationPreferenceUpdate
  ): Promise<PlayerNotificationPreferences> {
    await ensurePlayerRow(playerId);

    const merged: PlayerNotificationPreferences = {
      ...(await this.getPreferences(playerId)),
      ...input,
    };

    await prisma.$executeRawUnsafe(
      `
      UPDATE player_notification_preferences
      SET
        push_crypto_trade = ?,
        push_crypto_price_alert = ?,
        push_crypto_order = ?,
        push_crypto_mission = ?,
        push_crypto_leaderboard = ?,
        inapp_crypto_trade = ?,
        inapp_crypto_price_alert = ?,
        inapp_crypto_order = ?,
        inapp_crypto_mission = ?,
        inapp_crypto_leaderboard = ?,
        updated_at = NOW()
      WHERE player_id = ?
      `,
      merged.pushCryptoTrade,
      merged.pushCryptoPriceAlert,
      merged.pushCryptoOrder,
      merged.pushCryptoMission,
      merged.pushCryptoLeaderboard,
      merged.inAppCryptoTrade,
      merged.inAppCryptoPriceAlert,
      merged.inAppCryptoOrder,
      merged.inAppCryptoMission,
      merged.inAppCryptoLeaderboard,
      playerId
    );

    return merged;
  },
};
