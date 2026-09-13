# Google Sign-In

## Scope
Speler-login en -registratie via **Google** (web OAuth, alleen `openid email profile`). Geen Google Drive, Gmail of andere extra scopes. Native Google Sign-In SDK valt buiten deze module.

## Primary Frontend Entry
- `client/lib/screens/login_screen.dart` — knop **Doorgaan met Google** (alleen web, alleen als de API `loginEnabled` teruggeeft)

## Primary Backend Entry
- `GET /auth/google/status` — `{ loginEnabled }` (geen auth)
- `GET /auth/google/start` — redirect naar Google OAuth
- `GET /auth/google/callback` — code → sessie of pending-registratie, daarna redirect naar `APP_BASE_URL/login?g=ok|pending|error`
- `POST /auth/google/complete` — `{ pendingToken, username, gender, preferredLanguage, acceptedTerms }`
- Service: `backend/src/services/googleAuthService.ts`, `authService.issueSession`

## Env (alleen server, nooit in git)
Zet in `.env.plesk` (zie `.env.plesk.example`):

- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_OAUTH_REDIRECT_URI` — default `${API_BASE_URL}/auth/google/callback` → `https://api.themobstate.com/auth/google/callback`

Zonder Client ID + Secret blijft de knop verborgen.

## Google Cloud (eenmalig)

1. [Google Cloud Console](https://console.cloud.google.com/) → project **The Mob State**.
2. **APIs & Services → OAuth consent screen**: User type **External**, app-naam The Mob State, support-mail `info@themobstate.com`, homepage `https://themobstate.com`, privacy `https://themobstate.com/privacy`, terms `https://themobstate.com/terms`.
3. Scopes: alleen `openid`, `.../auth/userinfo.email`, `.../auth/userinfo.profile`.
4. Authorized domains: `themobstate.com` (Search Console-verificatie).
5. **Publish** de consent screen (Production). Brand verification is optioneel; zonder branding kan de consent-schermnaam generiek zijn.
6. **Credentials → Create credentials → OAuth client ID → Web application**.
7. Authorized redirect URI: `https://api.themobstate.com/auth/google/callback`
8. Authorized JavaScript origins (optioneel): `https://themobstate.com`
9. Client ID + Secret naar `.env.plesk` en backend herstarten.

## Change Rules
- Google-email koppelt alleen aan een bestaand account als dat e-mailadres bij ons **en** bij Google geverifieerd is. Anders `GOOGLE_EMAIL_IN_USE`.
- Nieuwe Google-spelers kiezen **username + gender + voorwaarden**. Google-email wordt `emailVerified: true`.
- Google-only accounts krijgen een random `passwordHash`; inloggen gaat daarna via Google.
- Ban-check via `authService.issueSession`.

## Cross-Module Dependencies
- Auth / e-mailverificatie → Google slaat de mail-gate over (Google bevestigt het adres)
- Marketing web → OAuth landt op `/login?g=ok|pending|error`
- Privacy/terms (statische HTML + in-game legal) moeten Google noemen

## Must Preserve
- Knop verbergen als login niet geconfigureerd is
- Username/password- en Facebook-login blijven werken
- Terms-vinkje verplicht bij nieuwe Google-accounts
- Geen extra Google-scopes zonder nieuw protocol

## QA Checklist
1. Zonder env: geen Google-knop
2. Met Client ID/Secret: knop zichtbaar; bestaande `googleId` logt in; nieuwe speler krijgt complete-formulier
3. Geverifieerd e-mailadres koppelt het bestaande account
4. User weigert Google-toestemming → foutmelding, geen 500

## i18n and Messaging
Player ARB-prefix `google*` plus `legalPrivacySection12*`.

## When To Update This File
Update bij native SDK, extra Google-scopes, of een wijziging in OAuth-redirects.
