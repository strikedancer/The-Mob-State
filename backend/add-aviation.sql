-- Add Aviation system tables (Phase 10.1)

-- Aviation License table
CREATE TABLE aviation_licenses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL UNIQUE,
  licenseType VARCHAR(50) NOT NULL DEFAULT 'basic',
  purchasePrice INT NOT NULL,
  issuedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_playerId (playerId),
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Aircraft table
CREATE TABLE aircraft (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL,
  aircraftType VARCHAR(50) NOT NULL,
  fuel INT NOT NULL DEFAULT 0,
  maxFuel INT NOT NULL,
  isBroken BOOLEAN NOT NULL DEFAULT FALSE,
  totalFlights INT NOT NULL DEFAULT 0,
  purchasePrice INT NOT NULL,
  purchasedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_playerId (playerId),
  INDEX idx_aircraftType (aircraftType),
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
