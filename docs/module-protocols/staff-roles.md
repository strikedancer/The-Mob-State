# Player staff roles (Mod / Ops)

## Scope
A player account can be given `staffRole` `NONE` (default), `MOD`, or `OPS`. Super-admins assign this on Admin → Players. Mods and Ops keep playing with their normal account. They can also sign in at admin.themobstate.com with that same game username and password. No second admin password. Super-admin table accounts stay separate.

## In the game
- World chat badge next to the name (`Mod` / `Ops`), including on your own bubbles.
- Long-press another world-chat message: delete for everyone, mute 15 min / 1 hour, unmute.
- Staff can open the report list from the world-chat header.
- No crew-chat or DM moderation in this pass. No permanent ban from the game UI.

## Admin site
| Role | Pages |
|------|--------|
| **Mod** | World chat only (delete / mute / reports). No kill-switch or extra blocklist. |
| **Ops** | World chat + Tickets + Players (search and read). No money, rank, VIP, ban, config, admins, or Ops lab. |
| **Super-admin** | Full admin as today. Only they assign or revoke Mod/Ops. |

## Backend
- Column `players.staffRole` (`NONE` / `MOD` / `OPS`), added at startup by `ensureStaffRoleSchema.ts`.
- Admin login: try `admins` first, then a player with `staffRole != NONE`.
- Staff JWT: `type: 'admin'`, `playerId`, `staffRole`, no `adminId`. Mapped as `VIEWER` so existing write guards stay closed.
- `restrictPlayerStaffAdminRoutes` whitelists the routes above. Other `/admin/*` returns 403.
- In-game: `requirePlayerStaff` on `/global-chat/messages/:id/staff`, `/global-chat/mutes`, `/global-chat/staff/overview`.
- Audit: staff actions store `actorPlayerId` + `actorStaffRole` (nullable `adminId`).

## Must preserve
- Super-admin is the only one who grants roles or bans accounts.
- Staff cannot change economy sliders, VIP, money, or config.
- Same login error for a normal player and a bad password (no role leak).
- Clearing House runtime stays 3. Event Pass qty stays 1.

## QA
1. Super-admin sets a player to Mod. That player sees a badge on their own world-chat lines and on other players' views of those lines, and can delete someone else's world-chat line.
2. The same player logs into admin.themobstate.com with the game password and only sees World chat.
3. Change the role to Ops: Tickets and Players appear; Manage / money / ban stay hidden.
4. A player with `NONE` cannot open staff routes (403) and cannot log into admin.
5. Super-admin can set the role back to None; the next login and JWT refresh lose access.

## When To Update This File
When adding crew-chat/DM tools, extra admin pages for Ops, or a dedicated staff password.
