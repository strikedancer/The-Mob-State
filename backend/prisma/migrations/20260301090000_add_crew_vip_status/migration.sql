-- Add VIP status fields to crews table
ALTER TABLE crews ADD COLUMN isVip BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE crews ADD COLUMN vipExpiresAt DATETIME;
