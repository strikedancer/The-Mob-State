# Phase 2: Events, Leaderboards & Rivalry - Implementation Plan

## Status
- **Phase 1**: ✅ COMPLETE (Leveling, Police Raids, District Upgrades)
- **Phase 2**: 📋 PLANNING
- **Start Date**: March 6, 2026

## Phase 2 Overview
Add competitive and event-based features to make the prostitution system more engaging and strategic.

## Features to Implement

### 1. VIP Events System
**Goal**: Special time-limited events that offer bonus rewards

#### Database Schema
```sql
-- VIP Events table
CREATE TABLE vip_events (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  event_type ENUM('celebrity_visit', 'bachelor_party', 'convention', 'festival') NOT NULL,
  country_code VARCHAR(2) NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  bonus_multiplier DECIMAL(3,2) DEFAULT 2.0, -- 2x earnings
  min_level_required INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Event participation tracking
CREATE TABLE event_participations (
  id INT PRIMARY KEY AUTO_INCREMENT,
  event_id INT NOT NULL,
  player_id INT NOT NULL,
  prostitute_id INT NOT NULL,
  earnings DECIMAL(10,2) DEFAULT 0,
  participated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES vip_events(id),
  FOREIGN KEY (player_id) REFERENCES players(id),
  FOREIGN KEY (prostitute_id) REFERENCES prostitutes(id)
);
```

#### Backend Implementation
- `vipEventService.ts`: 
  - `getActiveEvents(countryCode)` - Get events in specific country
  - `participateInEvent(playerId, prostituteId, eventId)` - Assign prostitute to event
  - `calculateEventEarnings(prostituteId, eventId)` - Calculate bonus earnings
  - `endEvent(eventId)` - Cleanup when event expires

- `routes/vipEvents.ts`:
  - `GET /vip-events/active/:countryCode` - List active events
  - `POST /vip-events/:id/participate` - Join event
  - `GET /vip-events/my-participations` - Player's active participations

#### Frontend Implementation
- Update `prostitution_screen.dart`:
  - Add "Events" tab showing active VIP events
  - Event cards with countdown timer, bonus multiplier, location
  - "Assign Prostitute" button for each event
  
- New widget: `vip_event_card.dart`:
  - Event title, description, countdown
  - Bonus multiplier badge (e.g., "2.5x earnings")
  - Requirements (min level, location)
  - Visual: gold/purple premium styling

#### Event Types
1. **Celebrity Visit**: 3x multiplier, 4 hours, level 5+ required
2. **Bachelor Party**: 2x multiplier, 2 hours, any level
3. **Convention**: 2.5x multiplier, 8 hours, level 3+, VIP district only
4. **Festival**: 2x multiplier, 12 hours, any level

---

### 2. Leaderboards
**Goal**: Competition and prestige tracking

#### Database Schema
```sql
-- Weekly/monthly leaderboard snapshots
CREATE TABLE prostitution_leaderboards (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  period ENUM('weekly', 'monthly', 'all_time') NOT NULL,
  period_start DATE NOT NULL,
  total_earnings DECIMAL(12,2) DEFAULT 0,
  total_prostitutes INT DEFAULT 0,
  total_districts INT DEFAULT 0,
  highest_level INT DEFAULT 1,
  rank_position INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id),
  UNIQUE KEY unique_player_period (player_id, period, period_start)
);

-- Achievement tracking
CREATE TABLE prostitution_achievements (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  achievement_type VARCHAR(50) NOT NULL,
  achievement_data JSON,
  unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id)
);
```

#### Backend Implementation
- `leaderboardService.ts`:
  - `updatePlayerStats(playerId)` - Update leaderboard entry
  - `getLeaderboard(period, limit)` - Get top players
  - `getPlayerRank(playerId, period)` - Get specific player ranking
  - `calculateWeeklyReset()` - Cron job for weekly leaderboard
  - `checkAchievements(playerId)` - Check if player unlocked achievements

