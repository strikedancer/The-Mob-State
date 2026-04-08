-- Update propertytest user with money and rank
UPDATE players 
SET money = 500000, rank = 20
WHERE username = 'propertytest';

SELECT id, username, money, rank FROM players WHERE username = 'propertytest';
