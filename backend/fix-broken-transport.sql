-- Fix broken transport records (NULL transportDestination)
UPDATE VehicleInventory 
SET 
  transportStatus = NULL,
  transportArrivalTime = NULL,
  transportDestination = NULL,
  transportMethod = NULL
WHERE transportDestination IS NULL 
  AND (transportStatus IS NOT NULL OR transportArrivalTime IS NOT NULL);
