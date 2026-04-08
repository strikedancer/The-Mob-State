-- Update existing inventory items to have a purchasePrice based on base prices
UPDATE inventory i
JOIN (
  SELECT 'contraband_flowers' as goodType, 100 as basePrice
  UNION ALL SELECT 'contraband_electronics', 500
  UNION ALL SELECT 'contraband_diamonds', 2000
  UNION ALL SELECT 'contraband_weapons', 1500
  UNION ALL SELECT 'contraband_pharmaceuticals', 800
) prices ON i.goodType = prices.goodType
SET i.purchasePrice = prices.basePrice
WHERE i.purchasePrice = 0;
