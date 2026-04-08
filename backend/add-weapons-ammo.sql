-- Add weapon inventory table
CREATE TABLE weapon_inventory (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL,
  weaponId VARCHAR(50) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  `condition` INT NOT NULL DEFAULT 100,
  purchasedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_player_weapon (playerId, weaponId),
  INDEX idx_playerId (playerId),
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
);

-- Add ammo inventory table
CREATE TABLE ammo_inventory (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL,
  ammoType VARCHAR(50) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  UNIQUE KEY unique_player_ammo (playerId, ammoType),
  INDEX idx_playerId (playerId),
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
);
