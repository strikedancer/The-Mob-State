-- Add jailbreak feature
-- Allows crew members to break out jailed players

-- Create jailbreak attempts table
CREATE TABLE IF NOT EXISTS jailbreak_attempts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  rescuerId INT NOT NULL,
  jailedPlayerId INT NOT NULL,
  success BOOLEAN NOT NULL,
  crewId INT,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (rescuerId) REFERENCES players(id),
  FOREIGN KEY (jailedPlayerId) REFERENCES players(id),
  FOREIGN KEY (crewId) REFERENCES crews(id),
  
  INDEX idx_jailed_player (jailedPlayerId),
  INDEX idx_rescuer (rescuerId),
  INDEX idx_created (createdAt)
);
