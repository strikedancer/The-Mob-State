-- Add 9 new tools to the database
-- Run this after the initial 4 tools have been added

-- Delete old lockpick_set if it exists
DELETE FROM crime_tools WHERE id = 'lockpick_set';
DELETE FROM player_tools WHERE toolId = 'lockpick_set';

-- Insert new tools
INSERT INTO crime_tools (id, name, type, basePrice, maxDurability, loseChance, wearPerUse, requiredFor) VALUES
('spray_paint', 'Spuitbus Verf', 'SPRAY_PAINT', 25, 10, 1.0, 100, JSON_ARRAY('graffiti', 'vandalism')),
('crowbar', 'Koevoet', 'CROWBAR', 150, 100, 0.15, 20, JSON_ARRAY('atm_theft')),
('glass_cutter', 'Glassnijder', 'GLASS_CUTTER', 400, 100, 0.10, 10, JSON_ARRAY('jewelry_heist')),
('hacking_laptop', 'Hacking Laptop', 'LAPTOP', 2500, 100, 0.05, 5, JSON_ARRAY('hack_account', 'identity_theft')),
('counterfeiting_kit', 'Vervalsingsspullen', 'COUNTERFEITING', 5000, 100, 0.10, 8, JSON_ARRAY('counterfeit_money')),
('toolbox', 'Gereedschapskist', 'TOOLBOX', 300, 100, 0.10, 10, JSON_ARRAY('steal_car_parts')),
('rope', 'Nylon Touw (50m)', 'ROPE', 30, 1, 1.0, 100, JSON_ARRAY('kidnapping')),
('silencer', 'Geluiddemper', 'SILENCER', 1200, 100, 0.20, 15, JSON_ARRAY('assassination', 'eliminate_witness')),
('fake_documents', 'Valse Documenten', 'FAKE_DOCS', 800, 1, 1.0, 100, JSON_ARRAY('smuggling'));

SELECT 'Migration complete: Added 9 new tools' AS status;
