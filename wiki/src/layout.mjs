import { LANGS, LANG_LABEL, ui } from './i18n.mjs';

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
  <link rel="stylesheet" href="/theme.css">
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
      <input class="search" id="almanac-search" type="search" placeholder="${esc(ui(lang, 'search'))}">
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
  <script src="/client.js"></script>
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
