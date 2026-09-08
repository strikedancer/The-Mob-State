# Don Protocol

## Scope
Persistent Don hub: protection rackets, loan sharking, NPC officials and city contracts in the current country. Rank 7+ unless Admin `DON_MIN_RANK` says otherwise. Claim is always personal. Tribute goes to cash unless the owner is `leader` / `co_leader` / `capo` (capo only in `capoCountry`) and chooses crew-bank.

Street crime `protection_racket` stays a one-shot shake. This hub is the persistent empire and must not also grant shops from that crime.

Out of scope for this module: blotter newspaper, weapons P2P, Facebook Login, horses. Country police, Clearing House, war theater and Midnight Races live in their own protocols.

## Primary Frontend Entry
- `client/lib/screens/don_screen.dart` (dashboard Empire → Don; optional `/don`)
- Crew Members: role `consigliere` / `capo` + capo land in `crew_screen.dart`

## Primary Backend Entry
- `GET /don/overview`
- `POST /don/rackets/:id/claim|collect|squeeze|tribute|contest|hold`
- `POST /don/loans/npc` `{ npcKey, principal }`
- `POST /don/loans/offer` `{ borrowerId | borrowerUsername, principal }`
- `POST /don/loans/:id/accept|repay|collect`
- `POST /don/officials/:office/bribe` (`judge` | `commissioner` | `alderman`)
- `POST /don/contracts/:id/bid` `{ fromCrew, greedy }`
- `POST /crews/:id/members/:playerId/role` `{ role, capoCountry? }`
- Services: `donService.ts`, `donRuntimeConfig.ts`, tick in `tickQueue.ts`

## Catalogs
- `backend/content/donBusinesses.json`
- `backend/content/donOfficials.json`
- `backend/content/donContracts.json` (NPC sharks + city contracts)

## Runtime keys (`DON_*`, default **on**)
Tune in Admin; do not flip Clearing House defaults from this module.
- `DON_ENABLED` (1)
- `DON_MIN_RANK` (7)
- `DON_COLLECT_COOLDOWN_SECONDS` (14400)
- `DON_ABANDON_SECONDS` (259200)
- Squeeze: duration, tribute %, wanted, flee %
- Contest window, max rackets (8)
- Loan caps: 3 active, 2k–50k principal, 3-day term, NPC default %, collect %
- Official hours (24), judge appeal bonus (max +8%), commissioner wanted mult (80%), alderman payout bonus, off-books %

## Player loops
- **Rackets:** claim in current country with a weapon that meets intimidation. Manual collect + cooldown. Unused shops abandon after ~72h. Squeeze: higher tribute, extra wanted, chance the shop flees. Rival contest: short window; owner can hold.
- **Loans:** player is the shark. NPC lend (tick repay or default) + P2P escrow offer. Default → collect a share of due, wanted, no full wipe.
- **Officials:** one judge / commissioner / alderman per country. Cash overbid, expires, rival can replace. Judge stacks with law-school **only up to the +8% Don cap**, then appeal still clamps 10–85%. Commissioner lowers crime-fail wanted. Alderman unlocks/boosts large contracts. Per-case court bribe in `court.md` stays.
- **Contracts:** open jobs per country; bid costs 20% of catalog payout (cash or crew-bank). Greedy: +payout +heat. Off-books bonus if you own rackets in that country. Large jobs need alderman and/or engineering school.

## Crew roles
- `consigliere`: sees crew-Don racket overview; no crew-bank withdraw.
- `capo` + `capoCountry`: may send tribute / contract bids to crew-bank only in that country.
- Leader / co-leader: crew-bank tribute in any country.

Tribute and contract payouts stay **under** jobs/drugs/nightclub unless telemetry says otherwise. No credit paywall. No daily pet-decay.

## Cross-Module Dependencies
- Don -> Travel (current country)
- Don -> Crew / crew-bank (hybrid tribute, capo/consigliere)
- Don -> Court (capped judge appeal bonus; per-case bribe unchanged)
- Don -> Crimes (weapon intimidation gate; commissioner wanted mult on fail bump)
- Don -> School (engineering gate on large contracts)
- Don -> Territory (`regionKey` optional; **no** contest-reuse)
- Don -> Dashboard (Empire section), Notifications/world events (`don.*`), Balance

## Must Preserve
- Street `protection_racket` crime must not also grant persistent shops.
- Judge bonus is capped; law-school still applies; appeal hard cap 10–85%.
- Commissioner is a light wanted multiplier, not arrest immunity.
- Crew-bank tribute requires role + (for capo) matching country; overflow falls back to cash.
- Clear success/failure feedback and refresh after every Don action.

## QA Checklist
1. Empire → Don: claim, collect, squeeze, rival contest + hold, tribute toggle cash vs crew-bank.
2. NPC loan + P2P offer/accept/repay/collect on default.
3. Bribe judge/commissioner/alderman; overbid; expiry.
4. Bid a small contract; greedy heat; large contract locked without alderman/engineering.
5. Leader sets consigliere and capo+country; capo tribute only in that country.
6. Rank &lt; 7 and jailed players are blocked.
7. Help topic `don` NL/EN; Don hub does not own war-theater / races / police / Clearing House.
