-- Allow Season Pass one-time offer reward type (Premium catalog was 500ing on ensureSeasonPassOffer).
ALTER TABLE `premium_one_time_offers`
  MODIFY COLUMN `rewardType` ENUM('money', 'ammo', 'credits', 'event_boost', 'season_pass') NOT NULL;
