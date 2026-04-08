-- Add FBI heat tracking to players table
ALTER TABLE players ADD COLUMN fbiHeat INT NOT NULL DEFAULT 0 AFTER wantedLevel;
