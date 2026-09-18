/**
 * Almanac Ask engine — grounded retrieval over search.json + catalog facts.
 * Live street prices stay blocked. Own-account stats need a wiki login.
 */
(function (root) {
  const STOP = new Set(
    'hoe wat waar wanneer waarom welke wie is zijn de het een van voor met naar op in uit bij om tot dat die dit als kan kun moet mag wel niet ik je we ze en of maar ook nog al mijn jouw onze even iets help uitleg vertel leg werkt werk doe doet over how what where when why which who are the a an of for with to from at do does can you we my me tell explain about work works working please was der das und oder funktioniert comment quoi quel quelle est les des une pour avec dans como que cual donde para con una los las come cosa quale dove perche nel jak co gdzie dlaczego czy dla jest o onde uma os as there here then just really'.split(
      /\s+/
    )
  );

  const SHORT_KEEP = new Set(['don', 'vip', 'xp', 'fbi', 'rld', 'hp', 'hq', 'icu', 'pvp']);

  const SYN_GROUPS = [
    ['prostitutie', 'prostitution', 'hoeren', 'hoer', 'hoerenhuis', 'rld', 'redlight', 'prostytucja', 'prostituierte'],
    ['innen', 'ophalen', 'collect', 'collectable', 'inkomsten', 'einkassieren', 'encaisser', 'cobrar'],
    ['territorium', 'territory', 'wapendepot', 'arsenal', 'frontlijn', 'frontline', 'territoire', 'territorio'],
    ['crewvip', 'donatiepot'],
    ['schild', 'shield', 'schutzschild', 'bouclier', 'escudo'],
    ['gevangenis', 'jail', 'cel', 'prison', 'knast', 'carcel', 'cella', 'wiezienie', 'cadeia'],
    ['nachtclub', 'nightclub'],
    ['crewbank', 'storten', 'opnemen'],
    ['rugzak', 'backpack', 'inventaris', 'rucksack', 'sac', 'mochila'],
    ['hitlist', 'hitlijst', 'bounty'],
    ['don', 'donship', 'gouverneur'],
    ['handleiding', 'handbook', 'almanak', 'almanac', 'handbuch', 'manuel', 'manual', 'manuale', 'poradnik'],
    ['missie', 'mission', 'missies', 'missione', 'misja'],
    ['auto', 'autos', 'car', 'cars', 'wagen', 'voertuig', 'voiture', 'coche', 'samochod', 'carro', 'macchina'],
    ['boot', 'boten', 'boat', 'yacht', 'schip', 'marina', 'bateau', 'barco', 'barca', 'lodz'],
    ['motor', 'motoren', 'motorcycle', 'motorfiets', 'moto', 'motorrad', 'motocykl'],
    ['stelen', 'steal', 'jatten', 'diefstal', 'heist', 'stehlen', 'voler', 'robar', 'rubare', 'ukrasc', 'roubar'],
    ['wapen', 'weapon', 'waffe', 'arme', 'arma', 'bron'],
    ['misdaad', 'crime', 'verbrechen', 'crimen', 'crimine', 'przestepstwo'],
    ['baan', 'banen', 'job', 'jobs', 'emploi', 'trabajo', 'lavoro', 'praca', 'emprego', 'arbeit'],
    ['cocaine', 'coke', 'kokain', 'kokaina', 'cocaina'],
    ['wiet', 'weed', 'cannabis'],
    ['reizen', 'travel', 'reisen', 'voyage', 'viaje', 'viaggio', 'podroz'],
  ];

  const PRICE_RE =
    /\b(live\s*prijs|huidige\s*prijs|straatprijs|street\s*price|hoeveel\s*kost\s+nu|current\s+price|koers\s+nu|spot\s*price|aktueller\s+preis|preis\s+jetzt|prix\s+actuel|prix\s+live|precio\s+actual|prezzo\s+attuale|aktualna\s+cena|preco\s+atual|quanto\s+custa\s+agora|was\s+kostet\s+jetzt)\b/i;
  const SECRET_RE =
    /\b(wachtwoord|password|passwort|mot\s+de\s+passe|contrasena|haslo|palavra[-\s]?passe|senha|login\s*code|reset\s+password|mijn\s+wachtwoord|my\s+password)\b/i;
  const FOLLOW_RE =
    /^(en|ook|dat|dit|daar|die|then|and|also|what about|how about|und|et|y|anche|tambien|tez|tambem|oraz|sowie|aussi|e poi)\b/i;

  const KIND_RES = [
    { kind: 'motorcycles', re: /\b(motoren|motors?|motorfiets(?:en)?|motorcycles?|motorbikes?|motorrader|motorrad|motos?|motocykle?|motocykl)\b/i },
    { kind: 'boats', re: /\b(boten|boot|boats?|boote?|yacht|jacht|schip|schepen|marina|bateaux?|barcos?|barche|barca|lodzie|lodz)\b/i },
    { kind: 'cars', re: /\b(auto'?s?|autos?|cars?|wagen|wagens|voitures?|coches?|carros?|macchine|samochody|samochod)\b/i },
  ];

  const STEAL_RE =
    /\b(stel(?:en|e)?|stehl(?:e|en|t)?|stiehl(?:st|t)?|jatten|heist|diefstal|steal(?:ing)?|theft|voler|robar|robo|rubare|furto|ukrasc|kradziez|roubar|roubo|voertuig\s+stel)\b/i;
  const BEST_RE =
    /\b(beste|best|duurste|hoogste|top|most\s+valuable|richest|teuerste|meilleure?|plus\s+cher|mejor|mas\s+caro|migliore|najlepsze?|najdrozsz\w*|melhor|mais\s+caro|sterkst(?:e)?|strongest|plus\s+forte|mas\s+fuerte)\b/i;
  const WHERE_RE =
    /\b(waar|where|wo|donde|dove|gdzie|onde|welk\s+land|which\s+country|in\s+welk|in\s+welchem)\b/i;
  const MINE_RE =
    /\b(die\s+ik\s+kan|voor\s+mijn\s+(rank|rang|level)|op\s+mijn\s+(rank|rang)|i\s+can\s+steal|for\s+my\s+rank|auf\s+meinem\s+rang|a\s+mon\s+rang|en\s+mi\s+rango|al\s+mio\s+grado|na\s+mojej\s+randze|na\s+minha\s+patente)\b/i;
  const WEAPON_RE = /\b(wapens?|weapons?|waffe(?:n)?|armes?|armas?|armi|bron(?:i)?)\b/i;
  const CRIME_RE =
    /\b(misda(?:ad|den)|crimes?|verbrechen|crimen(?:es)?|crimini?|przestepstw\w*)\b/i;
  const JOB_RE =
    /\b(baan|banen|jobs?|arbeit|emploi(?:s)?|trabajo(?:s)?|lavor[io]|prac[ae]|emprego(?:s)?)\b/i;
  const DRUG_RE =
    /\b(drugs?|drogen|drogues?|drogas?|narkotyk\w*|coca[i]?ne|coke|kokain\w*|wiet|weed|hero[i]?n\w*|xtc|ecstasy|hasj|hash|lsd|meth|fentanyl)\b/i;
  const CHEAP_RE =
    /\b(lager|goedkoop(?:st(?:e)?)?|cheaper|cheapest|lower|niedriger|gunstig(?:er|st)?|moins\s+cher|plus\s+bas(?:se)?|mas\s+(?:baja|barata)|piu\s+bassa|nizsz\w*|mais\s+baixa)\b/i;
  const DEAR_RE =
    /\b(hoger|duur(?:der|ste)?|higher|dearer|expensive|teurer|teuerste|plus\s+cher|plus\s+haut(?:e)?|mas\s+(?:alta|cara)|piu\s+alta|wyzsz\w*|mais\s+alta)\b/i;
  const TYPICAL_RE =
    /\b(doorgaans|typically|typisch|typiquement|suele|di\s+solito|zwykle|costuma)\b/i;
  const TRAVEL_RE =
    /\b(hoe\s+kom\s+ik|how\s+(?:do\s+i\s+|to\s+)?get\s+to|wie\s+komme\s+ich|comment\s+(?:aller|venir|je\s+vais)|como\s+(?:llego|chegar|chego)|come\s+arriv[oa]|jak\s+(?:dojechac|dostac\s+sie)|reis\s+naar|travel\s+to|vliegen\s+naar|flug\s+nach|voler\s+vers|volare\s+a)\b/i;
  const HUB_RE = /\b(reis.?hubs?|travel\s*hubs?|reise-?hubs?|hubs?\s+de\s+voyage)\b/i;

  const PLAYER_FIELDS = [
    { field: 'money', re: /\b(hoeveel\s+(geld|cash)|mijn\s+(geld|cash|saldo)|how\s+much\s+(money|cash)|my\s+(money|cash|balance)|wie\s+viel\s+geld|mein\s+geld|combien\s+d[' ]?argent|mon\s+argent|cuanto\s+dinero|mi\s+dinero|quant[io]\s+(soldi|denaro)|i\s+miei\s+soldi|ile\s+(mam\s+)?(pieniedzy|kasy)|quanto\s+dinheiro|o\s+meu\s+dinheiro)\b/i },
    { field: 'bank', re: /\b(mijn\s+bank|banksaldo|hoeveel.{0,12}bank|bank\s+balance|my\s+bank|mein\s+bank|ma\s+banque|mi\s+banco|la\s+mia\s+banca|moj\s+bank|o\s+meu\s+banco)\b/i },
    { field: 'rank', re: /\b(welke\s+(rank|rang)|mijn\s+(rank|rang|level)|what\s+rank|which\s+rank|my\s+rank|welchen\s+rang|welcher\s+rang|mein\s+rang|quel\s+rang|mon\s+rang|que\s+rango|mi\s+rango|che\s+grado|quale\s+grado|jaka\s+(mam\s+)?rang|que\s+patente|qual\s+patente)\b/i },
    { field: 'crewVip', re: /\b(crew\s*vip|crewvip)\b/i },
    { field: 'vip', re: /\b((?:hoe\s*lang|remaining|left|nog|wie\s+lange|combien|cuanto|quanto|ile).{0,24}vip|vip.{0,24}(?:over|resterend|left|nog|expire|bleibt|reste|queda|resta|zostalo)|mijn\s+vip|heb\s+ik.{0,16}vip|ben\s+ik.{0,8}vip|am\s+i\s+vip|my\s+vip|mein\s+vip|mon\s+vip|mi\s+vip)\b/i },
    { field: 'health', re: /\b(mijn\s+(health|gezondheid|hp|leven)|hoeveel\s+(hp|health)|my\s+(health|hp)|meine\s+gesundheit|ma\s+sante|mi\s+salud|la\s+mia\s+salute|moje\s+zdrowie|a\s+minha\s+saude)\b/i },
    { field: 'wanted', re: /\b(mijn\s+(wanted|gezocht)|wanted\s*level|hoeveel\s+sterren|my\s+wanted|meine\s+fahndung|mi\s+buscado)\b/i },
    { field: 'fbi', re: /\b(mijn\s+fbi|fbi\s*heat|how\s+much\s+fbi|mein\s+fbi)\b/i },
    { field: 'country', re: /\b(waar\s+ben\s+ik|in\s+welk\s+land\s+ben|my\s+(country|location)|huidige\s+land|current\s+country|wo\s+bin\s+ich|ou\s+suis[-\s]je|donde\s+estoy|dove\s+sono|gdzie\s+jestem|onde\s+estou)\b/i },
    { field: 'xp', re: /\b(hoeveel\s+xp|mijn\s+xp|my\s+xp|meine\s+xp|mon\s+xp|mi\s+xp)\b/i },
    { field: 'credits', re: /\b(premium\s*credits?|hoeveel\s+credits|mijn\s+credits|my\s+credits|meine\s+credits|mes\s+credits|mis\s+creditos)\b/i },
    { field: 'jail', re: /\b(zit\s+ik\s+(in\s+de\s+)?(cel|gevangenis)|hoe\s+lang.{0,16}(cel|jail|gevangenis)|mijn\s+(cel|jail)|am\s+i\s+in\s+jail|sitze\s+ich|bin\s+ich.{0,12}(knast|gefangnis)|suis[-\s]je.{0,12}prison|estoy.{0,12}carcel|sono.{0,12}(cella|prigione)|siedze|estou.{0,12}(cadeia|prisao))\b/i },
    { field: 'status', re: /\b(mijn\s+(status|stats|stand)|hoe\s+sta\s+ik|my\s+(status|stats|account\s+info)|mein\s+status|mon\s+statut|mi\s+estado|il\s+mio\s+stato|moj\s+status|o\s+meu\s+estado)\b/i },
  ];

  function fold(value) {
    return String(value || '')
      .toLowerCase()
      .normalize('NFD')
      .replace(/\p{M}/gu, '')
      .replace(/['’`]/g, '')
      .replace(/-/g, ' ');
  }

  function stem(token) {
    if (token.length < 5) return token;
    return token.replace(/(eringen|ering|ingen|eren|ende|heid|ties|tjes|ing|ers|ies|en|s)$/i, '');
  }

  function rawTokens(raw) {
    return fold(raw)
      .replace(/[^\p{L}\p{N}]+/gu, ' ')
      .split(/\s+/)
      .filter(Boolean);
  }

  function tokensOf(raw) {
    const words = rawTokens(raw);
    const kept = words.filter((t) => (t.length >= 3 || SHORT_KEEP.has(t)) && !STOP.has(t));
    const base = kept.length ? kept : words.filter((t) => t.length >= 2);
    return base.map(stem);
  }

  function expandTokens(tokens) {
    const set = new Set(tokens);
    for (const token of tokens) {
      for (const group of SYN_GROUPS) {
        const stemmedGroup = group.map(stem);
        if (group.includes(token) || stemmedGroup.includes(token)) {
          for (const extra of stemmedGroup) set.add(extra);
        }
      }
    }
    return [...set];
  }

  function fieldText(entry) {
    return [
      entry.title || '',
      entry.title || '',
      entry.title || '',
      entry.snippet || '',
      entry.answer || '',
      entry.aliases || '',
      (entry.text || '').slice(0, 8000),
    ].join(' ');
  }

  function tokenizeDoc(entry) {
    if (entry._askTokens) return entry._askTokens;
    const tokens = tokensOf(fieldText(entry));
    const tf = new Map();
    for (const token of tokens) tf.set(token, (tf.get(token) || 0) + 1);
    entry._askTokens = { tokens, tf, dl: tokens.length || 1 };
    return entry._askTokens;
  }

  function buildIndex(pages) {
    const df = new Map();
    let totalDl = 0;
    for (const entry of pages) {
      const doc = tokenizeDoc(entry);
      totalDl += doc.dl;
      const seen = new Set(doc.tf.keys());
      for (const token of seen) df.set(token, (df.get(token) || 0) + 1);
    }
    return {
      pages,
      n: pages.length || 1,
      avgdl: pages.length ? totalDl / pages.length : 1,
      df,
    };
  }

  function idf(stats, token) {
    const df = stats.df.get(token) || 0.5;
    return Math.log(1 + (stats.n - df + 0.5) / (df + 0.5));
  }

  function bm25(stats, entry, queryTokens) {
    const doc = tokenizeDoc(entry);
    const k1 = 1.4;
    const b = 0.75;
    let score = 0;
    for (const token of queryTokens) {
      const tf = doc.tf.get(token) || 0;
      if (!tf) continue;
      const denom = tf + k1 * (1 - b + (b * doc.dl) / stats.avgdl);
      score += idf(stats, token) * ((tf * (k1 + 1)) / denom);
    }
    return score;
  }

  function phraseBonus(entry, needle) {
    const clean = fold(needle)
      .replace(/[^\p{L}\p{N} ]+/gu, ' ')
      .replace(/\s+/g, ' ')
      .trim();
    if (!clean || clean.length < 3) return 0;
    const title = fold(entry.title);
    const answer = fold(entry.answer);
    const snippet = fold(entry.snippet);
    if (title === clean) return 28;
    if (title.includes(clean)) return 16;
    if (snippet.includes(clean)) return 8;
    if (answer.includes(clean)) return 6;
    return 0;
  }

  function titleBoost(entry, queryTokens) {
    const titleTokens = tokensOf(entry.title);
    if (!titleTokens.length) return 0;
    let boost = 0;
    for (const token of queryTokens) {
      if (!titleTokens.includes(token)) continue;
      boost += SHORT_KEEP.has(token) || token.length <= 3 ? 16 : 7;
    }
    if (titleTokens.every((token) => queryTokens.includes(token))) boost += 8;
    return boost;
  }

  function blockedIntent(question) {
    const q = fold(question);
    if (PRICE_RE.test(q) || PRICE_RE.test(question)) return 'price';
    if (SECRET_RE.test(q) || SECRET_RE.test(question)) return 'secret';
    return null;
  }

  function resolveFollowup(question, session) {
    const trimmed = String(question || '').trim();
    if (!session?.lastTitle) return trimmed;
    if (trimmed.length < 48 && FOLLOW_RE.test(fold(trimmed))) {
      return `${session.lastTitle} ${trimmed}`;
    }
    return trimmed;
  }

  function rankPages(stats, raw, limit = 8) {
    const query = fold(raw).trim();
    const tokens = expandTokens(tokensOf(query));
    if (!tokens.length) return [];
    return stats.pages
      .map((entry) => {
        let score =
          bm25(stats, entry, tokens) + phraseBonus(entry, query) + titleBoost(entry, tokens);
        if (entry.kind === 'guide' || (entry.href || '').includes('/guide/')) score *= 1.22;
        return { entry, score };
      })
      .filter((row) => row.score > 0.35)
      .sort((a, b) => b.score - a.score || String(a.entry.title).localeCompare(String(b.entry.title)))
      .slice(0, limit);
  }

  function sentencesOf(entry) {
    const blob = `${entry.snippet || ''} ${entry.answer || ''}`.replace(/\s+/g, ' ').trim();
    if (!blob) return [];
    return blob
      .split(/(?<=[.!?])\s+/)
      .map((s) => s.trim())
      .filter((s) => s.length > 28 && s.length < 420);
  }

  function pickSentences(pages, tokens, maxSentences = 5) {
    const scored = [];
    pages.forEach((page, pageIdx) => {
      for (const sentence of sentencesOf(page.entry)) {
        const lower = fold(sentence);
        const hits = tokens.filter((t) => t.length >= 3 && lower.includes(t));
        if (!hits.length) continue;
        scored.push({
          sentence,
          href: page.entry.href,
          title: page.entry.title,
          pageIdx,
          hits: hits.length,
          weight: hits.reduce((sum, token) => sum + token.length, 0),
        });
      }
    });
    scored.sort((a, b) => b.hits - a.hits || b.weight - a.weight || a.pageIdx - b.pageIdx);
    const firstPass = [];
    const seenPage = new Set();
    for (const row of scored) {
      if (seenPage.has(row.pageIdx)) continue;
      seenPage.add(row.pageIdx);
      firstPass.push(row);
      if (firstPass.length >= Math.min(3, maxSentences)) break;
    }
    const used = new Set(firstPass.map((row) => fold(row.sentence).slice(0, 80)));
    const chosen = [...firstPass];
    for (const row of scored) {
      const key = fold(row.sentence).slice(0, 80);
      if (used.has(key)) continue;
      used.add(key);
      chosen.push(row);
      if (chosen.length >= maxSentences) break;
    }
    chosen.sort((a, b) => a.pageIdx - b.pageIdx || b.hits - a.hits);
    return chosen;
  }

  function clip(value, max) {
    const text = String(value || '').replace(/\s+/g, ' ').trim();
    if (text.length <= max) return text;
    const cut = text.slice(0, max);
    const at = Math.max(cut.lastIndexOf('. '), cut.lastIndexOf(' '));
    return `${cut.slice(0, at > 40 ? at + 1 : max).trim()}…`;
  }

  function followupsFor(ranked, copy) {
    const tpl = copy.followTpl || '{title}';
    return ranked.slice(1, 4).map((row) => tpl.replace('{title}', row.entry.title));
  }

  function moneyFmt(n) {
    const v = Number(n);
    if (!Number.isFinite(v)) return '—';
    return `€${Math.round(v).toLocaleString('nl-NL')}`;
  }

  function listJoin(items, copy) {
    const list = (items || []).filter(Boolean);
    const and = (copy && copy.listAnd) || 'en';
    if (!list.length) return '';
    if (list.length === 1) return list[0];
    return `${list.slice(0, -1).join(', ')} ${and} ${list[list.length - 1]}`;
  }

  function fill(tpl, vars) {
    return String(tpl || '').replace(/\{(\w+)\}/g, (_, key) =>
      vars[key] == null ? '' : String(vars[key])
    );
  }

  function kindLabel(kind, copy) {
    if (kind === 'boats') return copy.kindBoats || 'boten';
    if (kind === 'motorcycles') return copy.kindMotorcycles || 'motoren';
    return copy.kindCars || 'auto’s';
  }

  function tabLabel(kind, copy) {
    if (kind === 'boats') return copy.kindBoats || 'Boot';
    if (kind === 'motorcycles') return copy.kindMotorcycles || 'Motor';
    return copy.kindCars || 'Auto';
  }

  function detectKinds(question) {
    const q = fold(question);
    const found = KIND_RES.filter((row) => row.re.test(q)).map((row) => row.kind);
    return [...new Set(found)];
  }

  function detectPlayerIntent(question) {
    const q = fold(question);
    const fields = [];
    for (const row of PLAYER_FIELDS) {
      if (row.re.test(q) || row.re.test(question)) fields.push(row.field);
    }
    if (!fields.length) return null;
    const identity = /\b(ben ik|am i|habe ich|bin ich|suis[-\s]?je|soy|sono|mam|sou)\b/i.test(q);
    if (
      fields.includes('rank') &&
      !identity &&
      (CRIME_RE.test(q) ||
        WEAPON_RE.test(q) ||
        JOB_RE.test(q) ||
        STEAL_RE.test(q) ||
        detectKinds(q).length ||
        MINE_RE.test(q))
    ) {
      fields.splice(fields.indexOf('rank'), 1);
    }
    if (!fields.length) return null;
    if (fields.includes('status')) {
      return {
        intent: 'player',
        fields: ['money', 'bank', 'rank', 'vip', 'crewVip', 'health', 'wanted', 'country', 'jail'],
      };
    }
    if (fields.includes('money') && !fields.includes('bank') && /\bbank\b/i.test(question) === false) {
      fields.push('bank');
    }
    return { intent: 'player', fields: [...new Set(fields)] };
  }

  function findCountryId(facts, question) {
    if (!facts?.countries) return null;
    const q = fold(question)
      .replace(/[^\p{L}\p{N}]+/gu, ' ')
      .replace(/\s+/g, ' ')
      .trim();
    const tokens = new Set(q.split(/\s+/).filter(Boolean));
    let best = null;
    let bestLen = 0;
    for (const [id, row] of Object.entries(facts.countries)) {
      const names = [id.replace(/_/g, ' '), row.name, ...(row.aliases || [])]
        .map(fold)
        .filter((n) => n.length >= 4);
      for (const name of names) {
        const hit = name.includes(' ') ? q.includes(name) : tokens.has(name) || q.includes(` ${name} `) || q.startsWith(`${name} `) || q.endsWith(` ${name}`);
        if (hit && name.length >= bestLen) {
          best = id;
          bestLen = name.length;
        }
      }
    }
    return best;
  }

  function findNamedIn(list, question, minLen = 3) {
    const q = fold(question);
    if (!list?.length || q.length < minLen) return null;
    const tokens = new Set(
      q
        .replace(/[^\p{L}\p{N}]+/gu, ' ')
        .split(/\s+/)
        .filter(Boolean)
    );
    let best = null;
    let bestLen = 0;
    for (const item of list) {
      const names = [item.name, String(item.id || '').replace(/_/g, ' '), ...(item.names || [])]
        .map(fold)
        .filter((n) => n.length >= minLen);
      for (const name of names) {
        const hit = name.includes(' ')
          ? q.includes(name)
          : tokens.has(name) || (name.length >= 4 && q.includes(name));
        if (hit && name.length > bestLen) {
          best = item;
          bestLen = name.length;
        }
      }
    }
    return best;
  }

  function findNamedVehicle(facts, question) {
    return findNamedIn(facts?.vehicles, question, 4);
  }

  function findNamedWeapon(facts, question) {
    return findNamedIn(facts?.weapons, question, 3);
  }

  function findNamedDrug(facts, question) {
    const named = findNamedIn(facts?.drugs, question, 3);
    if (named) return named;
    const q = fold(question);
    if (!/\b(wiet|weed|cannabis)\b/.test(q)) return null;
    return (facts?.drugs || []).find((d) => d.id === 'white_widow' || d.type === 'WEED') || null;
  }

  function isStealQuestion(question) {
    const q = fold(question);
    if (WEAPON_RE.test(q) && !detectKinds(q).length) return false;
    if (CRIME_RE.test(q) && !detectKinds(q).length) return false;
    if (JOB_RE.test(q) && !detectKinds(q).length) return false;
    if (DRUG_RE.test(q) && !detectKinds(q).length && !STEAL_RE.test(q)) return false;
    if (TRAVEL_RE.test(q) && !STEAL_RE.test(q) && !detectKinds(q).length) return false;
    if (STEAL_RE.test(q)) return true;
    if (WHERE_RE.test(q) && (BEST_RE.test(q) || detectKinds(q).length)) return true;
    if (BEST_RE.test(q) && detectKinds(q).length) return true;
    return false;
  }

  function detectStealIntent(question, facts, player) {
    const q = fold(question);
    if (!facts?.vehicles || !isStealQuestion(q)) return null;
    const named = findNamedVehicle(facts, q);
    const kinds = detectKinds(q);
    const country = findCountryId(facts, q);
    const mine = MINE_RE.test(q) || Boolean(player?.rank && BEST_RE.test(q));
    if (named && !BEST_RE.test(q)) {
      return { intent: 'steal', mode: 'named', vehicle: named, country, mine };
    }
    const useKinds = kinds.length ? kinds : ['cars', 'boats', 'motorcycles'];
    if (BEST_RE.test(q) || STEAL_RE.test(q) || named == null) {
      return { intent: 'steal', mode: 'best', kinds: useKinds, country, mine };
    }
    return null;
  }

  function countryLabel(facts, id) {
    const row = facts?.countries?.[id];
    return row?.name || id;
  }

  function countryHref(lang, facts, id) {
    const row = facts?.countries?.[id];
    const canon = row?.canon;
    if (!canon) return null;
    return `/${lang || facts.lang || 'nl'}/countries/${canon}/`;
  }

  function vehicleHref(lang, vehicle) {
    return `/${lang || 'nl'}/vehicles/${vehicle.id}/`;
  }

  function formatCountryList(facts, ids, copy) {
    const unique = [...new Set(ids || [])];
    if (!unique.length) return copy.stealNamedGlobal ? '' : '';
    return listJoin(unique.map((id) => countryLabel(facts, id)), copy);
  }

  function listedCountries(vehicle, facts) {
    if (vehicle.global) return [];
    return (vehicle.countries || []).filter((id) => facts?.countries?.[id]?.canon);
  }

  function inCountry(vehicle, countryId, facts) {
    if (!countryId) return true;
    if (vehicle.global) return true;
    const canon = facts?.countries?.[countryId]?.canon || countryId;
    const aliases = [countryId, canon, countryId === 'uk' ? 'united_kingdom' : '', canon === 'uk' ? 'united_kingdom' : ''];
    return vehicle.countries.some((id) => aliases.includes(id));
  }

  function pickBest(facts, kind, countryId, maxRank) {
    return facts.vehicles
      .filter((v) => v.kind === kind && !v.eventOnly && inCountry(v, countryId, facts))
      .filter((v) => v.global || listedCountries(v, facts).length > 0)
      .filter((v) => maxRank == null || v.requiredRank <= maxRank)
      .sort((a, b) => b.value - a.value || a.requiredRank - b.requiredRank)
      .slice(0, 3);
  }

  function stealSources(lang, facts, vehicles, copy) {
    const map = new Map();
    map.set(`/${lang}/vehicles/steal/`, {
      title: copy.stealTitle || copy.askStealTitle || 'Stelen',
      href: `/${lang}/vehicles/steal/`,
    });
    for (const vehicle of vehicles) {
      map.set(vehicleHref(lang, vehicle), { title: vehicle.name, href: vehicleHref(lang, vehicle) });
    }
    return [...map.values()];
  }

  function formatStealAnswer(intent, facts, copy, player) {
    const lang = facts.lang || 'nl';
    const maxRank = intent.mine && player?.rank ? Number(player.rank) : null;
    const street = copy.stealStreet || '';

    if (intent.mode === 'named' && intent.vehicle) {
      const vehicle = intent.vehicle;
      const countries = vehicle.global
        ? copy.stealNamedGlobal
        : formatCountryList(facts, listedCountries(vehicle, facts), copy);
      let body = fill(vehicle.global ? copy.stealNamedGlobal : copy.stealNamed, {
        name: vehicle.name,
        kind: tabLabel(vehicle.kind, copy),
        rank: vehicle.requiredRank,
        value: moneyFmt(vehicle.value),
        countries,
      });
      if (vehicle.eventOnly) body = `${body} ${copy.stealEvent || ''}`.trim();
      body = `${body} ${street}`.trim();
      if (maxRank != null && vehicle.requiredRank > maxRank) {
        body = `${body} ${fill(copy.stealRankGate, { rank: vehicle.requiredRank, mine: maxRank })}`.trim();
      }
      return {
        intent: 'steal',
        blocked: null,
        empty: false,
        needAuth: false,
        body: clip(body, 1100),
        sources: stealSources(lang, facts, [vehicle], copy),
        followups: stealFollowups(intent, facts, copy, player),
      };
    }

    const kinds = intent.kinds || ['cars'];
    const chunks = [];
    const used = [];
    for (const kind of kinds) {
      let rows = pickBest(facts, kind, intent.country, maxRank);
      if (!rows.length && maxRank != null) rows = pickBest(facts, kind, intent.country, null);
      if (!rows.length) continue;
      const top = rows[0];
      used.push(top);
      const countries = top.global
        ? copy.stealEverywhere || copy.stealNamedGlobal
        : formatCountryList(facts, listedCountries(top, facts), copy);
      const tpl = maxRank != null && top.requiredRank <= maxRank ? copy.stealBestMine : copy.stealBest;
      chunks.push(
        fill(tpl, {
          name: top.name,
          kind: kindLabel(kind, copy),
          rank: top.requiredRank,
          value: moneyFmt(top.value),
          countries,
          mine: maxRank || '',
          tab: tabLabel(kind, copy),
        })
      );
    }
    if (!chunks.length) {
      return {
        intent: 'steal',
        blocked: null,
        empty: true,
        needAuth: false,
        body: copy.stealEmpty || copy.empty,
        sources: stealSources(lang, facts, [], copy),
        followups: stealFollowups(intent, facts, copy, player),
      };
    }
    const body = clip(`${chunks.join(' ')} ${street}`.trim(), 1200);
    return {
      intent: 'steal',
      blocked: null,
      empty: false,
      needAuth: false,
      body,
      sources: stealSources(lang, facts, used, copy),
      followups: stealFollowups(intent, facts, copy, player),
    };
  }

  function rankTitleFor(facts, rank) {
    const n = Number(rank) || 1;
    const row = (facts?.rankTitles || []).find((item) => n >= item.min && n <= item.max);
    return row?.title || String(n);
  }

  function formatRemain(ms, copy) {
    const value = Number(ms);
    if (!Number.isFinite(value) || value <= 0) return copy.remainNone || '';
    const days = Math.floor(value / 86400000);
    const hours = Math.floor((value % 86400000) / 3600000);
    const minutes = Math.floor((value % 3600000) / 60000);
    if (days > 0) return fill(copy.remainDays, { days, hours });
    if (hours > 0) return fill(copy.remainHours, { hours, minutes });
    return fill(copy.remainMinutes, { minutes: Math.max(1, minutes) });
  }

  function formatJail(seconds, copy) {
    const value = Number(seconds) || 0;
    if (value <= 0) return copy.playerJailOff || '';
    return fill(copy.playerJailOn, { remain: formatRemain(value * 1000, copy) });
  }

  function formatPlayerAnswer(snapshot, fields, facts, copy) {
    const want = new Set(fields || []);
    const lines = [];
    const country = snapshot.currentCountry
      ? countryLabel(facts, snapshot.currentCountry)
      : snapshot.currentCountry;
    if (want.has('money')) {
      lines.push(fill(copy.playerMoney, { money: moneyFmt(snapshot.money), name: snapshot.username }));
    }
    if (want.has('bank')) {
      lines.push(fill(copy.playerBank, { money: moneyFmt(snapshot.bankBalance) }));
    }
    if (want.has('rank')) {
      lines.push(
        fill(copy.playerRank, {
          rank: snapshot.rank,
          title: snapshot.rankTitle || rankTitleFor(facts, snapshot.rank),
          xp: Number(snapshot.xp || 0).toLocaleString('nl-NL'),
        })
      );
    }
    if (want.has('vip')) {
      if (snapshot.isVip) {
        lines.push(fill(copy.playerVipOn, { remain: formatRemain(snapshot.vipRemainingMs, copy) }));
      } else {
        lines.push(copy.playerVipOff);
      }
    }
    if (want.has('crewVip')) {
      if (!snapshot.crewName) lines.push(copy.playerNoCrew);
      else if (snapshot.crewIsVip) {
        lines.push(
          fill(copy.playerCrewVipOn, {
            crew: snapshot.crewName,
            remain: formatRemain(snapshot.crewVipRemainingMs, copy),
          })
        );
      } else {
        lines.push(fill(copy.playerCrewVipOff, { crew: snapshot.crewName }));
      }
    }
    if (want.has('health')) lines.push(fill(copy.playerHealth, { health: snapshot.health }));
    if (want.has('wanted')) lines.push(fill(copy.playerWanted, { wanted: snapshot.wantedLevel ?? 0 }));
    if (want.has('fbi')) lines.push(fill(copy.playerFbi, { fbi: snapshot.fbiHeat ?? 0 }));
    if (want.has('country')) lines.push(fill(copy.playerCountry, { country: country || '—' }));
    if (want.has('xp') && !want.has('rank')) {
      lines.push(fill(copy.playerXp, { xp: Number(snapshot.xp || 0).toLocaleString('nl-NL') }));
    }
    if (want.has('credits')) {
      lines.push(fill(copy.playerCredits, { credits: Number(snapshot.premiumCredits || 0).toLocaleString('nl-NL') }));
    }
    if (want.has('jail')) lines.push(formatJail(snapshot.jailRemainingSeconds, copy));
    return clip(lines.filter(Boolean).join(' '), 1100);
  }

  function stealFollowups(intent, facts, copy, player) {
    const used = new Set(intent.kinds || (intent.vehicle ? [intent.vehicle.kind] : []));
    const out = [];
    if (!used.has('cars') && copy.followStealCar) out.push(copy.followStealCar);
    if (!used.has('boats') && copy.followStealBoat) out.push(copy.followStealBoat);
    if (!used.has('motorcycles') && copy.followStealMoto) out.push(copy.followStealMoto);
    if (!player && copy.followStealMine) out.push(copy.followStealMine);
    if (intent.country && copy.followTravel) {
      out.push(fill(copy.followTravel, { country: countryLabel(facts, intent.country) }));
    }
    if (copy.followWeapon) out.push(copy.followWeapon);
    if (copy.followJob) out.push(copy.followJob);
    return [...new Set(out)].slice(0, 3);
  }

  function playerFollowups(fields, copy) {
    const have = new Set(fields || []);
    const out = [];
    if (!have.has('rank') && copy.followRank) out.push(copy.followRank);
    if (!have.has('vip') && copy.followVip) out.push(copy.followVip);
    return out.slice(0, 3);
  }

  function whichLike(question) {
    return /\b(welk|welke|which|welche(?:s|r|n|m)?|quelle|quel(?:le|s|les)?|cual|que|che|quale|jaka|jaki|qual)\b/i.test(
      fold(question)
    );
  }

  function detectWeaponIntent(question, facts, player) {
    const q = fold(question);
    if (!facts?.weapons?.length) return null;
    if (detectKinds(q).length) return null;
    const named = findNamedWeapon(facts, q);
    if (named && !BEST_RE.test(q) && !MINE_RE.test(q)) {
      const short = fold(named.name).replace(/\s+/g, '').length < 4;
      const detail =
        /\b(schade|damage|degats|dano|obrazen|schaden|prijs|price|preis|prix|precio|prezzo|cena|rang|rank)\b/i.test(
          q
        );
      if (!short || detail) return { intent: 'weapon', named };
    }
    if (!WEAPON_RE.test(q)) return null;
    if (!(BEST_RE.test(q) || MINE_RE.test(q) || whichLike(q))) return null;
    return {
      intent: 'weapon',
      mine: MINE_RE.test(q) || Boolean(player?.rank && BEST_RE.test(q)),
    };
  }

  function formatWeaponAnswer(intent, facts, copy, player) {
    const lang = facts.lang || 'nl';
    if (intent.named) {
      const top = intent.named;
      return {
        intent: 'weapon',
        blocked: null,
        empty: false,
        needAuth: false,
        body: clip(
          fill(copy.weaponNamed || copy.weaponBest, {
            name: top.name,
            damage: top.damage,
            rank: top.requiredRank,
            price: moneyFmt(top.price),
          }),
          900
        ),
        sources: [
          { title: top.name, href: `/${lang}/weapons/${top.id}/` },
          { title: copy.weapons || 'Weapons', href: `/${lang}/weapons/` },
        ],
        followups: [copy.followCrime, copy.followJob, copy.followStealCar].filter(Boolean).slice(0, 3),
      };
    }
    const maxRank = intent.mine && player?.rank ? Number(player.rank) : null;
    let rows = (facts.weapons || [])
      .filter((w) => maxRank == null || w.requiredRank <= maxRank)
      .sort((a, b) => b.damage - a.damage || a.requiredRank - b.requiredRank);
    if (!rows.length && maxRank != null) {
      rows = [...facts.weapons].sort((a, b) => b.damage - a.damage || a.requiredRank - b.requiredRank);
    }
    const top = rows[0];
    if (!top) {
      return {
        intent: 'weapon',
        blocked: null,
        empty: true,
        needAuth: false,
        body: copy.weaponEmpty || copy.empty,
        sources: [{ title: copy.weapons || 'Weapons', href: `/${lang}/weapons/` }],
        followups: [copy.followCrime, copy.followStealCar].filter(Boolean),
      };
    }
    const tpl = maxRank != null && top.requiredRank <= maxRank ? copy.weaponMine : copy.weaponBest;
    return {
      intent: 'weapon',
      blocked: null,
      empty: false,
      needAuth: false,
      body: clip(
        fill(tpl, {
          name: top.name,
          damage: top.damage,
          rank: top.requiredRank,
          price: moneyFmt(top.price),
          mine: maxRank || '',
        }),
        900
      ),
      sources: [
        { title: top.name, href: `/${lang}/weapons/${top.id}/` },
        { title: copy.weapons || 'Weapons', href: `/${lang}/weapons/` },
      ],
      followups: [copy.followCrime, copy.followStealCar].filter(Boolean).slice(0, 3),
    };
  }

  function detectCrimeIntent(question, facts, player) {
    const q = fold(question);
    if (!facts?.crimes?.length || !CRIME_RE.test(q)) return null;
    if (detectKinds(q).length) return null;
    if (!(BEST_RE.test(q) || MINE_RE.test(q) || whichLike(q))) return null;
    return {
      intent: 'crime',
      mine: MINE_RE.test(q) || Boolean(player?.rank && (BEST_RE.test(q) || whichLike(q))),
    };
  }

  function formatCrimeAnswer(intent, facts, copy, player) {
    const lang = facts.lang || 'nl';
    const maxRank = intent.mine && player?.rank ? Number(player.rank) : null;
    const ranked = (facts.crimes || [])
      .filter((c) => maxRank == null || c.minLevel <= maxRank)
      .sort((a, b) => b.maxReward - a.maxReward || a.minLevel - b.minLevel);
    const top = ranked[0];
    if (!top) {
      return {
        intent: 'crime',
        blocked: null,
        empty: true,
        needAuth: false,
        body: copy.crimeEmpty || copy.empty,
        sources: [{ title: copy.crimes || 'Crimes', href: `/${lang}/crimes/` }],
        followups: [copy.followWeapon].filter(Boolean),
      };
    }
    const names = listJoin(
      ranked.slice(0, 4).map((c) => c.name),
      copy
    );
    const tpl = maxRank != null ? copy.crimeMine : copy.crimeBest;
    return {
      intent: 'crime',
      blocked: null,
      empty: false,
      needAuth: false,
      body: clip(
        fill(tpl, {
          name: top.name,
          names,
          rank: top.minLevel,
          reward: moneyFmt(top.maxReward),
          xp: top.xp,
          mine: maxRank || '',
        }),
        900
      ),
      sources: [
        { title: top.name, href: `/${lang}/crimes/${top.id}/` },
        { title: copy.crimes || 'Crimes', href: `/${lang}/crimes/` },
      ],
      followups: [copy.followWeapon, copy.followJob, copy.followStealCar].filter(Boolean).slice(0, 3),
    };
  }

  function detectJobIntent(question, facts, player) {
    const q = fold(question);
    if (!facts?.jobs?.length || !JOB_RE.test(q)) return null;
    if (detectKinds(q).length) return null;
    if (!(BEST_RE.test(q) || MINE_RE.test(q) || whichLike(q))) return null;
    return {
      intent: 'job',
      mine: MINE_RE.test(q) || Boolean(player?.rank && (BEST_RE.test(q) || whichLike(q))),
    };
  }

  function formatJobAnswer(intent, facts, copy, player) {
    const lang = facts.lang || 'nl';
    const maxRank = intent.mine && player?.rank ? Number(player.rank) : null;
    const ranked = (facts.jobs || [])
      .filter((job) => maxRank == null || job.minLevel <= maxRank)
      .sort((a, b) => b.maxEarnings - a.maxEarnings || a.minLevel - b.minLevel);
    const top = ranked[0];
    if (!top) {
      return {
        intent: 'job',
        blocked: null,
        empty: true,
        needAuth: false,
        body: copy.jobEmpty || copy.empty,
        sources: [{ title: copy.jobs || 'Jobs', href: `/${lang}/jobs/` }],
        followups: [copy.followCrime, copy.followStealCar].filter(Boolean),
      };
    }
    const names = listJoin(
      ranked.slice(0, 4).map((job) => job.name),
      copy
    );
    const tpl = maxRank != null ? copy.jobMine : copy.jobBest;
    return {
      intent: 'job',
      blocked: null,
      empty: false,
      needAuth: false,
      body: clip(
        fill(tpl, {
          name: top.name,
          names,
          rank: top.minLevel,
          reward: moneyFmt(top.maxEarnings),
          xp: top.xp,
          mine: maxRank || '',
        }),
        900
      ),
      sources: [
        { title: top.name, href: `/${lang}/jobs/${top.id}/` },
        { title: copy.jobs || 'Jobs', href: `/${lang}/jobs/` },
      ],
      followups: [copy.followCrime, copy.followDrug, copy.followStealCar].filter(Boolean).slice(0, 3),
    };
  }

  function detectDrugIntent(question, facts) {
    const q = fold(question);
    if (!facts?.drugs?.length) return null;
    if (detectKinds(q).length || STEAL_RE.test(q)) return null;
    const wantsTypical = WHERE_RE.test(q) || CHEAP_RE.test(q) || DEAR_RE.test(q) || TYPICAL_RE.test(q);
    if (!wantsTypical) return null;
    const named = findNamedDrug(facts, q);
    const fallback =
      DRUG_RE.test(q) && !named
        ? (facts.drugs || []).find((d) => d.id === 'cocaine') || facts.drugs[0]
        : null;
    const drug = named || fallback;
    if (!drug) return null;
    return { intent: 'drug', drug };
  }

  function typicalDrugCountries(drug, facts, limit = 3) {
    const rows = Object.entries(drug.pricing || {})
      .map(([id, value]) => ({
        id,
        value: Number(value),
        canon: facts.countries?.[id]?.canon || null,
      }))
      .filter((row) => row.canon && Number.isFinite(row.value));
    const cheap = [...rows].sort((a, b) => a.value - b.value || a.id.localeCompare(b.id)).slice(0, limit);
    const dear = [...rows].sort((a, b) => b.value - a.value || a.id.localeCompare(b.id)).slice(0, limit);
    return { cheap, dear };
  }

  function formatDrugAnswer(intent, facts, copy) {
    const lang = facts.lang || 'nl';
    const drug = intent.drug;
    const { cheap, dear } = typicalDrugCountries(drug, facts);
    const sources = [
      { title: drug.name, href: `/${lang}/drugs/${drug.id}/` },
      { title: copy.drugs || 'Drugs', href: `/${lang}/drugs/` },
    ];
    if (!cheap.length && !dear.length) {
      return {
        intent: 'drug',
        blocked: null,
        empty: true,
        needAuth: false,
        body: copy.drugEmpty || copy.empty,
        sources,
        followups: [copy.followJob, copy.followStealCar].filter(Boolean),
      };
    }
    return {
      intent: 'drug',
      blocked: null,
      empty: false,
      needAuth: false,
      body: clip(
        fill(copy.drugTypical, {
          name: drug.name,
          cheap: listJoin(
            cheap.map((row) => countryLabel(facts, row.id)),
            copy
          ),
          dear: listJoin(
            dear.map((row) => countryLabel(facts, row.id)),
            copy
          ),
        }),
        900
      ),
      sources,
      followups: [copy.followJob, copy.followStealCar].filter(Boolean).slice(0, 3),
    };
  }

  function detectTravelIntent(question, facts) {
    const q = fold(question);
    if (!facts?.travel) return null;
    if (HUB_RE.test(q)) return { intent: 'travel', mode: 'hubs' };
    if (!TRAVEL_RE.test(q) && !TRAVEL_RE.test(question)) return null;
    const country = findCountryId(facts, q);
    return { intent: 'travel', mode: country ? 'to' : 'hubs', country };
  }

  function formatTravelAnswer(intent, facts, copy) {
    const lang = facts.lang || 'nl';
    const hubs = (facts.travel?.hubs || []).map((id) => countryLabel(facts, id));
    const hubText = listJoin(hubs, copy) || copy.travelNone;
    const sources = [{ title: copy.travel || 'Travel', href: `/${lang}/travel/` }];
    if (intent.mode !== 'to' || !intent.country) {
      return {
        intent: 'travel',
        blocked: null,
        empty: false,
        needAuth: false,
        body: clip(fill(copy.travelHubs, { hubs: hubText }), 900),
        sources,
        followups: [copy.followStealCar].filter(Boolean),
      };
    }
    const canon = facts.countries?.[intent.country]?.canon || intent.country;
    const inbound = facts.travel?.inbound?.[canon] || facts.travel?.inbound?.[intent.country] || [];
    const outbound = facts.travel?.routes?.[canon] || facts.travel?.routes?.[intent.country] || [];
    const from = inbound.length
      ? listJoin(
          inbound.map((id) => countryLabel(facts, id)),
          copy
        )
      : copy.travelNone;
    const tos = outbound.length
      ? listJoin(
          outbound.map((id) => countryLabel(facts, id)),
          copy
        )
      : copy.travelNone;
    const href = countryHref(lang, facts, intent.country);
    if (href) sources.push({ title: countryLabel(facts, intent.country), href });
    return {
      intent: 'travel',
      blocked: null,
      empty: false,
      needAuth: false,
      body: clip(
        fill(copy.travelTo, {
          country: countryLabel(facts, intent.country),
          from,
          hubs: hubText,
          tos,
        }),
        1000
      ),
      sources,
      followups: [copy.followStealCar, copy.followWeapon].filter(Boolean).slice(0, 3),
    };
  }

  function remember(session, result, question) {
    if (!session || !result) return;
    session.lastTitle = result.sources?.[0]?.title || session.lastTitle;
    session.lastHref = result.sources?.[0]?.href || session.lastHref;
    session.lastQuery = question;
  }

  function mergeCopy(copy, facts) {
    return { ...(facts?.copy || {}), ...(copy || {}) };
  }

  function answerQuestion({ stats, facts, question, session, copy, player }) {
    const blocked = blockedIntent(question);
    if (blocked) {
      return {
        blocked,
        empty: false,
        needAuth: false,
        body: blocked === 'price' ? copy.blockedPrice : copy.blockedSecret || copy.blockedAccount,
        sources: [],
        followups: [],
      };
    }

    const resolved = resolveFollowup(question, session);
    const merged = mergeCopy(copy, facts);
    const playerIntent = detectPlayerIntent(resolved);
    if (playerIntent) {
      if (!player) {
        return {
          intent: 'player',
          blocked: null,
          empty: false,
          needAuth: true,
          fields: playerIntent.fields,
          body: copy.loginNeed || copy.blockedAccount,
          sources: [],
          followups: playerFollowups(playerIntent.fields, merged),
        };
      }
      const body = formatPlayerAnswer(player, playerIntent.fields, facts, merged);
      if (session) {
        session.lastTitle = player.username || 'status';
        session.lastQuery = question;
      }
      return {
        intent: 'player',
        blocked: null,
        empty: false,
        needAuth: false,
        fields: playerIntent.fields,
        body,
        sources: [],
        followups: playerFollowups(playerIntent.fields, merged),
      };
    }

    const stealIntent = detectStealIntent(resolved, facts, player);
    if (stealIntent) {
      const result = formatStealAnswer(stealIntent, facts, merged, player);
      remember(session, result, question);
      return result;
    }

    const drugIntent = detectDrugIntent(resolved, facts);
    if (drugIntent) {
      const result = formatDrugAnswer(drugIntent, facts, merged);
      remember(session, result, question);
      return result;
    }

    const jobIntent = detectJobIntent(resolved, facts, player);
    if (jobIntent) {
      const result = formatJobAnswer(jobIntent, facts, merged, player);
      remember(session, result, question);
      return result;
    }

    const weaponIntent = detectWeaponIntent(resolved, facts, player);
    if (weaponIntent) {
      const result = formatWeaponAnswer(weaponIntent, facts, merged, player);
      remember(session, result, question);
      return result;
    }

    const crimeIntent = detectCrimeIntent(resolved, facts, player);
    if (crimeIntent) {
      const result = formatCrimeAnswer(crimeIntent, facts, merged, player);
      remember(session, result, question);
      return result;
    }

    const travelIntent = detectTravelIntent(resolved, facts);
    if (travelIntent) {
      const result = formatTravelAnswer(travelIntent, facts, merged);
      remember(session, result, question);
      return result;
    }

    const ranked = rankPages(stats, resolved, 8);
    if (!ranked.length || ranked[0].score < 0.8) {
      return { blocked: null, empty: true, body: copy.empty, sources: [], followups: [] };
    }

    const top = ranked[0];
    const tokens = expandTokens(tokensOf(resolved));
    const picked = pickSentences(ranked.slice(0, 3), tokens, 5);
    const body = clip(
      picked.map((row) => row.sentence).join(' ') || top.entry.snippet || top.entry.answer || top.entry.title,
      1100
    );
    const sourceMap = new Map();
    sourceMap.set(top.entry.href, { title: top.entry.title, href: top.entry.href });
    for (const row of picked) {
      if (row.href) sourceMap.set(row.href, { title: row.title, href: row.href });
    }
    for (const row of ranked.slice(1, 3)) {
      if (row.score > top.score * 0.72) {
        sourceMap.set(row.entry.href, { title: row.entry.title, href: row.entry.href });
      }
    }
    if (session) {
      session.lastTitle = top.entry.title;
      session.lastHref = top.entry.href;
      session.lastQuery = question;
    }
    return {
      blocked: null,
      empty: false,
      body,
      sources: [...sourceMap.values()].slice(0, 4),
      followups: followupsFor(ranked, merged),
      top,
    };
  }

  root.AlmanacAsk = {
    tokensOf,
    expandTokens,
    buildIndex,
    rankPages,
    blockedIntent,
    resolveFollowup,
    detectPlayerIntent,
    detectStealIntent,
    detectWeaponIntent,
    detectCrimeIntent,
    detectJobIntent,
    detectDrugIntent,
    detectTravelIntent,
    formatStealAnswer,
    formatPlayerAnswer,
    findCountryId,
    answerQuestion,
  };
})(typeof window !== 'undefined' ? window : globalThis);
