-- Optional push for live player events (start/end). Default on for existing rows.
ALTER TABLE `player_notification_preferences`
ADD COLUMN `push_game_events` BOOLEAN NOT NULL DEFAULT TRUE;
