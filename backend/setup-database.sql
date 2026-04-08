-- MariaDB setup script voor Mafia Game
-- Run dit via phpMyAdmin of MySQL command line

-- Create database
CREATE DATABASE IF NOT EXISTS mafia_game CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (gebruik een sterker wachtwoord in productie!)
CREATE USER IF NOT EXISTS 'mafia_user'@'localhost' IDENTIFIED BY 'dev_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON mafia_game.* TO 'mafia_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Verify
SELECT User, Host FROM mysql.user WHERE User = 'mafia_user';
SHOW DATABASES LIKE 'mafia_game';
