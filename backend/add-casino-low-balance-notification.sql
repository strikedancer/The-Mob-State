-- Add lastLowBalanceNotification field to CasinoOwnership table
-- This tracks when the owner was last notified about low casino balance

ALTER TABLE `casino_ownerships` 
ADD COLUMN `lastLowBalanceNotification` DATETIME NULL AFTER `totalPaidOut`;

-- Update existing records to NULL (they haven't been notified yet)
-- No action needed as NULL is the default for new columns

SELECT 'Migration complete: Added lastLowBalanceNotification to casino_ownerships' AS status;
