-- Street and elite bodyguard counts. Existing `bodyguards` stays the standard tier.

ALTER TABLE `player_security`
  ADD COLUMN IF NOT EXISTS `bodyguardsStreet` INT NOT NULL DEFAULT 0 AFTER `bodyguards`,
  ADD COLUMN IF NOT EXISTS `bodyguardsElite` INT NOT NULL DEFAULT 0 AFTER `bodyguardsStreet`;
