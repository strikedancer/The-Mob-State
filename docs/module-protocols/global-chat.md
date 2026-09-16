# World chat (global lobby)

## Scope
One public in-game lobby for every logged-in player, with a curated sticker pack and a server-side swear filter for the player UI languages (nl, en, de, fr, es, it, pl, pt). Optional Discord bridge mirrors the same lobby to a dedicated Discord channel so people can talk without opening the game. Direct messages and crew chat stay separate. No credit paywall. No image uploads.

## Primary Frontend Entry
- `client/lib/screens/world_chat_screen.dart`
- Dashboard: Sociaal → Wereldchat (`_WebSection.worldChat`)
- Help topic `world-chat`

## Primary Backend Entry
- `GET /global-chat/messages`
- `POST /global-chat/messages` `{ message, stickerId? }`
- `DELETE /global-chat/messages/:id` (own message, ~10 minutes)
- `POST /global-chat/messages/:id/report`
- `GET /global-chat/stickers`
- Admin: `GET /admin/global-chat/overview`, `PUT /admin/global-chat/settings`, `DELETE /admin/global-chat/messages/:id`, mute routes
- Player staff (Mod/Ops): `DELETE /global-chat/messages/:id/staff`, `POST /global-chat/mutes`, `DELETE /global-chat/mutes/:playerId`, `GET /global-chat/staff/overview`
- Services: `globalChatService.ts`, `globalChatDiscordBridge.ts`, `profanityFilter.ts`
- Startup: `ensureGlobalChatSchema.ts`

## Change Rules
- Keep DMs and crew chat unchanged.
- Filter on the server, never only in the client.
- Live updates use SSE `global_chat.message` / `global_chat.message_deleted` via `eventBroadcaster.broadcast`. Do not write world-chat lines into the personal activity feed. No push per public message.
- System lines (`source: system`, sender `Gevangenis`) announce when a **real player** is jailed, bought out, or jailbroken. Names are in the body. NPCs are skipped. Own bail / self-escape stay silent. These lines still mirror to the Discord wereldchat lobby; they never go to `#updates`.
- Hide the live-event rail on World chat (same as Messages / Crew) so it cannot cover send.
- World chat stays open before rank 5.
- Discord outbound uses `GLOBAL_CHAT_DISCORD_WEBHOOK_URL`. Inbound polling uses `GLOBAL_CHAT_DISCORD_BOT_TOKEN` + `GLOBAL_CHAT_DISCORD_CHANNEL_ID`. Empty env = in-game only. Never post this lobby into `#updates` or the Crew Wars ops webhook.
- Game → Discord webhook names use `[Ops]` / `[Mod]` when the player is staff. Discord-native staff lines get a 🛡️ / 🔨 reaction.
- Linked Mods/Ops can moderate in `#wereldchat`: reply `!wis` (or `!delete`) to remove a line in-game and on Discord; `!mute @name 15|60`, `!unmute @name`, `!hulp`. Commands are not ingested as chat. Bot invite needs Send Messages + Manage Messages + Add Reactions for those tools; the `[Ops]`/`[Mod]` name prefix works with the webhook alone.
- Game → Discord does not bounce back (skip webhook/bot authors). Discord → game is not re-posted to Discord.
- Strip `@everyone` / `@here` / user mentions. `allowed_mentions.parse` is empty on outbound webhooks.
- Inbound Discord poll starts from “now” on boot (no history dump).

## Discord operator setup
1. Create a play channel such as `#wereldchat` (not Info, not `#updates`, not `#ops`).
2. Channel → Integrations → Webhook → copy URL into `GLOBAL_CHAT_DISCORD_WEBHOOK_URL` on the VPS (`.env.plesk`).
3. Discord Developer Portal → Bot: enable **Message Content Intent**, then invite the bot:
   `https://discord.com/oauth2/authorize?client_id=1549017603706716160&permissions=76864&scope=bot`
   (View Channel, Send Messages, Manage Messages, Add Reactions, Read Message History). Missing Access (403) until the bot is in the guild and can see `#wereldchat`. Inbound polling keeps retrying on 403 after invite; 401 (bad token) still stops. Re-invite if the bot was added with the older 66560 permission set, otherwise `!wis` / mute replies cannot delete Discord lines.
4. Put the bot token in `GLOBAL_CHAT_DISCORD_BOT_TOKEN` and the channel snowflake in `GLOBAL_CHAT_DISCORD_CHANNEL_ID`.
5. Recreate the backend container so env is picked up. Admin → Wereldchat shows outbound/inbound on/off.

Player OAuth stays `identify` + `email` only. The chat bot is a separate token.

## Cross-Module Dependencies
- Dashboard / Help / Frontend platform
- Discord (community invite + Sign-In stay; this adds a chat bridge)
- Messages (DMs remain private)
- Crew (crew chat remains crew-only)
- Prison (system jail / buyout / jailbreak lines)
- Admin (mute, delete, extra blocklist, kill switch `GLOBAL_CHAT_ENABLED`)
- Staff roles (player Mod/Ops in-game + scoped admin World chat)
- Player Profile (tap a linked in-game name)

## Must Preserve
- Rate limit (~1 / 3s, 10 / min). Max 200 characters.
- Stickers are a fixed catalog (`globalChatStickers.ts` / `global_chat_stickers.dart`), same ids.
- Banned accounts cannot send. Linked Discord of a banned or muted player is dropped inbound.
- Discord-sourced lines use the linked in-game username when `discordId` matches a player; otherwise the Discord username. Game-sourced lines always use the in-game username. Players who did not sign in with Discord can link later from Settings. Guests without a linked account still appear with a Discord tag.

## QA Checklist
1. Send text + sticker in-game; second browser sees it live.
2. Filter replaces blocked words with `***` instead of rejecting the whole line.
3. Own delete within 10 minutes; later delete fails.
4. Report someone else’s line; it shows in Admin.
5. Mute blocks send with `GLOBAL_CHAT_MUTED`. A Mod/Ops badge appears on their lines, including their own bubbles; they can delete another player's line and mute from long-press. Discord copies of those lines show `[Ops]` / `[Mod]` on the webhook name.
6. Live-event rail hidden on the screen; Enter sends.
7. Without Discord env, in-game chat still works.
8. With webhook only: game posts appear in Discord; Discord replies do not enter the game until bot+channel are set.
9. Jail a real player (or buy out / jailbreak another): a `Gevangenis` system line appears live. An NPC arrest does not.
10. Linked Mod/Ops in `#wereldchat`: `!hulp` lists commands; reply `!wis` deletes; `!mute Name 15` mutes world chat. A player without staffRole cannot run those commands.

## i18n and Messaging
ARB prefix `worldChat*` plus Help `helpTopicWorldChat*`.

## When To Update This File
Update when adding rooms, custom sticker assets, push, extra Discord intents/scopes, or Discord staff commands.
