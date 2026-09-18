import fs from 'fs';
import path from 'path';
import vm from 'vm';
import { fileURLToPath } from 'url';

const src = fs.readFileSync(path.join(path.dirname(fileURLToPath(import.meta.url)), 'ask-engine.js'), 'utf8');
vm.runInThisContext(src);
const { AlmanacAsk } = globalThis;

function assert(cond, msg) {
  if (!cond) throw new Error(msg);
}

const pages = [
  {
    href: '/nl/guide/prostitution/',
    title: 'Prostitutie',
    kind: 'guide',
    snippet: 'Werf recruits en innen straatinkomsten.',
    answer:
      'Straat- en Red Light-geld loopt door terwijl ze werken. Nu ophalen zet het bedrag onder Te innen op je rekening. Je hoeft niet meer op een vol uur te wachten. Nachtclub loopt via de club, niet via deze knop.',
    text: 'prostitutie hoeren innen te innen nu ophalen',
  },
  {
    href: '/nl/guide/territory/',
    title: 'Territorium',
    kind: 'guide',
    snippet: 'Crew-wapens voeden het frontlijn-arsenaal.',
    answer:
      'Crew-wapens en kogels in de gedeelde opslag zijn de HQ-reserve. Officers committen die naar een regio met een actief wapendepot. Persoonlijke inventaris telt niet.',
    text: 'territorium wapendepot arsenal frontlijn',
  },
  {
    href: '/nl/guide/don/',
    title: 'Don',
    kind: 'guide',
    snippet: 'Rackets, leningen en officials.',
    answer: 'Als Don regel je rackets, leningen, officials en contracten in je land.',
    text: 'don donship gouverneur racket',
  },
];

const stats = AlmanacAsk.buildIndex(pages);

const hoeren = AlmanacAsk.rankPages(stats, 'hoeren innen', 3);
assert(hoeren[0].entry.href.includes('prostitution'), `expected prostitution, got ${hoeren[0]?.entry.href}`);

const depot = AlmanacAsk.rankPages(stats, 'wapendepot', 3);
assert(depot[0].entry.href.includes('territory'), `expected territory, got ${depot[0]?.entry.href}`);

assert(AlmanacAsk.blockedIntent('huidige prijs cocaïne') === 'price', 'price guard');
assert(AlmanacAsk.blockedIntent('wat is mijn wachtwoord') === 'secret', 'secret guard');
assert(AlmanacAsk.blockedIntent('hoeveel geld heb ik') === null, 'money is player intent not block');
assert(AlmanacAsk.detectPlayerIntent('hoeveel geld heb ik')?.fields.includes('money'), 'money field');
assert(AlmanacAsk.detectPlayerIntent('welke rank ben ik')?.fields.includes('rank'), 'rank field');
assert(AlmanacAsk.detectPlayerIntent('hoe lang heb ik nog vip')?.fields.includes('vip'), 'vip field');
assert(!AlmanacAsk.detectPlayerIntent('hoe werkt VIP'), 'handbook VIP is not a self question');

