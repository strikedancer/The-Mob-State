-- Stack lots for drug / crypto / trade P2P marketplace
ALTER TABLE player_market_listings
  ADD COLUMN quantity INT NOT NULL DEFAULT 1 AFTER refId,
  ADD COLUMN meta LONGTEXT NULL AFTER quantity;
