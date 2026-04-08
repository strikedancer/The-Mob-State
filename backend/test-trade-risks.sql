-- Test script voor trade risk mechanics

-- 1. Maak oude bloemen (bijna bedorven - 47 uur oud)
UPDATE inventory 
SET purchasedAt = DATE_SUB(NOW(), INTERVAL 47 HOUR)
WHERE goodType = 'contraband_flowers' AND playerId = 2;

-- 2. Voeg beschadigde elektronica toe
INSERT INTO inventory (playerId, goodType, quantity, purchasePrice, `condition`, purchasedAt)
VALUES (2, 'contraband_electronics', 10, 500, 45, NOW())
ON DUPLICATE KEY UPDATE 
  quantity = 10,
  `condition` = 45,
  purchasePrice = 500;

-- 3. Voeg verse bloemen toe om spoilage warning te testen
INSERT INTO inventory (playerId, goodType, quantity, purchasePrice, `condition`, purchasedAt)
VALUES (2, 'contraband_flowers', 50, 100, 100, DATE_SUB(NOW(), INTERVAL 38 HOUR))
ON DUPLICATE KEY UPDATE 
  quantity = 50,
  purchasedAt = DATE_SUB(NOW(), INTERVAL 38 HOUR),
  purchasePrice = 100;

-- 4. Voeg wapens toe om confiscatie te testen
INSERT INTO inventory (playerId, goodType, quantity, purchasePrice, `condition`, purchasedAt)
VALUES (2, 'contraband_weapons', 20, 1500, 100, NOW())
ON DUPLICATE KEY UPDATE 
  quantity = 20,
  purchasePrice = 1500;

-- Check resultaat
SELECT 
  goodType,
  quantity,
  purchasePrice,
  `condition` as conditie,
  purchasedAt,
  TIMESTAMPDIFF(HOUR, purchasedAt, NOW()) as uren_geleden,
  CASE 
    WHEN goodType = 'contraband_flowers' AND TIMESTAMPDIFF(HOUR, purchasedAt, NOW()) > 48 THEN 'BEDORVEN'
    WHEN goodType = 'contraband_flowers' AND TIMESTAMPDIFF(HOUR, purchasedAt, NOW()) > 36 THEN 'WAARSCHUWING'
    ELSE 'OK'
  END as status
FROM inventory 
WHERE playerId = 2;
