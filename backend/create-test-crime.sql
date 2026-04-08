-- Create a test crime attempt for appeals testing
-- This simulates a sentenced crime with jail time

-- Get the player ID for testplayer
SET @playerId = (SELECT id FROM players WHERE username = 'testplayer');

-- Insert a test crime attempt (bank robbery - federal crime)
INSERT INTO crime_attempts (
  playerId,
  crimeId,
  success,
  reward,
  xpGained,
  jailed,
  jailTime,
  vehicleId,
  appealedAt,
  createdAt
)
VALUES (
  @playerId,
  'bank_robbery',  -- federal crime
  true,            -- success
  50000,           -- reward
  500,             -- xp gained
  true,            -- jailed
  180,             -- jail time (3 hours) - enough for meaningful appeal
  NULL,            -- no vehicle used
  NULL,            -- not appealed yet
  NOW()
);

SELECT 'Test crime created for appeals testing:' AS message;
SELECT id, crimeId, jailTime, jailed, appealedAt 
FROM crime_attempts 
WHERE playerId = @playerId 
ORDER BY createdAt DESC 
LIMIT 1;
