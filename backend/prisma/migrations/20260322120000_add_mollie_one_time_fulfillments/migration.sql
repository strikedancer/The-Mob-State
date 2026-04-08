CREATE TABLE `mollie_payment_fulfillments` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `molliePaymentId` VARCHAR(64) NOT NULL,
  `playerId` INTEGER NOT NULL,
  `productKey` VARCHAR(64) NOT NULL,
  `payload` JSON NULL,
  `fulfilledAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

  UNIQUE INDEX `mollie_payment_fulfillments_molliePaymentId_key`(`molliePaymentId`),
  INDEX `mollie_payment_fulfillments_playerId_idx`(`playerId`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
