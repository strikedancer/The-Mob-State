import { ui, countryName, COUNTRY } from './i18n.mjs';

export const COUNTRY_CANON = {
  united_kingdom: 'uk',
  uk: 'uk',
};

const EXTRA_ALIASES = {
  netherlands: ['holland', 'nederland'],
  belgium: ['belgie'],
  germany: ['duitsland', 'deutschland'],
  france: ['frankrijk'],
  spain: ['spanje'],
  italy: ['italie'],
  uk: ['engeland', 'britain', 'united kingdom', 'verenigd koninkrijk'],
  united_kingdom: ['engeland', 'britain', 'united kingdom', 'verenigd koninkrijk'],
  switzerland: ['zwitserland', 'schweiz'],
  usa: ['amerika', 'america', 'united states', 'verenigde staten'],
  mexico: ['mexico'],
  colombia: ['colombia'],
  brazil: ['brazilië', 'brasil'],
  argentina: ['argentinie', 'argentina'],
  japan: ['nippon'],
  china: [],
  russia: ['rusland'],
  turkey: ['turkije'],
  united_arab_emirates: ['emiraten', 'dubai'],
  south_africa: ['zuid-afrika', 'zuid afrika'],
  australia: ['australie'],
  austria: ['oostenrijk'],
  monaco: ['monaco'],
};

const RANK_BANDS = [
  [1, 1, 'rankEmptySuit'],
  [2, 2, 'rankDeliveryBoy'],
  [3, 4, 'rankPicciotto'],
  [5, 6, 'rankShoplifter'],
  [7, 9, 'rankPickpocket'],
  [10, 14, 'rankThief'],
  [15, 19, 'rankAssociate'],
  [20, 24, 'rankCadet'],
  [25, 29, 'rankSoldier'],
  [30, 34, 'rankSwindler'],
  [35, 39, 'rankAssassin'],
  [40, 44, 'rankLocalChief'],
  [45, 49, 'rankChief'],
  [50, 59, 'rankDrugLord'],
  [60, 74, 'rankGodfather'],
  [75, 89, 'rankDon'],
  [90, 119, 'rankOverlord'],
  [120, 150, 'rankLegend'],
];

function uniqueNames(values) {
  const seen = new Set();
  const out = [];
  for (const raw of values) {
    const n = String(raw || '').trim();
    if (!n) continue;
    const key = n
      .toLowerCase()
      .normalize('NFD')
      .replace(/\p{M}/gu, '');
    if (seen.has(key)) continue;
    seen.add(key);
    out.push(n);
  }
  return out;
}

function nameOf(item, lang) {
  if (lang === 'nl') return item.displayName || item.name || item.id;
  return item.name_en || item.nameEn || item.displayName || item.name || item.id;
}

function allItemNames(item) {
  return uniqueNames([
    item.displayName,
    item.name,
    item.name_en,
    item.nameEn,
    String(item.id || '').replace(/_/g, ' '),
  ]);
}

function aliasesFor(id) {
  const row = COUNTRY[id] || {};
  return uniqueNames([...(EXTRA_ALIASES[id] || []), ...Object.values(row)]).filter(
    (n) => n.replace(/[\s-]/g, '').length >= 4
  );
}

function tagVehicles(data, lang) {
  const tag = (list, kind) =>
    (list || []).map((v) => {
      const countries = (v.availableInCountries || []).map((id) => String(id).toLowerCase());
      return {
        id: v.id,
        kind,
        name: nameOf(v, lang),
        names: allItemNames(v),
        requiredRank: Number(v.requiredRank) || 1,
        value: Number(v.baseValue) || 0,
        rarity: String(v.rarity || 'common'),
        eventOnly: Boolean(v.eventOnly),
        global: kind === 'boats' && countries.length === 0,
        countries,
      };
    });
  return [
    ...tag(data.vehicles.cars, 'cars'),
    ...tag(data.vehicles.boats, 'boats'),
    ...tag(data.vehicles.motorcycles, 'motorcycles'),
  ];
}

function tagWeapons(data, lang) {
  return (data.weapons || []).map((w) => ({
    id: w.id,
    name: nameOf(w, lang),
    names: allItemNames(w),
    damage: Number(w.damage) || 0,
    price: Number(w.price) || 0,
    requiredRank: Number(w.requiredRank) || 1,
    type: String(w.type || ''),
  }));
}

function tagCrimes(data, lang) {
  return (data.crimes || []).map((c) => ({
    id: c.id,
    name: nameOf(c, lang),
    names: allItemNames(c),
    minLevel: Number(c.minLevel) || 1,
    maxReward: Number(c.maxReward) || 0,
    xp: Number(c.xpReward) || 0,
  }));
}

function tagTravel(data) {
  const hubs = (data.travel?.hubs || []).map((id) => String(id).toLowerCase());
  const inbound = {};
  const routes = {};
  for (const [from, tos] of Object.entries(data.travel?.directRoutes || {})) {
    const fromId = String(from).toLowerCase();
    const list = (tos || []).map((id) => String(id).toLowerCase());
    routes[fromId] = list;
    for (const to of list) {
      if (!inbound[to]) inbound[to] = [];
      inbound[to].push(fromId);
    }
  }
  return { hubs, routes, inbound };
}

