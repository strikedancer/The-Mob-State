-- Country-local material depots + backpack (_carried_) stock.
-- Existing rows migrate to the player's current country (fallback: netherlands).

ALTER TABLE `production_materials`
  ADD COLUMN `country` VARCHAR(50) NOT NULL DEFAULT 'netherlands' AFTER `playerId`;

UPDATE `production_materials` pm
INNER JOIN `players` p ON p.`id` = pm.`playerId`
SET pm.`country` = COALESCE(NULLIF(TRIM(p.`currentCountry`), ''), 'netherlands');

-- Drop legacy unique index if present (Prisma default name).
ALTER TABLE `production_materials`
  DROP INDEX `production_materials_playerId_materialId_key`;

-- Collapse any duplicate (playerId, country, materialId) rows after backfill.
UPDATE `production_materials` pm
INNER JOIN (
  SELECT `playerId`, `country`, `materialId`, MAX(`id`) AS keep_id, SUM(`quantity`) AS total_qty
  FROM `production_materials`
  GROUP BY `playerId`, `country`, `materialId`
  HAVING COUNT(*) > 1
) d ON pm.`playerId` = d.`playerId`
   AND pm.`country` = d.`country`
   AND pm.`materialId` = d.`materialId`
SET pm.`quantity` = IF(pm.`id` = d.keep_id, d.total_qty, 0);

DELETE pm FROM `production_materials` pm
INNER JOIN (
  SELECT `playerId`, `country`, `materialId`, MAX(`id`) AS keep_id
  FROM `production_materials`
  GROUP BY `playerId`, `country`, `materialId`
  HAVING COUNT(*) > 1
) d ON pm.`playerId` = d.`playerId`
   AND pm.`country` = d.`country`
   AND pm.`materialId` = d.`materialId`
   AND pm.`id` <> d.keep_id;

ALTER TABLE `production_materials`
  ADD UNIQUE INDEX `production_materials_playerId_country_materialId_key` (`playerId`, `country`, `materialId`),
  ADD INDEX `idx_production_materials_country` (`country`);
