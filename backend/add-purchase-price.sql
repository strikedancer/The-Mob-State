-- Add purchasePrice to inventory table
ALTER TABLE inventory 
ADD COLUMN purchasePrice INT NOT NULL DEFAULT 0 COMMENT 'Average purchase price per unit';
