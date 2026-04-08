-- Add Inventory table for trade system (Phase 9.2)
CREATE TABLE inventory (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL,
  goodType VARCHAR(50) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_player_good (playerId, goodType),
  INDEX idx_playerId (playerId),
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
