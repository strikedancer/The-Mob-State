-- Profile likes: one like per source->target player pair
CREATE TABLE IF NOT EXISTS profile_likes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sourcePlayerId INT NOT NULL,
  targetPlayerId INT NOT NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_profile_likes_source_target (sourcePlayerId, targetPlayerId),
  KEY idx_profile_likes_target (targetPlayerId),
  KEY idx_profile_likes_source (sourcePlayerId),
  CONSTRAINT fk_profile_likes_source_player FOREIGN KEY (sourcePlayerId) REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT fk_profile_likes_target_player FOREIGN KEY (targetPlayerId) REFERENCES players(id) ON DELETE CASCADE
);
