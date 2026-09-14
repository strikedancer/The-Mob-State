-- Discord weekly link prompt + one-time cash bonus tracking.
ALTER TABLE `players` ADD COLUMN `discordLinkPromptShownAt` DATETIME(3) NULL;
ALTER TABLE `players` ADD COLUMN `discordLinkPromptDeclinedAt` DATETIME(3) NULL;
ALTER TABLE `players` ADD COLUMN `discordLinkBonusPaidAt` DATETIME(3) NULL;
