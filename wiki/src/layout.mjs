import { LANGS, LANG_LABEL, ui } from './i18n.mjs';

/** Query-bust CSS/JS; nginx caches those files for 7 days. */
const ASSET_V = '20260918d';

export function esc(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

export function money(n) {
  const v = Number(n);
  if (!Number.isFinite(v)) return '—';
  return '€' + Math.round(v).toLocaleString('nl-NL');
}

const NAV = [
  ['', 'home'],
  ['guide/', 'guide'],
  ['countries/', 'countries'],
  ['trade/', 'trade'],
  ['vehicles/', 'vehicles'],
  ['weapons/', 'weapons'],
  ['drugs/', 'drugs'],
  ['materials/', 'materials'],
  ['properties/', 'properties'],
  ['aircraft/', 'aircraft'],
  ['backpacks/', 'backpacks'],
  ['travel/', 'travel'],
  ['crimes/', 'crimes'],
];

export function page({ lang, title, path, hero, crumbs, body, description }) {
  const abs = `https://wiki.themobstate.com/${lang}/${path}`;
  const hreflangs = LANGS.map(
    (l) =>
      `<link rel="alternate" hreflang="${l}" href="https://wiki.themobstate.com/${l}/${path}">`
  ).join('\n    ');
  const nav = NAV.map(([href, key]) => {
    const active = path === href || (href && path.startsWith(href));
    return `<a class="${active ? 'active' : ''}" href="/${lang}/${href}">${esc(ui(lang, key))}</a>`;
  }).join('');
  const crumbHtml = (crumbs || [])
    .map((c, i, arr) =>
      i === arr.length - 1
        ? `<span>${esc(c.label)}</span>`
        : `<a href="${esc(c.href)}">${esc(c.label)}</a> / `
    )
    .join('');
  const heroHtml = hero
    ? `<header class="hero">
        <div class="hero-media" style="background-image:url('${esc(hero.image)}')"></div>
        <div class="hero-copy">
          <p class="hero-kicker">${esc(hero.kicker || ui(lang, 'heroKicker'))}</p>
          <h1>${esc(hero.title)}</h1>
          <p>${esc(hero.lead || '')}</p>
        </div>
      </header>`
    : '';
  return `<!doctype html>
<html lang="${lang}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${esc(title)} · ${esc(ui(lang, 'siteTitle'))}</title>
  <meta name="description" content="${esc(description || hero?.lead || ui(lang, 'heroLead'))}">
  <link rel="canonical" href="${abs}">
  ${hreflangs}
  <link rel="alternate" hreflang="x-default" href="https://wiki.themobstate.com/en/${path}">
  <meta property="og:title" content="${esc(title)}">
  <meta property="og:description" content="${esc(description || hero?.lead || '')}">
  <meta property="og:image" content="${esc(hero?.image || '/images/logo.png')}">
  <meta property="og:type" content="website">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700&family=Source+Sans+3:wght@400;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/theme.css?v=${ASSET_V}">
</head>
<body>
  <a class="skip" href="#main">Skip</a>
  <nav class="nav">
    <a class="brand" href="/${lang}/">
      <img src="/images/logo.png" alt="" onerror="this.remove()">
      ${esc(ui(lang, 'brand'))} · ${esc(ui(lang, 'siteTitle'))}
    </a>
    <div class="nav-links">${nav}</div>
    <div class="nav-tools">
      <input class="search" id="almanac-search" type="search" placeholder="${esc(ui(lang, 'search'))}" autocomplete="off" data-empty="${esc(ui(lang, 'empty'))}" data-index="/${lang}/search.json">
      <label class="lang">
        <select id="lang-switch">${LANGS.map(
          (l) => `<option value="${l}" ${l === lang ? 'selected' : ''}>${esc(LANG_LABEL[l])}</option>`
        ).join('')}</select>
      </label>
      <a class="pill" href="https://themobstate.com/">${esc(ui(lang, 'play'))}</a>
    </div>
  </nav>
  ${heroHtml}
  <main id="main" class="wrap">
    ${crumbHtml ? `<div class="crumbs">${crumbHtml}</div>` : ''}
    ${body}
  </main>
  <footer class="footer">${esc(ui(lang, 'footer'))}</footer>
  <button type="button" class="ask-toggle" id="almanac-ask" aria-expanded="false" aria-controls="almanac-chat">${esc(ui(lang, 'askOpen'))}</button>
  <aside id="almanac-chat" class="ask-panel" hidden role="dialog" aria-labelledby="almanac-ask-title" data-welcome="${esc(ui(lang, 'askWelcome'))}" data-empty="${esc(ui(lang, 'askEmpty'))}" data-read="${esc(ui(lang, 'askRead'))}" data-more="${esc(ui(lang, 'askMore'))}" data-sources="${esc(ui(lang, 'askSources'))}" data-follow="${esc(ui(lang, 'askFollow'))}" data-follow-tpl="${esc(ui(lang, 'askFollowTpl'))}" data-thinking="${esc(ui(lang, 'askThinking'))}" data-blocked-price="${esc(ui(lang, 'askBlockedPrice'))}" data-blocked-account="${esc(ui(lang, 'askBlockedAccount'))}" data-blocked-secret="${esc(ui(lang, 'askBlockedSecret'))}" data-login-need="${esc(ui(lang, 'askLoginNeed'))}" data-login-user="${esc(ui(lang, 'askLoginUser'))}" data-login-pass="${esc(ui(lang, 'askLoginPass'))}" data-login-submit="${esc(ui(lang, 'askLoginSubmit'))}" data-login-fail="${esc(ui(lang, 'askLoginFail'))}" data-login-unverified="${esc(ui(lang, 'askLoginUnverified'))}" data-login-banned="${esc(ui(lang, 'askLoginBanned'))}" data-logout="${esc(ui(lang, 'askLogout'))}" data-session="${esc(ui(lang, 'askSession'))}" data-facts="/${lang}/facts.json" data-api="https://api.themobstate.com">
    <header class="ask-head">
      <div>
        <p class="ask-kicker">${esc(ui(lang, 'askKicker'))}</p>
        <h2 id="almanac-ask-title">${esc(ui(lang, 'askTitle'))}</h2>
        <p class="ask-session" id="almanac-ask-session" hidden></p>
      </div>
      <div class="ask-head-actions">
        <button type="button" class="ask-logout" id="almanac-ask-logout" hidden>${esc(ui(lang, 'askLogout'))}</button>
        <button type="button" class="ask-close" id="almanac-ask-close" aria-label="${esc(ui(lang, 'askClose'))}">×</button>
      </div>
    </header>
    <div class="ask-log" id="almanac-ask-log"></div>
    <div class="ask-suggest">${ui(lang, 'askSuggest')
      .split('|')
      .map((q) => `<button type="button" data-ask="${esc(q.trim())}">${esc(q.trim())}</button>`)
      .join('')}</div>
    <form class="ask-form" id="almanac-ask-form">
      <label class="skip" for="almanac-ask-input">${esc(ui(lang, 'askPlaceholder'))}</label>
      <input id="almanac-ask-input" type="text" autocomplete="off" maxlength="400" placeholder="${esc(ui(lang, 'askPlaceholder'))}">
      <button type="submit">${esc(ui(lang, 'askSend'))}</button>
    </form>
  </aside>
  <script src="/ask-engine.js?v=${ASSET_V}"></script>
  <script src="/client.js?v=${ASSET_V}"></script>
</body>
</html>`;
}

export function card({ href, title, image, meta, pills, search, type, contain }) {
  const pillHtml = (pills || []).filter(Boolean).map((p) => `<span class="pill">${esc(p)}</span>`).join('');
  return `<a class="card" href="${esc(href)}" data-search="${esc(search || title)}" ${type ? `data-type="${esc(type)}"` : ''}>
    <div class="card-media${contain ? ' contain' : ''}" style="${image ? `background-image:url('${esc(image)}')` : ''}"></div>
    <div class="card-body">
      <h3>${esc(title)}</h3>
      ${meta ? `<div class="meta">${esc(meta)}</div>` : ''}
      ${pillHtml ? `<div class="pills">${pillHtml}</div>` : ''}
    </div>
  </a>`;
}

export function stat(label, value) {
  return `<div class="stat"><b>${esc(value)}</b><span>${esc(label)}</span></div>`;
}
