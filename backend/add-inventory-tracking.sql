-- Add purchasedAt and condition columns to inventory
ALTER TABLE inventory 
ADD COLUMN purchasedAt DATETIME DEFAULT CURRENT_TIMESTAMP AFTER purchasePrice,
ADD COLUMN `condition` INT DEFAULT 100 AFTER purchasedAt;

-- Update existing records to have current timestamp
UPDATE inventory SET purchasedAt = createdAt WHERE purchasedAt IS NULL;
