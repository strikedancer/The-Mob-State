# SEO (Search) protocol

Doel: beter vindbaar zijn voor zoekopdrachten zoals **“mafia game”** en **“text based mafia game”** via een sterke technische basis (crawlbaar, correcte metadata) en indexeerbare landingscontent.

## Canonical domeinen

- **App (public)**: `https://themobstate.com/` (canonical). `https://themobstate.nl/` serves the same Flutter shell; keep Search Console / sitemap on `.com`.
- **API**: `https://api.themobstate.com/`
- **Admin**: `https://admin.themobstate.com/`
- **Almanac**: `https://wiki.themobstate.com/` (catalog generated from `backend/content`, all locales; rebuilds when those files change on the VPS)

In de client-web entry (`client/web/index.html`) is een canonical gezet naar de public app URL.

## Flutter web (SPA) en SEO

De Flutter web client is een SPA. Zonder extra maatregelen ziet een crawler vooral de app-shell HTML.

Om alsnog indexeerbare content te hebben voor belangrijke zoekintents, gebruiken we **statische HTML landings** die direct door nginx worden geserveerd (dus **geen** fallback naar `/index.html`):

- **NL (primair)**
  - `/text-based-mafia-game` → `client/web/seo/text-based-mafia-game.html`
  - `/mafia-game` → `client/web/seo/mafia-game.html`
- **EN (internationale zoekintent / “text based mafia game”)**
  - `/en/` → `client/web/seo/en/index.html`
  - `/en/text-based-mafia-game` → `client/web/seo/en/text-based-mafia-game.html`
  - `/en/mafia-game` → `client/web/seo/en/mafia-game.html`
- **Overige UI-talen** (`de`, `fr`, `es`, `it`, `pl`, `pt`): `/{lang}/text-based-mafia-game` — zelfde intent (appnaam **The Mob State** + *text-based mafia game*). Bron: `scripts/generate_seo_landings.mjs`.

Tussen de landings (en de homepage) gebruiken we **hreflang** + **`x-default`** in:

- de `<head>` van de statische landings, en
- `sitemap.xml` via `xhtml:link` alternates (zie bestand; `xmlns:xhtml` is meegenomen).

`https://themobstate.com/en` redirect naar `https://themobstate.com/en/` (nginx `location = /en`).

Deze paden staan ook in `sitemap.xml`.

## robots.txt en sitemap

- `client/web/robots.txt` verwijst naar `https://themobstate.com/sitemap.xml` **en** `https://wiki.themobstate.com/sitemap.xml`.
- `client/web/sitemap.xml` bevat homepage, meertalige text-based landings, wiki-homes en legal.
- Wiki genereert `https://wiki.themobstate.com/sitemap.xml` bij elke almanak-build (hubs + handleiding, hreflang op die URLs).

In `client/docker/nginx.conf` staan expliciete `location =` blocks zodat `robots.txt`, `sitemap.xml` en de SEO landings niet door de SPA fallback worden overruled.

## Social previews en structured data

In `client/web/index.html` hebben we:

- `<title>` + meta description voor zoekresultaten
- Open Graph (`og:*`) en Twitter cards
- JSON-LD voor `Organization`, `WebSite` en `VideoGame`

## Search Console (kort)

Twee properties, beide als URL-prefix:

1. `https://themobstate.com/` — sitemap `https://themobstate.com/sitemap.xml`
2. `https://wiki.themobstate.com/` — sitemap `https://wiki.themobstate.com/sitemap.xml`

Daarna:

3. **URL-inspectie → Indexering aanvragen** (eenmalig per nieuwe URL): `/`, `/en/`, `/text-based-mafia-game`, `/en/text-based-mafia-game`, plus één extra taal (bijv. `/de/text-based-mafia-game`), en `https://wiki.themobstate.com/nl/` + `/en/`.
4. **Prestaties**: filter queries op `the mob state`, `themobstate`, `text based mafia`, `text-based mafia game`. Merknaam eerst; generic `mafia game` is later.
5. **Pagina’s**: geen 404 op de landings; wiki niet als “uitgesloten / redirected” laten staan.
6. `themobstate.nl` niet als aparte canonieke property pushen — blijft alias van `.com`.

Niet indienen: `api.` / `admin.`.

## Release / verificatie checklist

Na deploy:

1. Search Console-stappen hierboven.
2. Controleer robots: `https://themobstate.com/robots.txt` (twee Sitemap-regels).
3. Steekproef: `https://themobstate.com/de/text-based-mafia-game` is echte HTML (geen Flutter-shell).
4. Wiki-home title bevat **The Mob State** + text-based zin in die taal.
5. Social preview: liefst **1200×630** marketing image (nu vaak `logo.png`).

