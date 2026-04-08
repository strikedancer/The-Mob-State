INSERT IGNORE INTO game_event_templates (`key`, category, eventType, titleNl, titleEn, shortDescriptionNl, shortDescriptionEn, isActive, createdAt, updatedAt) VALUES
('crime_spree', 'crime', 'competition', 'Crime Spree', 'Crime Spree', 'Pleeg de meeste crimes en win prijzen!', 'Commit the most crimes and win prizes!', 1, NOW(), NOW()),
('drug_run', 'drugs', 'competition', 'Drug Run', 'Drug Run', 'Verkoop de meeste drugs en claim de top positie!', 'Sell the most drugs and claim the top spot!', 1, NOW(), NOW()),
('vehicle_theft_rally', 'vehicles', 'competition', 'Auto Jattevent', 'Vehicle Theft Rally', 'Steel zoveel mogelijk voertuigen om te winnen!', 'Steal as many vehicles as possible to win!', 1, NOW(), NOW()),
('smuggling_rush', 'smuggling', 'competition', 'Smokkelrun', 'Smuggling Rush', 'Smokkkel de grootste lading en win!', 'Smuggle the biggest load and win!', 1, NOW(), NOW());

INSERT INTO game_event_schedules (templateId, scheduleType, intervalMinutes, durationMinutes, cooldownMinutes, enabled, weight, createdAt, updatedAt)
SELECT t.id, 'interval', 360, 60, 120, 1, 1, NOW(), NOW()
FROM game_event_templates t
WHERE t.`key` = 'crime_spree'
  AND NOT EXISTS (SELECT 1 FROM game_event_schedules WHERE templateId = t.id);

INSERT INTO game_event_schedules (templateId, scheduleType, intervalMinutes, durationMinutes, cooldownMinutes, enabled, weight, createdAt, updatedAt)
SELECT t.id, 'interval', 480, 90, 180, 1, 1, NOW(), NOW()
FROM game_event_templates t
WHERE t.`key` = 'drug_run'
  AND NOT EXISTS (SELECT 1 FROM game_event_schedules WHERE templateId = t.id);

INSERT INTO game_event_schedules (templateId, scheduleType, intervalMinutes, durationMinutes, cooldownMinutes, enabled, weight, createdAt, updatedAt)
SELECT t.id, 'interval', 720, 120, 240, 1, 1, NOW(), NOW()
FROM game_event_templates t
WHERE t.`key` = 'vehicle_theft_rally'
  AND NOT EXISTS (SELECT 1 FROM game_event_schedules WHERE templateId = t.id);

INSERT INTO game_event_schedules (templateId, scheduleType, intervalMinutes, durationMinutes, cooldownMinutes, enabled, weight, createdAt, updatedAt)
SELECT t.id, 'interval', 600, 90, 180, 1, 1, NOW(), NOW()
FROM game_event_templates t
WHERE t.`key` = 'smuggling_rush'
  AND NOT EXISTS (SELECT 1 FROM game_event_schedules WHERE templateId = t.id);
