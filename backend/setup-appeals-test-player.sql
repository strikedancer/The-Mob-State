-- Create test player for appeals testing
-- Username: testplayer
-- Password: test123

-- Delete existing test player
DELETE FROM players WHERE username = 'testplayer';

-- Create test player with money for appeals
INSERT INTO players (username, passwordHash, money, health, hunger, thirst, rank, xp, wantedLevel, fbiHeat, createdAt, updatedAt, lastTickAt)
VALUES (
  'testplayer',
  '$2b$10$sW2gwR/8hPCR36ZFCqFDXe9Q3satAvR75cbof.X70boYw7fzoolkC',  -- 'test123'
  500000,   -- €500k for appeal costs
  100,      -- health
  100,      -- hunger
  100,      -- thirst
  25,       -- rank (high enough to commit crimes)
  25000,    -- xp
  50,       -- wantedLevel (for testing modifiers)
  15,       -- fbiHeat (for testing modifiers)
  NOW(),
  NOW(),
  NOW()
);

SELECT 'Test player created for appeals testing:' AS message;
SELECT id, username, rank, money, wantedLevel, fbiHeat FROM players WHERE username = 'testplayer';
