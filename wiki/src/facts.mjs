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

function nameOf(item, lang) {
  if (lang === 'nl') return item.displayName || item.name || item.id;
  return item.name_en || item.nameEn || item.displayName || item.name || item.id;
}

function tagVehicles(data, lang) {
  const tag = (list, kind) =>
    (list || []).map((v) => {
      const countries = (v.availableInCountries || []).map((id) => String(id).toLowerCase());
      return {
        id: v.id,
        kind,
        name: nameOf(v, lang),
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
      aliases: EXTRA_ALIASES[id] || [],
    };
  }

  return {
    lang,
    vehicles: tagVehicles(data, lang),
    countries,
    rankTitles: RANK_BANDS.map(([min, max, key]) => ({
      min,
      max,
      title: ui(lang, key),
    })),
    copy: {
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
    },
  };
}
