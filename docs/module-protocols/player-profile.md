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
- In context-screens zoals hitlist, chat of lijsten mag profielweergave de hoofdflow niet onnodig breken; embedded of contextuele navigatie heeft de voorkeur waar dat UX-technisch past.

## Cross-Module Dependencies
- Dashboard -> Player Profile (own profile via header user menu)
- Messages -> Player Profile (gespreksdeelnemers)
- Crew -> Player Profile (leden en eigenaars)
- Hitlist -> Player Profile (target context met privacygrenzen)
- Prison/Leaderboards/Trade/Events -> Player Profile (andere spelers zichtbaar in lijsten)

## Registration (gender + starter avatar)
- Nieuwe accounts kiezen bij registratie **mannelijk of vrouwelijk** (`LoginScreen`); de server slaat `gender` (`male` \| `female`) op en zet `avatar` op `default_1` / `default_2`. Bestaande accounts kunnen `gender` null hebben; avatars blijven via `settings` / rank-allowlist wisselbaar. **Preset** custom portret-PNG’s (defaults): `backend/scripts/generate_default_avatars_leonardo.py` (Leonardo API, zie `PROTOCOL_MASTER` AI-keys). **Speler-gestuurde portretten:** selfie-upload in Instellingen → kost premium credits, opslag onder `/images/player_avatars/...` op de runtime mount; zie [player-portraits.md](player-portraits.md). **Flutter web:** registratie toont `AvatarHelper` → na asset-fallback `Image.network` naar `/images/avatars/default_*.png`; die bestanden moeten op de **externe client-image mount** staan (`runtime/client-images/avatars/`, sync via deploy-script uit `client/assets/images/avatars/`). **Layout:** breed scherm = formulier rechts; onderaan zelfde **GuestLegalFooter** als marketing (`bottomNavigationBar`).

## Must Preserve
- Publiek profiel toont featured achievements (top 6–9), tappable crew-naam en `EstateLotView` als er een huis/appartement met upgrade-levels is. Geen live landkaart.
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
7. Verifieer dat embedded/contextuele flows de hoofdmodule niet onnodig kapot navigeren.

## Implementation Pattern

```dart
import 'player_profile_screen.dart';

void _openPlayerProfile(int playerId, String username) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PlayerProfileScreen(playerId: playerId, username: username),
    ),
  );
}

GestureDetector(
  onTap: () => _openPlayerProfile(playerId, username),
  child: /* Text(username) of CircleAvatar */,
)
```

## When To Update This File
Update bij nieuwe profielinteracties, profielprivacyregels, like-functionaliteit, of wanneer extra schermtypen profielnavigatie moeten ondersteunen.