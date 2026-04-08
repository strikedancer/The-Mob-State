-- Add backpack system tables

-- Table for player backpacks (which backpack does the player own)
CREATE TABLE IF NOT EXISTS player_backpacks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  player_id INT NOT NULL,
  backpack_id VARCHAR(50) NOT NULL,
  purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_player_backpack (player_id),
  FOREIGN KEY (player_id) REFERENCES Player(id) ON DELETE CASCADE,
  INDEX idx_player_backpack (player_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add column to track base carrying capacity (without backpack)
-- The total capacity will be base + backpack_slots
ALTER TABLE Player 
ADD COLUMN IF NOT EXISTS base_carry_slots INT DEFAULT 5 
COMMENT 'Base carrying capacity without backpack';

-- No need to add backpack_slots to Player table as we'll calculate it dynamically
-- from the player_backpacks join

SELECT 'Backpack system tables created successfully' AS status;
