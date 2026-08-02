-- Stack lots for drug / crypto / trade P2P marketplace
-- Idempotent: safe after failed BOM apply (columns may already exist).
SET @qty_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'player_market_listings'
    AND COLUMN_NAME = 'quantity'
);
SET @sql_qty := IF(@qty_exists = 0,
  'ALTER TABLE player_market_listings ADD COLUMN quantity INT NOT NULL DEFAULT 1 AFTER refId',
  'SELECT 1');
PREPARE stmt FROM @sql_qty; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @meta_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'player_market_listings'
    AND COLUMN_NAME = 'meta'
);
SET @sql_meta := IF(@meta_exists = 0,
  'ALTER TABLE player_market_listings ADD COLUMN meta LONGTEXT NULL AFTER quantity',
  'SELECT 1');
PREPARE stmt FROM @sql_meta; EXECUTE stmt; DEALLOCATE PREPARE stmt;