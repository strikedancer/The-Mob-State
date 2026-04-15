ALTER TABLE player_security
  ADD COLUMN bodyguardUpkeepDueAt DATETIME NULL AFTER bodyguards,
  ADD COLUMN armorCondition INT NOT NULL DEFAULT 100 AFTER armor;

UPDATE player_security
SET armorCondition = 100
WHERE armorCondition IS NULL OR armorCondition <= 0;

UPDATE player_security
SET bodyguardUpkeepDueAt = DATE_ADD(NOW(), INTERVAL 24 HOUR)
WHERE bodyguards > 0 AND bodyguardUpkeepDueAt IS NULL;