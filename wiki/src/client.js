const SEARCH = document.getElementById('almanac-search');
const LANG = document.documentElement.lang || 'en';

function cardText(card) {
  return (card.getAttribute('data-search') || card.textContent || '').toLowerCase();
}

function applySearch(q) {
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

if (SEARCH) {
  SEARCH.addEventListener('input', () => applySearch(SEARCH.value));
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
