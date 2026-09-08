# Player Profile Protocol

## Scope
Publieke spelersprofielen, profielnavigatie vanuit andere schermen, profielprivacy en profiel-interacties zoals likes.

## Primary Frontend Entry
- client/lib/screens/player_profile_screen.dart

## Primary Backend Entry
- backend/src/routes/player.ts

## Change Rules
- Dashboard header user menu (avatar) includes **My profile** so a player can open their own public profile without going through friends/chat.
- Elke screen die een andere speler toont met bruikbare `playerId` moet navigatie naar het profiel bieden.
- Profielnavigatie moet klikbaar en zichtbaar gesignaleerd worden; verstop dit niet achter impliciete of hover-only affordances.
- Publieke profieldata mag geen live gameplay-intel lekken zoals huidig land of andere locatiecontext die hitlist/onderzoek beïnvloedt.
- In context-screens zoals hitlist, chat of lijsten mag profielweergave de hoofdflow niet onnodig breken. Op web opent het profiel **in de dashboard-content** (sidebar + header blijven staan), niet als fullscreen-route. Gebruik `PlayerProfileNavigation.open`.

## Cross-Module Dependencies
- Dashboard -> Player Profile (own profile via header user menu)
- Messages -> Player Profile (gespreksdeelnemers)
- Crew -> Player Profile (leden en eigenaars)
- Hitlist -> Player Profile (target context met privacygrenzen)
- Prison/Leaderboards/Trade/Events -> Player Profile (andere spelers zichtbaar in lijsten)

## Registration (gender + starter avatar)
- Nieuwe accounts kiezen bij registratie **mannelijk of vrouwelijk** (`LoginScreen`); de server slaat `gender` (`male` \| `female`) op en zet `avatar` op `default_1` / `default_2`. Bestaande accounts kunnen `gender` null hebben; avatars blijven via `settings` / rank-allowlist wisselbaar. **Preset** custom portret-PNG’s (defaults): `backend/scripts/generate_default_avatars_leonardo.py` (Leonardo API, zie `PROTOCOL_MASTER` AI-keys). **Speler-gestuurde portretten:** selfie-upload in Instellingen → kost premium credits, opslag onder `/images/player_avatars/...` op de runtime mount; zie [player-portraits.md](player-portraits.md). **Flutter web:** registratie toont `AvatarHelper` → na asset-fallback `Image.network` naar `/images/avatars/default_*.png`; die bestanden moeten op de **externe client-image mount** staan (`runtime/client-images/avatars/`, sync via deploy-script uit `client/assets/images/avatars/`). **Layout:** breed scherm = formulier rechts; onderaan zelfde **GuestLegalFooter** als marketing (`bottomNavigationBar`).

## Must Preserve
- Publiek profiel toont **alle behaalde badges** (`unlockedAchievements`: id, category, title, icon, unlockedAt) met echte badge-PNG’s, plus `featuredAchievements` (laatste 9, backward-compat), **event chips** (goud/zilver/brons-aantallen van `player_event_items`, ook 0), tappable crew-naam en **eigendommen** (`ownedProperties`: `propertyType` + `upgradeLevel`, catalogusfoto’s zoals op het eigendomsscherm). Geen `EstateLotView` / geen oud landgoed-composiet. Geen live landkaart, geen land per pand, geen opslaginhoud, geen locked-progress. Chips zijn prestige + P2P-verkoop, geen locatie-intel.
- **Online** op het publieke profiel is echte sessie-activiteit (`online:{playerId}` in Redis, gezet bij authenticate). Gebruik **niet** `lastTickAt` / `updatedAt` / `lastSessionAt` als “nu online” — ticks en login-tijd zijn geen presence. Last-seen komt uit `lastseen:{playerId}` (laatste authenticate); ontbreekt die key, val terug op `createdAt`. `lastSessionAt` is alleen voor single-session JWT-vervanging.
- Duidelijke profielnavigatie vanaf avatars en namen.
- Rangtitel op het publieke profiel is gelokaliseerd vanaf het numerieke rank-veld en gelijk aan de dashboard-rang (niet de ruwe Engelse API-`rankTitle`).
- Correcte guard op null/ongeldige `playerId` waarden.
- Privacygrenzen op publieke profielinformatie.
- Consistente NL/EN copy en consistente kliksignalen.

## Backend Contract Guardrails
- Bij profiel-like functionaliteit moet `profile_likes` runtime idempotent gebootstrapt kunnen worden of expliciet als deploystap geborgd zijn.
- Profielresponses moeten geen live locatie of andere verborgen intel lekken als dat gameplay-effect heeft.

## Frontend Guardrails
- Gebruik een gedeelde helper of vast patroon voor profielnavigatie waar mogelijk.
- Namen die naar een profiel linken moeten visueel herkenbaar zijn, bijvoorbeeld met een duidelijke linkkleur.
- Avatar- en naamnavigatie moeten dezelfde target gebruiken om inconsistent gedrag te voorkomen.

## QA Checklist
1. Open je eigen profiel via de avatar-knop → Mijn profiel.
2. Verifieer dat de rangtitel op dashboard en publiek profiel hetzelfde is (bijv. Soldaat op rang 25–29, niet Peetvader).
3. Open profielnavigatie vanaf minimaal twee verschillende contextschermen.
4. Controleer dat null/ontbrekende `playerId` niet klikbaar wordt gemaakt.
5. Verifieer dat publiek profiel geen live locatie-informatie toont.
6. Controleer NL/EN copy voor profielknoppen, likes en foutmeldingen.
7. Verifieer dat een profiel op web in de content-pane opent (sidebar zichtbaar) en dat Terug de vorige module terugzet. Geen fullscreen AppBar over de hele shell.
8. Open het profiel van een account dat lang niet inlogde: Online mag niet “Nu online” zijn; toon last-seen in dagen. Een tweede keer openen mag dat niet in “Nu online” veranderen.
9. Open eigen en andermans profiel: Event chips-kaart toont goud/zilver/brons (0 als leeg). Geen live land.
10. Open eigen en andermans profiel: Prestaties-kaart toont alleen behaalde badges (PNG + titel bij tik). Leeg = “Nog geen badges”. Locked/hidden progress niet zichtbaar.
11. Open eigen en andermans profiel: Eigendommen-kaart toont catalogusfoto’s + niveau. Geen landgoed-composiet, geen land, geen opslag.

## Implementation Pattern

```dart
import '../utils/player_profile_navigation.dart';

void _openPlayerProfile(int playerId, String username) {
  PlayerProfileNavigation.open(context, playerId, username);
}

GestureDetector(
  onTap: () => _openPlayerProfile(playerId, username),
  child: /* Text(username) of CircleAvatar */,
)
```

## When To Update This File
Update bij nieuwe profielinteracties, profielprivacyregels, like-functionaliteit, of wanneer extra schermtypen profielnavigatie moeten ondersteunen.