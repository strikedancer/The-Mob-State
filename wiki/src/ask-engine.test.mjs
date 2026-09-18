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
assert(AlmanacAsk.blockedIntent('hoeveel geld heb ik') === 'account', 'account guard');

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
