-- Fix stuck travel state for testuser2
UPDATE players 
SET 
  travelingTo = NULL,
  travelRoute = NULL,
  currentTravelLeg = 0,
  travelStartedAt = NULL
WHERE username = 'testuser2';

-- Verify the fix
SELECT 
  id,
  username, 
  currentCountry,
  travelingTo,
  currentTravelLeg,
  travelStartedAt
FROM players 
WHERE username = 'testuser2';
