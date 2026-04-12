# Crew Building System - VIP Level Expansion

## Overview
The crew building system now supports 15 levels per building type:
- **Levels 0-9**: Standard levels (all crews)
- **Levels 10-14**: VIP-exclusive levels (crew VIP required)

This provides 50% more progression depth and exclusive endgame content for VIP crews.

## VIP Levels Explained

### What is Crew VIP?
- **Type**: Per-crew subscription status (separate from player VIP)
- **Duration**: Time-limited activation with optional auto-renewal
- **Benefits**: Unlock levels 10-14 on all buildings
- **Cost**: TBD (to be determined by game balance)

### VIP Status Field
Located in crew database:
```sql
crews.isVip (boolean) - Currently active VIP status
crews.vipExpiresAt (datetime) - Expiration timestamp
```

### VIP Check Function
The system automatically checks crew VIP status on every upgrade:
```typescript
async function isCrewVip(crewId: number): Promise<boolean> {
  const crew = await prisma.crew.findUnique({ ... });
  return hasActiveVip(crew.isVip, crew.vipExpiresAt);
}
```

## Level 10-14 Specifications

### Capacity Multipliers
Each VIP level continues the progression from level 9:

**Car Storage (Standard Progression)**
```
Level 9: 115 capacity
Level 10 (VIP): 145 capacity (~1.26x)
Level 11 (VIP): 180 capacity
Level 12 (VIP): 220 capacity
Level 13 (VIP): 265 capacity
Level 14 (VIP): 315 capacity
```

**Cash Storage (Highest Progression)**
```
Level 9: 2,200,000,000 capacity
Level 10 (VIP): 4,000,000,000 capacity (~1.82x)
Level 11 (VIP): 7,000,000,000 capacity
Level 12 (VIP): 12,000,000,000 capacity
Level 13 (VIP): 20,000,000,000 capacity
Level 14 (VIP): 35,000,000,000 capacity
```

### Upgrade Costs
VIP level upgrades scale exponentially to reflect their exclusive nature:

**Car Storage VIP Costs**
```
Level 10: €250,000,000 (250M)
Level 11: €450,000,000 (450M)
Level 12: €800,000,000 (800M)
Level 13: €1,400,000,000 (1.4B)
Level 14: €2,400,000,000 (2.4B)
Total for all VIP levels: €5,900,000,000 (5.9B)
```

**Difficulty Comparison**
```
Standard Levels (0-9): ~770M total cost
VIP Levels (10-14): ~5.9B total cost
Ratio: VIP is ~7.6x more expensive than standard progression
```

## How VIP Levels Are Gated

### Database Checking
```typescript
const levelDef = getLevelDefinition(type, nextLevel);
if (levelDef.requiresVip && !crewVip) {
  throw new Error('BUILDING_VIP_REQUIRED');
}
```

### Configuration Flag
In `crewBuildings.json`, VIP levels are marked:
```json
{
  "level": 10,
  "upgradeCost": 250000000,
  "capacity": 145,
  "requiresVip": true
}
```

### Error Handling
When non-VIP crew attempts VIP level upgrade:
- Error Code: `BUILDING_VIP_REQUIRED`
- Message: "Crew VIP required to upgrade this building beyond level 9"
- User sees disabled upgrade button with explanation

## Frontend Display

### VIP Badge
Buildings show VIP status badge when crew is VIP:
```
Building Name [VIP]
```

Badge styling:
- Background: Purple
- Label: "VIP"
- Display logic:
  - Shows if crew has active VIP status
  - Conditional on maxLevel > 9

### Building Card Status
```
Current Level: 9/15  [VIP Badge]
Capacity: 115
Next upgrade cost: €250,000,000 (Level 10)
```

### Disabled State
If crew isn't VIP and tries to upgrade past level 9:
```
Current Level: 9/15
Capacity: 115
[Button disabled] - "Crew VIP required for level 10"
```

