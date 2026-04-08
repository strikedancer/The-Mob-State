-- Phase 1: Core Enhancement - Leveling, Raids, and Upgrades
-- Add columns for prostitute leveling system
ALTER TABLE prostitutes 
  ADD COLUMN experience INT DEFAULT 0 NOT NULL AFTER redLightRoomId,
  ADD COLUMN level INT DEFAULT 1 NOT NULL AFTER experience,
  ADD COLUMN isBusted BOOLEAN DEFAULT FALSE NOT NULL AFTER level,
  ADD COLUMN bustedUntil DATETIME NULL AFTER isBusted;

-- Add columns for district upgrade system
ALTER TABLE red_light_districts
  ADD COLUMN tier INT DEFAULT 1 NOT NULL AFTER roomCount,
  ADD COLUMN securityLevel INT DEFAULT 0 NOT NULL AFTER tier;

-- Add column for room tier
ALTER TABLE red_light_rooms
  ADD COLUMN tier INT DEFAULT 1 NOT NULL AFTER lastEarningsAt;

-- Create index for busted prostitutes (for raid queries)
CREATE INDEX idx_prostitutes_busted ON prostitutes(isBusted, bustedUntil);

-- Success message
SELECT 'Phase 1 enhancement tables updated successfully!' as message;
