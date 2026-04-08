-- Drug heat system + auto-collect + last drug action tracking
-- Run this migration when deploying the drug expansion update

ALTER TABLE `players`
  ADD COLUMN `drugHeat`         INT           NOT NULL DEFAULT 0    COMMENT 'Police heat level 0-100 from drug activity',
  ADD COLUMN `autoCollectDrugs` TINYINT(1)    NOT NULL DEFAULT 0    COMMENT 'VIP: auto-collect ready productions',
  ADD COLUMN `lastDrugActionAt` DATETIME      NULL                  COMMENT 'Timestamp for heat decay calculation';
