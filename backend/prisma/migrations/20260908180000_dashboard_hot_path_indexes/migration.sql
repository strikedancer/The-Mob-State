-- Hot-path indexes for dashboard-stats, unread badges, jail list, tick decay/raids.
-- Composite keys match the filters (player + time / success / type).

CREATE INDEX `crime_attempts_playerId_createdAt_idx` ON `crime_attempts`(`playerId`, `createdAt`);
CREATE INDEX `crime_attempts_playerId_success_idx` ON `crime_attempts`(`playerId`, `success`);

CREATE INDEX `job_attempts_playerId_completedAt_idx` ON `job_attempts`(`playerId`, `completedAt`);

CREATE INDEX `vehicle_inventory_playerId_vehicleType_idx` ON `vehicle_inventory`(`playerId`, `vehicleType`);
CREATE INDEX `vehicle_inventory_playerId_stolenAt_idx` ON `vehicle_inventory`(`playerId`, `stolenAt`);

CREATE INDEX `drug_production_playerId_completed_finishesAt_idx`
  ON `drug_production`(`playerId`, `completed`, `finishesAt`);

CREATE INDEX `direct_messages_receiverId_read_idx` ON `direct_messages`(`receiverId`, `read`);

CREATE INDEX `players_jailRelease_idx` ON `players`(`jailRelease`);
CREATE INDEX `players_fbiHeat_idx` ON `players`(`fbiHeat`);
