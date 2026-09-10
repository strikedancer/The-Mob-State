import fs from 'fs';
import path from 'path';
import { LANGS, ui } from './i18n.mjs';
import { esc, page, card } from './layout.mjs';

export function idToPascal(id) {
  return id
    .split('-')
    .map((s) => s.charAt(0).toUpperCase() + s.slice(1))
    .join('');
}

export function resolveHelpPaths(args, root) {
  return {
    l10n: path.resolve(args.l10n || process.env.WIKI_L10N || path.join(root, '..', 'client', 'lib', 'l10n')),
    helpIndex: path.resolve(
      args['help-index'] ||
        process.env.WIKI_HELP_INDEX ||
        path.join(root, '..', 'client', 'lib', 'data', 'help_content.dart')
    ),
  };
}

export function loadHelpTopics(l10nDir, helpIndexPath) {
  if (!fs.existsSync(helpIndexPath)) {
    throw new Error(`wiki: missing help index ${helpIndexPath}`);
  }
  const dart = fs.readFileSync(helpIndexPath, 'utf8');
  const ids = [...dart.matchAll(/id:\s*'([^']+)'/g)].map((m) => m[1]);
  if (!ids.length) throw new Error('wiki: no help topic ids in help_content.dart');
  const arbs = {};
  for (const lang of LANGS) {
    const file = path.join(l10nDir, `app_${lang}.arb`);
    if (!fs.existsSync(file)) {
      throw new Error(`wiki: missing ARB ${file}`);
    }
    arbs[lang] = JSON.parse(fs.readFileSync(file, 'utf8').replace(/^\uFEFF/, ''));
  }
  return { ids, arbs };
}

export function topicField(arbs, lang, id, part) {
  const key = `helpTopic${idToPascal(id)}${part}`;
  const row = arbs[lang] || arbs.en;
  const value = row[key] || arbs.en[key] || '';
  return String(value);
}

function bullets(text) {
  return String(text)
    .split('\n')
    .map((s) => s.trim())
    .filter(Boolean);
}

function topicImage(id) {
  if (id === 'profile') return '/images/wiki/hubs/profile.png';
  return '/images/wiki/hubs/guide.png';
}

function renderList(items) {
  if (!items.length) return '';
  return `<ul>${items.map((item) => `<li>${esc(item)}</li>`).join('')}</ul>`;
}

export function guidePages(help, lang, write) {
  const groups = new Map();
  for (const id of help.ids) {
    const category = topicField(help.arbs, lang, id, 'Category') || ui(lang, 'guide');
    if (!groups.has(category)) groups.set(category, []);
    groups.get(category).push(id);
  }

  const featured = help.ids.includes('profile') ? ['profile'] : [];
  const featuredHtml = featured
    .map((id) =>
      card({
        href: `/${lang}/guide/${id}/`,
        title: topicField(help.arbs, lang, id, 'Title'),
        image: topicImage(id),
        meta: topicField(help.arbs, lang, id, 'Summary'),
        search: `${topicField(help.arbs, lang, id, 'Title')} ${topicField(help.arbs, lang, id, 'Summary')}`,
      })
    )
    .join('');

  const sections = [...groups.entries()]
    .map(([category, ids]) => {
      const cards = ids
        .map((id) =>
          card({
            href: `/${lang}/guide/${id}/`,
            title: topicField(help.arbs, lang, id, 'Title'),
            image: topicImage(id),
            meta: topicField(help.arbs, lang, id, 'Summary'),
            pills: [category],
            search: `${topicField(help.arbs, lang, id, 'Title')} ${topicField(help.arbs, lang, id, 'Summary')} ${topicField(help.arbs, lang, id, 'How')}`,
          })
        )
        .join('');
      return `<div class="section-title"><h2>${esc(category)}</h2></div>
        <div class="grid wide" data-filter-group>${cards}</div>`;
    })
    .join('');

  write(
    `${lang}/guide/index.html`,
    page({
      lang,
      path: 'guide/',
      title: ui(lang, 'guide'),
      hero: {
        image: '/images/wiki/hubs/guide.png',
        title: ui(lang, 'guide'),
        lead: ui(lang, 'guideLead'),
      },
      crumbs: [
        { href: `/${lang}/`, label: ui(lang, 'home') },
        { href: `/${lang}/guide/`, label: ui(lang, 'guide') },
      ],
      body: `<p class="lede">${esc(ui(lang, 'guideLead'))}</p>
        ${
          featuredHtml
            ? `<div class="section-title"><h2>${esc(ui(lang, 'guideFeatured'))}</h2></div>
        <div class="grid wide">${featuredHtml}</div>`
            : ''
        }
        ${sections}`,
    })
  );

  for (const id of help.ids) {
    const title = topicField(help.arbs, lang, id, 'Title');
    const summary = topicField(help.arbs, lang, id, 'Summary');
    const how = bullets(topicField(help.arbs, lang, id, 'How'));
    const tips = bullets(topicField(help.arbs, lang, id, 'Tips'));
    write(
      `${lang}/guide/${id}/index.html`,
      page({
        lang,
        path: `guide/${id}/`,
        title,
        description: summary,
        hero: {
          image: topicImage(id),
          title,
          lead: summary,
        },
        crumbs: [
          { href: `/${lang}/`, label: ui(lang, 'home') },
          { href: `/${lang}/guide/`, label: ui(lang, 'guide') },
          { href: `/${lang}/guide/${id}/`, label: title },
        ],
        body: `<div class="manual">
          <p class="lede">${esc(summary)}</p>
          <h2>${esc(ui(lang, 'howItWorks'))}</h2>
          ${renderList(how)}
          <h2>${esc(ui(lang, 'tips'))}</h2>
          ${renderList(tips)}
        </div>`,
      })
    );
  }
}

export function guideSitemapPaths(help) {
  const paths = ['guide'];
  for (const id of help.ids) paths.push(`guide/${id}`);
  return paths;
}
