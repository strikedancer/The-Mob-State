-- Phase 3: Housing upkeep for prostitutes
ALTER TABLE prostitutes
  ADD COLUMN housingTier INT NOT NULL DEFAULT 1 AFTER bustedUntil,
  ADD COLUMN housingRentPerDay INT NOT NULL DEFAULT 35 AFTER housingTier,
  ADD COLUMN housingPaidUntil DATETIME NULL AFTER housingRentPerDay,
  ADD COLUMN lastWorkedAt DATETIME NULL AFTER housingPaidUntil;

UPDATE prostitutes
SET
  housingTier = CASE WHEN variant BETWEEN 6 AND 10 THEN 2 ELSE 1 END,
  housingRentPerDay = CASE WHEN variant BETWEEN 6 AND 10 THEN 60 ELSE 35 END,
  housingPaidUntil = DATE_ADD(COALESCE(lastEarningsAt, NOW()), INTERVAL 7 DAY),
  lastWorkedAt = COALESCE(lastEarningsAt, recruitedAt, NOW())
WHERE housingPaidUntil IS NULL OR lastWorkedAt IS NULL;

CREATE INDEX idx_prostitutes_housing_paid_until ON prostitutes(housingPaidUntil);
CREATE INDEX idx_prostitutes_last_worked_at ON prostitutes(lastWorkedAt);

SELECT 'Phase 3 housing columns added successfully!' AS message;
