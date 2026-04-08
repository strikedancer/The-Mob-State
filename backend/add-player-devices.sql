-- Add player_devices table for FCM tokens
CREATE TABLE IF NOT EXISTS player_devices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  playerId INT NOT NULL,
  deviceToken VARCHAR(500) NOT NULL,
  deviceType ENUM('android', 'ios', 'web') NOT NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE,
  UNIQUE KEY unique_device_token (deviceToken(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