- `routes/leaderboards.ts`:
  - `GET /leaderboards/:period` - Get leaderboard (weekly/monthly/all-time)
  - `GET /leaderboards/my-rank/:period` - Get current player rank
  - `GET /leaderboards/achievements` - Get player achievements

#### Frontend Implementation
- New screen: `prostitution_leaderboard_screen.dart`:
  - Tab bar: Weekly / Monthly / All-Time
  - ListView with player cards showing:
    - Rank position (#1, #2, #3 with medals)
    - Username
    - Total earnings
    - Number of prostitutes/districts
  - Highlight current player's position
  - "Your Rank" sticky header at top

- Leaderboard display on `prostitution_screen.dart`:
  - Small "View Leaderboard" button in stats card
  - Badge showing current rank (e.g., "#12")

#### Achievements
1. **First Steps**: Recruit first prostitute
2. **Empire Builder**: Own 5 districts
3. **Leveling Master**: Max level prostitute (level 10)
4. **Untouchable**: Never busted for 7 days
5. **Millionaire**: Earn €1,000,000 total
6. **VIP Service**: Complete 10 VIP events
7. **Security Expert**: Max security on all districts

---

### 3. Rivalry Mechanics
**Goal**: Player vs player competition and sabotage

#### Database Schema
```sql
-- Rivalry relationships
CREATE TABLE prostitution_rivalries (
  id INT PRIMARY KEY AUTO_INCREMENT,
  player_id INT NOT NULL,
  rival_player_id INT NOT NULL,
  rivalry_score INT DEFAULT 0, -- Accumulated sabotage points
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_attack_at TIMESTAMP,
  FOREIGN KEY (player_id) REFERENCES players(id),
  FOREIGN KEY (rival_player_id) REFERENCES players(id),
  UNIQUE KEY unique_rivalry (player_id, rival_player_id)
);

-- Sabotage actions
CREATE TABLE sabotage_actions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  attacker_id INT NOT NULL,
  victim_id INT NOT NULL,
  action_type ENUM('tip_police', 'steal_customer', 'damage_reputation', 'bribe_employee') NOT NULL,
  success BOOLEAN DEFAULT FALSE,
  cost DECIMAL(10,2) NOT NULL,
  impact_description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (attacker_id) REFERENCES players(id),
  FOREIGN KEY (victim_id) REFERENCES players(id)
);
```

#### Backend Implementation
- `rivalryService.ts`:
  - `getActiveRivals(playerId)` - Get player's rivals
  - `executeSabotage(attackerId, victimId, actionType)` - Perform sabotage
  - `calculateSabotageSuccess(attacker, victim, actionType)` - Success chance
  - `applyRivalryEffects()` - Apply ongoing rivalry penalties

- Sabotage Actions:
  1. **Tip Police** (€5k): Increases raid chance for rival's districts by +20% for 24h
  2. **Steal Customer** (€3k): Reduces rival's earnings by 15% for 12h
  3. **Damage Reputation** (€10k): All rival's prostitutes lose 10% level bonus for 24h
  4. **Bribe Employee** (€8k): One random prostitute from rival becomes busted for 2h

- `routes/rivalries.ts`:
  - `GET /rivalries/active` - Get active rivalries
  - `POST /rivalries/sabotage` - Execute sabotage action
  - `GET /rivalries/history` - Sabotage history
  - `POST /rivalries/start` - Challenge another player

#### Frontend Implementation
- New screen: `prostitution_rivalry_screen.dart`:
  - List of active rivals with scores
  - "Challenge Player" button to start rivalry
  - 4 sabotage action cards with costs and effects
  - Confirmation dialog with risk/reward info
  - Recent sabotage activity feed

- Rivalry notifications:
  - Push notification when sabotaged
  - Alert banner on prostitution_screen when under attack

#### Balance Mechanics
- Cooldown: 4 hours between sabotage actions
- Defense: Higher security levels reduce sabotage success (10% per level)
- Retaliation: Victim gets 50% cost discount on counter-sabotage
- Protection: Can buy "Protection Insurance" (€25k/week) for 30% damage reduction

---

## Implementation Order

### Week 1: VIP Events
1. Database migrations for events tables (Day 1)
2. Backend service and routes (Day 2-3)
3. Frontend event cards and participation (Day 4-5)
4. Testing and balance tuning (Day 6-7)

### Week 2: Leaderboards
1. Database migrations for leaderboard tables (Day 1)
2. Backend leaderboard calculation and cron jobs (Day 2-3)
3. Frontend leaderboard screen (Day 4-5)
4. Achievement system (Day 6-7)

### Week 3: Rivalry System
1. Database migrations for rivalry tables (Day 1)
2. Backend sabotage mechanics (Day 2-4)
3. Frontend rivalry screen and actions (Day 5-6)
4. Testing and balance (Day 7)

---

## Technical Considerations

### Cron Jobs Needed
- `checkExpiredEvents()` - Every 5 minutes, end expired events
- `updateLeaderboards()` - Daily at midnight, calculate rankings
- `resetWeeklyLeaderboard()` - Monday at 00:00, archive and reset
- `cleanupOldRivalries()` - Weekly, remove inactive rivalries (30+ days)

### Redis Cache Strategy
- Cache active events: `vip_events:active:{countryCode}` (5 min TTL)
- Cache leaderboards: `leaderboard:{period}` (15 min TTL)
- Cache player rank: `leaderboard:rank:{playerId}:{period}` (15 min TTL)

### Push Notifications
- Event starts in your country: "VIP Event: Celebrity Visit started in Amsterdam! 3x earnings!"
- Rival sabotaged you: "⚠️ Your district was sabotaged by {username}!"
- New leaderboard rank: "🏆 You're now #12 on the weekly leaderboard!"
- Achievement unlocked: "🎉 Achievement: Empire Builder unlocked!"

### UI/UX Enhancements
- Animated countdown timers for events
- Particle effects on leaderboard for top 3
- Shake animation when sabotaged
- Confetti effect on achievement unlock

---

## Localization Keys Needed

### VIP Events
- `vipEventTitle`: "VIP Events"
- `vipEventCelebrity`: "Celebrity Visit"
- `vipEventBachelor`: "Bachelor Party"
- `vipEventConvention`: "Convention"
- `vipEventFestival`: "Festival"
- `vipEventBonus`: "Bonus"
- `vipEventAssign`: "Assign Prostitute"
- `vipEventActive`: "Active Events"
- `vipEventEndsIn`: "Ends in"
- `vipEventRequires`: "Requires Level"

### Leaderboards
- `leaderboardTitle`: "Leaderboards"
- `leaderboardWeekly`: "Weekly"
- `leaderboardMonthly`: "Monthly"
- `leaderboardAllTime`: "All Time"
- `leaderboardYourRank`: "Your Rank"
- `leaderboardEarnings`: "Total Earnings"
- `leaderboardAchievements`: "Achievements"

### Rivalry
- `rivalryTitle`: "Rivalry"
- `rivalryChallengePlayer`: "Challenge Player"
- `rivalrySabotage`: "Sabotage"
- `rivalryTipPolice`: "Tip Police"
- `rivalryStealCustomer`: "Steal Customer"
- `rivalryDamageReputation`: "Damage Reputation"
- `rivalryBribeEmployee`: "Bribe Employee"
- `rivalrySuccess`: "Sabotage successful!"
- `rivalryFailed`: "Sabotage failed!"
- `rivalryUnderAttack`: "Under Attack!"

---

## Success Metrics
- [ ] 50%+ of players participate in at least 1 VIP event per week
- [ ] Leaderboard updated correctly every week
- [ ] At least 30% of active players have 1+ rivalry
- [ ] Average 3-5 sabotage actions per active rivalry per week
- [ ] No game-breaking exploits or balance issues

---

## Next Steps
1. Review and approve Phase 2 plan
2. Create database migration files
3. Start with VIP Events implementation
4. Test each feature before moving to next

