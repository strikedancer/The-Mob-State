-- Player-owned transferable event collectables (marketplace event_item escrow source)
CREATE TABLE IF NOT EXISTS player_event_items (
  id INT NOT NULL AUTO_INCREMENT,
  playerId INT NOT NULL,
  itemKey VARCHAR(64) NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  sourceLiveEventId INT NULL,
  createdAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uq_player_event_items_player_item (playerId, itemKey),
  INDEX idx_player_event_items_player (playerId),
  CONSTRAINT fk_player_event_items_player FOREIGN KEY (playerId) REFERENCES players(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;