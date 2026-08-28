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
      weapons: [{ weaponId: 'handgun_heavy', condition: 100 }],
      items: [{ itemKey: 'event_badge_rival', quantity: 1 }],
      premiumCredits: 25,
    };
  }
  if (level % 10 === 0) {
    return {
      cash: cash * 2,
      tools: [{ toolId: level >= 30 ? 'hacking_laptop' : 'car_theft_tools', quantity: 1 }],
      premiumCredits: credits || 5,
      items: [{ itemKey: level >= 30 ? 'event_chip_gold' : 'event_chip_silver', quantity: 1 }],
    };
  }
  if (level % 7 === 0) {
    return {
      cash,
      weapons: [{ weaponId: level >= 35 ? 'handgun_9mm' : 'knife', condition: 100 }],
      ammo: [{ ammoType: '9mm', quantity: 40 + level }],
      premiumCredits: credits || 3,
    };
  }
  if (category === 'vehicles') {
    return {
      cash,
      vehicleParts: { car: 3 + Math.floor(level / 6), motorcycle: 2, boat: level >= 30 ? 1 : 0 },
      premiumCredits: credits || 2,
    };
  }
  return {
    cash,
    ammo: [{ ammoType: level >= 25 ? '12gauge' : '45acp', quantity: 25 + level }],
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
