/**
 * Full push + in-app notification copy for player languages de, fr, es, it, pl, pt.
 * Transactional email HTML for those languages lives in `playerEmailBundlesExtra.ts`; EN/NL email in `translationService.ts`.
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
  territoryContestStarted: {
    title: 'Territorium unter Angriff!',
    pushBody: (regionKey, contestId) =>
      `Region ${regionKey} wird angegriffen (Contest #${contestId}).`,
    inboxMessage: (regionKey, contestId) =>
      [
        'Territorium unter Angriff!',
        '',
        `Region: ${regionKey}`,
        `Contest: #${contestId}`,
        'Eine andere Crew hat einen Territoriumsangriff gestartet.',
      ].join('\n'),
  },
  territoryContestActiveAttacker: {
    title: 'Territoriumsangriff ist live!',
    pushBody: (regionName, contestId) =>
      `Die Vorbereitung für ${regionName} ist vorbei. Du kannst jetzt angreifen (Contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Territoriumsangriff ist live!',
        '',
        `Region: ${regionName}`,
        `Contest: #${contestId}`,
        'Die Vorbereitung ist beendet. Angriffsaktionen sind jetzt freigeschaltet.',
      ].join('\n'),
  },
  territoryContestActiveDefender: {
    title: 'Territoriumsverteidigung ist live!',
    pushBody: (regionName, contestId) =>
      `Der Angriff auf ${regionName} ist jetzt aktiv. Verteidige jetzt (Contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Territoriumsverteidigung ist live!',
        '',
        `Region: ${regionName}`,
        `Contest: #${contestId}`,
        'Die Vorbereitung ist beendet. Verteidigungsaktionen sind jetzt freigeschaltet.',
      ].join('\n'),
  },
  territoryCaptured: {
    title: 'Region erobert!',
    pushBody: (regionKey) => `Eure Crew hat ${regionKey} erobert.`,
    inboxMessage: (regionKey) =>
      [
        'Region erobert!',
        '',
        `Region: ${regionKey}`,
        'Eure Crew hat diese Region erfolgreich übernommen.',
      ].join('\n'),
  },
  territoryLost: {
    title: 'Region verloren!',
    pushBody: (regionKey) => `${regionKey} wurde von einer anderen Crew übernommen.`,
    inboxMessage: (regionKey) =>
      [
        'Region verloren!',
        '',
        `Region: ${regionKey}`,
        'Diese Region wurde von einer anderen Crew übernommen.',
      ].join('\n'),
  },
  territoryArsenalLow: {
    title: 'Territoriumsarsenal wird knapp',
    pushBody: (regionKey) => `Das Front-Depot in ${regionKey} ist fast leer. Nachschub, sonst kämpft ihr über die lange HQ-Linie.`,
    inboxMessage: (regionKey) =>
      [
        'Territoriumsarsenal wird knapp',
        '',
        `Region: ${regionKey}`,
        'Das Front-Depot ist fast leer. Schickt Waffen und Munition aus dem Crew-Lager oder macht einen Nachschublauf im Contest.',
      ].join('\n'),
  },
  territoryArsenalCaptured: {
    title: 'Front-Depot verloren',
    pushBody: (regionKey) => `${regionKey} fiel mit Waffen und Munition im Depot. Ein Teil wurde geplündert, der Rest verbrannt.`,
    inboxMessage: (regionKey) =>
      [
        'Front-Depot verloren',
        '',
        `Region: ${regionKey}`,
        'Waffen und Munition in diesem Gebiet kamen nicht zurück ins HQ. Der Sieger nahm einen Anteil, der Rest verbrannte.',
      ].join('\n'),
  },
  rldStolen: {
    title: 'Rekrut gestohlen',
    pushBody: (thiefName, workerName) => `${thiefName} hat ${workerName} aus deinem Rotlichtviertel gestohlen.`,
    inboxMessage: (thiefName, workerName) =>
      `${thiefName} hat ${workerName} aus einem Zimmer genommen.\nDu hast 12 Stunden, um sie zurückzuholen, solange sie auf der Straße ist.`,
  },
  rldReclaimed: {
    title: 'Rekrut zurückgeholt',
    pushBody: (ownerName, workerName) => `${ownerName} hat ${workerName} zurückgeholt.`,
    inboxMessage: (ownerName, workerName) => `${ownerName} holte ${workerName} innerhalb von 12 Stunden zurück.`,
  },
  rldContestPrep: {
    title: 'Viertel umkämpft',
    pushBody: (challengerName, country) => `${challengerName} fordert dein Rotlichtviertel in ${country} heraus.`,
    inboxMessage: (challengerName, country) =>
      `${challengerName} startet einen Kampf um dein Viertel in ${country}.\nDu hast kurz Zeit für Sicherheit oder eine Wache.`,
  },
  rldContestActive: {
    title: 'Viertelkampf läuft',
    pushBody: (country) => `Der Kampf um das Rotlichtviertel in ${country} läuft.`,
    inboxMessage: (country) => `Stehlen, Sabotage und Halten zählen jetzt in ${country}.`,
  },
  rldContestWon: {
    title: 'Du besitzt das Viertel',
    pushBody: (country) => `Du besitzt jetzt das Rotlichtviertel in ${country}.`,
    inboxMessage: (country) => `Zimmer, Upgrades und Mieter bleiben. Die Miete in ${country} geht an dich.`,
  },
  rldContestLost: {
    title: 'Viertel verloren',
    pushBody: (winnerName, country) => `${winnerName} hat dein Rotlichtviertel in ${country} übernommen.`,
    inboxMessage: (winnerName, country) => `${winnerName} gewann den Kampf in ${country}. Zimmer und Mieter bleiben im Gebäude.`,
  },
  raceResult: {
    title: 'Midnight Races',
    systemSender: 'Midnight Races',
    refunded: 'Das Rennen wurde abgebrochen (weniger als zwei Fahrer). Einsatz und Wetten wurden erstattet.',
    winnerLine: (winner) => `Sieger: ${winner}.`,
    driverLine: (place, payout) => `Du wurdest #${place} und hast ${payout} erhalten.`,
    betWonLine: (payout) => `Deine Wette zahlte ${payout}.`,
    betLostLine: 'Deine Wette hat verloren.',
    hostLine: (rake) => `Dein Club nahm ${rake} Rake.`,
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
  territoryContestStarted: {
    title: 'Région attaquée !',
    pushBody: (regionKey, contestId) =>
      `La région ${regionKey} est attaquée (contest n°${contestId}).`,
    inboxMessage: (regionKey, contestId) =>
      [
        'Région attaquée !',
        '',
        `Région : ${regionKey}`,
        `Contest : #${contestId}`,
        'Une autre crew a lancé une attaque territoriale.',
      ].join('\n'),
  },
  territoryContestActiveAttacker: {
    title: 'Attaque territoriale en cours !',
    pushBody: (regionName, contestId) =>
      `La préparation de ${regionName} est terminée. Tu peux attaquer (contest n°${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Attaque territoriale en cours !',
        '',
        `Région : ${regionName}`,
        `Contest : #${contestId}`,
        'La préparation est terminée. Les actions d’attaque sont débloquées.',
      ].join('\n'),
  },
  territoryContestActiveDefender: {
    title: 'Défense territoriale en cours !',
    pushBody: (regionName, contestId) =>
      `L’attaque sur ${regionName} est maintenant active. Défends maintenant (contest n°${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Défense territoriale en cours !',
        '',
        `Région : ${regionName}`,
        `Contest : #${contestId}`,
        'La préparation est terminée. Les actions de défense sont débloquées.',
      ].join('\n'),
  },
  territoryCaptured: {
    title: 'Région capturée !',
    pushBody: (regionKey) => `Ta crew a capturé ${regionKey}.`,
    inboxMessage: (regionKey) =>
      [
        'Région capturée !',
        '',
        `Région : ${regionKey}`,
        'Ta crew a repris cette région avec succès.',
      ].join('\n'),
  },
  territoryLost: {
    title: 'Région perdue !',
    pushBody: (regionKey) => `${regionKey} a été prise par une autre crew.`,
    inboxMessage: (regionKey) =>
      [
        'Région perdue !',
        '',
        `Région : ${regionKey}`,
        'Cette région a été prise par une autre crew.',
      ].join('\n'),
  },
  territoryArsenalLow: {
    title: 'Arsenal territorial presque vide',
    pushBody: (regionKey) => `Le dépôt de première ligne à ${regionKey} est presque vide. Réapprovisionnez, sinon vous combattez via la longue ligne HQ.`,
    inboxMessage: (regionKey) =>
      [
        'Arsenal territorial presque vide',
        '',
        `Région : ${regionKey}`,
        'Le dépôt de première ligne est presque vide. Envoyez armes et munitions depuis le stockage crew, ou faites un ravitaillement pendant le contest.',
      ].join('\n'),
  },
  territoryArsenalCaptured: {
    title: 'Dépôt de première ligne perdu',
    pushBody: (regionKey) => `${regionKey} est tombé avec des armes et des munitions encore dans le dépôt. Une part a été pillée, le reste a brûlé.`,
    inboxMessage: (regionKey) =>
      [
        'Dépôt de première ligne perdu',
        '',
        `Région : ${regionKey}`,
        'Les armes et munitions engagées ici ne sont pas revenues au QG. Le vainqueur a pris une part ; le reste a brûlé.',
      ].join('\n'),
  },
  rldStolen: {
    title: 'Recrue volée',
    pushBody: (thiefName, workerName) => `${thiefName} a volé ${workerName} dans ton quartier rouge.`,
    inboxMessage: (thiefName, workerName) =>
      `${thiefName} a emmené ${workerName} hors d'une chambre.\nTu as 12 heures pour la récupérer tant qu'elle est dans la rue.`,
  },
  rldReclaimed: {
    title: 'Recrue reprise',
    pushBody: (ownerName, workerName) => `${ownerName} a repris ${workerName}.`,
    inboxMessage: (ownerName, workerName) => `${ownerName} a repris ${workerName} en moins de 12 heures.`,
  },
  rldContestPrep: {
    title: 'Quartier contesté',
    pushBody: (challengerName, country) => `${challengerName} conteste ton quartier rouge à ${country}.`,
    inboxMessage: (challengerName, country) =>
      `${challengerName} lance un contest pour ton quartier à ${country}.\nTu as un court délai pour renforcer la sécurité.`,
  },
  rldContestActive: {
    title: 'Le combat est lancé',
    pushBody: (country) => `Le contest du quartier rouge à ${country} est en cours.`,
    inboxMessage: (country) => `Vol, sabotage et tenue comptent maintenant à ${country}.`,
  },
  rldContestWon: {
    title: 'Le quartier est à toi',
    pushBody: (country) => `Tu possèdes maintenant le quartier rouge à ${country}.`,
    inboxMessage: (country) => `Chambres, améliorations et locataires restent. Le loyer à ${country} t'appartient.`,
  },
  rldContestLost: {
    title: 'Quartier perdu',
    pushBody: (winnerName, country) => `${winnerName} a pris ton quartier rouge à ${country}.`,
    inboxMessage: (winnerName, country) => `${winnerName} a gagné le contest à ${country}. Chambres et locataires restent dans l'immeuble.`,
  },
  raceResult: {
    title: 'Midnight Races',
    systemSender: 'Midnight Races',
    refunded: 'La grille a été annulée (moins de deux pilotes). Votre mise et vos paris ont été remboursés.',
    winnerLine: (winner) => `Vainqueur : ${winner}.`,
    driverLine: (place, payout) => `Tu as fini #${place} et reçu ${payout}.`,
    betWonLine: (payout) => `Ton pari a rapporté ${payout}.`,
    betLostLine: 'Ton pari a perdu.',
    hostLine: (rake) => `Ton club a pris ${rake} de rake.`,
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
  territoryContestStarted: {
    title: '¡Región bajo ataque!',
    pushBody: (regionKey, contestId) =>
      `La región ${regionKey} está bajo ataque (contest #${contestId}).`,
    inboxMessage: (regionKey, contestId) =>
      [
        '¡Región bajo ataque!',
        '',
        `Región: ${regionKey}`,
        `Contest: #${contestId}`,
        'Otra crew ha iniciado un ataque territorial.',
      ].join('\n'),
  },
  territoryContestActiveAttacker: {
    title: '¡El ataque territorial está activo!',
    pushBody: (regionName, contestId) =>
      `La preparación de ${regionName} ha terminado. Ya puedes atacar (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        '¡El ataque territorial está activo!',
        '',
        `Región: ${regionName}`,
        `Contest: #${contestId}`,
        'La preparación ha terminado. Las acciones de ataque están desbloqueadas.',
      ].join('\n'),
  },
  territoryContestActiveDefender: {
    title: '¡La defensa territorial está activa!',
    pushBody: (regionName, contestId) =>
      `El ataque a ${regionName} ya está activo. Defiende ahora (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        '¡La defensa territorial está activa!',
        '',
        `Región: ${regionName}`,
        `Contest: #${contestId}`,
        'La preparación ha terminado. Las acciones de defensa están desbloqueadas.',
      ].join('\n'),
  },
  territoryCaptured: {
    title: '¡Región capturada!',
    pushBody: (regionKey) => `Tu crew capturó ${regionKey}.`,
    inboxMessage: (regionKey) =>
      [
        '¡Región capturada!',
        '',
        `Región: ${regionKey}`,
        'Tu crew tomó esta región con éxito.',
      ].join('\n'),
  },
  territoryLost: {
    title: '¡Región perdida!',
    pushBody: (regionKey) => `${regionKey} fue tomada por otra crew.`,
    inboxMessage: (regionKey) =>
      [
        '¡Región perdida!',
        '',
        `Región: ${regionKey}`,
        'Esta región fue tomada por otra crew.',
      ].join('\n'),
  },
  territoryArsenalLow: {
    title: 'El arsenal territorial se agota',
    pushBody: (regionKey) => `El depósito de primera línea en ${regionKey} está casi vacío. Reabastécelo o lucháis con la línea larga del HQ.`,
    inboxMessage: (regionKey) =>
      [
        'El arsenal territorial se agota',
        '',
        `Región: ${regionKey}`,
        'El depósito de primera línea está casi vacío. Envía armas y munición desde el almacén de la crew, o haz un suministro durante el contest.',
      ].join('\n'),
  },
  territoryArsenalCaptured: {
    title: 'Depósito de primera línea perdido',
    pushBody: (regionKey) => `${regionKey} cayó con armas y munición aún en el depósito. Parte fue saqueada; el resto se quemó.`,
    inboxMessage: (regionKey) =>
      [
        'Depósito de primera línea perdido',
        '',
        `Región: ${regionKey}`,
        'Las armas y munición comprometidas aquí no volvieron al HQ. El ganador se llevó una parte; el resto se quemó.',
      ].join('\n'),
  },
  rldStolen: {
    title: 'Recluta robada',
    pushBody: (thiefName, workerName) => `${thiefName} robó a ${workerName} de tu barrio rojo.`,
    inboxMessage: (thiefName, workerName) =>
      `${thiefName} se llevó a ${workerName} de una habitación.\nTienes 12 horas para recuperarla mientras esté en la calle.`,
  },
  rldReclaimed: {
    title: 'Recluta recuperada',
    pushBody: (ownerName, workerName) => `${ownerName} recuperó a ${workerName}.`,
    inboxMessage: (ownerName, workerName) => `${ownerName} recuperó a ${workerName} en menos de 12 horas.`,
  },
  rldContestPrep: {
    title: 'Barrio en disputa',
    pushBody: (challengerName, country) => `${challengerName} disputa tu barrio rojo en ${country}.`,
    inboxMessage: (challengerName, country) =>
      `${challengerName} empezó un contest por tu barrio en ${country}.\nTienes un momento para subir la seguridad.`,
  },
  rldContestActive: {
    title: 'La pelea está en marcha',
    pushBody: (country) => `El contest del barrio rojo en ${country} ya corre.`,
    inboxMessage: (country) => `Robar, sabotear y aguantar ya cuentan en ${country}.`,
  },
  rldContestWon: {
    title: 'El barrio es tuyo',
    pushBody: (country) => `Ahora eres dueño del barrio rojo en ${country}.`,
    inboxMessage: (country) => `Habitaciones, mejoras e inquilinos se quedan. El alquiler en ${country} va a ti.`,
  },
  rldContestLost: {
    title: 'Barrio perdido',
    pushBody: (winnerName, country) => `${winnerName} tomó tu barrio rojo en ${country}.`,
    inboxMessage: (winnerName, country) => `${winnerName} ganó el contest en ${country}. Habitaciones e inquilinos se quedan en el edificio.`,
  },
  raceResult: {
    title: 'Midnight Races',
    systemSender: 'Midnight Races',
    refunded: 'La parrilla se canceló (menos de dos pilotos). Tu apuesta y tus apuestas se reembolsaron.',
    winnerLine: (winner) => `Ganador: ${winner}.`,
    driverLine: (place, payout) => `Terminaste #${place} y recibiste ${payout}.`,
    betWonLine: (payout) => `Tu apuesta pagó ${payout}.`,
    betLostLine: 'Tu apuesta perdió.',
    hostLine: (rake) => `Tu club se llevó ${rake} de rake.`,
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
  territoryContestStarted: {
    title: 'Regione sotto attacco!',
    pushBody: (regionKey, contestId) =>
      `La regione ${regionKey} è sotto attacco (contest #${contestId}).`,
    inboxMessage: (regionKey, contestId) =>
      [
        'Regione sotto attacco!',
        '',
        `Regione: ${regionKey}`,
        `Contest: #${contestId}`,
        "Un'altra crew ha avviato un attacco territoriale.",
      ].join('\n'),
  },
  territoryContestActiveAttacker: {
    title: 'Attacco territoriale attivo!',
    pushBody: (regionName, contestId) =>
      `La preparazione di ${regionName} è finita. Puoi attaccare ora (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Attacco territoriale attivo!',
        '',
        `Regione: ${regionName}`,
        `Contest: #${contestId}`,
        'La preparazione è terminata. Le azioni di attacco sono sbloccate.',
      ].join('\n'),
  },
  territoryContestActiveDefender: {
    title: 'Difesa territoriale attiva!',
    pushBody: (regionName, contestId) =>
      `L'attacco a ${regionName} è ora attivo. Difendi ora (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Difesa territoriale attiva!',
        '',
        `Regione: ${regionName}`,
        `Contest: #${contestId}`,
        'La preparazione è terminata. Le azioni di difesa sono sbloccate.',
      ].join('\n'),
  },
  territoryCaptured: {
    title: 'Regione conquistata!',
    pushBody: (regionKey) => `La tua crew ha conquistato ${regionKey}.`,
    inboxMessage: (regionKey) =>
      [
        'Regione conquistata!',
        '',
        `Regione: ${regionKey}`,
        'La tua crew ha conquistato questa regione.',
      ].join('\n'),
  },
  territoryLost: {
    title: 'Regione persa!',
    pushBody: (regionKey) => `${regionKey} è stata presa da un’altra crew.`,
    inboxMessage: (regionKey) =>
      [
        'Regione persa!',
        '',
        `Regione: ${regionKey}`,
        'Questa regione è stata presa da un’altra crew.',
      ].join('\n'),
  },
  territoryArsenalLow: {
    title: 'Arsenale territoriale quasi vuoto',
    pushBody: (regionKey) => `Il deposito in prima linea a ${regionKey} è quasi vuoto. Riforniscilo o combatti dalla lunga linea HQ.`,
    inboxMessage: (regionKey) =>
      [
        'Arsenale territoriale quasi vuoto',
        '',
        `Regione: ${regionKey}`,
        'Il deposito in prima linea è quasi vuoto. Invia armi e munizioni dallo storage crew, o fai un rifornimento durante il contest.',
      ].join('\n'),
  },
  territoryArsenalCaptured: {
    title: 'Deposito in prima linea perso',
    pushBody: (regionKey) => `${regionKey} è caduto con armi e munizioni ancora nel deposito. Una parte è stata saccheggiata, il resto bruciato.`,
    inboxMessage: (regionKey) =>
      [
        'Deposito in prima linea perso',
        '',
        `Regione: ${regionKey}`,
        'Armi e munizioni impegnate qui non sono tornate all’HQ. Il vincitore ha preso una parte; il resto è bruciato.',
      ].join('\n'),
  },
  rldStolen: {
    title: 'Recluta rubata',
    pushBody: (thiefName, workerName) => `${thiefName} ha rubato ${workerName} dal tuo quartiere a luci rosse.`,
    inboxMessage: (thiefName, workerName) =>
      `${thiefName} ha portato via ${workerName} da una stanza.\nHai 12 ore per riprenderla finché è in strada.`,
  },
  rldReclaimed: {
    title: 'Recluta ripresa',
    pushBody: (ownerName, workerName) => `${ownerName} ha ripreso ${workerName}.`,
    inboxMessage: (ownerName, workerName) => `${ownerName} ha ripreso ${workerName} entro 12 ore.`,
  },
  rldContestPrep: {
    title: 'Quartiere contestato',
    pushBody: (challengerName, country) => `${challengerName} contesta il tuo quartiere a luci rosse in ${country}.`,
    inboxMessage: (challengerName, country) =>
      `${challengerName} ha avviato un contest per il tuo quartiere in ${country}.\nHai poco tempo per alzare la sicurezza.`,
  },
  rldContestActive: {
    title: 'Lo scontro è vivo',
    pushBody: (country) => `Il contest del quartiere a luci rosse in ${country} è iniziato.`,
    inboxMessage: (country) => `Furto, sabotaggio e tenuta contano ora in ${country}.`,
  },
  rldContestWon: {
    title: 'Il quartiere è tuo',
    pushBody: (country) => `Ora possiedi il quartiere a luci rosse in ${country}.`,
    inboxMessage: (country) => `Stanze, upgrade e inquilini restano. L'affitto in ${country} va a te.`,
  },
  rldContestLost: {
    title: 'Quartiere perso',
    pushBody: (winnerName, country) => `${winnerName} ha preso il tuo quartiere a luci rosse in ${country}.`,
    inboxMessage: (winnerName, country) => `${winnerName} ha vinto il contest in ${country}. Stanze e inquilini restano nell'edificio.`,
  },
  raceResult: {
    title: 'Midnight Races',
    systemSender: 'Midnight Races',
    refunded: 'La griglia è stata annullata (meno di due piloti). La tua puntata e le scommesse sono state rimborsate.',
    winnerLine: (winner) => `Vincitore: ${winner}.`,
    driverLine: (place, payout) => `Hai finito #${place} e ricevuto ${payout}.`,
    betWonLine: (payout) => `La tua scommessa ha pagato ${payout}.`,
    betLostLine: 'La tua scommessa ha perso.',
    hostLine: (rake) => `Il tuo club ha preso ${rake} di rake.`,
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
  territoryContestStarted: {
    title: 'Region pod atakiem!',
    pushBody: (regionKey, contestId) =>
      `Region ${regionKey} jest atakowany (contest #${contestId}).`,
    inboxMessage: (regionKey, contestId) =>
      [
        'Region pod atakiem!',
        '',
        `Region: ${regionKey}`,
        `Contest: #${contestId}`,
        'Inna ekipa rozpoczęła atak terytorialny.',
      ].join('\n'),
  },
  territoryContestActiveAttacker: {
    title: 'Atak terytorialny jest aktywny!',
    pushBody: (regionName, contestId) =>
      `Przygotowanie ${regionName} zakończone. Możesz atakować (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Atak terytorialny jest aktywny!',
        '',
        `Region: ${regionName}`,
        `Contest: #${contestId}`,
        'Przygotowanie się skończyło. Akcje ataku są odblokowane.',
      ].join('\n'),
  },
  territoryContestActiveDefender: {
    title: 'Obrona terytorium jest aktywna!',
    pushBody: (regionName, contestId) =>
      `Atak na ${regionName} jest teraz aktywny. Broń się teraz (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Obrona terytorium jest aktywna!',
        '',
        `Region: ${regionName}`,
        `Contest: #${contestId}`,
        'Przygotowanie się skończyło. Akcje obrony są odblokowane.',
      ].join('\n'),
  },
  territoryCaptured: {
    title: 'Region przejęty!',
    pushBody: (regionKey) => `Twoja ekipa przejęła ${regionKey}.`,
    inboxMessage: (regionKey) =>
      [
        'Region przejęty!',
        '',
        `Region: ${regionKey}`,
        'Twoja ekipa pomyślnie przejęła ten region.',
      ].join('\n'),
  },
  territoryLost: {
    title: 'Region utracony!',
    pushBody: (regionKey) => `${regionKey} został przejęty przez inną ekipę.`,
    inboxMessage: (regionKey) =>
      [
        'Region utracony!',
        '',
        `Region: ${regionKey}`,
        'Ten region został przejęty przez inną ekipę.',
      ].join('\n'),
  },
  territoryArsenalLow: {
    title: 'Arsenał terytorium się kończy',
    pushBody: (regionKey) => `Skład na froncie w ${regionKey} jest prawie pusty. Uzupełnij go, albo walczysz długą linią z HQ.`,
    inboxMessage: (regionKey) =>
      [
        'Arsenał terytorium się kończy',
        '',
        `Region: ${regionKey}`,
        'Skład na froncie jest prawie pusty. Wyślij broń i amunicję z magazynu ekipy albo zrób dostawę podczas contestu.',
      ].join('\n'),
  },
  territoryArsenalCaptured: {
    title: 'Utracono skład na froncie',
    pushBody: (regionKey) => `${regionKey} padł z bronią i amunicją w składzie. Część zrabowano, reszta spłonęła.`,
    inboxMessage: (regionKey) =>
      [
        'Utracono skład na froncie',
        '',
        `Region: ${regionKey}`,
        'Broń i amunicja tutaj nie wróciły do HQ. Zwycięzca wziął część; reszta spłonęła.',
      ].join('\n'),
  },
  rldStolen: {
    title: 'Rekrut ukradziony',
    pushBody: (thiefName, workerName) => `${thiefName} ukradł ${workerName} z twojej dzielnicy czerwonych latarni.`,
    inboxMessage: (thiefName, workerName) =>
      `${thiefName} zabrał ${workerName} z pokoju.\nMasz 12 godzin, by ją odzyskać, póki jest na ulicy.`,
  },
  rldReclaimed: {
    title: 'Rekrut odzyskany',
    pushBody: (ownerName, workerName) => `${ownerName} odzyskał ${workerName}.`,
    inboxMessage: (ownerName, workerName) => `${ownerName} odzyskał ${workerName} w ciągu 12 godzin.`,
  },
  rldContestPrep: {
    title: 'Dzielnica sporna',
    pushBody: (challengerName, country) => `${challengerName} kwestionuje twoją dzielnicę w ${country}.`,
    inboxMessage: (challengerName, country) =>
      `${challengerName} zaczął contest o twoją dzielnicę w ${country}.\nMasz chwilę na ochronę.`,
  },
  rldContestActive: {
    title: 'Walka trwa',
    pushBody: (country) => `Contest o dzielnicę czerwonych latarni w ${country} trwa.`,
    inboxMessage: (country) => `Kradzież, sabotaż i utrzymanie liczą się teraz w ${country}.`,
  },
  rldContestWon: {
    title: 'Dzielnica jest twoja',
    pushBody: (country) => `Jesteś teraz właścicielem dzielnicy w ${country}.`,
    inboxMessage: (country) => `Pokoje, ulepszenia i najemcy zostają. Czynsz w ${country} idzie do ciebie.`,
  },
  rldContestLost: {
    title: 'Dzielnica stracona',
    pushBody: (winnerName, country) => `${winnerName} zajął twoją dzielnicę w ${country}.`,
    inboxMessage: (winnerName, country) => `${winnerName} wygrał contest w ${country}. Pokoje i najemcy zostają w budynku.`,
  },
  raceResult: {
    title: 'Midnight Races',
    systemSender: 'Midnight Races',
    refunded: 'Wyścig odwołano (mniej niż dwóch kierowców). Twój wpis i zakłady zwrócono.',
    winnerLine: (winner) => `Zwycięzca: ${winner}.`,
    driverLine: (place, payout) => `Ukończyłeś jako #${place} i otrzymałeś ${payout}.`,
    betWonLine: (payout) => `Twój zakład wypłacił ${payout}.`,
    betLostLine: 'Twój zakład przegrał.',
    hostLine: (rake) => `Twój klub wziął ${rake} rake.`,
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
  territoryContestStarted: {
    title: 'Região sob ataque!',
    pushBody: (regionKey, contestId) =>
      `A região ${regionKey} está sob ataque (contest #${contestId}).`,
    inboxMessage: (regionKey, contestId) =>
      [
        'Região sob ataque!',
        '',
        `Região: ${regionKey}`,
        `Contest: #${contestId}`,
        'Outra crew iniciou um ataque territorial.',
      ].join('\n'),
  },
  territoryContestActiveAttacker: {
    title: 'Ataque territorial está ativo!',
    pushBody: (regionName, contestId) =>
      `A preparação de ${regionName} terminou. Já podes atacar (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Ataque territorial está ativo!',
        '',
        `Região: ${regionName}`,
        `Contest: #${contestId}`,
        'A preparação terminou. As ações de ataque estão desbloqueadas.',
      ].join('\n'),
  },
  territoryContestActiveDefender: {
    title: 'Defesa territorial está ativa!',
    pushBody: (regionName, contestId) =>
      `O ataque a ${regionName} está agora ativo. Defende agora (contest #${contestId}).`,
    inboxMessage: (regionName, contestId) =>
      [
        'Defesa territorial está ativa!',
        '',
        `Região: ${regionName}`,
        `Contest: #${contestId}`,
        'A preparação terminou. As ações de defesa estão desbloqueadas.',
      ].join('\n'),
  },
  territoryCaptured: {
    title: 'Região capturada!',
    pushBody: (regionKey) => `A tua crew capturou ${regionKey}.`,
    inboxMessage: (regionKey) =>
      [
        'Região capturada!',
        '',
        `Região: ${regionKey}`,
        'A tua crew capturou esta região com sucesso.',
      ].join('\n'),
  },
  territoryLost: {
    title: 'Região perdida!',
    pushBody: (regionKey) => `${regionKey} foi tomada por outra crew.`,
    inboxMessage: (regionKey) =>
      [
        'Região perdida!',
        '',
        `Região: ${regionKey}`,
        'Esta região foi tomada por outra crew.',
      ].join('\n'),
  },
  territoryArsenalLow: {
    title: 'Arsenal territorial quase vazio',
    pushBody: (regionKey) => `O depósito da linha da frente em ${regionKey} está quase vazio. Reabastece, ou lutas pela linha longa do HQ.`,
    inboxMessage: (regionKey) =>
      [
        'Arsenal territorial quase vazio',
        '',
        `Região: ${regionKey}`,
        'O depósito da linha da frente está quase vazio. Envia armas e munição do armazenamento da crew, ou faz um reabastecimento durante o contest.',
      ].join('\n'),
  },
  territoryArsenalCaptured: {
    title: 'Depósito da linha da frente perdido',
    pushBody: (regionKey) => `${regionKey} caiu com armas e munição ainda no depósito. Parte foi saqueada, o resto queimou.`,
    inboxMessage: (regionKey) =>
      [
        'Depósito da linha da frente perdido',
        '',
        `Região: ${regionKey}`,
        'As armas e a munição aqui não voltaram para o HQ. O vencedor ficou com uma parte; o resto queimou.',
      ].join('\n'),
  },
  rldStolen: {
    title: 'Recruta roubada',
    pushBody: (thiefName, workerName) => `${thiefName} roubou ${workerName} do teu bairro vermelho.`,
    inboxMessage: (thiefName, workerName) =>
      `${thiefName} levou ${workerName} de um quarto.\nTens 12 horas para a recuperar enquanto estiver na rua.`,
  },
  rldReclaimed: {
    title: 'Recruta recuperada',
    pushBody: (ownerName, workerName) => `${ownerName} recuperou ${workerName}.`,
    inboxMessage: (ownerName, workerName) => `${ownerName} recuperou ${workerName} em menos de 12 horas.`,
  },
  rldContestPrep: {
    title: 'Bairro contestado',
    pushBody: (challengerName, country) => `${challengerName} contesta o teu bairro vermelho em ${country}.`,
    inboxMessage: (challengerName, country) =>
      `${challengerName} começou um contest pelo teu bairro em ${country}.\nTens um momento para reforçar a segurança.`,
  },
  rldContestActive: {
    title: 'A luta está ao vivo',
    pushBody: (country) => `O contest do bairro vermelho em ${country} está a decorrer.`,
    inboxMessage: (country) => `Roubar, sabotagem e aguentar contam agora em ${country}.`,
  },
  rldContestWon: {
    title: 'O bairro é teu',
    pushBody: (country) => `Agora és dono do bairro vermelho em ${country}.`,
    inboxMessage: (country) => `Quartos, melhorias e inquilinos ficam. A renda em ${country} vai para ti.`,
  },
  rldContestLost: {
    title: 'Bairro perdido',
    pushBody: (winnerName, country) => `${winnerName} ficou com o teu bairro vermelho em ${country}.`,
    inboxMessage: (winnerName, country) => `${winnerName} ganhou o contest em ${country}. Quartos e inquilinos ficam no prédio.`,
  },
  raceResult: {
    title: 'Midnight Races',
    systemSender: 'Midnight Races',
    refunded: 'A grelha foi cancelada (menos de dois condutores). A tua inscrição e apostas foram reembolsadas.',
    winnerLine: (winner) => `Vencedor: ${winner}.`,
    driverLine: (place, payout) => `Ficaste #${place} e recebeste ${payout}.`,
    betWonLine: (payout) => `A tua aposta pagou ${payout}.`,
    betLostLine: 'A tua aposta perdeu.',
    hostLine: (rake) => `O teu clube ficou com ${rake} de rake.`,
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
