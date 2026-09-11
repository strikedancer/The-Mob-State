import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { LANGS, ui, countryName } from './i18n.mjs';
import { esc, money, page, card, stat } from './layout.mjs';
import { guidePages, guideSitemapPaths, loadHelpTopics, resolveHelpPaths } from './guides.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, cur, i, arr) => {
    if (cur.startsWith('--')) acc.push([cur.slice(2), arr[i + 1]]);
    return acc;
  }, [])
);

const ROOT = path.resolve(__dirname, '..');
const CONTENT = path.resolve(args.content || path.join(ROOT, '..', 'backend', 'content'));
const OUT = path.resolve(args.out || path.join(ROOT, 'dist'));
const HELP_PATHS = resolveHelpPaths(args, ROOT);

function readJson(name) {
  const raw = fs.readFileSync(path.join(CONTENT, name), 'utf8').replace(/^\uFEFF/, '');
  return JSON.parse(raw);
}

function write(rel, html) {
  const file = path.join(OUT, rel);
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, html);
}

function copyAsset(name) {
  fs.copyFileSync(path.join(__dirname, name), path.join(OUT, name));
}

function nameOf(item, lang) {
  if (lang === 'nl') return item.displayName || item.name || item.id;
  return (
    item.name_en ||
    item.nameEn ||
    item.descriptionEn && lang === 'en' && item.name ||
    item.displayName ||
    item.name ||
    item.id
  );
}

function descOf(item, lang) {
  if (lang === 'en') return item.descriptionEn || item.description_en || item.description || '';
  return item.description || item.descriptionEn || item.description_en || '';
}

