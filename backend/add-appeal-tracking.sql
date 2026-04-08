-- Add appeal tracking to crime_attempts table
ALTER TABLE crime_attempts ADD COLUMN appealedAt DATETIME NULL AFTER vehicleId;
