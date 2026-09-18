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
    italy: { name: 'Italië', canon: 'italy', aliases: ['italie'] },
    france: { name: 'Frankrijk', canon: 'france', aliases: [] },
    netherlands: { name: 'Nederland', canon: 'netherlands', aliases: ['holland'] },
    spain: { name: 'Spanje', canon: 'spain', aliases: [] },
    usa: { name: 'Verenigde Staten', canon: 'usa', aliases: ['amerika'] },
    germany: { name: 'Duitsland', canon: 'germany', aliases: [] },
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

console.log('ask-engine tests ok');