function img(url) {
  if (!url) return '';
  const clean = String(url).replace(/^assets\//, '').replace(/^images\//, '');
  if (clean.startsWith('/')) return clean;
  return `/images/${clean}`;
}

function vehicleImg(v) {
  const file = v.imageNew || v.image || `${v.id}.png`;
  return `/images/vehicles/${path.basename(file)}`;
}

function factorClass(n) {
  if (n < 0.95) return 'cheap';
  if (n > 1.1) return 'dear';
  return 'mid';
}

function load() {
  const countries = readJson('countries.json');
  const trade = readJson('tradableGoods.json');
  const vehicles = readJson('vehicles.json');
  const weapons = readJson('weapons.json').weapons || [];
  const ammo = readJson('ammo.json').ammo || [];
  const security = readJson('security.json');
  const drugsFile = readJson('drugs.json');
  const facilities = readJson('drug_facilities.json').facilities || {};
  const properties = readJson('properties.json').properties || [];
  const aircraft = readJson('aircraft.json');
  const backpacks = readJson('backpacks.json').backpacks || [];
  const travel = readJson('travelRoutes.json');
  const crimes = readJson('crimes.json').crimes || [];
  const jobs = readJson('jobs.json');
  const crew = readJson('crewBuildings.json');
  const school = readJson('educationTracks.json').tracks || [];
  return {
    countries,
    trade,
    vehicles,
    weapons,
    ammo,
    security,
    drugs: drugsFile.drugs || [],
    materials: drugsFile.materials || [],
    facilities,
    properties,
    aircraft,
    backpacks,
    travel,
    crimes,
    jobs,
    crew,
    school,
  };
}

function homeHubs(lang) {
  const keys = [
    'guide',
    'countries',
    'trade',
    'vehicles',
    'weapons',
    'drugs',
    'materials',
    'facilities',
    'properties',
    'aircraft',
    'backpacks',
    'security',
    'ammo',
    'travel',
    'crimes',
    'jobs',
    'crew',
    'school',
  ];
  return keys
    .map((key) => {
      const href = `${key}/`;
      return card({
        href: `/${lang}/${href}`,
        title: ui(lang, key),
        image: `/images/wiki/hubs/${key}.png`,
        search: ui(lang, key),
      });
    })
    .join('');
}

function countryPages(data, lang) {
  const list = data.countries
    .map((c) =>
      card({
        href: `/${lang}/countries/${c.id}/`,
        title: countryName(lang, c.id),
        image: '/images/backgrounds/login_background.png',
        meta: `${ui(lang, 'travelCost')}: ${money(c.travelCost)}`,
        search: `${countryName(lang, c.id)} ${c.id}`,
      })
    )
    .join('');
  write(
    `${lang}/countries/index.html`,
    page({
      lang,
      path: 'countries/',
      title: ui(lang, 'countries'),
      hero: {
        image: '/images/backgrounds/login_background.png',
        title: ui(lang, 'countries'),
        lead: ui(lang, 'overviewLead'),
      },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/countries/`, label: ui(lang, 'countries') },
      ],
      body: `<div class="grid wide" data-filter-group>${list}<p class="empty" hidden>${esc(ui(lang, 'empty'))}</p></div>`,
    })
  );

  for (const c of data.countries) {
    const goodsHere = data.trade.filter((g) => (g.availableInCountries || []).includes(c.id));
    const carsHere = (data.vehicles.cars || []).filter((v) => (v.availableInCountries || []).includes(c.id));
    const boatsHere = (data.vehicles.boats || []).filter((v) => (v.availableInCountries || []).includes(c.id));
    const bikesHere = (data.vehicles.motorcycles || []).filter((v) => (v.availableInCountries || []).includes(c.id));
    const bonuses = Object.entries(c.tradeBonuses || {}).sort((a, b) => a[1] - b[1]);
    const bonusRows = bonuses
      .map(([id, n]) => {
        const good = data.trade.find((g) => g.id === id);
        return `<tr><td><a href="/${lang}/trade/${id}/">${esc(good ? nameOf(good, lang) : id)}</a></td><td class="${factorClass(n)}">${n.toFixed(2)}</td></tr>`;
      })
      .join('');
    const body = `
      <p class="lede">${esc(descOf(c, lang))}</p>
      <div class="stats" style="margin:18px 0 28px">
        ${stat(ui(lang, 'travelCost'), money(c.travelCost))}
        ${stat(ui(lang, 'trade'), String(goodsHere.length))}
        ${stat(ui(lang, 'cars'), String(carsHere.length))}
        ${stat(ui(lang, 'motorcycles'), String(bikesHere.length))}
        ${stat(ui(lang, 'boats'), String(boatsHere.length))}
      </div>
      <div class="notice">${esc(ui(lang, 'liveNotice'))}</div>
      <div class="section-title"><h2>${esc(ui(lang, 'trade'))}</h2></div>
      <table><thead><tr><th>${esc(ui(lang, 'trade'))}</th><th>${esc(ui(lang, 'factor'))}</th></tr></thead><tbody>${bonusRows}</tbody></table>
      <div class="section-title"><h2>${esc(ui(lang, 'vehicles'))}</h2></div>
      <div class="grid">${[...carsHere, ...boatsHere, ...bikesHere]
        .slice(0, 24)
        .map((v) =>
          card({
            href: `/${lang}/vehicles/${v.id}/`,
            title: nameOf(v, lang),
            image: vehicleImg(v),
            contain: true,
            search: nameOf(v, lang),
          })
        )
        .join('')}</div>
      <p class="meta">${esc(ui(lang, 'sourceCountries'))}: ${goodsHere.map((g) => `<a href="/${lang}/trade/${g.id}/">${esc(nameOf(g, lang))}</a>`).join(' · ')}</p>
    `;
    write(
      `${lang}/countries/${c.id}/index.html`,
      page({
        lang,
        path: `countries/${c.id}/`,
        title: countryName(lang, c.id),
        hero: {
          image: '/images/backgrounds/login_background.png',
          kicker: ui(lang, 'countries'),
          title: countryName(lang, c.id),
          lead: descOf(c, lang),
        },
        crumbs: [
          { href: `/${lang}/`, label: ui(lang, 'home') },
          { href: `/${lang}/countries/`, label: ui(lang, 'countries') },
          { href: `/${lang}/countries/${c.id}/`, label: countryName(lang, c.id) },
        ],
        body,
      })
    );
  }
}

function tradePages(data, lang) {
  const list = data.trade
    .map((g) =>
      card({
        href: `/${lang}/trade/${g.id}/`,
        title: nameOf(g, lang),
        image: `/images/trade_goods/cards/${g.id}.png`,
        meta: `${ui(lang, g.category) || g.category} · ${money(g.basePrice)}`,
        pills: [g.category, `T${g.tier}`],
        search: `${nameOf(g, lang)} ${g.id} ${g.category}`,
        type: g.category,
        contain: true,
      })
    )
    .join('');
  const filters = ['all', 'starter', 'bulk', 'luxury', 'dangerous']
    .map(
      (k, i) =>
        `<button data-filter="${k}" class="${i === 0 ? 'active' : ''}">${esc(k === 'all' ? ui(lang, 'all') : ui(lang, k))}</button>`
    )
    .join('');
  write(
    `${lang}/trade/index.html`,
    page({
      lang,
      path: 'trade/',
      title: ui(lang, 'trade'),
      hero: {
        image: '/images/backgrounds/smuggling_hub_bg_desktop.png',
        title: ui(lang, 'trade'),
        lead: ui(lang, 'liveNotice'),
      },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/trade/`, label: ui(lang, 'trade') },
      ],
      body: `<div class="filters" data-filter-bar="trade">${filters}</div>
        <div class="grid wide" data-kind="trade" data-filter-group>${list}<p class="empty" hidden>${esc(ui(lang, 'empty'))}</p></div>`,
    })
  );

  for (const g of data.trade) {
    const rows = data.countries
      .map((c) => {
        const n = c.tradeBonuses?.[g.id] ?? 1;
        return { c, n };
      })
      .sort((a, b) => a.n - b.n);
    const sources = new Set(g.availableInCountries || []);
    const table = rows
      .map(
        ({ c, n }) => `<tr>
          <td><a href="/${lang}/countries/${c.id}/">${esc(countryName(lang, c.id))}</a></td>
          <td class="${factorClass(n)}">${n.toFixed(2)}</td>
          <td>${sources.has(c.id) ? esc(ui(lang, 'sourceCountries')) : '—'}</td>
        </tr>`
      )
      .join('');
    const cheapest = rows.slice(0, 3).map((r) => countryName(lang, r.c.id)).join(', ');
    const dearest = rows.slice(-3).reverse().map((r) => countryName(lang, r.c.id)).join(', ');
    write(
      `${lang}/trade/${g.id}/index.html`,
      page({
        lang,
        path: `trade/${g.id}/`,
        title: nameOf(g, lang),
        description: descOf(g, lang),
        hero: {
          image: `/images/trade_goods/cards/${g.id}.png`,
          kicker: ui(lang, 'trade'),
          title: nameOf(g, lang),
          lead: descOf(g, lang),
        },
        crumbs: [
          { href: `/${lang}/`, label: ui(lang, 'home') },
          { href: `/${lang}/trade/`, label: ui(lang, 'trade') },
          { href: `/${lang}/trade/${g.id}/`, label: nameOf(g, lang) },
        ],
        body: `<div class="detail">
          <div class="portrait"><img src="/images/trade_goods/cards/${esc(g.id)}.png" alt="${esc(nameOf(g, lang))}"></div>
          <div>
            <p class="lede">${esc(descOf(g, lang))}</p>
            <div class="stats">
              ${stat(ui(lang, 'price'), money(g.basePrice))}
              ${stat(ui(lang, 'category'), ui(lang, g.category) || g.category)}
              ${stat('Tier', String(g.tier))}
              ${stat(ui(lang, 'slots'), String(g.weight || 1))}
            </div>
            <p class="meta">${esc(ui(lang, 'typicalCheap'))}: ${esc(cheapest)}</p>
            <p class="meta">${esc(ui(lang, 'typicalDear'))}: ${esc(dearest)}</p>
            <p class="meta">${esc(ui(lang, 'sourceCountries'))}: ${(g.availableInCountries || [])
              .map((id) => `<a href="/${lang}/countries/${id}/">${esc(countryName(lang, id))}</a>`)
              .join(' · ')}</p>
          </div>
        </div>
        <div class="notice">${esc(ui(lang, 'liveNotice'))}</div>
        <table><thead><tr><th>${esc(ui(lang, 'countries'))}</th><th>${esc(ui(lang, 'factor'))}</th><th></th></tr></thead><tbody>${table}</tbody></table>`,
      })
    );
  }
}

