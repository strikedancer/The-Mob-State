-- Update bestaande spelers naar Nederlands
UPDATE players SET preferredLanguage = 'nl' WHERE preferredLanguage = 'en' OR preferredLanguage IS NULL;

-- Controleer resultaat
SELECT id, username, preferredLanguage FROM players;
