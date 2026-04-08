-- Seed test users for development
-- All passwords hashed with bcrypt

-- testuser2: password = "test123"
DELETE FROM players WHERE username = 'testuser2';
INSERT INTO players (
  username, 
  passwordHash, 
  money, 
  health, 
  hunger, 
  thirst, 
  rank, 
  xp, 
  wantedLevel, 
  fbiHeat, 
  currentCountry,
  preferredLanguage,
  createdAt, 
  updatedAt, 
  lastTickAt,
  lastAmmoPurchaseAt
)
VALUES (
  'testuser2',
  '$2b$10$sW2gwR/8hPCR36ZFCqFDXe9Q3satAvR75cbof.X70boYw7fzoolkC',  -- password: test123
  1000000,   -- €1M for testing
  100,       -- health
  100,       -- hunger
  100,       -- thirst
  30,        -- rank 30 (high for testing)
  50000,     -- xp
  0,         -- wantedLevel
  0,         -- fbiHeat
  'netherlands',
  'nl',
  NOW(),
  NOW(),
  NOW(),
  NULL
);

-- testuser1: password = "test123"
DELETE FROM players WHERE username = 'testuser1';
INSERT INTO players (
  username, 
  passwordHash, 
  money, 
  health, 
  hunger, 
  thirst, 
  rank, 
  xp, 
  wantedLevel, 
  fbiHeat, 
  currentCountry,
  preferredLanguage,
  createdAt, 
  updatedAt, 
  lastTickAt,
  lastAmmoPurchaseAt
)
VALUES (
  'testuser1',
  '$2b$10$sW2gwR/8hPCR36ZFCqFDXe9Q3satAvR75cbof.X70boYw7fzoolkC',  -- password: test123
  500000,
  100,
  100,
  100,
  20,
  30000,
  0,
  0,
  'netherlands',
  'nl',
  NOW(),
  NOW(),
  NOW(),
  NULL
);

-- testplayer: password = "test123"
DELETE FROM players WHERE username = 'testplayer';
INSERT INTO players (
  username, 
  passwordHash, 
  money, 
  health, 
  hunger, 
  thirst, 
  rank, 
  xp, 
  wantedLevel, 
  fbiHeat, 
  currentCountry,
  preferredLanguage,
  createdAt, 
  updatedAt, 
  lastTickAt,
  lastAmmoPurchaseAt
)
VALUES (
  'testplayer',
  '$2b$10$sW2gwR/8hPCR36ZFCqFDXe9Q3satAvR75cbof.X70boYw7fzoolkC',  -- password: test123
  500000,
  100,
  100,
  100,
  25,
  25000,
  50,
  15,
  'netherlands',
  'nl',
  NOW(),
  NOW(),
  NOW(),
  NULL
);
