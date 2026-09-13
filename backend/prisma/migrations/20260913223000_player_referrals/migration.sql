-- Share-link referrals: one code per player, one referrer per recruit.
ALTER TABLE `players`
  ADD COLUMN `referralCode` VARCHAR(12) NULL,
  ADD COLUMN `referredById` INTEGER NULL,
  ADD COLUMN `referralQualifiedAt` DATETIME(3) NULL,
  ADD COLUMN `referralReferrerPaidAt` DATETIME(3) NULL;

CREATE UNIQUE INDEX `players_referralCode_key` ON `players`(`referralCode`);
CREATE INDEX `players_referredById_idx` ON `players`(`referredById`);

ALTER TABLE `players`
  ADD CONSTRAINT `players_referredById_fkey`
  FOREIGN KEY (`referredById`) REFERENCES `players`(`id`)
  ON DELETE SET NULL ON UPDATE CASCADE;
