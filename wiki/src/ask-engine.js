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
    ['prostitutie', 'prostitution', 'hoeren', 'hoer', 'hoerenhuis', 'rld', 'redlight'],
    ['innen', 'ophalen', 'collect', 'collectable', 'inkomsten'],
    ['territorium', 'territory', 'wapendepot', 'arsenal', 'frontlijn', 'frontline'],
    ['crewvip', 'donatiepot'],
    ['schild', 'shield'],
    ['gevangenis', 'jail', 'cel', 'prison'],
    ['nachtclub', 'nightclub'],
    ['crewbank', 'storten', 'opnemen'],
    ['rugzak', 'backpack', 'inventaris'],
    ['hitlist', 'hitlijst', 'bounty'],
    ['don', 'donship', 'gouverneur'],
    ['handleiding', 'handbook', 'almanak', 'almanac'],
    ['missie', 'mission', 'missies'],
    ['auto', 'autos', 'car', 'cars', 'wagen', 'voertuig'],
    ['boot', 'boten', 'boat', 'yacht', 'schip', 'marina'],
    ['motor', 'motoren', 'motorcycle', 'motorfiets', 'moto'],
    ['stelen', 'steal', 'jatten', 'diefstal', 'heist'],
  ];

  const PRICE_RE =
    /\b(live\s*prijs|huidige\s*prijs|straatprijs|street\s*price|hoeveel\s*kost\s+nu|current\s+price|koers\s+nu|spot\s*price)\b/i;
  const SECRET_RE =
    /\b(wachtwoord|password|login\s*code|reset\s+password|mijn\s+wachtwoord|my\s+password)\b/i;
  const FOLLOW_RE =
    /^(en|ook|dat|dit|daar|die|then|and|also|what about|how about|und|et|y)\b/i;

  const KIND_RES = [
    { kind: 'motorcycles', re: /\b(motoren|motors?|motorfiets(?:en)?|motorcycles?|motorbikes?|moto)\b/i },
    { kind: 'boats', re: /\b(boten|boot|boats?|yacht|jacht|schip|schepen|marina)\b/i },
    { kind: 'cars', re: /\b(auto'?s?|cars?|wagen|wagens)\b/i },
  ];

  const STEAL_RE =
    /\b(stel(?:en)?|jatten|heist|diefstal|steal(?:ing)?|theft|voertuig\s+stel)\b/i;
  const BEST_RE = /\b(beste|best|duurste|hoogste|top|most\s+valuable|richest)\b/i;
  const WHERE_RE = /\b(waar|where|welk\s+land|which\s+country|in\s+welk)\b/i;
  const MINE_RE = /\b(die\s+ik\s+kan|voor\s+mijn\s+(rank|rang|level)|op\s+mijn\s+(rank|rang)|i\s+can\s+steal|for\s+my\s+rank)\b/i;

  const PLAYER_FIELDS = [
    { field: 'money', re: /\b(hoeveel\s+(geld|cash)|mijn\s+(geld|cash|saldo)|how\s+much\s+(money|cash)|my\s+(money|cash|balance))\b/i },
    { field: 'bank', re: /\b(mijn\s+bank|banksaldo|hoeveel.{0,12}bank|bank\s+balance|my\s+bank)\b/i },
    { field: 'rank', re: /\b(welke\s+(rank|rang)|mijn\s+(rank|rang|level)|what\s+rank|which\s+rank|my\s+rank)\b/i },
    { field: 'crewVip', re: /\b(crew\s*vip|crewvip)\b/i },
    { field: 'vip', re: /\b((?:hoe\s*lang|remaining|left|nog).{0,24}vip|vip.{0,24}(?:over|resterend|left|nog|expire)|mijn\s+vip|heb\s+ik.{0,16}vip|ben\s+ik.{0,8}vip|am\s+i\s+vip|my\s+vip)\b/i },
    { field: 'health', re: /\b(mijn\s+(health|gezondheid|hp|leven)|hoeveel\s+(hp|health)|my\s+(health|hp))\b/i },
    { field: 'wanted', re: /\b(mijn\s+(wanted|gezocht)|wanted\s*level|hoeveel\s+sterren|my\s+wanted)\b/i },
    { field: 'fbi', re: /\b(mijn\s+fbi|fbi\s*heat|how\s+much\s+fbi)\b/i },
    { field: 'country', re: /\b(waar\s+ben\s+ik|in\s+welk\s+land\s+ben|my\s+(country|location)|huidige\s+land|current\s+country)\b/i },
    { field: 'xp', re: /\b(hoeveel\s+xp|mijn\s+xp|my\s+xp)\b/i },
    { field: 'credits', re: /\b(premium\s*credits?|hoeveel\s+credits|mijn\s+credits|my\s+credits)\b/i },
    { field: 'jail', re: /\b(zit\s+ik\s+(in\s+de\s+)?(cel|gevangenis)|hoe\s+lang.{0,16}(cel|jail|gevangenis)|mijn\s+(cel|jail)|am\s+i\s+in\s+jail)\b/i },
    { field: 'status', re: /\b(mijn\s+(status|stats|stand)|hoe\s+sta\s+ik|my\s+(status|stats|account\s+info))\b/i },
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
    if (PRICE_RE.test(question)) return 'price';
    if (SECRET_RE.test(question)) return 'secret';
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

  function pickSentences(pages, tokens, maxSentences = 4) {
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
    const used = new Set();
    const chosen = [];
    for (const row of scored) {
      const key = fold(row.sentence).slice(0, 80);
      if (used.has(key)) continue;
      used.add(key);
      chosen.push(row);
      if (chosen.length >= maxSentences) break;
    }
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

  function listJoin(items) {
    const list = (items || []).filter(Boolean);
    if (!list.length) return '';
    if (list.length === 1) return list[0];
    return `${list.slice(0, -1).join(', ')} en ${list[list.length - 1]}`;
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
    const found = KIND_RES.filter((row) => row.re.test(question)).map((row) => row.kind);
    return [...new Set(found)];
  }

  function detectPlayerIntent(question) {
    const fields = [];
    for (const row of PLAYER_FIELDS) {
      if (row.re.test(question)) fields.push(row.field);
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
    const q = fold(question);
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

  function findNamedVehicle(facts, question) {
    const q = fold(question);
    if (!facts?.vehicles || q.length < 4) return null;
    let best = null;
    let bestLen = 0;
    for (const vehicle of facts.vehicles) {
      const names = [vehicle.name, String(vehicle.id || '').replace(/_/g, ' ')]
        .map(fold)
        .filter((n) => n.length >= 4);
      for (const name of names) {
        if (q.includes(name) && name.length > bestLen) {
          best = vehicle;
          bestLen = name.length;
        }
      }
    }
    return best;
  }

  function isStealQuestion(question) {
    if (STEAL_RE.test(question)) return true;
    if (WHERE_RE.test(question) && (BEST_RE.test(question) || detectKinds(question).length)) return true;
    return false;
  }

  function detectStealIntent(question, facts) {
    if (!facts?.vehicles || !isStealQuestion(question)) return null;
    const named = findNamedVehicle(facts, question);
    const kinds = detectKinds(question);
    const country = findCountryId(facts, question);
    const mine = MINE_RE.test(question);
    if (named && !BEST_RE.test(question)) {
      return { intent: 'steal', mode: 'named', vehicle: named, country, mine };
    }
    const useKinds = kinds.length ? kinds : ['cars', 'boats', 'motorcycles'];
    if (BEST_RE.test(question) || STEAL_RE.test(question) || named == null) {
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
    return listJoin(unique.map((id) => countryLabel(facts, id)));
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
        followups: [],
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
        followups: [],
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
      followups: [],
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
          followups: [],
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
        followups: [],
      };
    }

    const stealIntent = detectStealIntent(resolved, facts);
    if (stealIntent) {
      const result = formatStealAnswer(stealIntent, facts, merged, player);
      if (session && result.sources[0]) {
        session.lastTitle = result.sources[0].title;
        session.lastHref = result.sources[0].href;
        session.lastQuery = question;
      }
      return result;
    }

    const ranked = rankPages(stats, resolved, 6);
    if (!ranked.length || ranked[0].score < 0.8) {
      return { blocked: null, empty: true, body: copy.empty, sources: [], followups: [] };
    }

    const top = ranked[0];
    const tokens = expandTokens(tokensOf(resolved));
    const picked = pickSentences([top], tokens, 4);
    const body = clip(
      picked.map((row) => row.sentence).join(' ') || top.entry.snippet || top.entry.answer || top.entry.title,
      900
    );
    const sourceMap = new Map();
    sourceMap.set(top.entry.href, { title: top.entry.title, href: top.entry.href });
    if (ranked[1] && ranked[1].score > top.score * 0.82) {
      sourceMap.set(ranked[1].entry.href, {
        title: ranked[1].entry.title,
        href: ranked[1].entry.href,
      });
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
      sources: [...sourceMap.values()],
      followups: followupsFor(ranked, copy),
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
    formatStealAnswer,
    formatPlayerAnswer,
    answerQuestion,
  };
})(typeof window !== 'undefined' ? window : globalThis);
