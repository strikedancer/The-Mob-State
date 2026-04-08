# Crew Building System - HQ Progression Linking

## Overview
The crew building system now includes intelligent level gating based on HQ style and level. This ensures a balanced progression where upgraded HQ unlocks higher building levels, encouraging crews to upgrade their headquarters.

## HQ Style Progression

Each HQ style provides a base max level for all side buildings:

### Camping (Base HQ)
- **Base Max Level**: 3
- **HQ Levels**: 0-3
- **Total Unlocked**: Levels 0-3 (4 levels)

### Rural (HQ Style 1)
- **Base Max Level**: 6
- **HQ Levels**: 0-3
- **Total Unlocked**: Levels 0-6 (7 levels)

### City (HQ Style 2)
- **Base Max Level**: 9
- **HQ Levels**: 0-3
- **Total Unlocked**: Levels 0-9 (10 levels, max without VIP)

### Villa (HQ Style 3)
- **Base Max Level**: 12
- **HQ Levels**: 0-3
- **Total Unlocked**: Levels 0-12 (13 levels, requires VIP for 10-12)

### VIP (HQ Style 4, VIP-Exclusive)
- **Base Max Level**: 15
- **HQ Levels**: 0-3
- **Total Unlocked**: Levels 0-15 (16 levels, all VIP-exclusive for 10-15)
- **Requirement**: Crew must have active VIP status

## Level Gating Logic

### Effective Max Level Calculation
```
effectiveMaxLevel = baseMaxByStyle + (hqLevel × 0.3)
```

**Example Progression:**
```
Camping HQ Level 0: Max side building level = 3
Camping HQ Level 1: Max side building level = 3.3 → 3 (rounded down)
Camping HQ Level 3: Max side building level = 3.9 → 3 (rounded down)

Rural HQ Level 0: Max side building level = 6
Rural HQ Level 1: Max side building level = 6.3 → 6
Rural HQ Level 3: Max side building level = 6.9 → 6

City HQ Level 3: Max side building level = 9.9 → 9
Villa HQ Level 3: Max side building level = 12.9 → 12
```

## VIP Gating

### VIP-Exclusive Levels (10-14)
- **Camping**: Levels 0-9 only (cannot reach 10+)
- **Rural**: Levels 0-9 only (VIP opens to max 12)
- **City**: Levels 0-9 without VIP (VIP unlocks 10 per style rule)
- **Villa**: Levels 0-12 without VIP (VIP opens to max 12)
- **VIP Style**: Levels 0-15 with VIP only (10-15 are VIP-exclusive)

### VIP Requirement Notes
- Levels 10-14 require **crew VIP status**
- Player-level VIP is separate (for individual features)
- Crew VIP can be purchased/gifted as a time-limited subscription
- VIP status displayed on building cards as a badge

## Upgrade Prevention Rules

The system prevents upgrades when:

1. **HQ Level Too Low**
   - Error: `HQ_LEVEL_TOO_LOW`
   - Message: "Your HQ level is too low for this building upgrade"

2. **Building VIP Required** (for Buildings levels 10+)
   - Error: `BUILDING_VIP_REQUIRED`
   - Message: "Crew VIP required to upgrade this building beyond level 9"

3. **HQ VIP Style Required** (for VIP-style HQ)
   - Error: `HQ_VIP_REQUIRED`
   - Message: "Crew VIP required to upgrade to VIP HQ style"

4. **Building at Max Level**
   - Error: `BUILDING_MAX_LEVEL`
   - Message: "This building is at maximum level"

## Frontend Display

### Crew Screen Building Tabs
- Each building shows max level based on current HQ
- VIP badge displays if crew has VIP status
- Disabled upgrade buttons show reason (if applicable)
- Tooltip text displays HQ requirement

### Building Card Information
```
Building Name [VIP Badge if applicable]
────────────────────────────────────────
Current Level: X / MaxLevel
Capacity: Y
────────────────────────────────────────
[Upgrade (€cost)] or [Disabled: HQ too low]
```

## Implementation Details

### Backend (crewBuildingService.ts)

**Function: getCrewBuildingStatus()**
- Calculates allowed building levels per HQ style
- Includes `allowedLevelByHq` in building status
- Returns whether crew has VIP status

**Function: upgradeCrewBuilding()**
- Validates against allowed level before upgrade
- Throws specific errors for VIP/HQ requirements
- Prevents progression beyond HQ-unlocked levels

**Function: getAllowedBuildingLevel()**
- Primary calculation function
- Maps HQ styles → base max levels
- Applies HQ level bonus
- Applies VIP restrictions

### Frontend (crew_screen.dart)

**Building Card Rendering**
- Displays `allowedLevelByHq` as warning if exceeded
- Shows VIP badge from `crewVip` status
- Disables upgrade buttons with appropriate messages

## Progression Strategy for Players

### Optimal Path (Without VIP)
```
1. Camping HQ (Levels 0-3) → Car Storage up to level 3
2. Rural HQ (Levels 0-3) → Car Storage up to level 6
3. City HQ (Levels 0-3) → Car Storage up to level 9 (max standard)
```

### VIP Upgrade Path
```
1. Reach City HQ Level 3
2. Purchase Crew VIP
3. Upgrade to Villa HQ → Car Storage can reach level 12
4. Eventually: VIP HQ → Car Storage can reach level 15
```

## Cost Considerations

Upgrading HQ is expensive, so players must balance:
- HQ upgrade costs vs. building unlocks they need
- Whether to upgrade buildings or HQ first
- VIP value vs. regular progression

## Configuration

All values are defined in `backend/content/crewBuildings.json`:
- Building upgrade costs per level
- Building capacities per level
- HQ member caps per level
- HQ style definitions

See `crewBuildings.json` for current values.

## Testing Checklist

- [ ] Camping HQ allows buildings up to level 3
- [ ] Rural HQ allows buildings up to level 6
- [ ] City HQ allows buildings up to level 9
- [ ] Villa HQ allows buildings up to level 12
- [ ] VIP HQ allows buildings up to level 15
- [ ] VIP crew without VIP style HQ can reach level 9 max
- [ ] Non-VIP crews cannot upgrade buildings beyond level 9
- [ ] Error messages display correctly in UI
- [ ] VIP badge appears on crew card when active
- [ ] Building tips show HQ requirement when applicable
