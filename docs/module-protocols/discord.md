# Discord (community, login, updates)

## Scope
Player **community invite** in the app, **Discord Sign-In** (web OAuth, same pattern as Google/Facebook), a **public `#updates` webhook** for player-facing patch notes, and an optional **world-chat bridge** (`global-chat.md`) on a dedicated play channel. Crew Wars staff alerts stay on a **separate** webhook (`CREW_WAR_DISCORD_WEBHOOK_URL`); they must never post into `#updates` or the world-chat channel. No auto-posts of crimes/wars to public channels, no native iOS/Android Discord SDK.

## Server layout (operator, in Discord)

Keep the guild small:

- **Info (read-only for `@everyone`):** `#regels`, `#updates` (patch notes; webhook-only), `#links` (game, wiki, in-game Support).
- **Play:** `#algemeen`, `#crew-zoeken`, `#hulp` (questions; tickets stay in the app).
- **Off-topic:** one channel.
- **Staff (hidden):** `#ops` (Crew Wars webhook), `#mod`.

Roles: `@everyone` can read info; talk only in play channels. Optional: `Speler`, `VIP` (manual), `Crewleider`, `Mod`. Server verification: phone or email. Welcome: short rules + invite, no wall of text.

Permanent invite (no expiry), preferably `https://discord.gg/…` landing on `#regels` or `#algemeen`. Store it as `DISCORD_INVITE_URL` (never a random expiring link in git).

`#updates`: only the updates webhook may post. Embed: title, 3–6 bullets, link to the game. No commit hashes, IPs, or player emails.

## Primary Frontend Entry
- `client/lib/screens/login_screen.dart` — **Doorgaan met Discord** (web only, if API `loginEnabled`)
- `client/lib/widgets/guest_legal_footer.dart` — landing/login footer Discord link
- `client/lib/screens/help_screen.dart` — Help CTA next to Almanac
- `client/lib/screens/settings_screen.dart` — Community / Discord row
- `client/lib/services/discord_community_service.dart` — caches `GET /public/community`

## Primary Backend Entry
- `GET /public/community` — `{ discordInviteUrl }` (no auth; empty/null hides CTAs)
- `GET /public/home` — same `discordInviteUrl` field on `data`
- `GET /auth/discord/status` — `{ loginEnabled }`
- `GET /auth/discord/start` — redirect to Discord OAuth
- `GET /auth/discord/callback` — code → session or pending registration, then `APP_BASE_URL/login?d=ok|pending|error`
- `POST /auth/discord/complete` — `{ pendingToken, username, gender, preferredLanguage, acceptedTerms, referralCode? }`
- Services: `backend/src/services/discordAuthService.ts`, `backend/src/lib/discordInvite.ts`, `authService.issueSession`
- Startup: `backend/src/startup/ensureDiscordSchema.ts` (`players.discordId`)

## Env (server only, never git)

`.env.plesk` / compose (`docker-compose.plesk.yml`):

- `DISCORD_INVITE_URL` — permanent `https://discord.gg/…` or `https://discord.com/invite/…`
- `DISCORD_CLIENT_ID`
- `DISCORD_CLIENT_SECRET`
- `DISCORD_OAUTH_REDIRECT_URI` — default `${API_BASE_URL}/auth/discord/callback` → `https://api.themobstate.com/auth/discord/callback`
- `DISCORD_UPDATES_WEBHOOK_URL` — incoming webhook for `#updates` only (used by `scripts/post_discord_update.ps1`, not by the game loop)
- World chat bridge (optional, see `global-chat.md`): `GLOBAL_CHAT_DISCORD_WEBHOOK_URL`, `GLOBAL_CHAT_DISCORD_BOT_TOKEN`, `GLOBAL_CHAT_DISCORD_CHANNEL_ID`

Without Client ID + Secret the login button stays hidden. Without a valid invite URL the Join Discord CTAs stay hidden. Empty updates webhook = no patch-note posts.

## Discord Developer Portal (once)

1. [discord.com/developers/applications](https://discord.com/developers/applications) → New Application **The Mob State**.
2. **OAuth2 → General:** add redirect `https://api.themobstate.com/auth/discord/callback`.
3. Scopes used by the game: `identify` and `email` only.
4. Copy Client ID + Secret into `.env.plesk` and recreate the backend container.
5. Create a permanent invite; put it in `DISCORD_INVITE_URL`.
6. In `#updates`, Integrations → Webhooks → copy URL to `DISCORD_UPDATES_WEBHOOK_URL` (not the Crew Wars ops webhook).

## Change Rules
- Discord-email links to an existing account only when that email is **verified** on our side and Discord reports `verified: true`. Otherwise `DISCORD_EMAIL_IN_USE`.
- New Discord players still pick **username + gender + terms**. Verified Discord email becomes `emailVerified: true`.
- Missing or unverified Discord email: registration still allowed (same as Facebook without mail).
- Discord-only accounts get a random `passwordHash`; later logins go through Discord.
- Ban-check via `authService.issueSession`.
- Crew Wars Discord transport stays in `crew-wars.md`. Public `#updates` never receives war events or world chat.
- World chat Discord bridge is documented in `global-chat.md`. Bot token is not an extra player OAuth scope.
- `scripts/post_discord_update.ps1` runs **after a player-facing live deploy**, not for docs-only or internal commits. Copy in Dutch, short pitch, no secrets.

## Cross-Module Dependencies
- Auth / email verification → verified Discord mail skips the mail-gate
- Marketing web → OAuth lands on `/login?d=ok|pending|error`; invite on footer + `/public/home`
- Referrals → `referralCode` on Discord complete (same as Google/Facebook)
- Help / Settings / Dashboard → community CTA
- Privacy/terms (ARB + static HTML) must mention Discord
- Crew Wars → separate staff webhook only

## Must Preserve
- Hide login if OAuth is not configured
- Hide invite CTAs if invite URL is empty or rejected
- Username/password, Google, and Facebook login keep working
- Terms checkbox required for new Discord accounts
- No extra Discord **player OAuth** scopes without a new protocol. The world-chat bot token is not an OAuth scope; see `global-chat.md`.

## QA Checklist
1. Without env: no Discord login button, no Join Discord CTAs
2. With Client ID/Secret: button visible; existing `discordId` logs in; new player gets complete form. Address bar cleaned after return (no `?d=ok&token=…`)
3. Verified email links the existing account
4. User denies Discord consent → error copy, no 500
5. Invite opens Discord in a new tab from landing, Help, and Settings
6. Updates script posts an embed to `#updates` without printing the webhook URL

## i18n and Messaging
Player ARB-prefix `discord*` plus `legalPrivacySection13*` and footer `landingFooterDiscord`. Help CTA uses `discordJoin` / `discordJoinBlurb`.

## When To Update This File
Update when adding link/unlink in Settings, extra OAuth scopes, public game-event posts, or a native Discord SDK.
