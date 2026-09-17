const SEARCH = document.getElementById('almanac-search');
const LANG = document.documentElement.lang || 'en';

function escHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function cardText(card) {
  return (card.getAttribute('data-search') || card.textContent || '').toLowerCase();
}

function applyCardFilter(q) {
  const query = (q || '').trim().toLowerCase();
  document.querySelectorAll('[data-search]').forEach((el) => {
    el.hidden = query && !cardText(el).includes(query);
  });
  document.querySelectorAll('[data-filter-group]').forEach((group) => {
    const visible = [...group.querySelectorAll('[data-search]')].some((n) => !n.hidden);
    const empty = group.querySelector('.empty');
    if (empty) empty.hidden = visible;
  });
}

let searchIndex = null;
let searchIndexPromise = null;
let activeIndex = -1;

function loadSearchIndex() {
  if (searchIndexPromise) return searchIndexPromise;
  const url = SEARCH?.dataset.index || `/${LANG}/search.json`;
  searchIndexPromise = fetch(url)
    .then((res) => {
      if (!res.ok) throw new Error('search index missing');
      return res.json();
    })
    .then((data) => {
      searchIndex = Array.isArray(data) ? data : [];
      return searchIndex;
    })
    .catch(() => {
      searchIndexPromise = null;
      searchIndex = [];
      return searchIndex;
    });
  return searchIndexPromise;
}

const STOP = new Set(
  'hoe wat waar wanneer waarom welke wie is zijn de het een van voor met naar op in uit bij om tot dat die dit als kan kun moet mag wel niet ik je we ze en of maar ook nog al mijn jouw onze even iets help uitleg vertel leg werkt werk doe doet over how what where when why which who are the a an of for with to from at do does can you we my me tell explain about work works working please wie was der das und oder funktioniert comment quoi quel quelle est les des une pour avec dans como que cual donde para con una los las come cosa quale dove perche nel jak co gdzie dlaczego czy dla jest o onde uma os as'.split(
    /\s+/
  )
);

function tokensOf(raw) {
  const words = String(raw || '')
    .toLowerCase()
    .normalize('NFD')
    .replace(/\p{M}/gu, '')
    .replace(/[^\p{L}\p{N}]+/gu, ' ')
    .split(/\s+/)
    .filter(Boolean);
  const kept = words.filter(
    (t) => (t.length >= 3 || ['don', 'vip', 'xp', 'fbi', 'rld', 'hp'].includes(t)) && !STOP.has(t)
  );
  return kept.length ? kept : words.filter((t) => t.length >= 2);
}

function hay(value) {
  return String(value || '')
    .toLowerCase()
    .replace(/-/g, ' ');
}

function scoreEntry(entry, query) {
  if (!query) return 0;
  const needle = hay(query);
  const title = hay(entry.title);
  const snippet = hay(entry.snippet);
  const answer = hay(entry.answer);
  const text = hay(entry.text);
  if (title === needle) return 100;
  if (title.startsWith(needle)) return 90;
  if (title.includes(needle)) return 80;
  if (snippet.includes(needle)) return 50;
  if (answer.includes(needle)) return 36;
  if (text.includes(needle)) return 20;
  return 0;
}

function rankEntries(index, raw, limit = 12) {
  const query = (raw || '').trim().toLowerCase();
  const tokens = tokensOf(query);
  return index
    .map((entry) => {
      let score = scoreEntry(entry, query);
      for (const token of tokens) score += scoreEntry(entry, token);
      if (tokens.length > 1) score += scoreEntry(entry, tokens.join(' '));
      if (score > 0 && (entry.kind === 'guide' || (entry.href || '').includes('/guide/'))) score += 14;
      return { entry, score };
    })
    .filter((row) => row.score > 0)
    .sort((a, b) => b.score - a.score || a.entry.title.localeCompare(b.entry.title))
    .slice(0, limit);
}

