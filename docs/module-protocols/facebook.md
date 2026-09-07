# Facebook (Login + Page)

## Scope
Koppeling met Meta voor **speler-login via Facebook** (web OAuth) en **handmatig plaatsen van berichten** op de Facebook-pagina vanuit Admin. Geen automatische game-posts (diefstallen, crimes, enz.). Native iOS/Android Facebook SDK valt buiten deze module.

## Primary Frontend Entry
- `client/lib/screens/login_screen.dart` — knop **Doorgaan met Facebook** (alleen web, alleen als de API `loginEnabled` teruggeeft)
- `admin/src/components/FacebookPageAdminPanel.tsx` — Admin → Config → Toegang (Vite `verbatimModuleSyntax`: type-only React imports such as `FormEvent`)

## Primary Backend Entry
- `GET /auth/facebook/status` — `{ loginEnabled, pageEnabled }` (geen auth)
- `GET /auth/facebook/start` — redirect naar Facebook OAuth
- `GET /auth/facebook/callback` — code → sessie of pending-registratie, daarna redirect naar `APP_BASE_URL/login`
- `POST /auth/facebook/complete` — `{ pendingToken, username, gender, preferredLanguage, acceptedTerms }`
- `GET /admin/facebook/status` — admin
- `POST /admin/facebook/publish` — `{ message, link? }` admin
- Services: `backend/src/services/facebookAuthService.ts`, `authService.issueSession`

## Env (alleen server, nooit in git)
Zet in `.env.plesk` (zie `.env.plesk.example`):

- `FACEBOOK_APP_ID`
- `FACEBOOK_APP_SECRET`
- `FACEBOOK_PAGE_ID`
- `FACEBOOK_PAGE_ACCESS_TOKEN` (Page token, niet user token)
- `FACEBOOK_OAUTH_REDIRECT_URI` — default `${API_BASE_URL}/auth/facebook/callback` → `https://api.themobstate.com/auth/facebook/callback`

Zonder App ID + Secret blijft de inlogknop verborgen. Zonder Page ID + token blijft Admin-plaatsen uit.

## Meta-app aanmaken (eenmalig, in de browser)

1. Ga naar [developers.facebook.com](https://developers.facebook.com/) en maak een app (type **Consumer** of **Business**), naam **The Mob State**.
2. Voeg het product **Facebook Login** toe (web).
3. **Valid OAuth Redirect URIs:** `https://api.themobstate.com/auth/facebook/callback`
4. App domains: `themobstate.com`, `api.themobstate.com`
5. Privacy policy URL: `https://themobstate.com/privacy`
6. Voor **live** login: app in Live mode (privacy policy verplicht). In Development mode werken alleen testers/rollen op de app.
7. Kopieer App ID + App Secret naar `.env.plesk` op de VPS en herstart de backend (`.\scripts\vps_pull_and_build.ps1` of container-restart).

### Page-token (berichten plaatsen)

1. Graph API Explorer: kies de app, user-token met `pages_show_list`, `pages_manage_posts`, `pages_read_engagement`.
2. `GET /me/accounts` → access_token van de The Mob State-pagina.
3. Wissel om naar een long-lived Page token en zet die in `FACEBOOK_PAGE_ACCESS_TOKEN` plus `FACEBOOK_PAGE_ID`.
4. In Development mode kan de pagina-admin posten. Live mode voor `pages_manage_posts` kan App Review vragen; tot die tijd blijft Dev mode + testers bruikbaar.

## Change Rules
- Facebook-email koppelt alleen aan een bestaand account als dat e-mailadres **geverifieerd** is. Anders `FACEBOOK_EMAIL_IN_USE`.
- Nieuwe Facebook-spelers kiezen nog steeds **username + gender + voorwaarden**. Facebook-email (indien gegeven) wordt meteen `emailVerified: true`.
- Facebook-only accounts krijgen een random `passwordHash`; inloggen gaat daarna via Facebook. Wachtwoord-reset kan als er een e-mail is.
- Geen auto-spam naar de pagina vanuit game-acties.
- Ban-check via `authService.issueSession` (zelfde als wachtwoord-login).

## Cross-Module Dependencies
- Auth / e-mailverificatie → Facebook slaat de mail-gate over (Facebook bevestigt het adres)
- Marketing web → OAuth landt op `/login?fb=ok|pending|error`
- Admin Config Toegang → naast e-mailverificatie-gate

## Must Preserve
- Knop verbergen als login niet geconfigureerd is
- Username/password-login blijft werken
- Terms-vinkje verplicht bij nieuwe Facebook-accounts

## QA Checklist
1. Zonder env: geen Facebook-knop, admin-pagina UIT
2. Met App ID/Secret: knop zichtbaar; bestaande Facebook-id logt in; nieuwe speler krijgt complete-formulier
3. Geverifieerd e-mailadres koppelt het bestaande account
4. Admin kan een testbericht + link publiceren
5. User weigert Facebook-toestemming → foutmelding, geen 500

## i18n and Messaging
Player ARB-prefix `facebook*` (`app_en.arb` / `app_nl.arb`). Admin-copy via `getAdminTr` in het paneel.

## When To Update This File
Update bij native SDK, extra Graph-rechten, automatische posts, of een wijziging in OAuth-redirects.
