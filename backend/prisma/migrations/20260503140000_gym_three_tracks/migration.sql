-- Three gym tracks (strength / speed / stamina) with separate session counts and cooldowns.
-- Preserve existing crime bonus: copy legacy sessions into all three counters so
-- (s/100)*0.04 + (sp/100)*0.02 + (st/100)*0.02 equals previous (sessions/100)*0.08 when all equal.

ALTER TABLE `gym_stats`
  ADD COLUMN `speedSessionsCompleted` INT NOT NULL DEFAULT 0 AFTER `sessionsCompleted`,
  ADD COLUMN `staminaSessionsCompleted` INT NOT NULL DEFAULT 0 AFTER `speedSessionsCompleted`,
  ADD COLUMN `speedLastTrainedAt` DATETIME(3) NULL AFTER `lastTrainedAt`,
  ADD COLUMN `staminaLastTrainedAt` DATETIME(3) NULL AFTER `speedLastTrainedAt`;

UPDATE `gym_stats`
SET
  `speedSessionsCompleted` = `sessionsCompleted`,
  `staminaSessionsCompleted` = `sessionsCompleted`,
  `strengthBonus` = ROUND(
    LEAST(1, `sessionsCompleted` / 100.0) * 0.04
      + LEAST(1, `sessionsCompleted` / 100.0) * 0.02
      + LEAST(1, `sessionsCompleted` / 100.0) * 0.02,
    4
  );
