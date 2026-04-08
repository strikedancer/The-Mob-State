-- Fix casino properties
DELETE FROM properties WHERE propertyType = 'casino';

INSERT INTO properties (propertyId, propertyType, countryId) VALUES
('casino_netherlands', 'casino', 'netherlands'),
('casino_belgium', 'casino', 'belgium'),
('casino_germany', 'casino', 'germany'),
('casino_france', 'casino', 'france'),
('casino_spain', 'casino', 'spain'),
('casino_italy', 'casino', 'italy'),
('casino_united_kingdom', 'casino', 'united_kingdom'),
('casino_austria', 'casino', 'austria'),
('casino_switzerland', 'casino', 'switzerland'),
('casino_sweden', 'casino', 'sweden');

SELECT * FROM properties WHERE propertyType = 'casino';
