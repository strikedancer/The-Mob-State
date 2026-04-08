INSERT INTO world_events (eventKey, params, playerId, createdAt) 
VALUES 
  ('player.registered', '{"username":"testuser"}', 1, NOW()),
  ('player.death', '{"username":"deadplayer","cause":"hunger"}', 2, NOW()),
  ('hospital.healed', '{"username":"hospitaltest","healthRestored":50}', 6, NOW());
