-- Migration: Add Crime Tools System
-- Date: 2026-02-18
-- Description: Adds crime_tools and player_tools tables for tool-based crime mechanics

-- Create crime_tools table
CREATE TABLE `crime_tools` (
  `id` VARCHAR(50) PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `type` VARCHAR(50) NOT NULL COMMENT 'BOLT_CUTTER, BURGLARY_KIT, JERRY_CAN, LOCKPICK, CAR_TOOLS',
  `basePrice` INT NOT NULL,
  `maxDurability` INT NOT NULL COMMENT '100 = new tool',
  `loseChance` FLOAT NOT NULL COMMENT 'Chance to lose tool after use (0.0-1.0)',
  `wearPerUse` INT NOT NULL COMMENT 'Durability loss per use',
  `requiredFor` JSON NOT NULL COMMENT 'Array of crime IDs that require this tool'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create player_tools table
CREATE TABLE `player_tools` (
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

-- Insert tool definitions from tools.json
INSERT INTO `crime_tools` (`id`, `name`, `type`, `basePrice`, `maxDurability`, `loseChance`, `wearPerUse`, `requiredFor`) VALUES
('bolt_cutter', 'Betonschaar', 'BOLT_CUTTER', 250, 100, 0.15, 25, '["steal_bike"]'),
('burglary_kit', 'Inbrekersset', 'BURGLARY_KIT', 1500, 100, 0.20, 10, '["burglary"]'),
('car_theft_tools', 'Auto Diefstal Gereedschap', 'CAR_TOOLS', 800, 100, 0.10, 15, '["car_theft"]'),
('jerry_can', 'Jerrycan (20L)', 'JERRY_CAN', 50, 1, 1.0, 100, '["arson"]'),
('lockpick_set', 'Lockpick Set', 'LOCKPICK', 350, 100, 0.05, 5, '["pickpocket", "burglary"]');

SELECT 'Migration complete: Added crime_tools and player_tools tables with 5 tool definitions' AS status;
