-- ============================================
-- Inventory System Migration
-- Adds carried inventory, property storage, and loadouts
-- ============================================

-- 1. Extend player_tools with location tracking
ALTER TABLE player_tools
ADD COLUMN location VARCHAR(50) DEFAULT 'carried' COMMENT 'carried or property_{id}',
ADD COLUMN quantity INT DEFAULT 1 COMMENT 'For stackable items',
ADD INDEX idx_location (location),
ADD INDEX idx_player_location (playerId, location);

-- 2. Add inventory capacity to players
ALTER TABLE players
ADD COLUMN inventory_slots_used INT DEFAULT 0 COMMENT 'Current slots in use',
ADD COLUMN max_inventory_slots INT DEFAULT 5 COMMENT 'Maximum carry capacity';

-- 3. Create property storage capacity table
CREATE TABLE IF NOT EXISTS property_storage_capacity (
  id INT PRIMARY KEY AUTO_INCREMENT,
  property_type VARCHAR(50) UNIQUE NOT NULL,
  max_slots INT NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default property storage capacities
INSERT INTO property_storage_capacity (property_type, max_slots, description) VALUES
('apartment', 20, 'Small apartment with limited storage space'),
('house', 50, 'Standard house with decent storage'),
('villa', 100, 'Luxury villa with large storage area'),
('warehouse', 500, 'Dedicated storage facility'),
('safehouse', 200, 'Hidden safehouse protected from FBI raids'),
('penthouse', 150, 'High-end penthouse with premium storage');

-- 4. Create tool loadouts table
CREATE TABLE IF NOT EXISTS tool_loadouts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  is_active BOOLEAN DEFAULT FALSE COMMENT 'Currently equipped loadout',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  INDEX idx_player (player_id),
  INDEX idx_active (player_id, is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Create loadout tools junction table
CREATE TABLE IF NOT EXISTS loadout_tools (
  id INT PRIMARY KEY AUTO_INCREMENT,
  loadout_id INT NOT NULL,
  tool_id VARCHAR(50) NOT NULL,
  slot_position INT DEFAULT 0 COMMENT 'Position in loadout (0-9)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (loadout_id) REFERENCES tool_loadouts(id) ON DELETE CASCADE,
  UNIQUE KEY unique_loadout_tool (loadout_id, tool_id),
  INDEX idx_loadout (loadout_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Create inventory upgrades table
CREATE TABLE IF NOT EXISTS inventory_upgrades (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  upgrade_type VARCHAR(50) NOT NULL COMMENT 'backpack, tactical_vest, cargo_pants',
  bonus_slots INT NOT NULL,
  purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  UNIQUE KEY unique_player_upgrade (player_id, upgrade_type),
  INDEX idx_player (player_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Create transfer history table for tracking movements
CREATE TABLE IF NOT EXISTS tool_transfers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  tool_id VARCHAR(50) NOT NULL,
  from_location VARCHAR(50) NOT NULL,
  to_location VARCHAR(50) NOT NULL,
  quantity INT DEFAULT 1,
  durability INT,
  transferred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  INDEX idx_player (player_id),
  INDEX idx_transferred_at (transferred_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Add tool slot sizes to crime_tools
ALTER TABLE crime_tools
ADD COLUMN slot_size INT DEFAULT 1 COMMENT 'How many inventory slots this tool takes';

-- Update existing tools with slot sizes
UPDATE crime_tools SET slot_size = 1 WHERE id IN ('bolt_cutter', 'lockpick_set', 'screwdriver', 'gps_jammer', 'burner_phone');
UPDATE crime_tools SET slot_size = 2 WHERE id IN ('burglary_kit', 'car_theft_tools', 'night_vision', 'crowbar');
UPDATE crime_tools SET slot_size = 3 WHERE id IN ('jerry_can', 'drill', 'welding_torch');
UPDATE crime_tools SET slot_size = 4 WHERE id IN ('explosives', 'heavy_cutter');

-- 9. Update all existing player tools to 'carried' location
UPDATE player_tools SET location = 'carried' WHERE location IS NULL;

-- 10. Calculate initial inventory usage for existing players
UPDATE players p
SET inventory_slots_used = (
  SELECT COALESCE(SUM(ct.slot_size * pt.quantity), 0)
  FROM player_tools pt
  JOIN crime_tools ct ON pt.toolId = ct.id
  WHERE pt.playerId = p.id AND pt.location = 'carried'
);

-- 11. Grant bonus slots based on player level
UPDATE players 
SET max_inventory_slots = CASE
  WHEN rank >= 50 THEN 20  -- Level 50+: 20 slots
  WHEN rank >= 25 THEN 15  -- Level 25-49: 15 slots
  WHEN rank >= 10 THEN 10  -- Level 10-24: 10 slots
  ELSE 5                    -- Level 1-9: 5 slots
END;

SELECT 'Inventory system migration completed!' AS status;
SELECT COUNT(*) AS total_tools, SUM(quantity) AS total_quantity FROM player_tools;
SELECT COUNT(*) AS total_players, AVG(max_inventory_slots) AS avg_max_slots FROM players;
