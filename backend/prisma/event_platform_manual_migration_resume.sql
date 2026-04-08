CREATE TABLE `game_event_participant_progress` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `liveEventId` INTEGER NOT NULL,
  `playerId` INTEGER NULL,
  `subjectType` VARCHAR(30) NOT NULL DEFAULT 'player',
  `subjectKey` VARCHAR(100) NOT NULL,
  `progressJson` JSON NULL,
  `score` DOUBLE NOT NULL DEFAULT 0,
  `rank` INTEGER NULL,
  `qualified` BOOLEAN NOT NULL DEFAULT false,
  `lastContributionAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  UNIQUE INDEX `gepp_live_subject_key_uq`(`liveEventId`, `subjectType`, `subjectKey`),
  INDEX `gepp_player_idx`(`playerId`),
  INDEX `gepp_live_rank_idx`(`liveEventId`, `rank`),
  INDEX `gepp_live_score_idx`(`liveEventId`, `score`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `game_event_leaderboard_snapshots` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `liveEventId` INTEGER NOT NULL,
  `boardType` VARCHAR(50) NOT NULL,
  `snapshotAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `entriesJson` JSON NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  INDEX `gels_live_board_snap_idx`(`liveEventId`, `boardType`, `snapshotAt`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `game_event_reward_rules` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `liveEventId` INTEGER NOT NULL,
  `triggerType` VARCHAR(50) NOT NULL,
  `triggerConfigJson` JSON NULL,
  `rewardsJson` JSON NOT NULL,
  `sortOrder` INTEGER NOT NULL DEFAULT 0,
  `isActive` BOOLEAN NOT NULL DEFAULT true,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  INDEX `gerr_live_active_sort_idx`(`liveEventId`, `isActive`, `sortOrder`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `game_event_reward_claims` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `liveEventId` INTEGER NOT NULL,
  `rewardRuleId` INTEGER NULL,
  `playerId` INTEGER NOT NULL,
  `grantedRewardsJson` JSON NOT NULL,
  `claimedAt` DATETIME(3) NULL,
  `deliveryStatus` VARCHAR(30) NOT NULL DEFAULT 'pending',
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  INDEX `gerc_player_delivery_idx`(`playerId`, `deliveryStatus`),
  INDEX `gerc_live_player_idx`(`liveEventId`, `playerId`),
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `game_event_schedules`
  ADD CONSTRAINT `ges_template_fk`
  FOREIGN KEY (`templateId`) REFERENCES `game_event_templates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `game_live_events`
  ADD CONSTRAINT `gle_template_fk`
  FOREIGN KEY (`templateId`) REFERENCES `game_event_templates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `gle_admin_fk`
  FOREIGN KEY (`createdByAdminId`) REFERENCES `admins`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `game_live_event_modifiers`
  ADD CONSTRAINT `glem_live_fk`
  FOREIGN KEY (`liveEventId`) REFERENCES `game_live_events`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `game_event_participant_progress`
  ADD CONSTRAINT `gepp_live_fk`
  FOREIGN KEY (`liveEventId`) REFERENCES `game_live_events`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `gepp_player_fk`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `game_event_leaderboard_snapshots`
  ADD CONSTRAINT `gels_live_fk`
  FOREIGN KEY (`liveEventId`) REFERENCES `game_live_events`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `game_event_reward_rules`
  ADD CONSTRAINT `gerr_live_fk`
  FOREIGN KEY (`liveEventId`) REFERENCES `game_live_events`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `game_event_reward_claims`
  ADD CONSTRAINT `gerc_live_fk`
  FOREIGN KEY (`liveEventId`) REFERENCES `game_live_events`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `gerc_rule_fk`
  FOREIGN KEY (`rewardRuleId`) REFERENCES `game_event_reward_rules`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `gerc_player_fk`
  FOREIGN KEY (`playerId`) REFERENCES `players`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
