-- Fix existing training bonuses to new balanced values
-- Shooting Range: from max 0.4 (40%) to max 0.1 (10%)
-- Gym: from max 0.3 (30%) to max 0.08 (8%)

-- Recalculate shooting range bonuses
-- Formula: (sessionsCompleted / 100) * 0.1
UPDATE shooting_range_stats
SET accuracyBonus = ROUND((sessionsCompleted / 100) * 0.1, 4)
WHERE accuracyBonus > 0;

-- Recalculate gym bonuses
-- Formula: (sessionsCompleted / 100) * 0.08
UPDATE gym_stats
SET strengthBonus = ROUND((sessionsCompleted / 100) * 0.08, 4)
WHERE strengthBonus > 0;
