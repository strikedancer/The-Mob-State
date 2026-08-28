/**
 * 50 monthly Season Pass / event milestone goals — category-specific targets with escalating rewards.
 * Free track = event prize; premium track = Season Pass bonus (requires €7.99 unlock).
 */

export type SeasonPassGoalCategory =
  | 'crime'
  | 'vehicles'
  | 'smuggling'
  | 'drugs'
  | 'money'
  | 'xp';

export type SeasonPassLevelDef = {
  level: number;
  goalCategory: SeasonPassGoalCategory;
  goalTarget: number;
  free: Record<string, unknown>;
  premium: Record<string, unknown>;
};

const CATEGORY_ORDER: SeasonPassGoalCategory[] = [
  'crime',
  'vehicles',
  'smuggling',
  'drugs',
  'money',
  'xp',
];

/** Per-category ascending targets (9 for crime/vehicles, 8 for the rest → 50 goals total). */
const CATEGORY_TARGETS: Record<SeasonPassGoalCategory, number[]> = {
  crime: [3, 8, 15, 25, 40, 60, 90, 130, 180],
  vehicles: [1, 3, 6, 10, 16, 25, 38, 55, 75],
  smuggling: [10, 30, 60, 120, 200, 350, 550, 800],
  drugs: [10, 30, 70, 140, 250, 450, 750, 1200],
  money: [10_000, 30_000, 75_000, 150_000, 300_000, 500_000, 800_000, 1_200_000],
  xp: [100, 300, 700, 1_500, 3_000, 5_500, 9_000, 14_000],
};

/** Non-VIP weapons for premium track — each used at most once per season ladder. */
const PREMIUM_WEAPON_SCHEDULE: Array<{ level: number; weaponId: string; ammo?: { ammoType: string; quantity: number } }> = [
  { level: 7, weaponId: 'knife', ammo: { ammoType: '9mm', quantity: 30 } },
  { level: 13, weaponId: 'molotov' },
  { level: 19, weaponId: 'handgun_9mm', ammo: { ammoType: '9mm', quantity: 60 } },
  { level: 25, weaponId: 'handgun_heavy', ammo: { ammoType: '45acp', quantity: 40 } },
  { level: 31, weaponId: 'smg_compact', ammo: { ammoType: '9mm', quantity: 90 } },
  { level: 37, weaponId: 'shotgun_pump', ammo: { ammoType: '12gauge', quantity: 40 } },
  { level: 43, weaponId: 'smg_suppressed', ammo: { ammoType: '9mm', quantity: 100 } },
  { level: 47, weaponId: 'shotgun_tactical', ammo: { ammoType: '12gauge', quantity: 50 } },
];

const PREMIUM_TOOL_SCHEDULE: Array<{ level: number; toolId: string }> = [
  { level: 10, toolId: 'bolt_cutter' },
  { level: 20, toolId: 'crowbar' },
  { level: 30, toolId: 'car_theft_tools' },
  { level: 40, toolId: 'hacking_laptop' },
];

const PREMIUM_AMMO_ROTATION = ['9mm', '45acp', '12gauge', '762mm', '556mm', '308'] as const;

function premiumWeaponGrant(level: number): Record<string, unknown> | null {
  const entry = PREMIUM_WEAPON_SCHEDULE.find((w) => w.level === level);
  if (!entry) return null;
  const grant: Record<string, unknown> = {
    weapons: [{ weaponId: entry.weaponId, condition: 100 }],
  };
  if (entry.ammo) {
    grant.ammo = [entry.ammo];
  }
  return grant;
}

function premiumToolGrant(level: number): Record<string, unknown> | null {
  const entry = PREMIUM_TOOL_SCHEDULE.find((t) => t.level === level);
  if (!entry) return null;
  return { tools: [{ toolId: entry.toolId, quantity: 1 }] };
}