function allVehicles(data) {
  const tag = (list, kind) => (list || []).map((v) => ({ ...v, _kind: kind }));
  return [
    ...tag(data.vehicles.cars, 'cars'),
    ...tag(data.vehicles.boats, 'boats'),
    ...tag(data.vehicles.motorcycles, 'motorcycles'),
  ];
}

function vehiclePages(data, lang) {
  const items = allVehicles(data);
  const filters = ['all', 'cars', 'boats', 'motorcycles']
    .map(
      (k, i) =>
        `<button data-filter="${k}" class="${i === 0 ? 'active' : ''}">${esc(k === 'all' ? ui(lang, 'all') : ui(lang, k))}</button>`
    )
    .join('');
  const list = items
    .map((v) =>
      card({
        href: `/${lang}/vehicles/${v.id}/`,
        title: nameOf(v, lang),
        image: vehicleImg(v),
        meta: `${ui(lang, v._kind)} · ${money(v.baseValue || v.marketValue?.netherlands || 0)}`,
        pills: [v.type, `${ui(lang, 'rank')} ${v.requiredRank || 1}`],
        search: `${nameOf(v, lang)} ${v.id} ${v.type} ${v._kind}`,
        type: v._kind,
        contain: true,
      })
    )
    .join('');
  write(
    `${lang}/vehicles/index.html`,
    page({
      lang,
      path: 'vehicles/',
      title: ui(lang, 'vehicles'),
      hero: {
        image: '/images/backgrounds/garage_background.png',
        title: ui(lang, 'vehicles'),
        lead: ui(lang, 'overviewLead'),
      },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/vehicles/`, label: ui(lang, 'vehicles') },
      ],
      body: `<div class="filters" data-filter-bar="vehicles">${filters}</div>
        <div class="grid" data-kind="vehicles" data-filter-group>${list}<p class="empty" hidden>${esc(ui(lang, 'empty'))}</p></div>`,
    })
  );
  for (const v of items) {
    const countries = (v.availableInCountries || [])
      .map((id) => `<a href="/${lang}/countries/${id}/">${esc(countryName(lang, id))}</a>`)
      .join(' · ');
    const market = Object.entries(v.marketValue || {})
      .map(([id, p]) => `<tr><td>${esc(countryName(lang, id))}</td><td>${money(p)}</td></tr>`)
      .join('');
    write(
      `${lang}/vehicles/${v.id}/index.html`,
      page({
        lang,
        path: `vehicles/${v.id}/`,
        title: nameOf(v, lang),
        description: descOf(v, lang),
        hero: {
          image: vehicleImg(v),
          kicker: ui(lang, v._kind),
          title: nameOf(v, lang),
          lead: descOf(v, lang),
        },
        crumbs: [
          { href: `/${lang}/`, label: ui(lang, 'home') },
          { href: `/${lang}/vehicles/`, label: ui(lang, 'vehicles') },
          { href: `/${lang}/vehicles/${v.id}/`, label: nameOf(v, lang) },
        ],
        body: `<div class="detail">
          <div class="portrait"><img src="${esc(vehicleImg(v))}" alt="${esc(nameOf(v, lang))}"></div>
          <div>
            <p class="lede">${esc(descOf(v, lang))}</p>
            <div class="stats">
              ${stat(ui(lang, 'speed'), v.stats?.speed ?? '—')}
              ${stat(ui(lang, 'armor'), v.stats?.armor ?? '—')}
              ${stat(ui(lang, 'cargo'), v.stats?.cargo ?? '—')}
              ${stat(ui(lang, 'stealth'), v.stats?.stealth ?? '—')}
              ${stat(ui(lang, 'rank'), v.requiredRank ?? 1)}
              ${stat(ui(lang, 'price'), money(v.baseValue))}
            </div>
            <p class="meta">${esc(ui(lang, 'availableIn'))}: ${countries || '—'}</p>
          </div>
        </div>
        ${market ? `<div class="section-title"><h2>${esc(ui(lang, 'price'))}</h2></div><table><tbody>${market}</tbody></table>` : ''}`,
      })
    );
  }
}

function simpleCatalog(lang, key, heroImg, items, hrefOf, imgOf, extra) {
  const list = items
    .map((item) =>
      card({
        href: hrefOf(item),
        title: nameOf(item, lang),
        image: imgOf(item),
        meta: extra?.(item),
        search: `${nameOf(item, lang)} ${item.id || item.type}`,
        contain: true,
      })
    )
    .join('');
  write(
    `${lang}/${key}/index.html`,
    page({
      lang,
      path: `${key}/`,
      title: ui(lang, key),
      hero: { image: heroImg, title: ui(lang, key), lead: ui(lang, 'overviewLead') },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/${key}/`, label: ui(lang, key) },
      ],
      body: `<div class="grid wide" data-filter-group>${list}<p class="empty" hidden>${esc(ui(lang, 'empty'))}</p></div>`,
    })
  );
}

