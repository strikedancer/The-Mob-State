# Midnight Races Protocol

## Scope
Scheduled street races in the player's **current country**. Qualify with an owned **car** that is physically in that country. Cash stake + optional spectator bets. Server-roll finish with garage/tune/condition as a light modifier. Hosting nightclub receives rake. Optional fixing = wanted, not a guaranteed win.

Not in v1: horses, breeding, real-time driving, daily condition decay, skill-game steering.

## Primary Frontend Entry
- `client/lib/screens/race_screen.dart` (Empire → Midnight Races; optional `/races`)
- Help topic `races`

## Primary Backend Entry
- `GET /races/overview`
- `POST /races/enter` `{ vehicleInventoryId, stake, fixing }`
- `POST /races/bet` `{ entryId, amount }`
- `raceService.ts` + `raceRuntimeConfig.ts`
- Tick: `tickQueue.ts` / `tickService.ts` settles meetings whose `endsAt` has passed

## Runtime keys (`RACE_*`, default **on**)
Tune in `runtime_config`. Caps keep this from becoming a second casino.
- `RACE_ENABLED` (1)
- `RACE_MIN_RANK` (3)
- `RACE_WINDOW_MINUTES` (90) / `RACE_COOLDOWN_MINUTES` (120)
- `RACE_RAKE_BPS` (800 = 8%)
- Stake 1k–25k, bet 500–8k, max 12 entries, max 3 bets per player
- `RACE_MIN_CONDITION` (35), `RACE_FIXING_WANTED` (8)

## Player rules
- Car only (`vehicleType=car`), `currentLocation` = current country, not listed, not in showroom, not in transit.
- One entry per meeting. Cannot bet on yourself.
- Fewer than two drivers → refund stakes and bets.
- Finish order: vehicle speed + tune speed + condition + RNG (+ fixing bonus).
- Driver prize is 65% of the net pool (after rake); winning bets share the rest. No nightclub host → rake is sunk.

## Change Rules
- Keep Dutch and English copy in sync (`race*` / `helpTopicRaces*`).
- Do not let races out-earn casino or jobs on a per-minute basis; raise caps only after telemetry.
- Garage/tune must remain visible in the roll; do not flatten to pure RNG.
- Fixing must never become a payout multiplier or immunity.

## Cross-Module Dependencies
- Garage / TuneShop (eligibility + speed modifier)
- Nightclub (host rake)
- Casino (rake pattern, not a second house game)
- Travel (you race where you stand)
- Country police / wanted (fixing heat)
- Dashboard Empire nav

## QA Checklist
- [ ] Enter with a car in-country; reject listed/showroom/transit/low condition
- [ ] Grid settles on tick after `endsAt`
- [ ] Host nightclub owner receives rake when present
- [ ] Solo entry refunds
- [ ] NL + EN strings
