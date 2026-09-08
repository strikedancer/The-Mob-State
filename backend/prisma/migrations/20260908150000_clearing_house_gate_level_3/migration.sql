INSERT INTO `runtime_config` (`configKey`, `configValue`)
VALUES ('CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL', '3')
ON DUPLICATE KEY UPDATE `configValue` = '3';
