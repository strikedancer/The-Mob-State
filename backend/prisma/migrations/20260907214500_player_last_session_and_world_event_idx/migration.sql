-- Auth used to scan world_events for auth.session.login on every request.
-- Store the session timestamp on players and index remaining event lookups.
ALTER TABLE `players`
  ADD COLUMN `lastSessionAt` DATETIME(3) NULL;

CREATE INDEX `world_events_playerId_eventKey_createdAt_idx`
  ON `world_events`(`playerId`, `eventKey`, `createdAt`);
