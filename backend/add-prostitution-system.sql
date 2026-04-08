-- Add Prostitution System
-- Adds prostitutes, red light districts, and rooms

-- Add lastProstituteRecruitment column to players table
ALTER TABLE players
ADD COLUMN lastProstituteRecruitment DATETIME NULL AFTER lastAmmoPurchaseAt;

-- Create prostitutes table
CREATE TABLE IF NOT EXISTS prostitutes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  playerId INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  variant INT NOT NULL DEFAULT 1,
  recruitedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  lastEarningsAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  location VARCHAR(20) NOT NULL DEFAULT 'street',
  redLightRoomId INT NULL UNIQUE,
  
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
  INDEX idx_playerId (playerId),
  INDEX idx_location (location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create red_light_districts table
CREATE TABLE IF NOT EXISTS red_light_districts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  countryCode VARCHAR(50) NOT NULL UNIQUE,
  ownerId INT NULL,
  purchasePrice INT NOT NULL DEFAULT 500000,
  purchasedAt DATETIME NULL,
  roomCount INT NOT NULL DEFAULT 8,
  
  FOREIGN KEY (ownerId) REFERENCES players(id) ON DELETE SET NULL,
  INDEX idx_countryCode (countryCode),
  INDEX idx_ownerId (ownerId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create red_light_rooms table
CREATE TABLE IF NOT EXISTS red_light_rooms (
  id INT PRIMARY KEY AUTO_INCREMENT,
  redLightDistrictId INT NOT NULL,
  roomNumber INT NOT NULL,
  occupied BOOLEAN NOT NULL DEFAULT FALSE,
  lastEarningsAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (redLightDistrictId) REFERENCES red_light_districts(id) ON DELETE CASCADE,
  UNIQUE KEY unique_district_room (redLightDistrictId, roomNumber),
  INDEX idx_redLightDistrictId (redLightDistrictId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add foreign key for redLightRoomId in prostitutes (after red_light_rooms exists)
ALTER TABLE prostitutes
ADD CONSTRAINT fk_prostitute_room
FOREIGN KEY (redLightRoomId) REFERENCES red_light_rooms(id) ON DELETE SET NULL;

-- Initialize red light districts for all countries
INSERT INTO red_light_districts (countryCode, purchasePrice, roomCount) VALUES
('netherlands', 750000, 10),
('belgium', 650000, 8),
('germany', 800000, 10),
('france', 850000, 10),
('spain', 700000, 8),
('italy', 750000, 8),
('uk', 900000, 10),
('usa', 1000000, 12),
('mexico', 600000, 8),
('colombia', 650000, 8),
('brazil', 700000, 10),
('argentina', 650000, 8),
('russia', 750000, 10),
('turkey', 600000, 8),
('thailand', 550000, 8),
('japan', 950000, 10),
('china', 900000, 10),
('australia', 850000, 8),
('southafrica', 600000, 8),
('dubai', 1200000, 12)
ON DUPLICATE KEY UPDATE countryCode=countryCode;

-- Create rooms for each district
-- This will be handled by backend service when district is created/purchased

SELECT 'Prostitution system tables created successfully' AS status;
