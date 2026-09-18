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
let askStats = null;
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
      askStats = window.AlmanacAsk ? window.AlmanacAsk.buildIndex(searchIndex) : null;
      return searchIndex;
    })
    .catch(() => {
      searchIndexPromise = null;
      searchIndex = [];
      askStats = null;
      return searchIndex;
    });
  return searchIndexPromise;
}

function rankEntries(index, raw, limit = 12) {
  if (window.AlmanacAsk) {
    const stats = askStats && askStats.pages === index ? askStats : window.AlmanacAsk.buildIndex(index);
    if (askStats !== stats) askStats = stats;
    return window.AlmanacAsk.rankPages(stats, raw, limit);
  }
  const query = (raw || '').trim().toLowerCase();
  return index
    .map((entry) => {
      const hay = `${entry.title || ''} ${entry.snippet || ''} ${entry.answer || ''}`.toLowerCase();
      return { entry, score: hay.includes(query) ? 1 : 0 };
    })
    .filter((row) => row.score > 0)
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

let askFacts = null;
let askFactsPromise = null;
const TOKEN_KEY = 'tms-almanac-token';
let playerSnapshot = null;
let playerSnapshotAt = 0;

function readStoredToken() {
  try {
    return sessionStorage.getItem(TOKEN_KEY) || '';
  } catch {
    return '';
  }
}

function writeStoredToken(value) {
  try {
    if (value) sessionStorage.setItem(TOKEN_KEY, value);
    else sessionStorage.removeItem(TOKEN_KEY);
  } catch {
    /* ignore */
  }
  try {
    localStorage.removeItem(TOKEN_KEY);
  } catch {
    /* ignore */
  }
}

function consumeHandoffToken() {
  try {
    localStorage.removeItem(TOKEN_KEY);
  } catch {
    /* ignore */
  }
  const hash = String(location.hash || '');
  if (!hash.startsWith('#tms=')) return false;
  const raw = decodeURIComponent(hash.slice(5).split('&')[0] || '').trim();
  if (!raw) return false;
  writeStoredToken(raw);
  history.replaceState(null, '', `${location.pathname}${location.search}`);
  return true;
}

function loadFacts() {
  const panel = document.getElementById('almanac-chat');
  const url = panel?.dataset.facts;
  if (!url) return Promise.resolve(null);
  if (askFactsPromise) return askFactsPromise;
  askFactsPromise = fetch(url)
    .then((res) => {
      if (!res.ok) throw new Error('facts missing');
      return res.json();
    })
    .then((data) => {
      askFacts = data;
      return data;
    })
    .catch(() => {
      askFactsPromise = null;
      askFacts = null;
      return null;
    });
  return askFactsPromise;
}

function initAsk() {
  const toggle = document.getElementById('almanac-ask');
  const panel = document.getElementById('almanac-chat');
  const log = document.getElementById('almanac-ask-log');
  const form = document.getElementById('almanac-ask-form');
  const input = document.getElementById('almanac-ask-input');
  const close = document.getElementById('almanac-ask-close');
  const logout = document.getElementById('almanac-ask-logout');
  const sessionEl = document.getElementById('almanac-ask-session');
  if (!toggle || !panel || !log || !form || !input) return;

  const apiBase = (panel.dataset.api || 'https://api.themobstate.com').replace(/\/$/, '');
  const copy = {
    welcome: panel.dataset.welcome || '',
    empty: panel.dataset.empty || '',
    read: panel.dataset.read || '→',
    more: panel.dataset.more || '',
    sources: panel.dataset.sources || '',
    follow: panel.dataset.follow || '',
    followTpl: panel.dataset.followTpl || '{title}',
    thinking: panel.dataset.thinking || '…',
    blockedPrice: panel.dataset.blockedPrice || '',
    blockedAccount: panel.dataset.blockedAccount || '',
    blockedSecret: panel.dataset.blockedSecret || panel.dataset.blockedAccount || '',
    loginNeed: panel.dataset.loginNeed || '',
    loginUser: panel.dataset.loginUser || '',
    loginPass: panel.dataset.loginPass || '',
    loginSubmit: panel.dataset.loginSubmit || '',
    loginFail: panel.dataset.loginFail || '',
    loginUnverified: panel.dataset.loginUnverified || '',
    loginBanned: panel.dataset.loginBanned || '',
    logout: panel.dataset.logout || '',
    session: panel.dataset.session || '{name}',
  };
  const session = { lastTitle: '', lastHref: '', lastQuery: '' };

  function token() {
    return readStoredToken();
  }

  function setToken(value) {
    writeStoredToken(value || '');
    playerSnapshot = null;
    playerSnapshotAt = 0;
  }

  function addMsg(kind, html, extraClass) {
    const row = document.createElement('div');
    row.className = `ask-msg ${kind}${extraClass ? ` ${extraClass}` : ''}`;
    row.innerHTML = html;
    log.appendChild(row);
    log.scrollTop = log.scrollHeight;
    return row;
  }

  function paintSession() {
    if (!sessionEl || !logout) return;
    if (playerSnapshot?.username) {
      sessionEl.hidden = false;
      sessionEl.textContent = copy.session.replace('{name}', playerSnapshot.username);
      logout.hidden = false;
    } else {
      sessionEl.hidden = true;
      sessionEl.textContent = '';
      logout.hidden = !token();
    }
  }

  async function fetchSnapshot(force) {
    const auth = token();
    if (!auth) {
      playerSnapshot = null;
      paintSession();
      return null;
    }
    if (!force && playerSnapshot && Date.now() - playerSnapshotAt < 60000) return playerSnapshot;
    try {
      const res = await fetch(`${apiBase}/almanac/me`, {
        headers: { Authorization: `Bearer ${auth}` },
      });
      if (res.status === 401 || res.status === 403) {
        setToken('');
        paintSession();
        return null;
      }
      if (!res.ok) return playerSnapshot;
      const data = await res.json();
      playerSnapshot = data.snapshot || null;
      playerSnapshotAt = Date.now();
      paintSession();
      return playerSnapshot;
    } catch {
      return playerSnapshot;
    }
  }

  function loginFormHtml() {
    return `<p>${escHtml(copy.loginNeed)}</p>`;
  }

  function openPanel() {
    panel.hidden = false;
    toggle.setAttribute('aria-expanded', 'true');
    if (!log.childElementCount && copy.welcome) addMsg('bot', `<p>${escHtml(copy.welcome)}</p>`);
    loadSearchIndex();
    loadFacts();
    fetchSnapshot();
    input.focus();
  }

  function closePanel() {
    panel.hidden = true;
    toggle.setAttribute('aria-expanded', 'false');
    toggle.focus();
  }

  function renderAnswer(result) {
    if (result.needAuth) {
      addMsg('bot', loginFormHtml(result.pending || session.lastQuery || ''));
      return;
    }
    if (result.empty || result.blocked) {
      addMsg('bot', `<p>${escHtml(result.body)}</p>`);
      return;
    }
    const sources = (result.sources || []).length
      ? `<p class="ask-related">${escHtml(copy.sources)}</p><ul class="ask-sources">${result.sources
          .map(
            (item) =>
              `<li><a href="${escHtml(item.href)}">${escHtml(copy.read)}: ${escHtml(item.title)}</a></li>`
          )
          .join('')}</ul>`
      : '';
    const follow = (result.followups || []).length
      ? `<p class="ask-related">${escHtml(copy.follow)}</p><div class="ask-follow">${result.followups
          .map((q) => `<button type="button" data-ask="${escHtml(q)}">${escHtml(q)}</button>`)
          .join('')}</div>`
      : '';
    addMsg('bot', `<p>${escHtml(result.body)}</p>${sources}${follow}`);
  }

  async function answerQuestion(raw, silentUser) {
    const question = (raw || '').trim();
    if (!question) return;
    if (!silentUser) addMsg('user', `<p>${escHtml(question)}</p>`);
    const thinking = addMsg('bot', `<p>${escHtml(copy.thinking)}</p>`, 'thinking');
    const index = await loadSearchIndex();
    const facts = await loadFacts();
    const player = await fetchSnapshot();
    const engine = window.AlmanacAsk;
    let result;
    if (engine && askStats) {
      result = engine.answerQuestion({
        stats: askStats,
        facts,
        question,
        session,
        copy,
        player,
      });
    } else {
      const ranked = rankEntries(index, question, 4);
      result = ranked.length
        ? {
            blocked: null,
            empty: false,
            body: ranked[0].entry.snippet || ranked[0].entry.title,
            sources: [{ title: ranked[0].entry.title, href: ranked[0].entry.href }],
            followups: [],
          }
        : { blocked: null, empty: true, body: copy.empty, sources: [], followups: [] };
    }
    thinking.remove();
    if (result.needAuth) result.pending = question;
    renderAnswer(result);
  }

  toggle.addEventListener('click', () => {
    if (panel.hidden) openPanel();
    else closePanel();
  });
  close?.addEventListener('click', closePanel);
  logout?.addEventListener('click', () => {
    setToken('');
    paintSession();
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !panel.hidden) closePanel();
  });
  panel.addEventListener('click', (event) => {
    const btn = event.target.closest('[data-ask]');
    if (!btn || !panel.contains(btn)) return;
    input.value = btn.dataset.ask || btn.textContent || '';
    form.requestSubmit();
  });
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const value = input.value;
    input.value = '';
    answerQuestion(value);
  });

  const handedOff = consumeHandoffToken();
  if (handedOff) {
    openPanel();
  } else if (token()) {
    fetchSnapshot();
  }
}

initAsk();
