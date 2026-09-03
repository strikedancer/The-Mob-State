INSERT INTO `runtime_config` (`configKey`, `configValue`)
VALUES ('DRUG_WHOLESALE_CREW_RUNNER_BPS', '500')
ON DUPLICATE KEY UPDATE `configKey` = `configKey`;
