-- Add notification settings to players table
ALTER TABLE players 
ADD COLUMN notifyFriendRequest BOOLEAN DEFAULT TRUE,
ADD COLUMN notifyFriendAccepted BOOLEAN DEFAULT TRUE,
ADD COLUMN emailFriendRequest BOOLEAN DEFAULT TRUE,
ADD COLUMN emailFriendAccepted BOOLEAN DEFAULT TRUE;
