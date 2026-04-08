-- Fix vehicle_inventory table - add missing transport columns

-- Check if transportStatus column exists, if not add it
ALTER TABLE vehicle_inventory 
ADD COLUMN IF NOT EXISTS transportStatus VARCHAR(20) NULL;

-- Check if transportArrivalTime column exists, if not add it
ALTER TABLE vehicle_inventory 
ADD COLUMN IF NOT EXISTS transportArrivalTime DATETIME NULL;

-- Check if transportDestination column exists, if not add it
ALTER TABLE vehicle_inventory 
ADD COLUMN IF NOT EXISTS transportDestination VARCHAR(50) NULL;

SELECT 'Vehicle inventory table updated successfully' AS status;