export function topVehicles(vehicles, kind, limit = 5) {
  return vehicles
    .filter((v) => v.kind === kind && !v.eventOnly)
    .sort((a, b) => b.value - a.value || a.requiredRank - b.requiredRank || a.name.localeCompare(b.name))
    .slice(0, limit);
}

export function buildFacts(data, lang) {
  const playable = new Set((data.countries || []).map((c) => c.id));
  const countryIds = new Set([
    ...playable,
    ...Object.keys(COUNTRY),
    'austria',
    'monaco',
    'united_kingdom',
  ]);
  const countries = {};
  for (const id of countryIds) {
    const canon = COUNTRY_CANON[id] || id;
    countries[id] = {
      name: countryName(lang, id) !== id ? countryName(lang, id) : countryName(lang, canon),
      canon: playable.has(canon) ? canon : playable.has(id) ? id : null,
      aliases: aliasesFor(id),
    };
  }

  return {
    lang,
    vehicles: tagVehicles(data, lang),
    weapons: tagWeapons(data, lang),
    crimes: tagCrimes(data, lang),
    travel: tagTravel(data),
    countries,
    rankTitles: RANK_BANDS.map(([min, max, key]) => ({
      min,
      max,
      title: ui(lang, key),
    })),
    copy: {
      listAnd: ui(lang, 'listAnd'),
      kindCars: ui(lang, 'cars'),
      kindBoats: ui(lang, 'boats'),
      kindMotorcycles: ui(lang, 'motorcycles'),
      stealTitle: ui(lang, 'askStealTitle'),
      stealBest: ui(lang, 'askStealBest'),
      stealBestMine: ui(lang, 'askStealBestMine'),
      stealNamed: ui(lang, 'askStealNamed'),
      stealNamedGlobal: ui(lang, 'askStealNamedGlobal'),
      stealEverywhere: ui(lang, 'askStealEverywhere'),
      stealStreet: ui(lang, 'askStealStreet'),
      stealEvent: ui(lang, 'askStealEvent'),
      stealEmpty: ui(lang, 'askStealEmpty'),
      stealRankGate: ui(lang, 'askStealRankGate'),
      followStealCar: ui(lang, 'askFollowStealCar'),
      followStealBoat: ui(lang, 'askFollowStealBoat'),
      followStealMoto: ui(lang, 'askFollowStealMoto'),
      followStealMine: ui(lang, 'askFollowStealMine'),
      followWeapon: ui(lang, 'askFollowWeapon'),
      followCrime: ui(lang, 'askFollowCrime'),
      followTravel: ui(lang, 'askFollowTravel'),
      followRank: ui(lang, 'askFollowRank'),
      followVip: ui(lang, 'askFollowVip'),
      playerMoney: ui(lang, 'askPlayerMoney'),
      playerBank: ui(lang, 'askPlayerBank'),
      playerRank: ui(lang, 'askPlayerRank'),
      playerVipOn: ui(lang, 'askPlayerVipOn'),
      playerVipOff: ui(lang, 'askPlayerVipOff'),
      playerCrewVipOn: ui(lang, 'askPlayerCrewVipOn'),
      playerCrewVipOff: ui(lang, 'askPlayerCrewVipOff'),
      playerNoCrew: ui(lang, 'askPlayerNoCrew'),
      playerHealth: ui(lang, 'askPlayerHealth'),
      playerWanted: ui(lang, 'askPlayerWanted'),
      playerFbi: ui(lang, 'askPlayerFbi'),
      playerCountry: ui(lang, 'askPlayerCountry'),
      playerXp: ui(lang, 'askPlayerXp'),
      playerCredits: ui(lang, 'askPlayerCredits'),
      playerJailOn: ui(lang, 'askPlayerJailOn'),
      playerJailOff: ui(lang, 'askPlayerJailOff'),
      remainDays: ui(lang, 'askRemainDays'),
      remainHours: ui(lang, 'askRemainHours'),
      remainMinutes: ui(lang, 'askRemainMinutes'),
      remainNone: ui(lang, 'askRemainNone'),
      weaponBest: ui(lang, 'askWeaponBest'),
      weaponMine: ui(lang, 'askWeaponMine'),
      weaponEmpty: ui(lang, 'askWeaponEmpty'),
      crimeBest: ui(lang, 'askCrimeBest'),
      crimeMine: ui(lang, 'askCrimeMine'),
      crimeEmpty: ui(lang, 'askCrimeEmpty'),
      travel: ui(lang, 'travel'),
      weapons: ui(lang, 'weapons'),
      crimes: ui(lang, 'crimes'),
      travelTo: ui(lang, 'askTravelTo'),
      travelHubs: ui(lang, 'askTravelHubs'),
      travelEmpty: ui(lang, 'askTravelEmpty'),
      travelNone: ui(lang, 'askTravelNone'),
    },
  };
}
