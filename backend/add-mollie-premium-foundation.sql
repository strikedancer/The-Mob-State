ALTER TABLE players
  ADD COLUMN IF NOT EXISTS mollieCustomerId VARCHAR(255) NULL,
  ADD COLUMN IF NOT EXISTS mollieSubscriptionId VARCHAR(255) NULL,
  ADD COLUMN IF NOT EXISTS premiumCredits INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS hitProtectionExpiresAt DATETIME NULL;

ALTER TABLE crews
  ADD COLUMN IF NOT EXISTS mollieSubscriptionId VARCHAR(255) NULL;

ALTER TABLE premium_one_time_offers
  ADD COLUMN IF NOT EXISTS descriptionNl TEXT NULL,
  ADD COLUMN IF NOT EXISTS descriptionEn TEXT NULL,
  ADD COLUMN IF NOT EXISTS creditAmount INT NULL,
  ADD COLUMN IF NOT EXISTS rewardKey VARCHAR(64) NULL,
  ADD COLUMN IF NOT EXISTS durationHours INT NULL,
  ADD COLUMN IF NOT EXISTS rewardValue INT NULL,
  ADD COLUMN IF NOT EXISTS metadataJson LONGTEXT NULL;

ALTER TABLE premium_one_time_offers
  MODIFY COLUMN rewardType ENUM('money','ammo','credits','event_boost') NOT NULL;

CREATE TABLE IF NOT EXISTS premium_payment_transactions (
  id INT NOT NULL AUTO_INCREMENT,
  playerId INT NOT NULL,
  productKey VARCHAR(64) NULL,
  checkoutType ENUM('PLAYER_VIP','CREW_VIP','ONE_TIME') NOT NULL,
  provider ENUM('MOLLIE') NOT NULL DEFAULT 'MOLLIE',
  status ENUM('OPEN','PENDING','PAID','CANCELED','EXPIRED','FAILED') NOT NULL DEFAULT 'OPEN',
  providerPaymentId VARCHAR(64) NULL,
  providerCustomerId VARCHAR(64) NULL,
  providerSubscriptionId VARCHAR(64) NULL,
  amountCurrency VARCHAR(10) NOT NULL DEFAULT 'EUR',
  amountValue VARCHAR(16) NOT NULL,
  description VARCHAR(255) NULL,
  metadataJson LONGTEXT NULL,
  paidAt DATETIME NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY premium_payment_transactions_providerPaymentId_key (providerPaymentId),
  KEY premium_payment_transactions_player_checkout_status_idx (playerId, checkoutType, status),
  KEY premium_payment_transactions_product_status_idx (productKey, status),
  CONSTRAINT premium_payment_transactions_player_fk FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS player_credit_transactions (
  id INT NOT NULL AUTO_INCREMENT,
  playerId INT NOT NULL,
  delta INT NOT NULL,
  balanceAfter INT NOT NULL,
  reasonType ENUM('PURCHASE','REDEEM','REFUND','ADMIN_ADJUSTMENT') NOT NULL,
  reasonKey VARCHAR(64) NULL,
  metadataJson LONGTEXT NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY player_credit_transactions_player_created_idx (playerId, createdAt),
  KEY player_credit_transactions_reason_created_idx (reasonType, createdAt),
  CONSTRAINT player_credit_transactions_player_fk FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS credit_shop_items (
  id INT NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(64) NOT NULL,
  titleNl VARCHAR(120) NOT NULL,
  titleEn VARCHAR(120) NOT NULL,
  descriptionNl TEXT NULL,
  descriptionEn TEXT NULL,
  creditCost INT NOT NULL,
  effectType ENUM('CASH_BUNDLE','HIT_PROTECTION','VEHICLE_REPAIR_FINISH','VEHICLE_TUNE_RESET','ACTION_COOLDOWN_RESET','EVENT_BOOST') NOT NULL,
  moneyAmount INT NULL,
  durationHours INT NULL,
  actionType VARCHAR(50) NULL,
  metadataJson LONGTEXT NULL,
  isActive TINYINT(1) NOT NULL DEFAULT 1,
  sortOrder INT NOT NULL DEFAULT 0,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY credit_shop_items_key ( `key` ),
  KEY credit_shop_items_active_sort_idx (isActive, sortOrder)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS player_credit_entitlements (
  id INT NOT NULL AUTO_INCREMENT,
  playerId INT NOT NULL,
  catalogItemId INT NULL,
  `key` VARCHAR(64) NOT NULL,
  effectType ENUM('CASH_BUNDLE','HIT_PROTECTION','VEHICLE_REPAIR_FINISH','VEHICLE_TUNE_RESET','ACTION_COOLDOWN_RESET','EVENT_BOOST') NOT NULL,
  status ENUM('ACTIVE','CONSUMED','EXPIRED') NOT NULL DEFAULT 'ACTIVE',
  durationHours INT NULL,
  startedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expiresAt DATETIME NULL,
  metadataJson LONGTEXT NULL,
  PRIMARY KEY (id),
  KEY player_credit_entitlements_player_status_expiry_idx (playerId, status, expiresAt),
  KEY player_credit_entitlements_catalogItemId_fkey (catalogItemId),
  CONSTRAINT player_credit_entitlements_player_fk FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT player_credit_entitlements_catalog_fk FOREIGN KEY (catalogItemId) REFERENCES credit_shop_items(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;