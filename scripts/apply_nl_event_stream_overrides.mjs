#!/usr/bin/env node
/**
 * Replaces English copies in app_nl.arb for game/event stream keys with Dutch.
 * Run after merge from app_en. Does not touch @metadata blocks.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const nlPath = path.join(__dirname, '..', 'client', 'lib', 'l10n', 'app_nl.arb');

const nl = JSON.parse(fs.readFileSync(nlPath, 'utf8'));

const T = {
  gameEventDefaultTitle: 'Event',
  gameEventStatusActive: 'Actief',
  gameEventStatusScheduled: 'Gepland',
  gameEventStatusCompleted: 'Afgerond',
  gameEventStatusDraft: 'Concept',
  gameEventTmplWeeklyVehicleTheftHuntTitle: 'Wekelijkse Diefstaljacht',
  gameEventTmplWeeklyVehicleTheftHuntDesc:
    'Steel zoveel mogelijk voertuigen tijdens het eventvenster.',
  gameEventTmplSmugglingSurgeTitle: 'Smokkelgolf',
  gameEventTmplSmugglingSurgeDesc:
    'Beweeg zoveel mogelijk smokkel in deze ronde.',
  gameEventTmplLabOutputChallengeTitle: 'Lab-output Uitdaging',
  gameEventTmplLabOutputChallengeDesc:
    'Produceer de meeste productie tijdens het event.',
  gameEventTmplStreetCrimeSpreeTitle: 'Straat Crime Spree',
  gameEventTmplStreetCrimeSpreeDesc:
    'Pleg zoveel mogelijk misdaden in het actieve venster.',
  gameScreenLoadError: 'Events konden niet geladen worden.',
  gameScreenDetailsLoadError: 'Eventdetails konden niet geladen worden.',
  gameScreenSectionLive: 'Live events',
  gameScreenNoActive: 'Er zijn nu geen actieve events.',
  gameScreenSectionUpcoming: 'Aankomende events',
  gameScreenNoUpcoming: 'Er zijn geen geplande events.',
  gameScreenStatusPrefix: 'Status: {value}',
  gameScreenStartLine: 'Start: {date}',
  gameScreenEndLine: 'Einde: {date}',
  gameScreenYourProgress: 'Jouw voortgang',
  gameScreenScore: 'Score: {value}',
  gameScreenRank: 'Rank: {value}',
  gameScreenLeaderboard: 'Leaderboard (top 10)',
  gameScreenNoLeaderboard: 'Nog geen leaderboard data.',
  gameScreenUnknownPlayer: 'Onbekend',
  gameCardActive: 'Actief',
  gameCardScheduled: 'Gepland',
  gameCardYourScore: 'Jouw score: {value}',
  gameCardYourRank: 'Jouw rank: {value}',
  gameCardTapDetails: 'Tik voor details en leaderboard',
  eventFeedDisconnected: 'Geen verbinding met de event stream',
  eventFeedReconnecting: 'Opnieuw verbinden...',
  eventFeedConnectedWaiting: 'Verbonden — wachten op events…',
  eventFeedConnecting: 'Verbinden met de event stream…',
  evStreamConnectionEstablished: 'Verbonden met event stream',
  evStreamAuthRegistered: 'Account succesvol aangemaakt.',
  evStreamAuthLogin: 'Welkom terug.',
  evStreamCrimeSuccess:
    'Succesvol {crimeName} gepleegd! +EUR {reward}, +{xpGained} XP',
  evStreamCrimeSuccessJailed:
    'Succesvol {crimeName} gepleegd! +EUR {reward}, +{xpGained} XP — maar gepakt! {minutes, plural, one{1 minuut} other{{minutes} minuten}} detentie.',
  evStreamCrimeSeizedVehicle: ' Je voertuig is in beslag genomen door de politie.',
  evStreamCrimeSeizedWeapon: ' Je wapen is in beslag genomen door de politie.',
  evStreamCrimeSuccessCleared:
    'Succesvol {crimeName} gepleegd! Strafblad gewist: {count, plural, one{1 veroordeling} other{{count} veroordelingen}}. +{xpGained} XP',
  evStreamCrimeFailedArrested: 'Gearresteerd door {authority} tijdens een {crimeName}-poging.',
  evStreamCrimeFailedJailed: 'Gepakt tijdens {crimeName}! {minutes, plural, one{1 minuut} other{{minutes} minuten}} detentie.',
  evStreamCrimeFailedBase: 'Misdrijf {crimeName} mislukt',
  evStreamChaseDamage: ' Je voertuig kreeg {pct}% schade tijdens de achtervolging.',
  evStreamCrimeJailed: 'Gepakt tijdens {crimeName}! {minutes, plural, one{1 minuut} other{{minutes} minuten}} detentie.',
  evStreamJobSuccess: 'Werk als {jobName} voltooid! +€{earnings}, +{xpGained} XP',
  evStreamJobSuccessEdu: ' (Opleidingsbonus +{pct}%)',
  evStreamJobFailedXp: 'Werk als {jobName} mislukt. −{xpLost} XP',
  evStreamJobFailed: 'Werk als {jobName} mislukt',
  evStreamJobErrorInvalid: 'Ongeldig werk',
  evStreamJobErrorLevel: 'Je rank is te laag voor dit werk',
  evStreamJobErrorCooldown:
    'Dit werk heeft cooldown. Wacht {minutes, plural, one{nog 1 minuut} other{nog {minutes} minuten}}',
  evStreamJobErrorGeneric: 'Werkfout: {reason}',
  evStreamTravelDeparted: 'Vliegt naar {dest}… −€{cost}',
  evStreamTravelArrived: 'Aangekomen in {country}.',
  evStreamBankDeposit: '€{amount} gestort op de bankrekening',
  evStreamBankWithdraw: '€{amount} opgenomen van de bankrekening',
  evStreamCryptoBuy: 'Kocht {quantity} {symbol} voor €{total}',
  evStreamCryptoSell: 'Verkocht {quantity} {symbol} voor €{total} (resultaat €{pnl})',
  evStreamCryptoAlert: '{symbol} alert: €{price} ({chg}% 24u)',
  evStreamCryptoOrderFilled: '{order} {side} uitgevoerd: {quantity} {symbol} op €{price}',
  evStreamCryptoOrderTriggered: '{trig} geactiveerd voor {symbol} op €{price}',
  evStreamCryptoRegime: 'Marktregime: {regime} ({move}% 24u)',
  evStreamCryptoNews: '{sentiment} nieuws: {headline}',
  evStreamCryptoMissionDaily: 'Dagmissie voltooid: {title} (+EUR {reward})',
  evStreamCryptoMissionWeekly: 'Weekmissie voltooid: {title} (+EUR {reward})',
  evStreamCryptoLeaderboard: 'Crypto leaderboard-beloning: #{rank} (+EUR {reward})',
  evStreamRegimeBull: 'stijgend',
  evStreamRegimeBear: 'dalend',
  evStreamRegimeSideways: 'zijwaarts',
  evStreamImpactBull: 'Positief',
  evStreamImpactBear: 'Negatief',
  evStreamImpactNeutral: 'Neutraal',
  evStreamPropertyBought: '{name} gekocht voor €{cost}',
  evStreamCrewCreated: 'Crew aangemaakt: {name}',
  evStreamCrewJoined: 'Bij crew gegaan: {name}',
  evStreamCrewWarDeclared: 'Crew-oorlog verklaard: #{a} vs #{b} ({type})',
  evStreamCrewWarStarted: 'Crew-oorlog gestart: #{a} vs #{b}',
  evStreamCrewLockdown: 'Crew-oorlog #{id} zit in lockdown',
  evStreamCrewResolved: 'Crew-oorlog #{id} afgerond. Winnaar: crew #{winner}',
  evStreamCrewAction: 'Crew-oorlog actie: {action} (+{points} ptn)',
  evStreamHeistOk: 'Overval “{name}” geslaagd! +€{money}',
  evStreamHeistFail: 'Overval “{name}” mislukt.',
  evStreamHospital: 'Genezen in ziekenhuis! +{hp} gezondheid, −€{cost}',
  evStreamPoliceArrested: 'Gearresteerd! {mins} minuten cel',
  evStreamPoliceEscaped: 'Je bent ontsnapt aan de politie.',
  evStreamFbiRaid: 'FBI-inval! Je verloor bezit en geld.',
  evStreamErrInsufficientFunds: 'Onvoldoende geld',
  evStreamErrInsufficientHealth: 'Onvoldoende gezondheid voor deze actie',
  evStreamErrInsufficientRank: 'Vereist rank {rank}',
  evStreamErrJailed: 'Je zit nog {minutes, plural, one{1 minuut} other{{minutes} minuten}} in de cel',
  evStreamErrNoHealthDefault: 'Je moet rusten en gezondheid herstellen',
  evStreamErrCooldown: 'Wacht {seconds, plural, one{1 seconde} other{{seconds} seconden}} voordat je opnieuw probeert',
  evStreamErrRescuerJailed: 'Je kunt anderen niet bevrijden in de cel',
  evStreamErrTargetNotJailed: 'Deze speler zit niet in de cel',
  evStreamErrCannotRescueSelf: 'Je kunt jezelf niet bevrijden',
  evStreamJailbreakOk: 'Uitbraak geslaagd! De speler is vrij.',
  evStreamJailbreakFail: 'Uitbraak mislukt! De speler zit nog in de cel.',
  evStreamJailbreakCaught: 'Uitbraak mislukt! Je bent gepakt: {mins} minuten cel.',
  evStreamBailPaid: 'Borg betaald: €{amount}. Je bent vrij.',
  evStreamErrInternal: 'Er ging iets mis. Probeer opnieuw.',
  evStreamTest: 'Test: {msg}',
  evStreamNoCriminalRecord: 'Je hebt geen strafblad om te wissen',
  evStreamWeaponSelectRequired: 'Kies eerst een misdaad-wapen',
  evStreamWeaponNotSuitable: 'Je hebt een geschikt wapen nodig: {types}',
  evStreamJobFallbackName: 'werk',
  evStreamUnknownKey: '{key}',
};

let n = 0;
for (const [k, v] of Object.entries(T)) {
  if (k in nl && nl[k] !== v) {
    nl[k] = v;
    n += 1;
  }
}
fs.writeFileSync(nlPath, JSON.stringify(nl, null, 2) + '\n', 'utf8');
console.log(`apply_nl_event_stream_overrides: updated ${n} Dutch strings in app_nl.arb`);