function detailPage(lang, key, item, heroImg, body) {
  write(
    `${lang}/${key}/${item.id || item.type}/index.html`,
    page({
      lang,
      path: `${key}/${item.id || item.type}/`,
      title: nameOf(item, lang),
      description: descOf(item, lang),
      hero: {
        image: heroImg,
        kicker: ui(lang, key),
        title: nameOf(item, lang),
        lead: descOf(item, lang),
      },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/${key}/`, label: ui(lang, key) },
        { href: `/${lang}/${key}/${item.id || item.type}/`, label: nameOf(item, lang) },
      ],
      body,
    })
  );
}

function restPages(data, lang) {
  simpleCatalog(
    lang,
    'weapons',
    '/images/backgrounds/weapon_shop_bg.png',
    data.weapons,
    (w) => `/${lang}/weapons/${w.id}/`,
    (w) => img(w.image) || `/images/weapons/${w.id}.png`,
    (w) => `${ui(lang, 'damage')} ${w.damage} · ${money(w.price)}`
  );
  for (const w of data.weapons) {
    const src = img(w.image) || `/images/weapons/${w.id}.png`;
    detailPage(
      lang,
      'weapons',
      w,
      src,
      `<div class="detail"><div class="portrait"><img src="${esc(src)}" alt=""></div><div>
        <p class="lede">${esc(descOf(w, lang))}</p>
        <div class="stats">
          ${stat(ui(lang, 'damage'), w.damage)}
          ${stat(ui(lang, 'intimidation'), w.intimidation)}
          ${stat(ui(lang, 'rank'), w.requiredRank)}
          ${stat(ui(lang, 'price'), money(w.price))}
          ${stat(ui(lang, 'ammoType'), w.ammoType || '—')}
        </div>
      </div></div>`
    );
  }

  simpleCatalog(
    lang,
    'ammo',
    '/images/backgrounds/ammo_factory_bg.png',
    data.ammo.map((a) => ({ ...a, id: a.type, name: a.name })),
    (a) => `/${lang}/ammo/`,
    () => '/images/backgrounds/ammo_factory_bg.png',
    (a) => `${money(a.pricePerRound)} / rd`
  );

  simpleCatalog(
    lang,
    'security',
    '/images/backgrounds/weapon_shop_bg.png',
    data.security,
    (s) => `/${lang}/security/${s.id}/`,
    (s) => `/images/security/${s.id}.png`,
    (s) => `${ui(lang, 'armor')} ${s.armor} · ${money(s.price)}`
  );
  for (const s of data.security) {
    detailPage(
      lang,
      'security',
      s,
      `/images/security/${s.id}.png`,
      `<div class="detail"><div class="portrait"><img src="/images/security/${esc(s.id)}.png" alt="" onerror="this.parentElement.style.display='none'"></div><div>
        <p class="lede">${esc(descOf(s, lang))}</p>
        <div class="stats">${stat(ui(lang, 'armor'), s.armor)}${stat(ui(lang, 'price'), money(s.price))}</div>
      </div></div>`
    );
  }

  simpleCatalog(
    lang,
    'drugs',
    '/images/backgrounds/drug_environment_desktop.png',
    data.drugs,
    (d) => `/${lang}/drugs/${d.id}/`,
    (d) => `/images/drugs/${d.id}.png`,
    (d) => `${money(d.basePrice)} · ${ui(lang, 'rank')} ${d.requiredRank}`
  );
  for (const d of data.drugs) {
    const mats = Object.entries(d.materials || {})
      .map(([id, n]) => {
        const mat = data.materials.find((m) => m.id === id);
        return `<a href="/${lang}/materials/${id}/">${esc(mat ? nameOf(mat, lang) : id)}</a> × ${n}`;
      })
      .join(' · ');
    const prices = Object.entries(d.countryPricing || {})
      .sort((a, b) => a[1] - b[1])
      .map(([id, p]) => `<tr><td><a href="/${lang}/countries/${id}/">${esc(countryName(lang, id))}</a></td><td>${money(p)}</td></tr>`)
      .join('');
    detailPage(
      lang,
      'drugs',
      d,
      `/images/drugs/${d.id}.png`,
      `<div class="detail"><div class="portrait"><img src="/images/drugs/${esc(d.id)}.png" alt=""></div><div>
        <p class="lede">${esc(descOf(d, lang))}</p>
        <div class="stats">
          ${stat(ui(lang, 'price'), money(d.basePrice))}
          ${stat(ui(lang, 'rank'), d.requiredRank)}
          ${stat(ui(lang, 'yield'), `${d.yieldMin}–${d.yieldMax}`)}
        </div>
        <p class="meta">${esc(ui(lang, 'materials'))}: ${mats}</p>
      </div></div>
      <div class="notice">${esc(ui(lang, 'liveNotice'))}</div>
      <table><thead><tr><th>${esc(ui(lang, 'countries'))}</th><th>${esc(ui(lang, 'price'))}</th></tr></thead><tbody>${prices}</tbody></table>`
    );
  }

  simpleCatalog(
    lang,
    'materials',
    '/images/backgrounds/drug_production_bg.png',
    data.materials,
    (m) => `/${lang}/materials/${m.id}/`,
    (m) => `/images/materials/${m.id}.png`,
    (m) => `${m.category} · ${money(m.price)}`
  );
  for (const m of data.materials) {
    detailPage(
      lang,
      'materials',
      m,
      `/images/materials/${m.id}.png`,
      `<div class="detail"><div class="portrait"><img src="/images/materials/${esc(m.id)}.png" alt=""></div><div>
        <p class="lede">${esc(descOf(m, lang))}</p>
        <div class="stats">${stat(ui(lang, 'price'), money(m.price))}${stat(ui(lang, 'category'), m.category)}</div>
      </div></div>`
    );
  }

  const facItems = Object.values(data.facilities).map((f) => ({ ...f, name: f.displayName || f.name }));
  simpleCatalog(
    lang,
    'facilities',
    '/images/backgrounds/drug_facility_bg.png',
    facItems,
    (f) => `/${lang}/facilities/${f.id}/`,
    (f) => `/images/facilities/${f.icon || f.id}.png`,
    (f) => money(f.purchasePrice)
  );
  for (const f of facItems) {
    detailPage(
      lang,
      'facilities',
      f,
      `/images/facilities/${f.icon || f.id}.png`,
      `<p class="lede">${esc(descOf(f, lang) || f.description)}</p>
       <div class="stats">${stat(ui(lang, 'price'), money(f.purchasePrice))}${stat(ui(lang, 'rank'), f.requiredRank)}</div>`
    );
  }

  simpleCatalog(
    lang,
    'properties',
    '/images/backgrounds/nightclub_hub_bg_desktop.png',
    data.properties,
    (p) => `/${lang}/properties/${p.id}/`,
    (p) => `/images/properties/${p.image || p.id + '.png'}`,
    (p) => money(p.basePrice)
  );
  for (const p of data.properties) {
    const src = `/images/properties/${p.image || p.id + '.png'}`;
    detailPage(
      lang,
      'properties',
      p,
      src,
      `<div class="detail"><div class="portrait"><img src="${esc(src)}" alt=""></div><div>
        <p class="lede">${esc(descOf(p, lang))}</p>
        <div class="stats">
          ${stat(ui(lang, 'price'), money(p.basePrice))}
          ${stat(ui(lang, 'income'), money(p.baseIncome))}
          ${stat(ui(lang, 'storage'), (p.storageCapacity || [])[0] ?? '—')}
          ${stat(ui(lang, 'rank'), p.minLevel)}
        </div>
      </div></div>`
    );
  }

  simpleCatalog(
    lang,
    'aircraft',
    '/images/aircraft/citation_x.png',
    data.aircraft,
    (a) => `/${lang}/aircraft/${a.id}/`,
    (a) => `/images/aircraft/${a.id}.png`,
    (a) => money(a.price)
  );
  for (const a of data.aircraft) {
    detailPage(
      lang,
      'aircraft',
      a,
      `/images/aircraft/${a.id}.png`,
      `<div class="detail"><div class="portrait"><img src="/images/aircraft/${esc(a.id)}.png" alt=""></div><div>
        <p class="lede">${esc(lang === 'en' ? a.description_en || a.description : a.description)}</p>
        <div class="stats">
          ${stat(ui(lang, 'price'), money(a.price))}
          ${stat(ui(lang, 'rank'), a.minRank)}
          ${stat(ui(lang, 'range'), `${a.maxRange} km`)}
          ${stat(ui(lang, 'cargo'), a.cargoCapacity)}
        </div>
      </div></div>`
    );
  }

  simpleCatalog(
    lang,
    'backpacks',
    '/images/backgrounds/smuggling_hub_bg.png',
    data.backpacks,
    (b) => `/${lang}/backpacks/${b.id}/`,
    () => '/images/backgrounds/smuggling_hub_bg.png',
    (b) => `+${b.slots} · ${money(b.price)}`
  );
  for (const b of data.backpacks) {
    detailPage(
      lang,
      'backpacks',
      b,
      '/images/backgrounds/smuggling_hub_bg.png',
      `<p class="lede">${esc(descOf(b, lang))}</p>
       <div class="stats">${stat(ui(lang, 'slots'), `+${b.slots}`)}${stat(ui(lang, 'price'), money(b.price))}${stat(ui(lang, 'rank'), b.requiredRank)}${stat(ui(lang, 'vip'), b.vipOnly ? ui(lang, 'vip') : '—')}</div>`
    );
  }

  const crimeItems = data.crimes.map((c) => ({ ...c, name: c.name }));
  simpleCatalog(
    lang,
    'crimes',
    '/images/backgrounds/crime_background.png',
    crimeItems,
    (c) => `/${lang}/crimes/${c.id}/`,
    (c) => `/images/crimes/${c.id}_crime.png`,
    (c) => `${money(c.minReward)}–${money(c.maxReward)}`
  );
  for (const c of crimeItems) {
    detailPage(
      lang,
      'crimes',
      c,
      `/images/crimes/${c.id}_crime.png`,
      `<p class="lede">${esc(descOf(c, lang))}</p>
       <div class="stats">${stat(ui(lang, 'rank'), c.minLevel)}${stat(ui(lang, 'price'), `${money(c.minReward)}–${money(c.maxReward)}`)}</div>`
    );
  }

  simpleCatalog(
    lang,
    'jobs',
    '/images/backgrounds/jobs_background.png',
    data.jobs,
    (j) => `/${lang}/jobs/${j.id}/`,
    (j) => `/images/jobs/${j.id}_job.png`,
    (j) => `${money(j.minEarnings)}–${money(j.maxEarnings)}`
  );
  for (const j of data.jobs) {
    detailPage(
      lang,
      'jobs',
      j,
      `/images/jobs/${j.id}_job.png`,
      `<p class="lede">${esc(descOf(j, lang))}</p>
       <div class="stats">${stat(ui(lang, 'rank'), j.minLevel)}${stat(ui(lang, 'income'), `${money(j.minEarnings)}–${money(j.maxEarnings)}`)}</div>`
    );
  }

  const crewItems = Object.entries(data.crew.buildings || {}).map(([id, b]) => ({
    id,
    name: b.label,
    description: b.label,
    levels: b.levels,
  }));
  simpleCatalog(
    lang,
    'crew',
    '/images/crew_buildings/cash/city/lvl_5.png',
    crewItems,
    (b) => `/${lang}/crew/${b.id}/`,
    (b) => `/images/crew_buildings/${b.id.replace('_storage', '').replace('car', 'car')}/city/lvl_5.png`,
    (b) => `${(b.levels || []).length} lvl`
  );
  for (const b of crewItems) {
    const rows = (b.levels || [])
      .map((lv) => `<tr><td>${lv.level}</td><td>${money(lv.upgradeCost)}</td><td>${lv.capacity ?? lv.memberCap ?? '—'}${lv.requiresVip ? ` · ${ui(lang, 'vip')}` : ''}</td></tr>`)
      .join('');
    detailPage(
      lang,
      'crew',
      b,
      '/images/crew_buildings/cash/city/lvl_5.png',
      `<table><thead><tr><th>Lvl</th><th>${esc(ui(lang, 'price'))}</th><th></th></tr></thead><tbody>${rows}</tbody></table>`
    );
  }

  simpleCatalog(
    lang,
    'school',
    '/images/backgrounds/courtroom_background.png',
    data.school,
    (t) => `/${lang}/school/${t.id}/`,
    () => '/images/backgrounds/courtroom_background.png',
    (t) => t.name
  );
  for (const t of data.school) {
    const certs = (t.certifications || []).map((c) => `<li>${esc(c.name)} (${ui(lang, 'rank')} ${c.requiredLevel})</li>`).join('');
    detailPage(
      lang,
      'school',
      t,
      '/images/backgrounds/courtroom_background.png',
      `<p class="lede">${esc(t.description)}</p><ul>${certs}</ul>`
    );
  }

  const hubList = (data.travel.hubs || []).map((id) => `<a href="/${lang}/countries/${id}/">${esc(countryName(lang, id))}</a>`).join(' · ');
  const routeRows = Object.entries(data.travel.directRoutes || {})
    .map(
      ([from, tos]) =>
        `<tr><td><a href="/${lang}/countries/${from}/">${esc(countryName(lang, from))}</a></td><td>${tos
          .map((id) => `<a href="/${lang}/countries/${id}/">${esc(countryName(lang, id))}</a>`)
          .join(' · ')}</td></tr>`
    )
    .join('');
  write(
    `${lang}/travel/index.html`,
    page({
      lang,
      path: 'travel/',
      title: ui(lang, 'travel'),
      hero: {
        image: '/images/backgrounds/marina_background.png',
        title: ui(lang, 'travel'),
        lead: ui(lang, 'overviewLead'),
      },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/travel/`, label: ui(lang, 'travel') },
      ],
      body: `<p class="lede">${esc(ui(lang, 'hubs'))}: ${hubList}</p>
        <div class="notice">${esc(ui(lang, 'liveNotice'))}</div>
        <table><thead><tr><th>${esc(ui(lang, 'countries'))}</th><th>${esc(ui(lang, 'direct'))}</th></tr></thead><tbody>${routeRows}</tbody></table>`,
    })
  );
}

