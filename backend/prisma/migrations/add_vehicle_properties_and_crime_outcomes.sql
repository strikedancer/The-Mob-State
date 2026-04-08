-- Add vehicle properties (speed, armor, stealth, cargo, condition)
ALTER TABLE vehicles 
ADD COLUMN speed INT DEFAULT 50 AFTER vehicleType,
ADD COLUMN armor INT DEFAULT 50 AFTER speed,
ADD COLUMN stealth INT DEFAULT 50 AFTER armor,
ADD COLUMN cargo INT DEFAULT 50 AFTER stealth,
ADD COLUMN `condition` FLOAT DEFAULT 100 AFTER cargo,
ADD COLUMN updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Create player_selected_vehicles table for crime vehicle selection
CREATE TABLE IF NOT EXISTS player_selected_vehicles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  playerId INT NOT NULL UNIQUE,
  vehicleId INT NOT NULL UNIQUE,
  selectedFor VARCHAR(50) DEFAULT 'robbery',
  selectedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY (vehicleId) REFERENCES vehicles(id) ON DELETE CASCADE,
  INDEX idx_playerId (playerId),
  INDEX idx_vehicleId (vehicleId)
);

-- Expand crime_attempts table with outcome tracking
ALTER TABLE crime_attempts
ADD COLUMN usedToolId VARCHAR(50) NULL AFTER vehicleId,
ADD COLUMN outcome VARCHAR(50) DEFAULT 'success' AFTER jailTime,
ADD COLUMN outcomeFail LONGTEXT NULL,
ADD COLUMN lootStolen INT DEFAULT 0,
ADD COLUMN cargoUsed INT DEFAULT 0,
ADD COLUMN vehicleConditionUsed FLOAT NULL,
ADD COLUMN vehicleSpeedBonus FLOAT DEFAULT 1,
ADD COLUMN vehicleCargoBonus FLOAT DEFAULT 1,
ADD COLUMN vehicleStealthBonus FLOAT DEFAULT 1,
ADD COLUMN toolConditionBefore INT NULL,
ADD COLUMN toolDamageSustained INT DEFAULT 0;
