-- Add 3 new advanced tools: Night Vision, Burner Phone, GPS Jammer
-- Run this migration to add new crime tools to the database

INSERT INTO crime_tools (id, name, type, basePrice, maxDurability, loseChance, wearPerUse, requiredFor) VALUES
  ('night_vision', 'Nachtkijker', 'NIGHT_VISION', 750, 100, 0.12, 8, JSON_ARRAY('evidence_room_heist')),
  ('burner_phone', 'Wegwerptelefoon', 'BURNER_PHONE', 20, 1, 1.0, 100, JSON_ARRAY('diamond_heist')),
  ('gps_jammer', 'GPS Jammer', 'GPS_JAMMER', 1200, 100, 0.18, 12, JSON_ARRAY('rob_armored_truck'));

SELECT 'Migration complete: Added 3 new advanced tools (Nachtkijker, Wegwerptelefoon, GPS Jammer)' AS status;
