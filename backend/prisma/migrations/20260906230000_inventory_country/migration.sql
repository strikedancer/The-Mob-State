-- Country-local personal trade warehouses.
-- Existing rows migrate to the owner's current country (fallback: netherlands).

ALTER TABLE `inventory`
  ADD COLUMN `country` VARCHAR(50) NOT NULL DEFAULT 'netherlands' AFTER `goodType`;

UPDATE `inventory` i
INNER JOIN `players` p ON p.`id` = i.`playerId`
SET i.`country` = COALESCE(NULLIF(TRIM(p.`currentCountry`), ''), 'netherlands');

ALTER TABLE `inventory`
  DROP INDEX `inventory_playerId_goodType_key`;

UPDATE `inventory` i
INNER JOIN (
  SELECT `playerId`, `goodType`, `country`, MAX(`id`) AS keep_id, SUM(`quantity`) AS total_qty
  FROM `inventory`
  GROUP BY `playerId`, `goodType`, `country`
  HAVING COUNT(*) > 1
) d ON i.`playerId` = d.`playerId`
   AND i.`goodType` = d.`goodType`
   AND i.`country` = d.`country`
SET i.`quantity` = IF(i.`id` = d.keep_id, d.total_qty, 0);

DELETE i FROM `inventory` i
INNER JOIN (
  SELECT `playerId`, `goodType`, `country`, MAX(`id`) AS keep_id
  FROM `inventory`
  GROUP BY `playerId`, `goodType`, `country`
  HAVING COUNT(*) > 1
) d ON i.`playerId` = d.`playerId`
   AND i.`goodType` = d.`goodType`
   AND i.`country` = d.`country`
   AND i.`id` <> d.keep_id;

ALTER TABLE `inventory`
  ADD UNIQUE INDEX `inventory_playerId_goodType_country_key` (`playerId`, `goodType`, `country`),
  ADD INDEX `inventory_playerId_country_idx` (`playerId`, `country`);
