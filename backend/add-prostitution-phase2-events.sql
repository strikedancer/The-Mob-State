-- Phase 2: VIP Events System
-- Add VIP events and participation tracking for prostitution system

USE mafia_game;

-- VIP Events table
CREATE TABLE IF NOT EXISTS vip_events (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  event_type ENUM('celebrity_visit', 'bachelor_party', 'convention', 'festival') NOT NULL,
  country_code VARCHAR(2) NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  bonus_multiplier DECIMAL(3,2) DEFAULT 2.0,
  min_level_required INT DEFAULT 1,
  max_participants INT DEFAULT 50,
  current_participants INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_country_time (country_code, start_time, end_time),
  INDEX idx_event_type (event_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Event participation tracking
CREATE TABLE IF NOT EXISTS event_participations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  event_id INT NOT NULL,
  player_id INT NOT NULL,
  prostitute_id INT NOT NULL,
  earnings DECIMAL(10,2) DEFAULT 0,
  status ENUM('active', 'completed', 'cancelled') DEFAULT 'active',
  participated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP NULL,
  FOREIGN KEY (event_id) REFERENCES vip_events(id) ON DELETE CASCADE,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY (prostitute_id) REFERENCES prostitutes(id) ON DELETE CASCADE,
  UNIQUE KEY unique_prostitute_event (prostitute_id, event_id),
  INDEX idx_player_event (player_id, event_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert some initial events for testing (next 48 hours)
INSERT INTO vip_events (title, description, event_type, country_code, start_time, end_time, bonus_multiplier, min_level_required, max_participants) VALUES
-- Celebrity Visit in Netherlands (active now)
('Celebrity After-Party', 'A famous actor is hosting an exclusive after-party in Amsterdam. VIP clients expected!', 'celebrity_visit', 'NL', NOW(), DATE_ADD(NOW(), INTERVAL 4 HOUR), 3.0, 5, 20),

-- Bachelor Party in Germany (starts in 2 hours)
('Bachelor Party Weekend', 'A wealthy group is celebrating in Berlin. Multiple clients, high tips!', 'bachelor_party', 'DE', DATE_ADD(NOW(), INTERVAL 2 HOUR), DATE_ADD(NOW(), INTERVAL 6 HOUR), 2.0, 1, 30),

-- Convention in Netherlands (starts in 6 hours)
('Tech Convention', 'Major tech convention in Amsterdam. Business travelers with expense accounts.', 'convention', 'NL', DATE_ADD(NOW(), INTERVAL 6 HOUR), DATE_ADD(NOW(), INTERVAL 14 HOUR), 2.5, 3, 40),

-- Festival in Belgium (starts in 12 hours)
('Music Festival Weekend', 'Large music festival in Brussels. Party atmosphere, many potential clients.', 'festival', 'BE', DATE_ADD(NOW(), INTERVAL 12 HOUR), DATE_ADD(NOW(), INTERVAL 24 HOUR), 2.0, 1, 50),

-- Celebrity Visit in Germany (starts tomorrow)
('Film Premiere Night', 'Red carpet premiere in Berlin. Celebrities and wealthy guests.', 'celebrity_visit', 'DE', DATE_ADD(NOW(), INTERVAL 24 HOUR), DATE_ADD(NOW(), INTERVAL 28 HOUR), 3.5, 7, 15);

SELECT '✅ VIP Events tables created successfully!' AS Status;
SELECT '📊 Sample events inserted for testing' AS Status;

-- Show active events
SELECT 
  id,
  title,
  event_type,
  country_code,
  bonus_multiplier,
  min_level_required,
  TIMESTAMPDIFF(MINUTE, NOW(), start_time) AS starts_in_minutes,
  TIMESTAMPDIFF(MINUTE, NOW(), end_time) AS ends_in_minutes,
  CASE 
    WHEN NOW() BETWEEN start_time AND end_time THEN '🟢 ACTIVE'
    WHEN NOW() < start_time THEN '🔵 UPCOMING'
    ELSE '⚫ ENDED'
  END AS status
FROM vip_events
ORDER BY start_time;
