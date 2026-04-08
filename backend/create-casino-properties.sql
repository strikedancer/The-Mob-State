-- Create casino properties for each country
-- These are fixed properties that cannot be deleted

INSERT INTO properties (propertyId, propertyType, countryId, playerId, name, price, income)
VALUES 
  ('casino_netherlands', 'casino', 'netherlands', NULL, 'Casino Amsterdam', 2000000, 0),
  ('casino_belgium', 'casino', 'belgium', NULL, 'Casino Brussels', 3000000, 0),
  ('casino_germany', 'casino', 'germany', NULL, 'Casino Berlin', 4000000, 0),
  ('casino_france', 'casino', 'france', NULL, 'Casino Paris', 5000000, 0),
  ('casino_spain', 'casino', 'spain', NULL, 'Casino Madrid', 4500000, 0),
  ('casino_italy', 'casino', 'italy', NULL, 'Casino Rome', 5500000, 0),
  ('casino_united_kingdom', 'casino', 'united_kingdom', NULL, 'Casino London', 8000000, 0),
  ('casino_austria', 'casino', 'austria', NULL, 'Casino Vienna', 6000000, 0),
  ('casino_switzerland', 'casino', 'switzerland', NULL, 'Casino Zurich', 10000000, 0),
  ('casino_sweden', 'casino', 'sweden', NULL, 'Casino Stockholm', 7000000, 0)
ON DUPLICATE KEY UPDATE 
  propertyType = VALUES(propertyType),
  name = VALUES(name),
  price = VALUES(price);
