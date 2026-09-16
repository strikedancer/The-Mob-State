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

function scoreEntry(entry, query) {
  const title = (entry.title || '').toLowerCase();
  const snippet = (entry.snippet || '').toLowerCase();
  const text = entry.text || '';
  if (title === query) return 100;
  if (title.startsWith(query)) return 90;
  if (title.includes(query)) return 80;
  if (snippet.includes(query)) return 50;
  if (text.includes(query)) return 20;
  return 0;
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
  const ranked = index
    .map((entry) => ({ entry, score: scoreEntry(entry, query) }))
    .filter((row) => row.score > 0)
    .sort((a, b) => b.score - a.score || a.entry.title.localeCompare(b.entry.title))
    .slice(0, 12)
    .map((row) => row.entry);
  renderResults(ranked);
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
