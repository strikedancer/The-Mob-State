# Module Protocols

These files are the change-attachment protocol for live game modules.

## Single Attachment Entry

Use this file as your default single attachment entrypoint:
- [Master Protocol](PROTOCOL_MASTER.md)
- [Protocol Template](PROTOCOL_TEMPLATE.md)

From there, open only the module files needed for the task.

Use them whenever a module is changed so scope, UX rules, i18n, notifications and QA stay aligned.

## Required workflow

1. Attach the matching protocol file to the task.
2. Read the current player-facing flow before editing code.
3. Preserve NL and EN parity for any new or changed copy.
4. Preserve mobile, tablet and desktop usability where the module is visible on client.
5. Validate backend data contracts when a module depends on Prisma relations or nested API payloads.
6. For dashboard-style screens that load multiple endpoints, prevent a single API failure from blanking the whole view.
7. Update the matching help content in client/lib/data/help_content.dart when player behavior changes.
8. Update the protocol file itself if the module contract or QA expectations change.

### Data contract validation (mandatory when backend touched)

- If service code uses Prisma `include` with relations, those relations must exist in `schema.prisma` on both sides.
- After schema or service query changes: run `npx prisma validate` and `npx prisma generate`.
- Re-test the exact endpoint used by the screen to catch `PrismaClientValidationError` before UI testing.

### Dashboard resilience

- For screens using multiple parallel API calls, do not let one failing call hide all data.
- Use safe fallbacks (`[]`, `{}`, `null`) or split critical calls so core sections keep rendering.

## Available protocols
- [Dashboard](dashboard.md)
- [Crimes](crimes.md)
- [Jobs](jobs.md)
- [Travel](travel.md)
- [Crew](crew.md)
- [Friends](friends.md)
- [Messages](messages.md)
- [Inventory](inventory.md)
- [Properties](properties.md)
- [Bank](bank.md)
- [Casino](casino.md)
- [Trade Goods](trade.md)
- [Black Market](black-market.md)
- [Drugs](drugs.md)
- [Nightclub](nightclub.md)
- [Crypto](crypto.md)
- [Smuggling](smuggling.md)
- [Tools](tools.md)
- [Court](court.md)
- [Hitlist](hitlist.md)
- [Security](security.md)
- [Hospital](hospital.md)
- [Prison](prison.md)
- [Steel Voertuig](steel_voertuig.md)
- [Garage](garage.md)
- [Motor](motor.md)
- [Marina](marina.md)
- [TuneShop](tuneshop.md)
- [Shooting Range](shooting-range.md)
- [Gym](gym.md)
- [Ammo Factory](ammo-factory.md)
- [School](school.md)
- [Prostitution](prostitution.md)
- [Red Light Districts](red-light-districts.md)
- [Achievements](achievements.md)
- [Settings](settings.md)