function resultsBox() {
  let box = document.getElementById('almanac-search-results');
  if (box) return box;
  box = document.createElement('div');
  box.id = 'almanac-search-results';
  box.className = 'search-results';
  box.hidden = true;
  box.setAttribute('role', 'listbox');
  SEARCH.parentElement.appendChild(box);
  return box;
}

function hideResults() {
  const box = document.getElementById('almanac-search-results');
  if (box) {
    box.hidden = true;
    box.innerHTML = '';
  }
  activeIndex = -1;
}

function renderResults(items) {
  const box = resultsBox();
  const emptyLabel = SEARCH?.dataset.empty || '—';
  if (!items.length) {
    box.innerHTML = `<p class="search-empty">${emptyLabel}</p>`;
    box.hidden = false;
    activeIndex = -1;
    return;
  }
  box.innerHTML = items
    .map(
      (item, i) =>
        `<a role="option" data-i="${i}" href="${escHtml(item.href)}"><strong>${escHtml(item.title)}</strong>${
          item.snippet ? `<span>${escHtml(item.snippet)}</span>` : ''
        }</a>`
    )
    .join('');
  box.hidden = false;
  activeIndex = 0;
  highlightActive();
}

function highlightActive() {
  const box = document.getElementById('almanac-search-results');
  if (!box) return;
  [...box.querySelectorAll('a')].forEach((a, i) => {
    a.classList.toggle('active', i === activeIndex);
  });
}

async function runSearch(raw) {
  const query = (raw || '').trim().toLowerCase();
  applyCardFilter(query);
  if (!query) {
    hideResults();
    return;
  }
  const index = await loadSearchIndex();
  renderResults(rankEntries(index, query, 12).map((row) => row.entry));
}

if (SEARCH) {
  SEARCH.addEventListener('focus', () => {
    loadSearchIndex();
  });
  SEARCH.addEventListener('input', () => runSearch(SEARCH.value));
  SEARCH.addEventListener('keydown', (event) => {
    const box = document.getElementById('almanac-search-results');
    const links = box && !box.hidden ? [...box.querySelectorAll('a')] : [];
    if (event.key === 'Escape') {
      hideResults();
      SEARCH.blur();
      return;
    }
    if (!links.length) return;
    if (event.key === 'ArrowDown') {
      event.preventDefault();
      activeIndex = Math.min(links.length - 1, activeIndex + 1);
      highlightActive();
    } else if (event.key === 'ArrowUp') {
      event.preventDefault();
      activeIndex = Math.max(0, activeIndex - 1);
      highlightActive();
    } else if (event.key === 'Enter' && activeIndex >= 0) {
      event.preventDefault();
      links[activeIndex]?.click();
    }
  });
  document.addEventListener('click', (event) => {
    if (!SEARCH.parentElement.contains(event.target)) hideResults();
  });
}

document.querySelectorAll('[data-filter]').forEach((btn) => {
  btn.addEventListener('click', () => {
    const group = btn.closest('[data-filter-bar]')?.dataset.filterBar;
    document.querySelectorAll(`[data-filter-bar="${group}"] [data-filter]`).forEach((b) => b.classList.remove('active'));
    btn.classList.add('active');
    const want = btn.dataset.filter;
    document.querySelectorAll(`[data-kind="${group}"] [data-type]`).forEach((card) => {
      card.dataset.typeHidden = want !== 'all' && card.dataset.type !== want ? '1' : '';
      card.hidden = Boolean(card.dataset.typeHidden) || (SEARCH && SEARCH.value && !cardText(card).includes(SEARCH.value.trim().toLowerCase()));
    });
  });
});

const select = document.getElementById('lang-switch');
if (select) {
  select.addEventListener('change', () => {
    const next = select.value;
    localStorage.setItem('tms-wiki-lang', next);
    const parts = location.pathname.split('/').filter(Boolean);
    if (parts[0] && parts[0].length === 2) parts[0] = next;
    else parts.unshift(next);
    location.href = '/' + parts.join('/') + (parts.length === 1 ? '/' : '');
  });
}

