# Player Profile Protocol

## Scope
Publieke spelersprofielen, profielnavigatie vanuit andere schermen, profielprivacy en profiel-interacties zoals likes.

## Primary Frontend Entry
- client/lib/screens/player_profile_screen.dart

## Primary Backend Entry
- backend/src/routes/player.ts

## Change Rules
- Elke screen die een andere speler toont met bruikbare `playerId` moet navigatie naar het profiel bieden.
- Profielnavigatie moet klikbaar en zichtbaar gesignaleerd worden; verstop dit niet achter impliciete of hover-only affordances.
- Publieke profieldata mag geen live gameplay-intel lekken zoals huidig land of andere locatiecontext die hitlist/onderzoek beïnvloedt.
- In context-screens zoals hitlist, chat of lijsten mag profielweergave de hoofdflow niet onnodig breken; embedded of contextuele navigatie heeft de voorkeur waar dat UX-technisch past.

## Cross-Module Dependencies
- Friends -> Player Profile (social context)
- Messages -> Player Profile (gespreksdeelnemers)
- Crew -> Player Profile (leden en eigenaars)
- Hitlist -> Player Profile (target context met privacygrenzen)
- Prison/Leaderboards/Trade/Events -> Player Profile (andere spelers zichtbaar in lijsten)

## Must Preserve
- Duidelijke profielnavigatie vanaf avatars en namen.
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
1. Open profielnavigatie vanaf minimaal twee verschillende contextschermen.
2. Controleer dat null/ontbrekende `playerId` niet klikbaar wordt gemaakt.
3. Verifieer dat publiek profiel geen live locatie-informatie toont.
4. Controleer NL/EN copy voor profielknoppen, likes en foutmeldingen.
5. Verifieer dat embedded/contextuele flows de hoofdmodule niet onnodig kapot navigeren.

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