/**
 * Almanac Ask engine — grounded retrieval over search.json.
 * No live prices, no account data, no game API.
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
  ];

  const PRICE_RE =
    /\b(live\s*prijs|huidige\s*prijs|straatprijs|street\s*price|hoeveel\s*kost\s+nu|current\s+price|koers\s+nu|spot\s*price)\b/i;
  const ACCOUNT_RE =
    /\b(mijn\s+(geld|cash|account|saldo|bank|wachtwoord)|hoeveel\s+(geld|cash)\s+heb\s+ik|how\s+much\s+(money|cash)\s+do\s+i|my\s+(money|cash|account|password)|login\s+code|reset\s+password)\b/i;
  const FOLLOW_RE =
    /^(en|ook|dat|dit|daar|die|then|and|also|what about|how about|und|et|y)\b/i;

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
    if (ACCOUNT_RE.test(question)) return 'account';
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

  function answerQuestion({ stats, question, session, copy }) {
    const blocked = blockedIntent(question);
    if (blocked) {
      return {
        blocked,
        empty: false,
        body: blocked === 'price' ? copy.blockedPrice : copy.blockedAccount,
        sources: [],
        followups: [],
      };
    }

    const resolved = resolveFollowup(question, session);
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
    answerQuestion,
  };
})(typeof window !== 'undefined' ? window : globalThis);
