-- Complete Tools Migration Script
-- This script ensures all 16 tools from tools.json are in the database
-- Run this against the mafia_game database

-- First, ensure the tables exist
CREATE TABLE IF NOT EXISTS `crime_tools` (
  `id` VARCHAR(50) PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `type` VARCHAR(50) NOT NULL COMMENT 'BOLT_CUTTER, BURGLARY_KIT, JERRY_CAN, etc.',
  `basePrice` INT NOT NULL,
  `maxDurability` INT NOT NULL COMMENT '100 = new tool',
  `loseChance` FLOAT NOT NULL COMMENT 'Chance to lose tool after use (0.0-1.0)',
  `wearPerUse` INT NOT NULL COMMENT 'Durability loss per use',
  `requiredFor` JSON NOT NULL COMMENT 'Array of crime IDs that require this tool'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `player_tools` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `playerId` INT NOT NULL,
  `toolId` VARCHAR(50) NOT NULL,
  `durability` INT NOT NULL COMMENT 'Current durability (0-100)',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`toolId`) REFERENCES `crime_tools`(`id`),
  
  UNIQUE KEY `playerId_toolId` (`playerId`, `toolId`),
  INDEX `idx_playerId` (`playerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Delete old lockpick_set if it exists (was replaced)
DELETE FROM player_tools WHERE toolId = 'lockpick_set';
DELETE FROM crime_tools WHERE id = 'lockpick_set';

-- Insert or update all 16 tools from tools.json
INSERT INTO crime_tools (id, name, type, basePrice, maxDurability, loseChance, wearPerUse, requiredFor) VALUES
('bolt_cutter', 'Betonschaar', 'BOLT_CUTTER', 250, 100, 0.15, 25, JSON_ARRAY('steal_bike')),
('burglary_kit', 'Inbrekersset', 'BURGLARY_KIT', 1500, 100, 0.20, 10, JSON_ARRAY('burglary')),
('car_theft_tools', 'Auto Diefstal Gereedschap', 'CAR_TOOLS', 800, 100, 0.10, 15, JSON_ARRAY('car_theft')),
('jerry_can', 'Jerrycan (20L)', 'JERRY_CAN', 50, 1, 1.0, 100, JSON_ARRAY('arson')),
('spray_paint', 'Spuitbus Verf', 'SPRAY_PAINT', 25, 10, 1.0, 100, JSON_ARRAY('graffiti', 'vandalism')),
('crowbar', 'Koevoet', 'CROWBAR', 150, 100, 0.15, 20, JSON_ARRAY('atm_theft')),
('glass_cutter', 'Glassnijder', 'GLASS_CUTTER', 400, 100, 0.10, 10, JSON_ARRAY('jewelry_heist')),
('hacking_laptop', 'Hacking Laptop', 'LAPTOP', 2500, 100, 0.05, 5, JSON_ARRAY('hack_account', 'identity_theft')),
('counterfeiting_kit', 'Vervalsingsspullen', 'COUNTERFEITING', 5000, 100, 0.10, 8, JSON_ARRAY('counterfeit_money')),
('toolbox', 'Gereedschapskist', 'TOOLBOX', 300, 100, 0.10, 10, JSON_ARRAY('steal_car_parts')),
('rope', 'Nylon Touw (50m)', 'ROPE', 30, 1, 1.0, 100, JSON_ARRAY('kidnapping')),
('silencer', 'Geluiddemper', 'SILENCER', 1200, 100, 0.20, 15, JSON_ARRAY('assassination', 'eliminate_witness')),
('fake_documents', 'Valse Documenten', 'FAKE_DOCS', 800, 1, 1.0, 100, JSON_ARRAY('smuggling')),
('night_vision', 'Nachtkijker', 'NIGHT_VISION', 750, 100, 0.12, 8, JSON_ARRAY('evidence_room_heist')),
('burner_phone', 'Wegwerptelefoon', 'BURNER_PHONE', 20, 1, 1.0, 100, JSON_ARRAY('diamond_heist')),
('gps_jammer', 'GPS Jammer', 'GPS_JAMMER', 1200, 100, 0.18, 12, JSON_ARRAY('rob_armored_truck'))
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  type = VALUES(type),
  basePrice = VALUES(basePrice),
  maxDurability = VALUES(maxDurability),
  loseChance = VALUES(loseChance),
  wearPerUse = VALUES(wearPerUse),
  requiredFor = VALUES(requiredFor);

-- Verify the migration
SELECT COUNT(*) as total_tools FROM crime_tools;
SELECT 'Migration complete: All 16 tools are now in the database' AS status;
