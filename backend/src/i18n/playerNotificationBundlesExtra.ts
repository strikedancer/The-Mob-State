/**
 * Full push + in-app notification copy for player languages de, fr, es, it, pl, pt.
 * EN/NL remain the primary catalogs in translationService (email HTML for those two only).
 */
import type { SupportedPlayerLanguage } from '../config/supportedLanguages';
import type { Translations } from '../services/translationService';

// —— DE ——
function deOrderType(t: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT') {
  if (t === 'LIMIT') {
    return 'Limit-Order';
  }
  if (t === 'STOP_LOSS') {
    return 'Stop-Loss-Order';
  }
  return 'Take-Profit-Order';
}
function deSide(side: 'BUY' | 'SELL') {
  return side === 'BUY' ? 'Gekauft' : 'Verkauft';
}
function deRegime(r: 'BULL' | 'BEAR' | 'SIDEWAYS') {
  if (r === 'BULL') {
    return 'bullish';
  }
  if (r === 'BEAR') {
    return 'bearish';
  }
  return 'seitwärts';
}
function deImpact(i: 'BULLISH' | 'BEARISH' | 'NEUTRAL') {
  if (i === 'BULLISH') {
    return 'Bullish';
  }
  if (i === 'BEARISH') {
    return 'Bearish';
  }
  return 'Neutral';
}
const notificationDE: Translations['notification'] = {
  friendRequest: {
    title: 'Neue Freundschaftsanfrage',
    body: (senderUsername) => `${senderUsername} möchte sich mit dir verbinden`,
  },
  friendAccepted: {
    title: 'Freundschaftsanfrage angenommen',
    body: (acceptorUsername) => `${acceptorUsername} hat deine Anfrage angenommen`,
  },
  crewJoinRequest: {
    title: 'Crew-Beitrittsanfrage',
    body: (requesterUsername, crewName) => `${requesterUsername} möchte ${crewName} beitreten`,
  },
  crewJoinApproved: {
    title: 'Crew-Beitritt bestätigt',
    body: (crewName) => `Dein Beitritt zu ${crewName} wurde bestätigt`,
  },
  crewJoinRejected: {
    title: 'Crew-Beitritt abgelehnt',
    body: (crewName) => `Dein Beitritt zu ${crewName} wurde abgelehnt`,
  },
  crewKicked: {
    title: 'Aus Crew entfernt',
    body: (crewName) => `Du wurdest aus ${crewName} entfernt`,
  },
  crewRoleChanged: {
    title: 'Crew-Rolle geändert',
    body: (crewName, role) => `Deine Rolle in ${crewName} ist jetzt ${role}`,
  },
  crewHeistResult: {
    title: (success) => (success ? 'Crew-Überfall erfolgreich' : 'Crew-Überfall fehlgeschlagen'),
    body: (crewName, heistName, success) =>
      success
        ? `${crewName} hat ${heistName} abgeschlossen`
        : `${crewName} ist bei ${heistName} gescheitert`,
  },
  directMessage: {
    title: 'Neue Nachricht',
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  supportTicketUpdate: {
    title: 'Support-Ticket aktualisiert',
    body: (ticketId, subject) => `Ticket #${ticketId} — neue Antwort: ${subject}`,
  },
  crewMessage: {
    title: (crewName) => `${crewName}`,
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  cryptoTradeExecuted: {
    title: (side) => (side === 'BUY' ? 'Krypto-Kauf ausgeführt' : 'Krypto-Verkauf ausgeführt'),
    body: (symbol, quantity, totalValue, realizedProfit) => {
      const base = `${quantity} ${symbol} für EUR ${totalValue}`;
      if (realizedProfit !== undefined) {
        return `Trade: ${base} (PnL: EUR ${realizedProfit})`;
      }
      return `Trade: ${base}`;
    },
  },
  cryptoPriceAlert: {
    title: 'Krypto-Preisalarm',
    body: (symbol, currentPrice, changePct) =>
      `${symbol} steht jetzt bei EUR ${currentPrice} (${changePct}% 24h)`,
  },
  cryptoOrderFilled: {
    title: 'Krypto-Order ausgeführt',
    body: (symbol, orderType, side, quantity, fillPrice) =>
      `${deOrderType(orderType)} ${deSide(side)}: ${quantity} ${symbol} @ EUR ${fillPrice}`,
  },
  cryptoOrderTriggered: {
    title: 'Krypto-Order ausgelöst',
    body: (symbol, triggerType, triggerPrice) =>
      `${triggerType === 'STOP_LOSS' ? 'Stop-Loss' : 'Take-Profit'} für ${symbol} @ EUR ${triggerPrice}`,
  },
  cryptoMarketRegime: {
    title: 'Krypto-Marktregime',
    body: (regime, marketMovePct) =>
      `Markt wechselte zu ${deRegime(regime)}-Regime (24h: ${marketMovePct}%)`,
  },
  cryptoMarketNews: {
    title: 'Krypto-Marktnachrichten',
    body: (headline, impact) => `${deImpact(impact)}: ${headline}`,
  },
  cryptoMissionCompleted: {
    title: (missionType) =>
      missionType === 'DAILY' ? 'Tägliche Krypto-Mission' : 'Wöchentliche Krypto-Mission',
    body: (missionTitle, rewardMoney) =>
      `${missionTitle} abgeschlossen. Belohnung: EUR ${rewardMoney}`,
  },
  cryptoLeaderboardReward: {
    title: 'Krypto-Ranglistenbelohnung',
    body: (rank, rewardMoney, periodLabel) =>
      `Du bist #${rank} in ${periodLabel}. Belohnung: EUR ${rewardMoney}`,
  },
  casinoLowBalance: {
    title: 'Casino: niedriges Guthaben',
    body: (casinoName, currentBalance, threshold) =>
      `${casinoName}: Guthaben EUR ${currentBalance} (min. EUR ${threshold})`,
  },
  cooldownExpired: {
    title: '⏰ Bereit für die Aktion!',
    body: (actionName) => `Deine ${actionName}-Abklingzeit ist abgelaufen. Lege los!`,
  },
  bankTransferReceived: {
    title: '💰 Geld erhalten',
    body: (senderUsername, amount) => `${senderUsername} hat dir €${amount} überwiesen.`,
  },
};

// —— FR ——
function frOrderType(t: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT') {
  if (t === 'LIMIT') {
    return 'Ordre limite';
  }
  if (t === 'STOP_LOSS') {
    return 'Stop-loss';
  }
  return 'Take-profit';
}
function frSide(side: 'BUY' | 'SELL') {
  return side === 'BUY' ? 'Achat' : 'Vente';
}
function frRegime(r: 'BULL' | 'BEAR' | 'SIDEWAYS') {
  if (r === 'BULL') {
    return 'haussier';
  }
  if (r === 'BEAR') {
    return 'baissier';
  }
  return 'latéral';
}
function frImpact(i: 'BULLISH' | 'BEARISH' | 'NEUTRAL') {
  if (i === 'BULLISH') {
    return 'Haussier';
  }
  if (i === 'BEARISH') {
    return 'Baissier';
  }
  return 'Neutre';
}
const notificationFR: Translations['notification'] = {
  friendRequest: {
    title: "Nouvelle demande d'ami",
    body: (senderUsername) => `${senderUsername} veut se connecter avec toi`,
  },
  friendAccepted: {
    title: 'Demande acceptée',
    body: (acceptorUsername) => `${acceptorUsername} a accepté ta demande`,
  },
  crewJoinRequest: {
    title: "Demande d'adhésion",
    body: (requesterUsername, crewName) => `${requesterUsername} veut rejoindre ${crewName}`,
  },
  crewJoinApproved: {
    title: 'Adhésion approuvée',
    body: (crewName) => `Ta candidature pour ${crewName} est approuvée`,
  },
  crewJoinRejected: {
    title: 'Adhésion refusée',
    body: (crewName) => `Ta candidature pour ${crewName} est refusée`,
  },
  crewKicked: {
    title: 'Exclu du Crew',
    body: (crewName) => `Tu as été exclu de ${crewName}`,
  },
  crewRoleChanged: {
    title: 'Rôle mis à jour',
    body: (crewName, role) => `Ton rôle dans ${crewName} est maintenant ${role}`,
  },
  crewHeistResult: {
    title: (success) => (success ? 'Braquage réussi' : 'Braquage échoué'),
    body: (crewName, heistName, success) =>
      success
        ? `${crewName} a réussi ${heistName}`
        : `${crewName} a échoué sur ${heistName}`,
  },
  directMessage: {
    title: 'Nouveau message',
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  supportTicketUpdate: {
    title: 'Ticket support',
    body: (ticketId, subject) => `Ticket #${ticketId} — nouvelle réponse : ${subject}`,
  },
  crewMessage: {
    title: (crewName) => `${crewName}`,
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  cryptoTradeExecuted: {
    title: (side) => (side === 'BUY' ? 'Achat crypto exécuté' : 'Vente crypto exécutée'),
    body: (symbol, quantity, totalValue, realizedProfit) => {
      const base = `${quantity} ${symbol} pour EUR ${totalValue}`;
      if (realizedProfit !== undefined) {
        return `Transaction : ${base} (PnL : EUR ${realizedProfit})`;
      }
      return `Transaction : ${base}`;
    },
  },
  cryptoPriceAlert: {
    title: 'Alerte prix crypto',
    body: (symbol, currentPrice, changePct) =>
      `${symbol} : EUR ${currentPrice} (${changePct}% 24h)`,
  },
  cryptoOrderFilled: {
    title: 'Ordre crypto exécuté',
    body: (symbol, orderType, side, quantity, fillPrice) =>
      `${frOrderType(orderType)} ${frSide(side)} : ${quantity} ${symbol} @ EUR ${fillPrice}`,
  },
  cryptoOrderTriggered: {
    title: 'Ordre déclenché',
    body: (symbol, triggerType, triggerPrice) =>
      `${triggerType === 'STOP_LOSS' ? 'Stop-loss' : 'Take-profit'} sur ${symbol} @ EUR ${triggerPrice}`,
  },
  cryptoMarketRegime: {
    title: 'Régime de marché',
    body: (regime, marketMovePct) =>
      `Marché : régime ${frRegime(regime)} (mouv. 24h ${marketMovePct}%)`,
  },
  cryptoMarketNews: {
    title: 'Actu crypto',
    body: (headline, impact) => `${frImpact(impact)} : ${headline}`,
  },
  cryptoMissionCompleted: {
    title: (missionType) =>
      missionType === 'DAILY' ? 'Mission crypto quotidienne' : 'Mission crypto hebdo',
    body: (missionTitle, rewardMoney) => `${missionTitle} terminée. Récompense : EUR ${rewardMoney}`,
  },
  cryptoLeaderboardReward: {
    title: 'Récompense classement',
    body: (rank, rewardMoney, periodLabel) =>
      `Tu finis #${rank} pour ${periodLabel}. Récompense : EUR ${rewardMoney}`,
  },
  casinoLowBalance: {
    title: 'Casino : solde bas',
    body: (casinoName, currentBalance, threshold) =>
      `${casinoName} : solde EUR ${currentBalance} (min. EUR ${threshold})`,
  },
  cooldownExpired: {
    title: "⏰ C'est l'heure d'agir !",
    body: (actionName) => `Le délai d'attente (${actionName}) est fini. À toi de jouer !`,
  },
  bankTransferReceived: {
    title: '💰 Argent reçu',
    body: (senderUsername, amount) => `${senderUsername} t'a viré €${amount}.`,
  },
};

// —— ES ——
function esOrderType(t: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT') {
  if (t === 'LIMIT') {
    return 'Orden límite';
  }
  if (t === 'STOP_LOSS') {
    return 'Stop loss';
  }
  return 'Take profit';
}
function esSide(side: 'BUY' | 'SELL') {
  return side === 'BUY' ? 'Compra' : 'Venta';
}
function esRegime(r: 'BULL' | 'BEAR' | 'SIDEWAYS') {
  if (r === 'BULL') {
    return 'alcista';
  }
  if (r === 'BEAR') {
    return 'bajista';
  }
  return 'lateral';
}
function esImpact(i: 'BULLISH' | 'BEARISH' | 'NEUTRAL') {
  if (i === 'BULLISH') {
    return 'Alcista';
  }
  if (i === 'BEARISH') {
    return 'Bajista';
  }
  return 'Neutro';
}
const notificationES: Translations['notification'] = {
  friendRequest: {
    title: 'Nueva solicitud de amistad',
    body: (senderUsername) => `${senderUsername} quiere conectar contigo`,
  },
  friendAccepted: {
    title: 'Solicitud aceptada',
    body: (acceptorUsername) => `${acceptorUsername} aceptó tu solicitud`,
  },
  crewJoinRequest: {
    title: 'Solicitud al Crew',
    body: (requesterUsername, crewName) => `${requesterUsername} quiere unirse a ${crewName}`,
  },
  crewJoinApproved: {
    title: 'Admisión aprobada',
    body: (crewName) => `Tu ingreso a ${crewName} fue aprobado`,
  },
  crewJoinRejected: {
    title: 'Admisión rechazada',
    body: (crewName) => `Tu ingreso a ${crewName} fue rechazado`,
  },
  crewKicked: {
    title: 'Expulsado del Crew',
    body: (crewName) => `Has sido expulsado de ${crewName}`,
  },
  crewRoleChanged: {
    title: 'Rol actualizado',
    body: (crewName, role) => `Tu rol en ${crewName} es ahora ${role}`,
  },
  crewHeistResult: {
    title: (success) => (success ? 'Atraco del Crew: éxito' : 'Atraco del Crew: fallo'),
    body: (crewName, heistName, success) =>
      success
        ? `${crewName} completó ${heistName}`
        : `${crewName} falló en ${heistName}`,
  },
  directMessage: {
    title: 'Nuevo mensaje',
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  supportTicketUpdate: {
    title: 'Actualización de soporte',
    body: (ticketId, subject) => `El ticket #${ticketId} tiene novedades: ${subject}`,
  },
  crewMessage: {
    title: (crewName) => `${crewName}`,
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  cryptoTradeExecuted: {
    title: (side) => (side === 'BUY' ? 'Compra crypto completada' : 'Venta crypto completada'),
    body: (symbol, quantity, totalValue, realizedProfit) => {
      const base = `${quantity} ${symbol} por EUR ${totalValue}`;
      if (realizedProfit !== undefined) {
        return `Operación: ${base} (PnL: EUR ${realizedProfit})`;
      }
      return `Operación: ${base}`;
    },
  },
  cryptoPriceAlert: {
    title: 'Alerta de precio',
    body: (symbol, currentPrice, changePct) => `${symbol}: EUR ${currentPrice} (${changePct}% 24h)`,
  },
  cryptoOrderFilled: {
    title: 'Orden ejecutada',
    body: (symbol, orderType, side, quantity, fillPrice) =>
      `${esOrderType(orderType)} ${esSide(side)}: ${quantity} ${symbol} @ EUR ${fillPrice}`,
  },
  cryptoOrderTriggered: {
    title: 'Orden activada',
    body: (symbol, triggerType, triggerPrice) =>
      `${triggerType === 'STOP_LOSS' ? 'Stop loss' : 'Take profit'} en ${symbol} @ EUR ${triggerPrice}`,
  },
  cryptoMarketRegime: {
    title: 'Régimen de mercado',
    body: (regime, marketMovePct) => `Mercado: régimen ${esRegime(regime)} (24h: ${marketMovePct}%)`,
  },
  cryptoMarketNews: {
    title: 'Noticias crypto',
    body: (headline, impact) => `${esImpact(impact)}: ${headline}`,
  },
  cryptoMissionCompleted: {
    title: (missionType) =>
      missionType === 'DAILY' ? 'Misión diaria' : 'Misión semanal',
    body: (missionTitle, rewardMoney) => `${missionTitle} completada. Recompensa: EUR ${rewardMoney}`,
  },
  cryptoLeaderboardReward: {
    title: 'Recompensa de ranking',
    body: (rank, rewardMoney, periodLabel) =>
      `Quedas #${rank} en ${periodLabel}. Recompensa: EUR ${rewardMoney}`,
  },
  casinoLowBalance: {
    title: 'Casino: saldo bajo',
    body: (casinoName, currentBalance, threshold) =>
      `${casinoName}: saldo EUR ${currentBalance} (mín. EUR ${threshold})`,
  },
  cooldownExpired: {
    title: '⏰ ¡Listo para actuar!',
    body: (actionName) =>
      `El tiempo de espera de ${actionName} ha terminado. ¡A por ello!`,
  },
  bankTransferReceived: {
    title: '💰 Dinero recibido',
    body: (senderUsername, amount) => `${senderUsername} te transferió €${amount}.`,
  },
};

// —— IT ——
function itOrderType(t: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT') {
  if (t === 'LIMIT') {
    return 'Ordine limite';
  }
  if (t === 'STOP_LOSS') {
    return 'Stop loss';
  }
  return 'Take profit';
}
function itSide(side: 'BUY' | 'SELL') {
  return side === 'BUY' ? 'Acquisto' : 'Vendita';
}
function itRegime(r: 'BULL' | 'BEAR' | 'SIDEWAYS') {
  if (r === 'BULL') {
    return 'rialzista';
  }
  if (r === 'BEAR') {
    return 'ribassista';
  }
  return 'laterale';
}
function itImpact(i: 'BULLISH' | 'BEARISH' | 'NEUTRAL') {
  if (i === 'BULLISH') {
    return 'Rialzista';
  }
  if (i === 'BEARISH') {
    return 'Ribassista';
  }
  return 'Neutro';
}

const notificationIT: Translations['notification'] = {
  friendRequest: {
    title: 'Nuova richiesta amicizia',
    body: (senderUsername) => `${senderUsername} vuole connettersi con te`,
  },
  friendAccepted: {
    title: 'Richiesta accettata',
    body: (acceptorUsername) => `${acceptorUsername} ha accettato la richiesta`,
  },
  crewJoinRequest: {
    title: 'Richiesta Crew',
    body: (requesterUsername, crewName) => `${requesterUsername} vuole unirsi a ${crewName}`,
  },
  crewJoinApproved: {
    title: 'Ammissione approvata',
    body: (crewName) => `La tua adesione a ${crewName} è approvata`,
  },
  crewJoinRejected: {
    title: 'Ammissione rifiutata',
    body: (crewName) => `La tua adesione a ${crewName} è rifiutata`,
  },
  crewKicked: {
    title: 'Espulso dal Crew',
    body: (crewName) => `Sei stato espulso da ${crewName}`,
  },
  crewRoleChanged: {
    title: 'Ruolo aggiornato',
    body: (crewName, role) => `Il tuo ruolo in ${crewName} è ora ${role}`,
  },
  crewHeistResult: {
    title: (success) => (success ? 'Colpo Crew: successo' : 'Colpo Crew: fallito'),
    body: (crewName, heistName, success) =>
      success
        ? `${crewName} ha completato ${heistName}`
        : `${crewName} ha fallito ${heistName}`,
  },
  directMessage: {
    title: 'Nuovo messaggio',
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  supportTicketUpdate: {
    title: 'Aggiornamento assistenza',
    body: (ticketId, subject) => `Il ticket #${ticketId} ha un aggiornamento: ${subject}`,
  },
  crewMessage: {
    title: (crewName) => `${crewName}`,
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  cryptoTradeExecuted: {
    title: (side) => (side === 'BUY' ? 'Acquisto crypto eseguito' : 'Vendita crypto eseguita'),
    body: (symbol, quantity, totalValue, realizedProfit) => {
      const base = `${quantity} ${symbol} a EUR ${totalValue}`;
      if (realizedProfit !== undefined) {
        return `Operazione: ${base} (PnL: EUR ${realizedProfit})`;
      }
      return `Operazione: ${base}`;
    },
  },
  cryptoPriceAlert: {
    title: 'Avviso prezzo crypto',
    body: (symbol, currentPrice, changePct) => `${symbol}: EUR ${currentPrice} (${changePct}% 24h)`,
  },
  cryptoOrderFilled: {
    title: 'Ordine eseguito',
    body: (symbol, orderType, side, quantity, fillPrice) =>
      `${itOrderType(orderType)} ${itSide(side)}: ${quantity} ${symbol} @ EUR ${fillPrice}`,
  },
  cryptoOrderTriggered: {
    title: 'Ordine attivato',
    body: (symbol, triggerType, triggerPrice) =>
      `${triggerType === 'STOP_LOSS' ? 'Stop loss' : 'Take profit'} su ${symbol} @ EUR ${triggerPrice}`,
  },
  cryptoMarketRegime: {
    title: 'Regime di mercato',
    body: (regime, marketMovePct) =>
      `Mercato: regime ${itRegime(regime)} (24h: ${marketMovePct}%)`,
  },
  cryptoMarketNews: {
    title: 'Notizie di mercato',
    body: (headline, impact) => `${itImpact(impact)}: ${headline}`,
  },
  cryptoMissionCompleted: {
    title: (missionType) =>
      missionType === 'DAILY' ? 'Missione crypto giornaliera' : 'Missione crypto settimanale',
    body: (missionTitle, rewardMoney) => `${missionTitle} completata. Ricompensa: EUR ${rewardMoney}`,
  },
  cryptoLeaderboardReward: {
    title: 'Ricompensa classifica',
    body: (rank, rewardMoney, periodLabel) =>
      `Hai chiuso al #${rank} in ${periodLabel}. Ricompensa: EUR ${rewardMoney}`,
  },
  casinoLowBalance: {
    title: 'Casino: saldo basso',
    body: (casinoName, currentBalance, threshold) =>
      `${casinoName}: saldo EUR ${currentBalance} (min. EUR ${threshold})`,
  },
  cooldownExpired: {
    title: '⏰ Pronto all’azione!',
    body: (actionName) => `Il cooldown su ${actionName} è scaduto. Torna in azione!`,
  },
  bankTransferReceived: {
    title: '💰 Denaro ricevuto',
    body: (senderUsername, amount) => `${senderUsername} ha trasferito €${amount} al tuo conto.`,
  },
};

// —— PL ——
function plOrderType(t: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT') {
  if (t === 'LIMIT') {
    return 'Zlecenie limit';
  }
  if (t === 'STOP_LOSS') {
    return 'Stop loss';
  }
  return 'Take profit';
}
function plSide(side: 'BUY' | 'SELL') {
  return side === 'BUY' ? 'Kupno' : 'Sprzedaż';
}
function plRegime(r: 'BULL' | 'BEAR' | 'SIDEWAYS') {
  if (r === 'BULL') {
    return 'byczy';
  }
  if (r === 'BEAR') {
    return 'niedźwiedzi';
  }
  return 'boczny';
}
function plImpact(i: 'BULLISH' | 'BEARISH' | 'NEUTRAL') {
  if (i === 'BULLISH') {
    return 'Hossa';
  }
  if (i === 'BEARISH') {
    return 'Bessa';
  }
  return 'Neutralnie';
}
const notificationPL: Translations['notification'] = {
  friendRequest: {
    title: 'Nowa prośba o znajomość',
    body: (senderUsername) => `${senderUsername} chce się z tobą połączyć`,
  },
  friendAccepted: {
    title: 'Prośba zaakceptowana',
    body: (acceptorUsername) => `${acceptorUsername} zaakceptował prośbę`,
  },
  crewJoinRequest: {
    title: 'Prośba o dołączenie do Crew',
    body: (requesterUsername, crewName) => `${requesterUsername} chce dołączyć do ${crewName}`,
  },
  crewJoinApproved: {
    title: 'Zatwierdzono dołączenie',
    body: (crewName) => `Prośba o wejście do ${crewName} została zatwierdzona`,
  },
  crewJoinRejected: {
    title: 'Odrzucono dołączenie',
    body: (crewName) => `Prośba o wejście do ${crewName} została odrzucona`,
  },
  crewKicked: {
    title: 'Wyrzucono z załogi',
    body: (crewName) => `Zostałeś wyrzucony z ${crewName}`,
  },
  crewRoleChanged: {
    title: 'Rola w załodze',
    body: (crewName, role) => `Twoja rola w ${crewName} to teraz ${role}`,
  },
  crewHeistResult: {
    title: (success) => (success ? 'Skok crew: sukces' : 'Skok crew: porażka'),
    body: (crewName, heistName, success) =>
      success
        ? `${crewName} ukończył ${heistName}`
        : `${crewName} nie udało się ${heistName}`,
  },
  directMessage: {
    title: 'Nowa wiadomość',
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  supportTicketUpdate: {
    title: 'Aktualizacja zgłoszenia',
    body: (ticketId, subject) => `Zgłoszenie #${ticketId} — nowa odpowiedź: ${subject}`,
  },
  crewMessage: {
    title: (crewName) => `${crewName}`,
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  cryptoTradeExecuted: {
    title: (side) => (side === 'BUY' ? 'Krypto: kupno' : 'Krypto: sprzedaż'),
    body: (symbol, quantity, totalValue, realizedProfit) => {
      const base = `${quantity} ${symbol} za EUR ${totalValue}`;
      if (realizedProfit !== undefined) {
        return `Transakcja: ${base} (PnL: EUR ${realizedProfit})`;
      }
      return `Transakcja: ${base}`;
    },
  },
  cryptoPriceAlert: {
    title: 'Alert ceny krypto',
    body: (symbol, currentPrice, changePct) => `${symbol}: EUR ${currentPrice} (${changePct}% 24h)`,
  },
  cryptoOrderFilled: {
    title: 'Zlecenie wykonane',
    body: (symbol, orderType, side, quantity, fillPrice) =>
      `${plOrderType(orderType)} ${plSide(side)}: ${quantity} ${symbol} @ EUR ${fillPrice}`,
  },
  cryptoOrderTriggered: {
    title: 'Zlecenie uruchomione',
    body: (symbol, triggerType, triggerPrice) =>
      `${triggerType === 'STOP_LOSS' ? 'Stop loss' : 'Take profit'} — ${symbol} @ EUR ${triggerPrice}`,
  },
  cryptoMarketRegime: {
    title: 'Reżim rynku',
    body: (regime, marketMovePct) => `Rynek: reżim ${plRegime(regime)} (24h: ${marketMovePct}%)`,
  },
  cryptoMarketNews: {
    title: 'Wiadomości rynkowe',
    body: (headline, impact) => `${plImpact(impact)}: ${headline}`,
  },
  cryptoMissionCompleted: {
    title: (missionType) => (missionType === 'DAILY' ? 'Misja dnia' : 'Misja tygodniowa'),
    body: (missionTitle, rewardMoney) => `${missionTitle} ukończona. Nagroda: EUR ${rewardMoney}`,
  },
  cryptoLeaderboardReward: {
    title: 'Nagroda w rankingu',
    body: (rank, rewardMoney, periodLabel) => `Miejsce #${rank} w ${periodLabel}. Nagroda: EUR ${rewardMoney}`,
  },
  casinoLowBalance: {
    title: 'Kasyno: niskie saldo',
    body: (casinoName, currentBalance, threshold) => `${casinoName}: saldo EUR ${currentBalance} (min. EUR ${threshold})`,
  },
  cooldownExpired: {
    title: '⏰ Gotowe do akcji!',
    body: (actionName) => `Czas odniesienia (${actionName}) minął. Wracaj do gry!`,
  },
  bankTransferReceived: {
    title: '💰 Otrzymano pieniądze',
    body: (senderUsername, amount) => `${senderUsername} przelał €${amount} na konto bankowe.`,
  },
};

// —— PT ——
function ptOrderType(t: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT') {
  if (t === 'LIMIT') {
    return 'Ordem limite';
  }
  if (t === 'STOP_LOSS') {
    return 'Stop loss';
  }
  return 'Take profit';
}
function ptSide(side: 'BUY' | 'SELL') {
  return side === 'BUY' ? 'Compra' : 'Venda';
}
function ptRegime(r: 'BULL' | 'BEAR' | 'SIDEWAYS') {
  if (r === 'BULL') {
    return 'de alta';
  }
  if (r === 'BEAR') {
    return 'de baixa';
  }
  return 'lateral';
}
function ptImpact(i: 'BULLISH' | 'BEARISH' | 'NEUTRAL') {
  if (i === 'BULLISH') {
    return 'Otimista';
  }
  if (i === 'BEARISH') {
    return 'Pessimista';
  }
  return 'Neutro';
}
const notificationPT: Translations['notification'] = {
  friendRequest: {
    title: 'Novo pedido de amizade',
    body: (senderUsername) => `${senderUsername} quer conectar contigo`,
  },
  friendAccepted: {
    title: 'Pedido aceite',
    body: (acceptorUsername) => `${acceptorUsername} aceitou o teu pedido`,
  },
  crewJoinRequest: {
    title: 'Pedido para a Crew',
    body: (requesterUsername, crewName) => `${requesterUsername} quer entrar em ${crewName}`,
  },
  crewJoinApproved: {
    title: 'Entrada aprovada',
    body: (crewName) => `O teu pedido para ${crewName} foi aprovado`,
  },
  crewJoinRejected: {
    title: 'Entrada rejeitada',
    body: (crewName) => `O teu pedido para ${crewName} foi rejeitado`,
  },
  crewKicked: {
    title: 'Removido da Crew',
    body: (crewName) => `Foste removido de ${crewName}`,
  },
  crewRoleChanged: {
    title: 'Papel atualizado',
    body: (crewName, role) => `O teu papel em ${crewName} é agora ${role}`,
  },
  crewHeistResult: {
    title: (success) => (success ? 'Assalto do Crew: sucesso' : 'Assalto do Crew: falhou'),
    body: (crewName, heistName, success) =>
      success
        ? `${crewName} concluiu ${heistName}`
        : `${crewName} falhou em ${heistName}`,
  },
  directMessage: {
    title: 'Nova mensagem',
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  supportTicketUpdate: {
    title: 'Atualização do ticket',
    body: (ticketId, subject) => `O ticket #${ticketId} tem nova resposta: ${subject}`,
  },
  crewMessage: {
    title: (crewName) => `${crewName}`,
    body: (senderUsername, message) => `${senderUsername}: ${message}`,
  },
  cryptoTradeExecuted: {
    title: (side) => (side === 'BUY' ? 'Compra cripto executada' : 'Venda cripto executada'),
    body: (symbol, quantity, totalValue, realizedProfit) => {
      const base = `${quantity} ${symbol} por EUR ${totalValue}`;
      if (realizedProfit !== undefined) {
        return `Operação: ${base} (PnL: EUR ${realizedProfit})`;
      }
      return `Operação: ${base}`;
    },
  },
  cryptoPriceAlert: {
    title: 'Alerta de preço cripto',
    body: (symbol, currentPrice, changePct) => `${symbol}: EUR ${currentPrice} (${changePct}% 24h)`,
  },
  cryptoOrderFilled: {
    title: 'Ordem preenchida',
    body: (symbol, orderType, side, quantity, fillPrice) =>
      `${ptOrderType(orderType)} ${ptSide(side)}: ${quantity} ${symbol} @ EUR ${fillPrice}`,
  },
  cryptoOrderTriggered: {
    title: 'Ordem acionada',
    body: (symbol, triggerType, triggerPrice) =>
      `${triggerType === 'STOP_LOSS' ? 'Stop loss' : 'Take profit'} em ${symbol} a EUR ${triggerPrice}`,
  },
  cryptoMarketRegime: {
    title: 'Regime de mercado',
    body: (regime, marketMovePct) => `Mercado: regime ${ptRegime(regime)} (24h: ${marketMovePct}%)`,
  },
  cryptoMarketNews: {
    title: 'Notícias de mercado',
    body: (headline, impact) => `${ptImpact(impact)}: ${headline}`,
  },
  cryptoMissionCompleted: {
    title: (missionType) =>
      missionType === 'DAILY' ? 'Missão cripto diária' : 'Missão cripto semanal',
    body: (missionTitle, rewardMoney) => `${missionTitle} concluída. Recompensa: EUR ${rewardMoney}`,
  },
  cryptoLeaderboardReward: {
    title: 'Recompensa do ranking',
    body: (rank, rewardMoney, periodLabel) =>
      `Ficaste em #${rank} em ${periodLabel}. Recompensa: EUR ${rewardMoney}`,
  },
  casinoLowBalance: {
    title: 'Casino: saldo baixo',
    body: (casinoName, currentBalance, threshold) => `${casinoName}: saldo EUR ${currentBalance} (mín. EUR ${threshold})`,
  },
  cooldownExpired: {
    title: '⏰ Hora de agir!',
    body: (actionName) => `O tempo de espera de ${actionName} acabou. Volte ao jogo!`,
  },
  bankTransferReceived: {
    title: '💰 Dinheiro recebido',
    body: (senderUsername, amount) => `${senderUsername} transferiu €${amount} para a tua conta bancária.`,
  },
};

export const NOTIFICATION_BUNDLES_I18N: Partial<Record<SupportedPlayerLanguage, Translations['notification']>> = {
  de: notificationDE,
  fr: notificationFR,
  es: notificationES,
  it: notificationIT,
  pl: notificationPL,
  pt: notificationPT,
};
