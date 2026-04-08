-- Create high-level test player for FBI testing
-- Username: fbi_test_highlevel
-- Password: test123 (hash: $2b$10$rN8eR5FxF5TkKvF5TkKvF5TkKvF5TkKvF5TkKvF5TkKvF5TkKvF5Tk)

-- Delete existing test player
DELETE FROM players WHERE username = 'fbi_test_highlevel';

-- Create high-level player
INSERT INTO players (username, passwordHash, money, health, hunger, thirst, rank, xp, wantedLevel, fbiHeat, createdAt, updatedAt, lastTickAt)
VALUES (
  'fbi_test_highlevel',
  '$2b$10$sW2gwR/8hPCR36ZFCqFDXe9Q3satAvR75cbof.X70boYw7fzoolkC',  -- 'test123'
  1000000,  -- €1M for bail tests
  100,      -- health
  100,      -- hunger
  100,      -- thirst
  30,       -- rank (high level to unlock all crimes)
  30000,    -- xp
  0,        -- wantedLevel
  0,        -- fbiHeat
  NOW(),
  NOW(),
  NOW()
);

SELECT 'High-level test player created:' AS message;
SELECT id, username, rank, money, fbiHeat, wantedLevel FROM players WHERE username = 'fbi_test_highlevel';
