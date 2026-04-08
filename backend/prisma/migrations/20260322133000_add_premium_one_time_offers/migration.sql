CREATE TABLE `premium_one_time_offers` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(64) NOT NULL,
  `titleNl` VARCHAR(120) NOT NULL,
  `titleEn` VARCHAR(120) NOT NULL,
  `priceEurCents` INTEGER NOT NULL,
  `rewardType` ENUM('money', 'ammo') NOT NULL,
  `moneyAmount` INTEGER NULL,
  `ammoType` VARCHAR(50) NULL,
  `ammoQuantity` INTEGER NULL,
  `isActive` BOOLEAN NOT NULL DEFAULT true,
  `sortOrder` INTEGER NOT NULL DEFAULT 0,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL,

  UNIQUE INDEX `premium_one_time_offers_key_key`(`key`),
  INDEX `premium_one_time_offers_isActive_sortOrder_idx`(`isActive`, `sortOrder`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `premium_one_time_offers`
(`key`, `titleNl`, `titleEn`, `priceEurCents`, `rewardType`, `moneyAmount`, `ammoType`, `ammoQuantity`, `isActive`, `sortOrder`, `createdAt`, `updatedAt`)
VALUES
('money_small', 'Cash boost klein', 'Cash boost small', 499, 'money', 50000, NULL, NULL, true, 10, NOW(3), NOW(3)),
('money_large', 'Cash boost groot', 'Cash boost large', 999, 'money', 120000, NULL, NULL, true, 20, NOW(3), NOW(3)),
('ammo_9mm_pack', '9mm munitie pack', '9mm ammo pack', 399, 'ammo', NULL, '9mm', 500, true, 30, NOW(3), NOW(3)),
('ammo_556_pack', '5.56mm munitie pack', '5.56mm ammo pack', 599, 'ammo', NULL, '556mm', 400, true, 40, NOW(3), NOW(3));
