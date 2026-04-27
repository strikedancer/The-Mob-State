# SEO (Search) protocol

Doel: beter vindbaar zijn voor zoekopdrachten zoals **“mafia game”** en **“text based mafia game”** via een sterke technische basis (crawlbaar, correcte metadata) en indexeerbare landingscontent.

## Canonical domeinen

- **App (public)**: `https://themobstate.com/`
- **API**: `https://api.themobstate.com/`
- **Admin**: `https://admin.themobstate.com/`

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

Tussen NL- en EN-landings (en de homepage) gebruiken we **hreflang** + **`x-default`** in:

- de `<head>` van de statische landings, en
- `sitemap.xml` via `xhtml:link` alternates (zie bestand; `xmlns:xhtml` is meegenomen).

`https://themobstate.com/en` redirect naar `https://themobstate.com/en/` (nginx `location = /en`).

Deze paden staan ook in `sitemap.xml`.

## robots.txt en sitemap

- `client/web/robots.txt` bevat de verwijzing naar `https://themobstate.com/sitemap.xml`.
- `client/web/sitemap.xml` bevat de homepage en de SEO landings.

In `client/docker/nginx.conf` staan expliciete `location =` blocks zodat `robots.txt`, `sitemap.xml` en de SEO landings niet door de SPA fallback worden overruled.

## Social previews en structured data

In `client/web/index.html` hebben we:

- `<title>` + meta description voor zoekresultaten
- Open Graph (`og:*`) en Twitter cards
- JSON-LD voor `Organization`, `WebSite` en `VideoGame`

## Release / verificatie checklist

Na deploy:

1. **Google Search Console**: property voor `https://themobstate.com` verifiëren.
2. Sitemap indienen: `https://themobstate.com/sitemap.xml`.
3. URL inspectie (minimaal):
   - `https://themobstate.com/`
   - `https://themobstate.com/en/`
   - `https://themobstate.com/text-based-mafia-game` en `https://themobstate.com/en/text-based-mafia-game`
   - `https://themobstate.com/mafia-game` en `https://themobstate.com/en/mafia-game`
4. Controleer robots: `https://themobstate.com/robots.txt`.
5. Controleer social preview (Open Graph) via een preview tool (Facebook/Twitter/LinkedIn) en pas `og:image` aan als nodig. Voor beste previews op social: gebruik liefst een **1200×630** marketing image (nu vaak `logo.png` als placeholder).