function clip(value, max) {
  const text = String(value || '').replace(/\s+/g, ' ').trim();
  if (text.length <= max) return text;
  const cut = text.slice(0, max);
  const at = Math.max(cut.lastIndexOf('. '), cut.lastIndexOf(' '));
  return `${cut.slice(0, at > 40 ? at + 1 : max).trim()}…`;
}

function pickAnswer(entry, tokens) {
  const blob = `${entry.snippet || ''} ${entry.answer || ''} ${entry.text || ''}`.replace(/\s+/g, ' ').trim();
  if (!blob) return entry.title || '';
  const sentences = blob
    .split(/(?<=[.!?])\s+/)
    .map((s) => s.trim())
    .filter((s) => s.length > 24);
  const scored = sentences
    .map((sentence) => {
      const lower = sentence.toLowerCase();
      const hits = tokens.filter((t) => lower.includes(t)).length;
      return { sentence, hits };
    })
    .sort((a, b) => b.hits - a.hits || b.sentence.length - a.sentence.length);
  const chosen = (scored[0]?.hits ? scored.filter((s) => s.hits === scored[0].hits).slice(0, 2) : scored.slice(0, 2))
    .map((s) => s.sentence)
    .join(' ');
  return clip(chosen || blob, 420);
}

function initAsk() {
  const toggle = document.getElementById('almanac-ask');
  const panel = document.getElementById('almanac-chat');
  const log = document.getElementById('almanac-ask-log');
  const form = document.getElementById('almanac-ask-form');
  const input = document.getElementById('almanac-ask-input');
  const close = document.getElementById('almanac-ask-close');
  if (!toggle || !panel || !log || !form || !input) return;

  const copy = {
    welcome: panel.dataset.welcome || '',
    empty: panel.dataset.empty || '',
    read: panel.dataset.read || '→',
    more: panel.dataset.more || '',
  };

  function addMsg(kind, html) {
    const row = document.createElement('div');
    row.className = `ask-msg ${kind}`;
    row.innerHTML = html;
    log.appendChild(row);
    log.scrollTop = log.scrollHeight;
  }

  function openPanel() {
    panel.hidden = false;
    toggle.setAttribute('aria-expanded', 'true');
    if (!log.childElementCount && copy.welcome) addMsg('bot', `<p>${escHtml(copy.welcome)}</p>`);
    loadSearchIndex();
    input.focus();
  }

  function closePanel() {
    panel.hidden = true;
    toggle.setAttribute('aria-expanded', 'false');
    toggle.focus();
  }

  async function answerQuestion(raw) {
    const question = (raw || '').trim();
    if (!question) return;
    addMsg('user', `<p>${escHtml(question)}</p>`);
    const index = await loadSearchIndex();
    const ranked = rankEntries(index, question, 4);
    if (!ranked.length) {
      addMsg('bot', `<p>${escHtml(copy.empty)}</p>`);
      return;
    }
    const top = ranked[0].entry;
    const related = ranked.slice(1, 3).map((row) => row.entry);
    const body = pickAnswer(top, tokensOf(question));
    const more = related.length
      ? `<p class="ask-related">${escHtml(copy.more)}</p><ul>${related
          .map((item) => `<li><a href="${escHtml(item.href)}">${escHtml(item.title)}</a></li>`)
          .join('')}</ul>`
      : '';
    addMsg(
      'bot',
      `<p>${escHtml(body)}</p><p><a href="${escHtml(top.href)}">${escHtml(copy.read)}: ${escHtml(top.title)}</a></p>${more}`
    );
  }

  toggle.addEventListener('click', () => {
    if (panel.hidden) openPanel();
    else closePanel();
  });
  close?.addEventListener('click', closePanel);
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !panel.hidden) closePanel();
  });
  panel.querySelectorAll('[data-ask]').forEach((btn) => {
    btn.addEventListener('click', () => {
      input.value = btn.dataset.ask || btn.textContent || '';
      form.requestSubmit();
    });
  });
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const value = input.value;
    input.value = '';
    answerQuestion(value);
  });
}

initAsk();

