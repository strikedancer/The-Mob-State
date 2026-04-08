-- Clear all jail attempts for testplayer
-- Sets all jail times to expired (1 hour ago)

-- Get player ID
SET @playerId = (SELECT id FROM players WHERE username = 'testplayer');

-- Update all jail attempts to be expired (1 hour ago + 1 minute jail = already free)
UPDATE crime_attempts
SET 
  createdAt = DATE_SUB(NOW(), INTERVAL 1 HOUR),
  jailTime = 1
WHERE playerId = @playerId AND jailed = 1;

-- Show result
SELECT 
  CONCAT('✅ Cleared ', COUNT(*), ' jail records for testplayer') AS result
FROM crime_attempts
WHERE playerId = @playerId AND jailed = 1;

SELECT 
  id,
  crimeId,
  jailed,
  jailTime,
  createdAt,
  TIMESTAMPDIFF(MINUTE, NOW(), DATE_ADD(createdAt, INTERVAL jailTime MINUTE)) AS remaining_minutes
FROM crime_attempts
WHERE playerId = @playerId AND jailed = 1
ORDER BY createdAt DESC
LIMIT 5;