const facts = {
  lang: 'nl',
  vehicles: [
    {
      id: 'ferrari',
      kind: 'cars',
      name: 'Ferrari Testarossa',
      requiredRank: 22,
      value: 900000,
      rarity: 'legendary',
      eventOnly: false,
      global: false,
      countries: ['italy', 'france'],
    },
    {
      id: 'old_sedan',
      kind: 'cars',
      name: 'Oude Volkswagen Golf',
      requiredRank: 1,
      value: 3000,
      rarity: 'common',
      eventOnly: false,
      global: false,
      countries: ['netherlands'],
    },
    {
      id: 'yacht',
      kind: 'boats',
      name: 'Luxury Yacht',
      requiredRank: 18,
      value: 800000,
      rarity: 'legendary',
      eventOnly: false,
      global: false,
      countries: ['spain'],
    },
    {
      id: 'harley',
      kind: 'motorcycles',
      name: 'Harley Davidson',
      requiredRank: 10,
      value: 400000,
      rarity: 'epic',
      eventOnly: false,
      global: false,
      countries: ['usa', 'germany'],
    },
  ],
  countries: {
    italy: { name: 'Italië', canon: 'italy', aliases: ['italie', 'italien', 'italia', 'wlochy'] },
    france: { name: 'Frankrijk', canon: 'france', aliases: [] },
    netherlands: { name: 'Nederland', canon: 'netherlands', aliases: ['holland'] },
    spain: { name: 'Spanje', canon: 'spain', aliases: [] },
    usa: { name: 'Verenigde Staten', canon: 'usa', aliases: ['amerika'] },
    germany: { name: 'Duitsland', canon: 'germany', aliases: [] },
    colombia: { name: 'Colombia', canon: 'colombia', aliases: [] },
    mexico: { name: 'Mexico', canon: 'mexico', aliases: [] },
    japan: { name: 'Japan', canon: 'japan', aliases: [] },
  },
  rankTitles: [{ min: 1, max: 150, title: 'Cadet' }],
  copy: {
    kindCars: 'auto’s',
    kindBoats: 'boten',
    kindMotorcycles: 'motoren',
    stealTitle: 'Voertuig stelen',
    stealBest: 'De hoogste cataloguswaarde onder {kind} is {name} (rang {rank}, {value}). Die kan verschijnen in {countries}. Tab {tab}.',
    stealBestMine: 'Op jouw rang {mine} is de hoogste cataloguswaarde onder {kind} {name} (rang {rank}, {value}) in {countries}. Tab {tab}.',
    stealNamed: '{name} ({kind}) heeft cataloguswaarde {value} en vraagt rang {rank}. Die kan verschijnen in {countries}.',
    stealNamedGlobal: '{name} is overal.',
    stealEverywhere: 'overal',
    stealStreet: 'Je kiest het model niet zelf.',
    stealEvent: 'Event only.',
    stealEmpty: 'geen voertuig',
    stealRankGate: 'vraagt rang {rank}; jij {mine}.',
    playerMoney: '{name}, je hebt {money} op zak.',
    playerBank: 'Op de bank staat {money}.',
    playerRank: 'Je bent rang {rank} ({title}), met {xp} XP.',
    playerVipOn: 'Player VIP loopt nog {remain}.',
    playerVipOff: 'Je hebt nu geen Player VIP.',
    playerCrewVipOn: 'Crew {crew} heeft Crew VIP nog {remain}.',
    playerCrewVipOff: 'Crew {crew} heeft nu geen Crew VIP.',
    playerNoCrew: 'Je zit in geen crew.',
    playerHealth: 'Gezondheid: {health}.',
    playerWanted: 'Wanted: {wanted}.',
    playerFbi: 'FBI-heat: {fbi}.',
    playerCountry: 'Je bent nu in {country}.',
    playerXp: 'XP: {xp}.',
    playerCredits: 'Premium credits: {credits}.',
    playerJailOn: 'Je zit nog {remain} in de cel.',
    playerJailOff: 'Je zit nu niet in de cel.',
    remainDays: '{days} dagen en {hours} uur',
    remainHours: '{hours} uur en {minutes} minuten',
    remainMinutes: '{minutes} minuten',
    remainNone: 'geen tijd meer',
    listAnd: 'en',
    weaponBest: 'Topwapen {name} schade {damage} rang {rank} {price}.',
    weaponMine: 'Op rang {mine} is {name} het sterkste wapen (schade {damage}).',
    weaponEmpty: 'geen wapen',
    crimeBest: 'Topmisdaad {name} rang {rank} tot {reward}.',
    crimeMine: 'Op rang {mine} kun je {names}. Top is {name} tot {reward}.',
    crimeEmpty: 'geen misdaad',
    travelTo: 'Naar {country} vanuit {from}. Hubs {hubs}. Direct {tos}.',
    travelHubs: 'Hubs: {hubs}.',
    travelEmpty: 'geen reis',
    travelNone: 'nergens',
    followStealCar: 'Waar steel ik de beste auto?',
    followStealBoat: 'Waar steel ik de beste boot?',
    followStealMoto: 'Waar steel ik de beste motor?',
    followStealMine: 'Wat kan ik stelen op mijn rank?',
    followWeapon: 'Wat is het sterkste wapen?',
    followCrime: 'Welke misdaad kan ik?',
    followTravel: 'Hoe kom ik in {country}?',
    followRank: 'Welke rank ben ik?',
    followVip: 'Hoe lang heb ik nog VIP?',
    followJob: 'Welke baan kan ik op mijn rank?',
    followDrug: 'Waar is cocaïne doorgaans lager?',
    jobBest: 'Topbaan {name} rang {rank} tot {reward}.',
    jobMine: 'Op rang {mine} kun je {names}. Top is {name} tot {reward}.',
    jobEmpty: 'geen baan',
    drugTypical: '{name} doorgaans lager in {cheap} en hoger in {dear}. Geen live straatprijs.',
    drugEmpty: 'geen drugfactor',
    weaponNamed: '{name} schade {damage} rang {rank} {price}.',
    jobs: 'Banen',
    drugs: 'Drugs',
  },
  weapons: [
    { id: 'knife', name: 'Mes', names: ['Mes', 'knife'], damage: 15, price: 50, requiredRank: 1, type: 'melee' },
    { id: 'rifle', name: 'Geweer', names: ['Geweer', 'rifle'], damage: 80, price: 9000, requiredRank: 20, type: 'rifle' },
  ],
  jobs: [
    { id: 'newspaper_delivery', name: 'Krant Bezorgen', names: ['krant'], minLevel: 1, maxEarnings: 100, xp: 5 },
    { id: 'airline_pilot', name: 'Piloot', names: ['piloot', 'pilot'], minLevel: 25, maxEarnings: 6000, xp: 300 },
  ],
  drugs: [
    {
      id: 'cocaine',
      name: 'Cocaïne',
      names: ['cocaine', 'coke', 'kokain', 'cocaina'],
      type: 'COCAINE',
      pricing: { colombia: 40, mexico: 60, netherlands: 100, japan: 200 },
    },
  ],
  crimes: [
    { id: 'pickpocket', name: 'Zakkenrollen', minLevel: 1, maxReward: 200, xp: 25 },
    { id: 'bank', name: 'Bankroof', minLevel: 40, maxReward: 80000, xp: 400 },
  ],
  travel: {
    hubs: ['germany', 'usa'],
    routes: { italy: ['france', 'germany'], france: ['italy', 'germany'] },
    inbound: { italy: ['france', 'germany'], france: ['italy'] },
  },
};

