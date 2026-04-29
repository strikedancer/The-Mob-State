#!/usr/bin/env node
/**
 * Replaces English copies in app_es.arb for game/event stream keys with Spanish.
 * ICU placeholders must match app_en.arb / @ metadata.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const esPath = path.join(__dirname, '..', 'client', 'lib', 'l10n', 'app_es.arb');

const es = JSON.parse(fs.readFileSync(esPath, 'utf8'));

const T = {
  gameEventDefaultTitle: 'Evento',
  gameEventStatusActive: 'Activo',
  gameEventStatusScheduled: 'Programado',
  gameEventStatusCompleted: 'Finalizado',
  gameEventStatusDraft: 'Borrador',
  gameEventTmplWeeklyVehicleTheftHuntTitle: 'Caza de robos semanal',
  gameEventTmplWeeklyVehicleTheftHuntDesc:
    'Roba tantos vehículos como puedas durante la ventana del evento.',
  gameEventTmplSmugglingSurgeTitle: 'Oleada de contrabando',
  gameEventTmplSmugglingSurgeDesc:
    'Mueve el mayor volumen de contrabando en esta ronda.',
  gameEventTmplLabOutputChallengeTitle: 'Desafío de producción del laboratorio',
  gameEventTmplLabOutputChallengeDesc:
    'Produce la mayor cantidad mientras el evento esté activo.',
  gameEventTmplStreetCrimeSpreeTitle: 'Racha de crímenes callejeros',
  gameEventTmplStreetCrimeSpreeDesc:
    'Completa tantos crímenes como puedas mientras el evento esté en curso.',
  gameScreenLoadError: 'No se pudieron cargar los eventos.',
  gameScreenDetailsLoadError: 'No se pudieron cargar los detalles del evento.',
  gameScreenSectionLive: 'Eventos en vivo',
  gameScreenNoActive: 'No hay eventos activos ahora.',
  gameScreenSectionUpcoming: 'Próximos eventos',
  gameScreenNoUpcoming: 'No hay eventos programados.',
  gameScreenStatusPrefix: 'Estado: {value}',
  gameScreenStartLine: 'Inicio: {date}',
  gameScreenEndLine: 'Fin: {date}',
  gameScreenYourProgress: 'Tu progreso',
  gameScreenScore: 'Puntuación: {value}',
  gameScreenRank: 'Posición: {value}',
  gameScreenLeaderboard: 'Clasificación (top 10)',
  gameScreenNoLeaderboard: 'Aún no hay datos de clasificación.',
  gameScreenUnknownPlayer: 'Desconocido',
  gameCardActive: 'Activo',
  gameCardScheduled: 'Programado',
  gameCardYourScore: 'Tu puntuación: {value}',
  gameCardYourRank: 'Tu posición: {value}',
  gameCardTapDetails: 'Toca para ver detalles y la clasificación',
  eventFeedDisconnected: 'Sin conexión al flujo de eventos',
  eventFeedReconnecting: 'Reconectando…',
  eventFeedConnectedWaiting: 'Conectado: esperando eventos…',
  eventFeedConnecting: 'Conectando al flujo de eventos…',
  evStreamConnectionEstablished: 'Conectado al flujo de eventos',
  evStreamAuthRegistered: 'Cuenta creada correctamente.',
  evStreamAuthLogin: 'Bienvenido de nuevo.',
  evStreamCrimeSuccess:
    '¡Completaste con éxito {crimeName}! +EUR {reward}, +{xpGained} XP',
  evStreamCrimeSuccessJailed:
    '¡Completaste con éxito {crimeName}! +EUR {reward}, +{xpGained} XP — ¡pero te pillaron! Encarcelado durante {minutes, plural, one{1 minuto} other{{minutes} minutos}}.',
  evStreamCrimeSeizedVehicle: ' La policía incautó tu vehículo.',
  evStreamCrimeSeizedWeapon: ' La policía confiscó tu arma.',
  evStreamCrimeSuccessCleared:
    '¡Completaste con éxito {crimeName}! Antecedentes borrados: {count, plural, one{1 condena} other{{count} condenas}}. +{xpGained} XP',
  evStreamCrimeFailedArrested:
    '¡Detenido por {authority} durante un intento de {crimeName}!',
  evStreamCrimeFailedJailed:
    '¡Te pillaron en {crimeName}! Encarcelado durante {minutes, plural, one{1 minuto} other{{minutes} minutos}}.',
  evStreamCrimeFailedBase: 'No se pudo completar {crimeName}',
  evStreamChaseDamage: ' Tu vehículo sufrió un {pct}% de daño en la persecución.',
  evStreamCrimeJailed:
    '¡Te pillaron en {crimeName}! Encarcelado durante {minutes, plural, one{1 minuto} other{{minutes} minutos}}.',
  evStreamJobSuccess:
    '¡Trabajo como {jobName} completado! +€{earnings}, +{xpGained} XP',
  evStreamJobSuccessEdu: ' (Bonificación de formación +{pct}%)',
  evStreamJobFailedXp: 'No completaste el trabajo como {jobName}. −{xpLost} XP',
  evStreamJobFailed: 'No completaste el trabajo como {jobName}',
  evStreamJobErrorInvalid: 'Trabajo no válido',
  evStreamJobErrorLevel: 'Tu rango es demasiado bajo para este trabajo',
  evStreamJobErrorCooldown:
    'Este trabajo tiene tiempo de espera. Espera {minutes, plural, one{1 minuto más} other{{minutes} minutos más}}',
  evStreamJobErrorGeneric: 'Error de trabajo: {reason}',
  evStreamTravelDeparted: 'Volando a {dest}… −€{cost}',
  evStreamTravelArrived: '¡Llegaste a {country}!',
  evStreamBankDeposit: 'Ingresaste €{amount} en el banco',
  evStreamBankWithdraw: 'Retiraste €{amount} del banco',
  evStreamCryptoBuy: 'Compraste {quantity} {symbol} por €{total}',
  evStreamCryptoSell:
    'Vendiste {quantity} {symbol} por €{total} (PyG €{pnl})',
  evStreamCryptoAlert: 'Alerta {symbol}: €{price} ({chg}% 24h)',
  evStreamCryptoOrderFilled:
    '{order} {side} ejecutada: {quantity} {symbol} a €{price}',
  evStreamCryptoOrderTriggered:
    '{trig} activada para {symbol} a €{price}',
  evStreamCryptoRegime:
    'Régimen de mercado: {regime} ({move}% 24h)',
  evStreamCryptoNews: 'Noticias {sentiment}: {headline}',
  evStreamCryptoMissionDaily:
    'Misión diaria completada: {title} (+EUR {reward})',
  evStreamCryptoMissionWeekly:
    'Misión semanal completada: {title} (+EUR {reward})',
  evStreamCryptoLeaderboard:
    'Recompensa del ranking crypto: n.º {rank} (+EUR {reward})',
  evStreamRegimeBull: 'alcista',
  evStreamRegimeBear: 'bajista',
  evStreamRegimeSideways: 'lateral',
  evStreamImpactBull: 'Alcista',
  evStreamImpactBear: 'Bajista',
  evStreamImpactNeutral: 'Neutral',
  evStreamPropertyBought: 'Compraste {name} por €{cost}',
  evStreamCrewCreated: 'Banda creada: {name}',
  evStreamCrewJoined: 'Te uniste a la banda: {name}',
  evStreamCrewWarDeclared:
    'Guerra de bandas declarada: #{a} vs #{b} ({type})',
  evStreamCrewWarStarted: 'Guerra de bandas iniciada: #{a} vs #{b}',
  evStreamCrewLockdown: 'La guerra de bandas #{id} está en confinamiento',
  evStreamCrewResolved:
    'Guerra de bandas #{id} resuelta. Ganador: banda #{winner}',
  evStreamCrewAction: 'Acción de guerra: {action} (+{points} pt)',
  evStreamHeistOk: 'Atraco “{name}” conseguido. +€{money}',
  evStreamHeistFail: 'Atraco “{name}” fallido.',
  evStreamHospital:
    '¡Curado en el hospital! +{hp} de salud, −€{cost}',
  evStreamPoliceArrested: '¡Detenido! {mins} minutos de cárcel',
  evStreamPoliceEscaped: 'Escapaste de la policía.',
  evStreamFbiRaid: '¡Redada del FBI! Perdiste propiedades y dinero.',
  evStreamErrInsufficientFunds: 'Dinero insuficiente',
  evStreamErrInsufficientHealth: 'Salud insuficiente para esta acción',
  evStreamErrInsufficientRank: 'Requiere rango {rank}',
  evStreamErrJailed:
    'Sigues en la cárcel {minutes, plural, one{1 minuto más} other{{minutes} minutos más}}',
  evStreamErrNoHealthDefault: 'Descansa y recupera salud',
  evStreamErrCooldown:
    'Espera {seconds, plural, one{1 segundo} other{{seconds} segundos}} antes de volver a intentarlo',
  evStreamErrRescuerJailed:
    'No puedes rescatar a otros mientras estás en la cárcel',
  evStreamErrTargetNotJailed: 'Ese jugador no está en la cárcel',
  evStreamErrCannotRescueSelf: 'No puedes rescatarte a ti mismo',
  evStreamJailbreakOk: '¡Fuga conseguida! El jugador está libre.',
  evStreamJailbreakFail: '¡Fuga fallida! El jugador sigue en la cárcel.',
  evStreamJailbreakCaught:
    '¡Fuga fallida! Te pillaron: {mins} minutos de cárcel.',
  evStreamBailPaid: 'Fianza pagada: €{amount}. ¡Estás libre!',
  evStreamErrInternal: 'Algo salió mal. Inténtalo de nuevo.',
  evStreamTest: 'Prueba: {msg}',
  evStreamNoCriminalRecord: 'No tienes antecedentes que borrar',
  evStreamWeaponSelectRequired:
    'Selecciona un arma para el crimen antes de cometerlo',
  evStreamWeaponNotSuitable: 'Necesitas un arma adecuada: {types}',
  evStreamJobFallbackName: 'trabajo',
  evStreamUnknownKey: '{key}',
};

let n = 0;
for (const [k, v] of Object.entries(T)) {
  if (k in es && es[k] !== v) {
    es[k] = v;
    n += 1;
  }
}
fs.writeFileSync(esPath, JSON.stringify(es, null, 2) + '\n', 'utf8');
console.log(`apply_es_event_stream_overrides: updated ${n} Spanish strings in app_es.arb`);
