-- Add bank_accounts table for Phase 8.1
-- Players can deposit money in banks for safety and earn interest

CREATE TABLE IF NOT EXISTS bank_accounts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL UNIQUE,
  balance INT DEFAULT 0,
  interestRate DOUBLE DEFAULT 0.05,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
  INDEX idx_playerId (playerId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
