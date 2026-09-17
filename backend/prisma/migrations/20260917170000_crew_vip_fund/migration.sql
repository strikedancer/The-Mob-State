ALTER TABLE `crews`
  ADD COLUMN IF NOT EXISTS `vipFundCents` INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `crew_vip_donations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `crewId` INT NOT NULL,
  `playerId` INT NOT NULL,
  `amountCents` INT NOT NULL,
  `monthsGranted` INT NOT NULL DEFAULT 0,
  `molliePaymentId` VARCHAR(64) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `crew_vip_donations_molliePaymentId_key` (`molliePaymentId`),
  INDEX `idx_crew_vip_donations_crew` (`crewId`, `createdAt`),
  INDEX `idx_crew_vip_donations_player` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