const stealCopy = { empty: 'empty', blockedPrice: 'price', blockedAccount: 'account', loginNeed: 'log in' };
const stealBest = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'waar kan ik de beste auto boot of motor stelen',
  copy: stealCopy,
});
assert(stealBest.intent === 'steal', `steal intent missing: ${JSON.stringify(stealBest)}`);
assert(/Ferrari/i.test(stealBest.body), `best car missing: ${stealBest.body}`);
assert(/Luxury Yacht/i.test(stealBest.body), `best boat missing: ${stealBest.body}`);
assert(/Harley/i.test(stealBest.body), `best moto missing: ${stealBest.body}`);
assert(/Italië/i.test(stealBest.body), `car country missing: ${stealBest.body}`);
assert(!stealBest.body.includes('Australi'), `false country match: ${stealBest.body}`);
assert(AlmanacAsk.detectStealIntent('waar kan ik de beste auto stelen', facts)?.country == null, 'de/auto must not pick a country');
assert(/kiest het model niet zelf/i.test(stealBest.body), `street-theft note missing: ${stealBest.body}`);

const named = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'waar kan ik de Ferrari Testarossa stelen',
  copy: stealCopy,
});
assert(/Ferrari/i.test(named.body) && /Italië/i.test(named.body), `named steal missing: ${named.body}`);

const mine = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'beste auto die ik kan stelen',
  copy: stealCopy,
  player: { rank: 1 },
});
assert(/Golf/i.test(mine.body), `rank-filtered steal should pick golf, got ${mine.body}`);