function rootIndex() {
  write(
    'index.html',
    `<!doctype html><html><head><meta charset="utf-8"><title>The Mob State Almanac</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script>
const langs = ${JSON.stringify(LANGS)};
const stored = localStorage.getItem('tms-wiki-lang');
const nav = (navigator.language || 'en').slice(0,2).toLowerCase();
const lang = langs.includes(stored) ? stored : (langs.includes(nav) ? nav : 'en');
location.replace('/' + lang + '/');
</script></head><body></body></html>`
  );
}

function robotsAndSitemap() {
  write(
    'robots.txt',
    `User-agent: *\nAllow: /\nSitemap: https://wiki.themobstate.com/sitemap.xml\n`
  );
  const urls = [];
  for (const lang of LANGS) {
    urls.push(`https://wiki.themobstate.com/${lang}/`);
    for (const p of [
      ...guideSitemapPaths(help),
      'countries',
      'trade',
      'vehicles',
      'weapons',
      'ammo',
      'security',
      'drugs',
      'materials',
      'facilities',
      'properties',
      'aircraft',
      'backpacks',
      'travel',
      'crimes',
      'jobs',
      'crew',
      'school',
    ]) {
      urls.push(`https://wiki.themobstate.com/${lang}/${p}/`);
    }
  }
  write(
    'sitemap.xml',
    `<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${urls
      .map((u) => `<url><loc>${u}</loc></url>`)
      .join('')}</urlset>`
  );
}

const data = load();
const help = loadHelpTopics(HELP_PATHS.l10n, HELP_PATHS.helpIndex);
fs.rmSync(OUT, { recursive: true, force: true });
fs.mkdirSync(OUT, { recursive: true });
copyAsset('theme.css');
copyAsset('client.js');
rootIndex();
robotsAndSitemap();

for (const lang of LANGS) {
  write(
    `${lang}/index.html`,
    page({
      lang,
      path: '',
        title: ui(lang, 'heroTitle'),
      hero: {
        image: '/images/backgrounds/login_background.png',
        kicker: ui(lang, 'heroKicker'),
        title: ui(lang, 'heroTitle'),
        lead: ui(lang, 'heroLead'),
      },
      body: `<p class="lede">${esc(ui(lang, 'overviewLead'))}</p>
        <div class="notice">${esc(ui(lang, 'liveNotice'))}</div>
        <div class="section-title"><h2>${esc(ui(lang, 'browse'))}</h2></div>
        <div class="grid wide">${homeHubs(lang)}</div>`,
    })
  );
  countryPages(data, lang);
  tradePages(data, lang);
  vehiclePages(data, lang);
  restPages(data, lang);
  guidePages(help, lang, write);
}

console.log(`Almanac built → ${OUT}`);