function freeReward(level: number, category: SeasonPassGoalCategory): Record<string, unknown> {
  const cash = Math.floor(1_500 + level * 800 + (category === 'money' ? 2_000 : 0));
  if (level % 10 === 0) {
    return {
      cash: cash * 3,
      items: [{ itemKey: level >= 40 ? 'event_chip_gold' : level >= 20 ? 'event_chip_silver' : 'event_chip_bronze', quantity: 1 }],
      xp: 50 + level * 5,
    };
  }
  if (level % 5 === 0) {
    return {
      cash,
      ammo: [{ ammoType: level >= 25 ? '45acp' : '9mm', quantity: 20 + level }],
      xp: 25 + level * 2,
    };
  }
  if (category === 'vehicles' || category === 'crime') {
    return {
      cash,
      vehicleParts: { car: 1 + Math.floor(level / 8), motorcycle: level >= 20 ? 1 : 0 },
    };
  }
  if (category === 'drugs' || category === 'smuggling') {
    return { cash, ammo: [{ ammoType: '9mm', quantity: 15 + Math.floor(level / 3) }] };
  }
  return { cash, xp: 15 + Math.floor(level / 2) };
}

function premiumReward(level: number, category: SeasonPassGoalCategory): Record<string, unknown> {
  const cash = Math.floor((2_500 + level * 1_400) * (category === 'money' ? 1.4 : 1));
  const credits = level % 5 === 0 ? Math.min(25, 2 + Math.floor(level / 5)) : 0;

  if (level === 50) {
    return {
      cash: 100_000,
      vehicles: [
        {
          vehicleId: 'moto_kawasaki_ninja_zx_10r_track_2',
          condition: 90,
          fuel: 60,
          cashFallback: 45_000,
        },
      ],
      weapons: [{ weaponId: 'assault_rifle', condition: 100 }],
      ammo: [{ ammoType: '762mm', quantity: 120 }],
      items: [{ itemKey: 'event_badge_rival', quantity: 1 }],
      premiumCredits: 25,
    };
  }

  const weaponGrant = premiumWeaponGrant(level);
  if (weaponGrant) {
    return {
      cash,
      premiumCredits: credits || 3,
      ...weaponGrant,
    };
  }

  const toolGrant = premiumToolGrant(level);
  if (toolGrant) {
    return {
      cash: cash * 2,
      premiumCredits: credits || 5,
      items: [
        {
          itemKey: level >= 30 ? 'event_chip_gold' : 'event_chip_silver',
          quantity: 1,
        },
      ],
      ...toolGrant,
    };
  }

  if (level % 10 === 0) {
    return {
      cash: cash * 2,
      premiumCredits: credits || 5,
      items: [
        {
          itemKey: level >= 30 ? 'event_chip_gold' : 'event_chip_silver',
          quantity: 1,
        },
      ],
      ammo: [
        {
          ammoType: PREMIUM_AMMO_ROTATION[(level / 10 - 1) % PREMIUM_AMMO_ROTATION.length],
          quantity: 35 + level,
        },
      ],
    };
  }

  if (category === 'vehicles') {
    return {
      cash,
      vehicleParts: {
        car: 3 + Math.floor(level / 6),
        motorcycle: 2,
        boat: level >= 30 ? 1 : 0,
      },
      premiumCredits: credits || 2,
    };
  }

  if (category === 'crime' || category === 'smuggling') {
    return {
      cash,
      ammo: [
        {
          ammoType: PREMIUM_AMMO_ROTATION[(level - 1) % PREMIUM_AMMO_ROTATION.length],
          quantity: 20 + level,
        },
      ],
      premiumCredits: credits || 2,
    };
  }

  return {
    cash,
    xp: 20 + Math.floor(level / 2),
    premiumCredits: credits || 2,
  };
}

function buildLevels(): SeasonPassLevelDef[] {
  const indices: Record<SeasonPassGoalCategory, number> = {
    crime: 0,
    vehicles: 0,
    smuggling: 0,
    drugs: 0,
    money: 0,
    xp: 0,
  };
  const levels: SeasonPassLevelDef[] = [];

  for (let level = 1; level <= 50; level++) {
    const goalCategory = CATEGORY_ORDER[(level - 1) % CATEGORY_ORDER.length];
    const idx = indices[goalCategory];
    const targets = CATEGORY_TARGETS[goalCategory];
    if (idx >= targets.length) continue;
    const goalTarget = targets[idx];
    indices[goalCategory] = idx + 1;

    levels.push({
      level,
      goalCategory,
      goalTarget,
      free: freeReward(level, goalCategory),
      premium: premiumReward(level, goalCategory),
    });
  }

  return levels;
}

export const SEASON_PASS_LEVELS: SeasonPassLevelDef[] = buildLevels();
