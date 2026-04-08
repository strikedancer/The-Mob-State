-- Reset wanted level and FBI heat for testplayer
-- This clears all police/FBI attention

-- Get player ID
SET @playerId = (SELECT id FROM players WHERE username = 'testplayer');

-- Reset wanted level and FBI heat to 0
UPDATE players
SET 
  wantedLevel = 0,
  fbiHeat = 0
WHERE id = @playerId;

-- Show result
SELECT 
  id,
  username,
  wantedLevel,
  fbiHeat,
  CONCAT('✅ Reset wanted level and FBI heat for ', username) AS result
FROM players
WHERE id = @playerId;