## Purchasing VIP Status

### Backend Endpoint (TBD)
```
POST /crews/{id}/vip/purchase
{
  "durationDays": 30  // Duration options: 7, 30, 90, 365
}
```

### Response on Success
```json
{
  "event": "crew.vip_purchased",
  "params": {
    "crew": {
      "id": 1,
      "isVip": true,
      "vipExpiresAt": "2026-04-19T...",
      "bankBalance": -250000000
    }
  }
}
```

### Cost Calculation
- 7 days: €25,000,000 (cost/day: 3.57M)
- 30 days: €75,000,000 (cost/day: 2.5M, 30% discount)
- 90 days: €180,000,000 (cost/day: 2M, 44% discount)
- 365 days: €500,000,000 (cost/day: 1.37M, 62% discount)

## VIP Expiration Handling

### Auto-Check on Every Action
```typescript
const isActiveVip = hasActiveVip(crew.isVip, crew.vipExpiresAt);
// Checks: crew.isVip && (crew.vipExpiresAt === null || crew.vipExpiresAt > now)
```

### Grace Period (Optional)
- Could implement 24-hour grace period after expiration
- Prevents mid-level loss if subscription lapses for a day
- Currently: No grace period (strict cutoff at expiration time)

### What Happens on Expiration
1. User attempts to upgrade building level 10 → level 11
2. System checks: `vipExpiresAt < Date.now()` → `isVip = false`
3. Upgrade blocked with error: `BUILDING_VIP_REQUIRED`
4. User sees notification: "Your crew VIP has expired. Renew to continue upgrading buildings."

## Database Migration

Migration file: `prisma/migrations/add_crew_vip_status/migration.sql`

```sql
ALTER TABLE crews ADD COLUMN isVip BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE crews ADD COLUMN vipExpiresAt DATETIME;
```

### Run Migration
```bash
cd backend
npx prisma migrate deploy
```

## Balancing Considerations

### Why VIP Levels?
1. **Revenue**: Provides monetizable feature
2. **Progression**: Extends endgame content
3. **Prestige**: Marks established crews
4. **Balance**: High cost discourages casual purchases

### Cost Curve Analysis
```
Standard (Level 0-9): 770M total
Level 10: 250M (3.6x last standard level)
Per VIP level avg: 1.18B (steep but achievable)
```

## Future Enhancements

### Potential Features
- [ ] VIP auto-renewal system
- [ ] VIP gifting between crews
- [ ] Limited-time VIP sales/discounts
- [ ] VIP-exclusive buildings (beyond just levels)
- [ ] Crew prestige tiers (based on VIP days purchased)
- [ ] VIP percentage bonuses (e.g., +5% storage capacity)

### Advanced Ideas
- Crew VIP synergy with player VIP bonuses
- VIP crew can earn player VIP for members
- VIP crews get access to exclusive heists/missions

## Troubleshooting

### Issue: VIP crew can't upgrade past level 9
**Solution**: Check `isVip` and `vipExpiresAt` fields in database
```sql
SELECT id, name, isVip, vipExpiresAt FROM crews WHERE id = X;
```

### Issue: Expired VIP crew still accessing level 10+
**Solution**: Frontend cache issue - reload page, or check `vipExpiresAt` is in past

### Issue: "BUILDING_VIP_REQUIRED" error appears in normal upgrade
**Solution**: Verify level being upgraded to in request body matches config in `crewBuildings.json`

## Testing Checklist

- [ ] Non-VIP crew cannot upgrade past level 9
- [ ] VIP crew can upgrade to level 10
- [ ] VIP crew can upgrade through level 14
- [ ] Expired VIP crew cannot upgrade past level 9
- [ ] VIP badge displays on building cards for VIP crews
- [ ] Upgrade cost displays correctly (250M for level 10, etc)
- [ ] Error message explains VIP requirement
- [ ] No database errors on VIP status checks
- [ ] Capacity values are correct per level
