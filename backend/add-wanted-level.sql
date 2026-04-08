-- Migration: add_wanted_level
-- Add wantedLevel field to Player model

ALTER TABLE players ADD COLUMN wantedLevel INT NOT NULL DEFAULT 0 AFTER xp;
