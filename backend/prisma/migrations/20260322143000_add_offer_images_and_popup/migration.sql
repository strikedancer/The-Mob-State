ALTER TABLE `premium_one_time_offers`
  ADD COLUMN `imageUrl` VARCHAR(500) NULL,
  ADD COLUMN `showPopupOnOpen` BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE `player_premium_popup_seen` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `playerId` INTEGER NOT NULL,
  `offerId` INTEGER NOT NULL,
  `seenAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  UNIQUE INDEX `player_premium_popup_seen_playerId_offerId_key`(`playerId`, `offerId`),
  INDEX `player_premium_popup_seen_playerId_seenAt_idx`(`playerId`, `seenAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `player_premium_popup_seen`
  ADD CONSTRAINT `player_premium_popup_seen_playerId_fkey`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `player_premium_popup_seen`
  ADD CONSTRAINT `player_premium_popup_seen_offerId_fkey`
  FOREIGN KEY (`offerId`) REFERENCES `premium_one_time_offers`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