const moneyQ = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'hoeveel geld heb ik',
  copy: { ...stealCopy, loginNeed: 'log in voor cijfers' },
});
assert(moneyQ.needAuth === true, 'player money should ask for login');

const moneyIn = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'hoeveel geld heb ik',
  copy: stealCopy,
  player: {
    username: 'DonTest',
    money: 125000,
    bankBalance: 50000,
    rank: 21,
    rankTitle: 'Cadet',
    xp: 8000,
    isVip: true,
    vipRemainingMs: 2 * 86400000 + 3 * 3600000,
    crewName: 'Nightshade',
    crewIsVip: true,
    crewVipRemainingMs: 3600000,
    health: 80,
    wantedLevel: 4,
    fbiHeat: 10,
    currentCountry: 'netherlands',
    premiumCredits: 12,
    jailRemainingSeconds: 0,
  },
});
assert(/125.000|125000/.test(moneyIn.body) && /DonTest/.test(moneyIn.body), `money body: ${moneyIn.body}`);
assert(/50.000|50000/.test(moneyIn.body), `bank body: ${moneyIn.body}`);

const vipQ = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'hoe lang heb ik nog vip',
  copy: stealCopy,
  player: {
    username: 'DonTest',
    isVip: true,
    vipRemainingMs: 2 * 86400000,
    currentCountry: 'netherlands',
  },
});
assert(/2 dagen/.test(vipQ.body), `vip remain: ${vipQ.body}`);

const session = {};
const first = AlmanacAsk.answerQuestion({
  stats,
  question: 'hoe werkt Don?',
  session,
  copy: { empty: 'empty', blockedPrice: 'price', blockedAccount: 'account', followTpl: 'Meer over {title}?' },
});
assert(/Don/i.test(first.sources[0]?.title || '') || /racket/i.test(first.body), `don answer missing: ${JSON.stringify(first)}`);
const follow = AlmanacAsk.resolveFollowup('en VIP?', session);
assert(/Don/i.test(follow), `follow-up should keep Don, got ${follow}`);

const deSteal = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Wo stehle ich das beste Auto?',
  copy: { ...stealCopy, listAnd: 'und' },
});
assert(deSteal.intent === 'steal' && /Ferrari/i.test(deSteal.body), `DE steal: ${deSteal.body}`);

const frSteal = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Où voler la meilleure voiture ?',
  copy: stealCopy,
});
assert(frSteal.intent === 'steal' && /Ferrari/i.test(frSteal.body), `FR steal: ${frSteal.body}`);

const esMoney = AlmanacAsk.detectPlayerIntent('¿Cuánto dinero tengo?');
assert(esMoney?.fields.includes('money'), `ES money: ${JSON.stringify(esMoney)}`);
assert(AlmanacAsk.detectPlayerIntent('Welchen Rang habe ich?')?.fields.includes('rank'), 'DE rank');
assert(AlmanacAsk.detectPlayerIntent('Che grado sono?')?.fields.includes('rank'), 'IT rank');
assert(AlmanacAsk.detectPlayerIntent('Ile mam pieniędzy?')?.fields.includes('money'), 'PL money');
assert(AlmanacAsk.detectPlayerIntent('Quanto dinheiro tenho?')?.fields.includes('money'), 'PT money');
assert(AlmanacAsk.blockedIntent('aktueller Preis Kokain') === 'price', 'DE price guard');
assert(AlmanacAsk.blockedIntent('mot de passe') === 'secret', 'FR secret guard');

const weaponQ = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Wat is het sterkste wapen?',
  copy: stealCopy,
});
assert(weaponQ.intent === 'weapon' && /Geweer/i.test(weaponQ.body), `weapon: ${weaponQ.body}`);

const crimeMine = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Welke misdaad kan ik op mijn rank?',
  copy: stealCopy,
  player: { rank: 1 },
});
assert(crimeMine.intent === 'crime' && /Zakkenrollen/i.test(crimeMine.body), `crime: ${crimeMine.body}`);
assert(!/Bankroof/i.test(crimeMine.body), `rank-1 crime should not pick bank: ${crimeMine.body}`);

