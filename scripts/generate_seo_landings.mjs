/**
 * Writes crawlable /{lang}/text-based-mafia-game landings.
 * NL stays at /text-based-mafia-game. Run from repo root:
 *   node scripts/generate_seo_landings.mjs
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const SEO = path.join(ROOT, 'client', 'web', 'seo');

const LANGS = ['nl', 'en', 'de', 'fr', 'es', 'it', 'pl', 'pt'];

const OG_LOCALE = {
  nl: 'nl_NL',
  en: 'en_US',
  de: 'de_DE',
  fr: 'fr_FR',
  es: 'es_ES',
  it: 'it_IT',
  pl: 'pl_PL',
  pt: 'pt_PT',
};

const copy = {
  nl: {
    title: 'The Mob State — text-based mafia game (browser)',
    description:
      'The Mob State is een text-based mafia game in je browser (PWA). Bouw je crew, pleeg misdaden en klim in rank — op mobiel en desktop.',
    h1: 'The Mob State: text-based mafia game',
    lead: 'The Mob State is een text-based mafia game (browser/PWA). Korte sessies: misdaden, werk, crew en seizoenen.',
    match:
      'Zoek je een text based mafia game of The Mob State? Speel direct, zonder app store. Almanak: handleiding en catalogus.',
    play: 'Speel The Mob State',
    wiki: 'Almanak',
    card1t: 'Browser / PWA',
    card1: 'Direct in de browser. Optioneel op het beginscherm, zonder store.',
    card2t: 'Progressie',
    card2: 'Cash, XP, voertuigen en doelen. Speel in korte blokken door de dag.',
    card3t: 'Crew',
    card3: 'Bouw een crew, speel events en strijd in seizoenen.',
    faqT: 'Veelgestelde vragen',
    q1: 'Wat is The Mob State?',
    a1: 'The Mob State is een text-based mafia game in de browser. Je speelt via menu’s en timers, niet via 3D-actie.',
    q2: 'Wat is een text-based mafia game?',
    a2: 'Een mafia-/crimespel met tekst-UI: acties, cooldowns en lange progressie (geld, rank, crew).',
    q3: 'Kan ik op mijn telefoon spelen?',
    a3: 'Ja. Mobiele browser of PWA op het beginscherm. Zelfde account via login (wachtwoord, Google of Facebook).',
    langs: 'Andere talen',
    foot: 'The Mob State — text-based mafia game',
  },
  en: {
    title: 'The Mob State — text-based mafia game (browser)',
    description:
      'The Mob State is a text-based mafia game in your browser (PWA). Build a crew, commit crimes, and climb the ranks on mobile or desktop.',
    h1: 'The Mob State: text-based mafia game',
    lead: 'The Mob State is a text-based mafia game (browser/PWA). Short sessions: crimes, jobs, crew play, and seasons.',
    match:
      'Looking for a text based mafia game or The Mob State? Play instantly — no app store. The almanac has the handbook and catalogues.',
    play: 'Play The Mob State',
    wiki: 'Almanac',
    card1t: 'Browser / PWA',
    card1: 'Play in the browser. Optionally add it to your home screen — still no store.',
    card2t: 'Progression',
    card2: 'Cash, XP, vehicles, and goals. Short sessions throughout the day.',
    card3t: 'Crew',
    card3: 'Build a crew, join events, and compete in seasons.',
    faqT: 'Frequently asked questions',
    q1: 'What is The Mob State?',
    a1: 'The Mob State is a text-based mafia game in the browser. You play through menus and timers, not 3D action.',
    q2: 'What is a text-based mafia game?',
    a2: 'A mafia/crime game with a text UI: actions, cooldowns, and long-term progress (money, rank, crew).',
    q3: 'Can I play on my phone?',
    a3: 'Yes. Mobile browser or PWA on the home screen. Same account via password, Google, or Facebook login.',
    langs: 'Other languages',
    foot: 'The Mob State — text-based mafia game',
  },
  de: {
    title: 'The Mob State — textbasiertes Mafia-Spiel (Browser)',
    description:
      'The Mob State ist ein text-based mafia game im Browser (PWA). Baue deine Crew, begehe Verbrechen und steige im Rang — am Handy und am PC.',
    h1: 'The Mob State: textbasiertes Mafia-Spiel',
    lead: 'The Mob State ist ein text-based mafia game (Browser/PWA). Kurze Sessions: Verbrechen, Jobs, Crew und Saisons.',
    match:
      'Du suchst ein text based mafia game oder The Mob State? Sofort spielen, ohne App Store. Almanach: Handbuch und Katalog.',
    play: 'The Mob State spielen',
    wiki: 'Almanach',
    card1t: 'Browser / PWA',
    card1: 'Direkt im Browser. Optional auf dem Startbildschirm, ohne Store.',
    card2t: 'Fortschritt',
    card2: 'Cash, XP, Fahrzeuge und Ziele. Kurze Sessions über den Tag.',
    card3t: 'Crew',
    card3: 'Baue eine Crew, spiele Events und kämpfe in Saisons.',
    faqT: 'Häufige Fragen',
    q1: 'Was ist The Mob State?',
    a1: 'The Mob State ist ein text-based mafia game im Browser. Du spielst über Menüs und Timer, nicht in 3D-Action.',
    q2: 'Was ist ein textbasiertes Mafia-Spiel?',
    a2: 'Ein Mafia-/Crime-Spiel mit Text-UI: Aktionen, Cooldowns und langer Fortschritt (Geld, Rang, Crew).',
    q3: 'Kann ich am Handy spielen?',
    a3: 'Ja. Mobiler Browser oder PWA auf dem Startbildschirm. Dasselbe Konto per Passwort, Google oder Facebook.',
    langs: 'Andere Sprachen',
    foot: 'The Mob State — text-based mafia game',
  },
  fr: {
    title: 'The Mob State — jeu de mafia textuel (navigateur)',
    description:
      'The Mob State est un text-based mafia game dans le navigateur (PWA). Construis ton crew, commets des crimes et monte en rang — mobile et ordinateur.',
    h1: 'The Mob State : jeu de mafia textuel',
    lead: 'The Mob State est un text-based mafia game (navigateur/PWA). Sessions courtes : crimes, jobs, crew et saisons.',
    match:
      'Tu cherches un text based mafia game ou The Mob State ? Joue tout de suite, sans app store. Almanach : manuel et catalogues.',
    play: 'Jouer à The Mob State',
    wiki: 'Almanach',
    card1t: 'Navigateur / PWA',
    card1: 'Dans le navigateur. Optionnellement sur l’écran d’accueil, sans store.',
    card2t: 'Progression',
    card2: 'Cash, XP, véhicules et objectifs. Courtes sessions dans la journée.',
    card3t: 'Crew',
    card3: 'Construis un crew, joue les events et vise les saisons.',
    faqT: 'Questions fréquentes',
    q1: 'Qu’est-ce que The Mob State ?',
    a1: 'The Mob State est un text-based mafia game dans le navigateur. Menus et timers, pas d’action 3D.',
    q2: 'Qu’est-ce qu’un jeu de mafia textuel ?',
    a2: 'Un jeu mafia/crime en interface texte : actions, cooldowns et progression longue (argent, rang, crew).',
    q3: 'Puis-je jouer sur téléphone ?',
    a3: 'Oui. Navigateur mobile ou PWA. Même compte via mot de passe, Google ou Facebook.',
    langs: 'Autres langues',
    foot: 'The Mob State — text-based mafia game',
  },
  es: {
    title: 'The Mob State — juego de mafia de texto (navegador)',
    description:
      'The Mob State es un text-based mafia game en el navegador (PWA). Construye tu crew, comete crímenes y sube de rango — en móvil y escritorio.',
    h1: 'The Mob State: juego de mafia de texto',
    lead: 'The Mob State es un text-based mafia game (navegador/PWA). Sesiones cortas: crímenes, trabajos, crew y temporadas.',
    match:
      '¿Buscas un text based mafia game o The Mob State? Juega al instante, sin app store. Almanaque: manual y catálogos.',
    play: 'Jugar The Mob State',
    wiki: 'Almanaque',
    card1t: 'Navegador / PWA',
    card1: 'En el navegador. Opcional en la pantalla de inicio, sin tienda.',
    card2t: 'Progreso',
    card2: 'Dinero, XP, vehículos y objetivos. Sesiones cortas a lo largo del día.',
    card3t: 'Crew',
    card3: 'Crea una crew, juega eventos y compite por temporadas.',
    faqT: 'Preguntas frecuentes',
    q1: '¿Qué es The Mob State?',
    a1: 'The Mob State es un text-based mafia game en el navegador. Menús y temporizadores, no acción 3D.',
    q2: '¿Qué es un juego de mafia de texto?',
    a2: 'Un juego de mafia/crimen con interfaz de texto: acciones, cooldowns y progreso largo (dinero, rango, crew).',
    q3: '¿Puedo jugar en el móvil?',
    a3: 'Sí. Navegador móvil o PWA. La misma cuenta con contraseña, Google o Facebook.',
    langs: 'Otros idiomas',
    foot: 'The Mob State — text-based mafia game',
  },
  it: {
    title: 'The Mob State — gioco mafia testuale (browser)',
    description:
      'The Mob State è un text-based mafia game nel browser (PWA). Costruisci la crew, commetti crimini e sali di rango — su telefono e computer.',
    h1: 'The Mob State: gioco mafia testuale',
    lead: 'The Mob State è un text-based mafia game (browser/PWA). Sessioni brevi: crimini, lavori, crew e stagioni.',
    match:
      'Cerchi un text based mafia game o The Mob State? Gioca subito, senza app store. Almanacco: manuale e cataloghi.',
    play: 'Gioca a The Mob State',
    wiki: 'Almanacco',
    card1t: 'Browser / PWA',
    card1: 'Nel browser. Opzionale sulla schermata Home, senza store.',
    card2t: 'Progressione',
    card2: 'Soldi, XP, veicoli e obiettivi. Sessioni brevi durante il giorno.',
    card3t: 'Crew',
    card3: 'Crea una crew, gioca gli event e punta alle stagioni.',
    faqT: 'Domande frequenti',
    q1: 'Cos’è The Mob State?',
    a1: 'The Mob State è un text-based mafia game nel browser. Menu e timer, non azione 3D.',
    q2: 'Cos’è un gioco mafia testuale?',
    a2: 'Un gioco mafia/crimine con UI testuale: azioni, cooldown e progresso a lungo termine (soldi, rango, crew).',
    q3: 'Posso giocare sul telefono?',
    a3: 'Sì. Browser mobile o PWA. Stesso account con password, Google o Facebook.',
    langs: 'Altre lingue',
    foot: 'The Mob State — text-based mafia game',
  },
  pl: {
    title: 'The Mob State — tekstowa gra mafijna (przeglądarka)',
    description:
      'The Mob State to text-based mafia game w przeglądarce (PWA). Buduj załogę, popełniaj przestępstwa i awansuj — na telefonie i komputerze.',
    h1: 'The Mob State: tekstowa gra mafijna',
    lead: 'The Mob State to text-based mafia game (przeglądarka/PWA). Krótkie sesje: przestępstwa, prace, załoga i sezony.',
    match:
      'Szukasz text based mafia game albo The Mob State? Graj od razu, bez sklepu. Almanach: poradnik i katalogi.',
    play: 'Graj w The Mob State',
    wiki: 'Almanach',
    card1t: 'Przeglądarka / PWA',
    card1: 'W przeglądarce. Opcjonalnie na ekranie głównym, bez sklepu.',
    card2t: 'Postęp',
    card2: 'Kasa, XP, pojazdy i cele. Krótkie sesje w ciągu dnia.',
    card3t: 'Załoga',
    card3: 'Zbuduj załogę, graj eventy i walcz w sezonach.',
    faqT: 'Częste pytania',
    q1: 'Czym jest The Mob State?',
    a1: 'The Mob State to text-based mafia game w przeglądarce. Menu i timery, nie akcja 3D.',
    q2: 'Czym jest tekstowa gra mafijna?',
    a2: 'Gra mafia/crime z interfejsem tekstowym: akcje, cooldowny i długi postęp (pieniądze, ranga, załoga).',
    q3: 'Czy mogę grać na telefonie?',
    a3: 'Tak. Przeglądarka mobilna albo PWA. To samo konto przez hasło, Google lub Facebook.',
    langs: 'Inne języki',
    foot: 'The Mob State — text-based mafia game',
  },
  pt: {
    title: 'The Mob State — jogo de máfia em texto (navegador)',
    description:
      'The Mob State é um text-based mafia game no navegador (PWA). Constrói a crew, comete crimes e sobe de rank — no telemóvel e no computador.',
    h1: 'The Mob State: jogo de máfia em texto',
    lead: 'The Mob State é um text-based mafia game (navegador/PWA). Sessões curtas: crimes, trabalhos, crew e temporadas.',
    match:
      'Procuras um text based mafia game ou The Mob State? Joga já, sem app store. Almanaque: manual e catálogos.',
    play: 'Jogar The Mob State',
    wiki: 'Almanaque',
    card1t: 'Navegador / PWA',
    card1: 'No navegador. Opcional no ecrã inicial, sem loja.',
    card2t: 'Progressão',
    card2: 'Dinheiro, XP, veículos e objetivos. Sessões curtas ao longo do dia.',
    card3t: 'Crew',
    card3: 'Cria uma crew, joga eventos e compete por temporadas.',
    faqT: 'Perguntas frequentes',
    q1: 'O que é The Mob State?',
    a1: 'The Mob State é um text-based mafia game no navegador. Menus e temporizadores, sem ação 3D.',
    q2: 'O que é um jogo de máfia em texto?',
    a2: 'Um jogo de máfia/crime com interface de texto: ações, cooldowns e progresso longo (dinheiro, rank, crew).',
    q3: 'Posso jogar no telemóvel?',
    a3: 'Sim. Navegador móvel ou PWA. A mesma conta com palavra-passe, Google ou Facebook.',
    langs: 'Outros idiomas',
    foot: 'The Mob State — text-based mafia game',
  },
};

function landingPath(lang) {
  return lang === 'nl' ? '/text-based-mafia-game' : `/${lang}/text-based-mafia-game`;
}

function wikiHome(lang) {
  return `https://wiki.themobstate.com/${lang}/`;
}

function hrefLangLinks() {
  const lines = LANGS.map(
    (l) => `    <link rel="alternate" hreflang="${l}" href="https://themobstate.com${landingPath(l)}" />`,
  );
  lines.push(
    '    <link rel="alternate" hreflang="x-default" href="https://themobstate.com/text-based-mafia-game" />',
  );
  return lines.join('\n');
}

function langNav(current) {
  return LANGS.map((l) => {
    const href = landingPath(l);
    const label = l.toUpperCase();
    if (l === current) return `<strong>${label}</strong>`;
    return `<a href="${href}">${label}</a>`;
  }).join(' · ');
}

function render(lang) {
  const t = copy[lang];
  const canonical = `https://themobstate.com${landingPath(lang)}`;
  const faqJson = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    inLanguage: lang,
    mainEntity: [
      {
        '@type': 'Question',
        name: t.q1,
        acceptedAnswer: { '@type': 'Answer', text: t.a1 },
      },
      {
        '@type': 'Question',
        name: t.q2,
        acceptedAnswer: { '@type': 'Answer', text: t.a2 },
      },
      {
        '@type': 'Question',
        name: t.q3,
        acceptedAnswer: { '@type': 'Answer', text: t.a3 },
      },
    ],
  });
  return `<!doctype html>
<html lang="${lang}">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>${t.title}</title>
    <meta name="description" content="${t.description}" />
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1" />
    <link rel="canonical" href="${canonical}" />
${hrefLangLinks()}

    <meta property="og:locale" content="${OG_LOCALE[lang]}" />
    <meta property="og:type" content="website" />
    <meta property="og:site_name" content="The Mob State" />
    <meta property="og:title" content="${t.title}" />
    <meta property="og:description" content="${t.description}" />
    <meta property="og:url" content="${canonical}" />
    <meta property="og:image" content="https://themobstate.com/logo.png" />

    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="${t.title}" />
    <meta name="twitter:description" content="${t.description}" />
    <meta name="twitter:image" content="https://themobstate.com/logo.png" />

    <script type="application/ld+json">${faqJson}</script>
    <style>
      :root { color-scheme: dark; }
      body {
        margin: 0;
        font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
        background: radial-gradient(1200px 600px at 20% -10%, rgba(212, 175, 55, 0.25), transparent),
          linear-gradient(135deg, #0b0a0b, #151012 55%, #080708);
        color: #f2f2f2;
      }
      .wrap { max-width: 980px; margin: 0 auto; padding: 40px 18px 60px; }
      .badge {
        display: inline-flex; padding: 8px 12px; border-radius: 999px;
        border: 1px solid rgba(212, 175, 55, 0.45); background: rgba(0, 0, 0, 0.25);
        color: rgba(212, 175, 55, 0.95); font-weight: 800; font-size: 12px;
      }
      h1 { margin: 18px 0 8px; font-size: clamp(28px, 3.8vw, 42px); letter-spacing: -0.5px; }
      p { margin: 12px 0; line-height: 1.55; color: rgba(242, 242, 242, 0.85); font-size: 16px; }
      .lang { font-size: 14px; }
      .lang a { color: rgba(212, 175, 55, 0.95); font-weight: 700; }
      .ctaRow { margin-top: 18px; display: flex; flex-wrap: wrap; gap: 10px; }
      .btn {
        display: inline-flex; padding: 12px 14px; border-radius: 12px; text-decoration: none;
        font-weight: 900; border: 1px solid rgba(255, 255, 255, 0.12);
        background: rgba(0, 0, 0, 0.35); color: #fff;
      }
      .btnPrimary {
        border-color: rgba(212, 175, 55, 0.55);
        background: linear-gradient(180deg, rgba(212, 175, 55, 0.28), rgba(212, 175, 55, 0.12));
      }
      .grid { margin-top: 26px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
      .card { padding: 14px; border-radius: 14px; border: 1px solid rgba(255, 255, 255, 0.08); background: rgba(0, 0, 0, 0.28); }
      .card h2 { margin: 0 0 8px; font-size: 15px; color: rgba(212, 175, 55, 0.95); }
      .card p { margin: 0; font-size: 13px; color: rgba(242, 242, 242, 0.78); }
      .faq { margin-top: 24px; padding: 14px; border-radius: 14px; border: 1px solid rgba(255, 255, 255, 0.08); background: rgba(0, 0, 0, 0.28); }
      .faq h2 { margin: 0 0 12px; color: #fff; font-size: 16px; }
      details { padding: 10px 0; border-top: 1px solid rgba(255, 255, 255, 0.08); }
      details:first-of-type { border-top: none; }
      summary { cursor: pointer; font-weight: 800; }
      .foot { margin-top: 26px; font-size: 12px; color: rgba(242, 242, 242, 0.55); }
      @media (max-width: 860px) { .grid { grid-template-columns: 1fr; } }
    </style>
  </head>
  <body>
    <main class="wrap">
      <div class="badge">The Mob State · text-based mafia game</div>
      <p class="lang">${t.langs}: ${langNav(lang)}</p>
      <h1>${t.h1}</h1>
      <p>${t.lead}</p>
      <p>${t.match}</p>
      <div class="ctaRow">
        <a class="btn btnPrimary" href="/">${t.play}</a>
        <a class="btn" href="${wikiHome(lang)}">${t.wiki}</a>
      </div>
      <section class="grid" aria-label="Highlights">
        <div class="card"><h2>${t.card1t}</h2><p>${t.card1}</p></div>
        <div class="card"><h2>${t.card2t}</h2><p>${t.card2}</p></div>
        <div class="card"><h2>${t.card3t}</h2><p>${t.card3}</p></div>
      </section>
      <section class="faq">
        <h2>${t.faqT}</h2>
        <details><summary>${t.q1}</summary><p>${t.a1}</p></details>
        <details><summary>${t.q2}</summary><p>${t.a2}</p></details>
        <details><summary>${t.q3}</summary><p>${t.a3}</p></details>
      </section>
      <div class="foot">© ${t.foot}</div>
    </main>
  </body>
</html>
`;
}

function outFile(lang) {
  if (lang === 'nl') return path.join(SEO, 'text-based-mafia-game.html');
  return path.join(SEO, lang, 'text-based-mafia-game.html');
}

for (const lang of LANGS) {
  const file = outFile(lang);
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, render(lang), 'utf8');
  console.log('wrote', path.relative(ROOT, file));
}
