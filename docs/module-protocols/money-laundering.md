# Money Laundering Protocol

## Scope
Covert cash→bank wash jobs with fee, delay, FBI-heat seize risk, and small heat reduction on success.

Niet in scope:
- Directe bankstorting (blijft gratis/instant via Bank-module)
- Crypto of aandelenhandel

## Primary Frontend Entry
- `client/lib/screens/bank_screen.dart` (launder-sectie)
- `client/lib/services/launder_service.dart`

## Primary Backend Entry
- Routes: `backend/src/routes/launder.ts` (`GET /launder/status`, `POST /launder/start`)
- Service: `backend/src/services/launderService.ts`
- Schema bootstrap: `backend/src/startup/ensureDeepEconomySchema.ts` (`launder_jobs`)
- Cron: `processDueLaunderJobs` elke minuut in `cronService.ts`

## Change Rules
- Direct bank deposit mag nooit dezelfde fee/delay/seize risk krijgen als laundering.
- Output gaat altijd naar bank (niet cash).
- Seize-kans schaalt met FBI heat; succes mag heat licht verlagen via runtime key.
- NL/EN copy + Help & Uitleg synchroon houden.

## Cross-Module Dependencies
- Money Laundering -> Bank (payout + bank account)
- Money Laundering -> Security/FBI heat (`players.fbiHeat`)
- Money Laundering -> Dashboard (bank-sectie / economy overview)
- Money Laundering -> Balance & Economy (fees, delays, risk sinks)
- Money Laundering -> Activity log (`launder.*`)

## Must Preserve
- Eén actieve wash-job per speler.
- Cooldown tussen jobs (`LAUNDER_COOLDOWN_SECONDS`).
- Exact-once completion/seize claim op job-status (`processing` → `completed`/`seized`).
- UI toont fee, duur en geschatte seize-kans voordat de speler start.

## Runtime Keys
- `LAUNDER_ENABLED`
- `LAUNDER_FEE_PERCENT` (default 12)
- `LAUNDER_MIN_AMOUNT` / `LAUNDER_MAX_AMOUNT`
- `LAUNDER_DURATION_MINUTES` (default 30)
- `LAUNDER_COOLDOWN_SECONDS` (default 900)
- `LAUNDER_SEIZE_CHANCE_PER_HEAT` (default 0.4)
- `LAUNDER_HEAT_REDUCTION_ON_SUCCESS` (default 2)

## QA Checklist
1. Start wash met genoeg cash → cash daalt, job visible, bank nog niet gestegen.
2. Na `completesAt` zonder seize → bank += `amountOut`, heat daalt (indien >0).
3. Seize-pad → geen bankpayout, job status `seized`.
4. Actieve job / cooldown / te laag / te hoog / disabled foutpaden.
5. Help-topic bank vermeldt laundering; geen belofte van tick-rente als die disabled is.

## When To Update This File
Update bij nieuwe risk layers, payout destinations, heat-interacties of cron/claim wijzigingen.
