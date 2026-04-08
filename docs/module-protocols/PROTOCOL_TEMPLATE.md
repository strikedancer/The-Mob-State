# Module Protocol Template

## Scope
Beschrijf kort wat deze module doet en waar de grenzen liggen.

## Primary Frontend Entry
- Noem hoofdscherm(en) in client

## Primary Backend Entry
- Noem route(s) en service(s) in backend

## Change Rules
- Behoud kernspel-loop en voorkom verborgen regressies
- Houd NL/EN copy synchroon
- Bewaak mobile/tablet/desktop bruikbaarheid

## Cross-Module Dependencies
- Module A -> Module B (reden)
- Module A -> Admin (logging/zichtbaarheid)

## Must Preserve
- Kritieke player feedback en statusweergave
- Correcte refresh na acties
- Consistente formatting (geld, timers, percentages)

## Backend Contract Guardrails
- Prisma includes vereisen bestaande relaties in schema
- Queryvelden moeten bestaan in model
- Geen runtime validatiefouten in logs

## Frontend Loading Guardrails
- Geen all-or-nothing loading bij multi-endpoint schermen
- Fallbacks voor optionele data
- Kernkaarten blijven zichtbaar bij partial failure

## QA Checklist
1. Happy flow
2. Foutpad/locked state
3. Refresh/navigatie terug
4. Mobile + desktop check
5. Backend logs check tijdens flow
6. Minimaal 1 gekoppelde module mee testen

## i18n and Messaging
- Nieuwe labels en meldingen in NL en EN
- Wording consistent met vergelijkbare modules

## When To Update This File
Update bij nieuwe subflows, nieuwe afhankelijkheden, nieuwe notificatiepaden of gewijzigde QA-risico's.
