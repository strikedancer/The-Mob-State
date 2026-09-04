-- Failed hit attempts stay active; lastCombatAt gates the retry window.

ALTER TABLE `hit_list`
  ADD COLUMN IF NOT EXISTS `lastCombatAt` DATETIME NULL AFTER `status`;