const travelQ = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Wie komme ich nach Italien?',
  copy: stealCopy,
});
assert(travelQ.intent === 'travel' && /Ital/i.test(travelQ.body), `travel: ${travelQ.body}`);

const autoMine = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'beste auto',
  copy: stealCopy,
  player: { rank: 1 },
});
assert(/Golf/i.test(autoMine.body), `logged-in best steal should rank-filter: ${autoMine.body}`);

const mixed = AlmanacAsk.answerQuestion({
  stats,
  question: 'prostitutie territorium wapendepot',
  copy: { empty: 'empty', blockedPrice: 'price', blockedAccount: 'account', followTpl: 'Meer over {title}?' },
});
assert(mixed.sources.length >= 2, `handbook should cite multiple pages, got ${JSON.stringify(mixed.sources)}`);

const jobMine = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Welke baan kan ik op mijn rank?',
  copy: stealCopy,
  player: { rank: 1 },
});
assert(jobMine.intent === 'job' && /Krant/i.test(jobMine.body), `job mine: ${jobMine.body}`);
assert(!/Piloot/i.test(jobMine.body), `rank-1 job should not pick pilot: ${jobMine.body}`);

const jobBest = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Welchen Job kann ich?',
  copy: stealCopy,
});
assert(jobBest.intent === 'job' && /Piloot/i.test(jobBest.body), `DE job: ${jobBest.body}`);
assert(AlmanacAsk.detectJobIntent('Quel emploi puis-je faire ?', facts), 'FR job');
assert(AlmanacAsk.detectJobIntent('¿Qué trabajo puedo hacer?', facts), 'ES job');
assert(AlmanacAsk.detectJobIntent('Che lavoro posso fare?', facts), 'IT job');
assert(AlmanacAsk.detectJobIntent('Jaką pracę mogę?', facts), 'PL job');
assert(AlmanacAsk.detectJobIntent('Que emprego posso fazer?', facts), 'PT job');
assert(AlmanacAsk.detectJobIntent('Which job can I do?', facts), 'EN job');

const drugQ = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Waar is cocaïne doorgaans lager?',
  copy: stealCopy,
});
assert(drugQ.intent === 'drug' && /Colombia/i.test(drugQ.body), `drug cheap: ${drugQ.body}`);
assert(/Japan/i.test(drugQ.body), `drug dear: ${drugQ.body}`);
assert(!/€\s*40|€40/.test(drugQ.body), `drug must not leak typical euros: ${drugQ.body}`);
assert(AlmanacAsk.blockedIntent('huidige prijs cocaïne') === 'price', 'coke live price still blocked');

const drugDe = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Wo ist Kokain typisch niedriger?',
  copy: stealCopy,
});
assert(drugDe.intent === 'drug' && /Colombia/i.test(drugDe.body), `DE drug: ${drugDe.body}`);

const drugFr = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Où la cocaïne est-elle typiquement plus basse ?',
  copy: stealCopy,
});
assert(drugFr.intent === 'drug' && /Colombia/i.test(drugFr.body), `FR drug: ${drugFr.body}`);

const namedWeapon = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'Hoeveel schade heeft Geweer?',
  copy: stealCopy,
});
assert(namedWeapon.intent === 'weapon' && /Geweer/i.test(namedWeapon.body) && /80/.test(namedWeapon.body), `named weapon: ${namedWeapon.body}`);

const frMyWeapons = AlmanacAsk.answerQuestion({
  stats,
  facts,
  question: 'quelles sont mes armes',
  copy: stealCopy,
});
assert(frMyWeapons.intent === 'weapon' && /Geweer/i.test(frMyWeapons.body), `FR mes armes should be strongest, got ${frMyWeapons.body}`);
assert(!/Mes/.test(frMyWeapons.body) || /Geweer/i.test(frMyWeapons.body), `FR mes armes must not be knife-only: ${frMyWeapons.body}`);

console.log('ask-engine tests ok');
