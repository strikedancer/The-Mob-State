-- Add currentCountry field for Phase 9.1
-- Players can travel between countries for trade

ALTER TABLE players ADD COLUMN currentCountry VARCHAR(50) DEFAULT 'netherlands';
