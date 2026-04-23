# Casino Phase 1 Update (2026-04-23)

Deze update voegt 2 nieuwe casinospellen toe:

- `Baccarat`
- `Video Poker`

## Wat is nieuw

- Casino-overzicht toont nu 6 spellen:
  - Slots
  - Blackjack
  - Roulette
  - Dice
  - Baccarat
  - Video Poker
- Beide nieuwe spellen draaien op dezelfde casino-bankrolllogica als bestaande games.
- Resultaten worden als JSON-string gelogd in `casinoTransaction.result`.
- Nieuwe games openen embedded in dezelfde dashboard/content-shell (geen losse fullpage flow).

## Spelregels (kort)

### Baccarat
- Inzettypes: speler, bankier, gelijkspel.
- Payouts:
  - Speler: 1:1
  - Bankier: 0.95:1 (commissie verwerkt)
  - Gelijkspel: 8:1

### Video Poker
- 5 kaarten per ronde, directe hand-evaluatie.
- Minimum winnende hand: Jacks or Better.
- Top payout: Royal Flush.

## UX en platform

- Mobiel/tablet/desktop responsive via fit-to-screen canvas.
- Kernactie, inzet en status blijven zonder verplichte verticale scroll zichtbaar in de minigame-view.
- Nieuwe casino-tegelafbeeldingen toegevoegd:
  - `client/assets/images/casino/baccarat.png`
  - `client/assets/images/casino/video_poker.png`

## NL/EN dekking

- Nieuwe game labels en beschrijvingen zijn uitgewerkt in NL en EN in de player flow.
- `Help & Uitleg` casino-item is bijgewerkt met Baccarat en Video Poker in zowel NL als EN.
