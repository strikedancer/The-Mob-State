/**
 * Translation Service
 * Handles email and notification translations for NL and EN
 */

export type Language = 'en' | 'nl';

interface Translations {
  email: {
    verification: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: string;
      buttonText: string;
      expiryNote: string;
      ignoreNote: string;
    };
    passwordReset: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: string;
      buttonText: string;
      expiryNote: string;
      ignoreNote: string;
    };
    friendRequest: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (senderUsername: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    friendAccepted: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (acceptorUsername: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    crewJoinRequest: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (requesterUsername: string, crewName: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    crewJoinApproved: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (crewName: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    crewJoinRejected: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (crewName: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    crewKicked: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (crewName: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    crewRoleChanged: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (crewName: string, role: string) => string;
      buttonText: string;
      settingsNote: string;
    };
    crewHeistResult: {
      subject: (success: boolean) => string;
      title: (success: boolean) => string;
      greeting: (username: string) => string;
      body: (crewName: string, heistName: string, success: boolean) => string;
      buttonText: string;
      settingsNote: string;
    };
    casinoLowBalance: {
      subject: string;
      title: string;
      greeting: (username: string) => string;
      body: (casinoName: string, currentBalance: string, threshold: string) => string;
      buttonText: string;
      settingsNote: string;
    };
  };
  notification: {
    friendRequest: {
      title: string;
      body: (senderUsername: string) => string;
    };
    friendAccepted: {
      title: string;
      body: (acceptorUsername: string) => string;
    };
    crewJoinRequest: {
      title: string;
      body: (requesterUsername: string, crewName: string) => string;
    };
    crewJoinApproved: {
      title: string;
      body: (crewName: string) => string;
    };
    crewJoinRejected: {
      title: string;
      body: (crewName: string) => string;
    };
    crewKicked: {
      title: string;
      body: (crewName: string) => string;
    };
    crewRoleChanged: {
      title: string;
      body: (crewName: string, role: string) => string;
    };
    crewHeistResult: {
      title: (success: boolean) => string;
      body: (crewName: string, heistName: string, success: boolean) => string;
    };
    directMessage: {
      title: string;
      body: (senderUsername: string, message: string) => string;
    };
    crewMessage: {
      title: (crewName: string) => string;
      body: (senderUsername: string, message: string) => string;
    };
    cryptoTradeExecuted: {
      title: (side: 'BUY' | 'SELL') => string;
      body: (symbol: string, quantity: string, totalValue: string, realizedProfit?: string) => string;
    };
    cryptoPriceAlert: {
      title: string;
      body: (symbol: string, currentPrice: string, changePct: string) => string;
    };
    cryptoOrderFilled: {
      title: string;
      body: (
        symbol: string,
        orderType: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT',
        side: 'BUY' | 'SELL',
        quantity: string,
        fillPrice: string
      ) => string;
    };
    cryptoOrderTriggered: {
      title: string;
      body: (
        symbol: string,
        triggerType: 'STOP_LOSS' | 'TAKE_PROFIT',
        triggerPrice: string
      ) => string;
    };
    cryptoMarketRegime: {
      title: string;
      body: (regime: 'BULL' | 'BEAR' | 'SIDEWAYS', marketMovePct: string) => string;
    };
    cryptoMarketNews: {
      title: string;
      body: (headline: string, impact: 'BULLISH' | 'BEARISH' | 'NEUTRAL') => string;
    };
    cryptoMissionCompleted: {
      title: (missionType: 'DAILY' | 'WEEKLY') => string;
      body: (missionTitle: string, rewardMoney: string) => string;
    };
    cryptoLeaderboardReward: {
      title: string;
      body: (rank: string, rewardMoney: string, periodLabel: string) => string;
    };
    casinoLowBalance: {
      title: string;
      body: (casinoName: string, currentBalance: string, threshold: string) => string;
    };
  };
  common: {
    footer: string;
    automatedMessage: string;
    appName: string;
  };
}

const translations: Record<Language, Translations> = {
  en: {
    email: {
      verification: {
        subject: '✅ Verify Your Email - The Mob State',
        title: '✅ Verify Your Email',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: 'Welcome to The Mob State! Before you can start building your criminal empire, we need to verify your email address. Click the button below to confirm your account:',
        buttonText: 'VERIFY EMAIL',
        expiryNote: 'This link will expire in 24 hours for security reasons.',
        ignoreNote: 'If you didn\'t create an account, you can safely ignore this email.',
      },
      passwordReset: {
        subject: '🔐 Reset Your Password - The Mob State',
        title: '🔐 Reset Your Password',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: 'We received a request to reset your password. Click the button below to create a new password:',
        buttonText: 'RESET PASSWORD',
        expiryNote: 'This link will expire in 1 hour for security reasons.',
        ignoreNote: 'If you didn\'t request this, your password remains unchanged.',
      },
      friendRequest: {
        subject: '🤝 New Friend Request - The Mob State',
        title: '🤝 New Friend Request',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (senderUsername) => `<strong style="color: #D4A574;">${senderUsername}</strong> wants to connect with you in The Mob State. Build your criminal network and dominate the underworld together!`,
        buttonText: 'VIEW REQUEST',
        settingsNote: 'You can manage your friend requests and notification settings in the game.',
      },
      friendAccepted: {
        subject: '🎉 Friend Request Accepted - The Mob State',
        title: '🎉 Friend Request Accepted',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (acceptorUsername) => `Great news! <strong style="color: #D4A574;">${acceptorUsername}</strong> has accepted your friend request. Your criminal network is growing!`,
        buttonText: 'VIEW FRIENDS',
        settingsNote: 'You can manage your friends and notification settings in the game.',
      },
      crewJoinRequest: {
        subject: '👥 Crew Join Request - The Mob State',
        title: '👥 Crew Join Request',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (requesterUsername, crewName) => `<strong style="color: #D4A574;">${requesterUsername}</strong> requested to join your crew <strong style="color: #D4A574;">${crewName}</strong>.`,
        buttonText: 'REVIEW REQUEST',
        settingsNote: 'You can manage crew requests and notifications in the game.',
      },
      crewJoinApproved: {
        subject: '✅ Crew Join Approved - The Mob State',
        title: '✅ Crew Join Approved',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName) => `Your request to join <strong style="color: #D4A574;">${crewName}</strong> was approved. Welcome aboard!`,
        buttonText: 'OPEN CREW',
        settingsNote: 'You can manage crew notifications in the game.',
      },
      crewJoinRejected: {
        subject: '❌ Crew Join Rejected - The Mob State',
        title: '❌ Crew Join Rejected',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName) => `Your request to join <strong style="color: #D4A574;">${crewName}</strong> was rejected.`,
        buttonText: 'FIND CREWS',
        settingsNote: 'You can manage crew notifications in the game.',
      },
      crewKicked: {
        subject: '⚠️ Removed From Crew - The Mob State',
        title: '⚠️ Removed From Crew',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName) => `You were removed from <strong style="color: #D4A574;">${crewName}</strong>.`,
        buttonText: 'FIND CREWS',
        settingsNote: 'You can manage crew notifications in the game.',
      },
      crewRoleChanged: {
        subject: '⭐ Crew Role Updated - The Mob State',
        title: '⭐ Crew Role Updated',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName, role) => `Your role in <strong style="color: #D4A574;">${crewName}</strong> is now <strong style="color: #D4A574;">${role}</strong>.`,
        buttonText: 'OPEN CREW',
        settingsNote: 'You can manage crew notifications in the game.',
      },
      crewHeistResult: {
        subject: (success) => success
            ? '💰 Crew Heist Success - The Mob State'
            : '🚨 Crew Heist Failed - The Mob State',
        title: (success) => success ? '💰 Crew Heist Success' : '🚨 Crew Heist Failed',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName, heistName, success) => success
            ? `Your crew <strong style="color: #D4A574;">${crewName}</strong> successfully completed <strong style="color: #D4A574;">${heistName}</strong>.`
            : `Your crew <strong style="color: #D4A574;">${crewName}</strong> failed <strong style="color: #D4A574;">${heistName}</strong>.`,
        buttonText: 'VIEW CREW',
        settingsNote: 'You can manage crew notifications in the game.',
      },
      casinoLowBalance: {
        subject: '⚠️ Casino Low Balance Warning - The Mob State',
        title: '⚠️ Casino Low Balance Warning',
        greeting: (username) => `Hey <strong style="color: #D4A574;">${username}</strong>,`,
        body: (casinoName, currentBalance, threshold) => `Your casino <strong style="color: #D4A574;">${casinoName}</strong> is running low on funds. Current balance: <strong style="color: #ff4444;">€${currentBalance}</strong>. Please deposit more money to keep your casino operational (minimum: €${threshold}).`,
        buttonText: 'MANAGE CASINO',
        settingsNote: 'You can manage your casino and notification settings in the game.',
      },
    },
    notification: {
      friendRequest: {
        title: 'New Friend Request',
        body: (senderUsername) => `${senderUsername} wants to connect with you`,
      },
      friendAccepted: {
        title: 'Friend Request Accepted',
        body: (acceptorUsername) => `${acceptorUsername} accepted your friend request`,
      },
      crewJoinRequest: {
        title: 'Crew Join Request',
        body: (requesterUsername, crewName) => `${requesterUsername} wants to join ${crewName}`,
      },
      crewJoinApproved: {
        title: 'Crew Join Approved',
        body: (crewName) => `Your request to join ${crewName} was approved`,
      },
      crewJoinRejected: {
        title: 'Crew Join Rejected',
        body: (crewName) => `Your request to join ${crewName} was rejected`,
      },
      crewKicked: {
        title: 'Removed From Crew',
        body: (crewName) => `You were removed from ${crewName}`,
      },
      crewRoleChanged: {
        title: 'Crew Role Updated',
        body: (crewName, role) => `Your role in ${crewName} is now ${role}`,
      },
      crewHeistResult: {
        title: (success) => success ? 'Crew Heist Success' : 'Crew Heist Failed',
        body: (crewName, heistName, success) => success
            ? `${crewName} completed ${heistName}`
            : `${crewName} failed ${heistName}`,
      },
      directMessage: {
        title: 'New Message',
        body: (senderUsername, message) => `${senderUsername}: ${message}`,
      },
      crewMessage: {
        title: (crewName) => `${crewName}`,
        body: (senderUsername, message) => `${senderUsername}: ${message}`,
      },
      cryptoTradeExecuted: {
        title: (side) => side === 'BUY' ? 'Crypto Buy Executed' : 'Crypto Sell Executed',
        body: (symbol, quantity, totalValue, realizedProfit) => {
          const base = `${sideLabel(side)} ${quantity} ${symbol} for EUR ${totalValue}`;
          if (realizedProfit !== undefined) {
            return `${base} (PnL: EUR ${realizedProfit})`;
          }
          return base;
        },
      },
      cryptoPriceAlert: {
        title: 'Crypto Price Alert',
        body: (symbol, currentPrice, changePct) => `${symbol} is now EUR ${currentPrice} (${changePct}% 24h)`,
      },
      cryptoOrderFilled: {
        title: 'Crypto Order Filled',
        body: (symbol, orderType, side, quantity, fillPrice) =>
          `${orderTypeLabel(orderType)} ${sideLabel(side)}: ${quantity} ${symbol} at EUR ${fillPrice}`,
      },
      cryptoOrderTriggered: {
        title: 'Crypto Order Triggered',
        body: (symbol, triggerType, triggerPrice) =>
          `${orderTypeLabel(triggerType)} triggered for ${symbol} at EUR ${triggerPrice}`,
      },
      cryptoMarketRegime: {
        title: 'Crypto Market Regime Change',
        body: (regime, marketMovePct) =>
          `Market switched to ${regimeLabelEn(regime)} regime (24h move ${marketMovePct}%)`,
      },
      cryptoMarketNews: {
        title: 'Crypto Market News',
        body: (headline, impact) =>
          `${impactLabelEn(impact)}: ${headline}`,
      },
      cryptoMissionCompleted: {
        title: (missionType) => missionType === 'DAILY'
          ? 'Daily Crypto Mission Complete'
          : 'Weekly Crypto Mission Complete',
        body: (missionTitle, rewardMoney) =>
          `${missionTitle} completed. Reward: EUR ${rewardMoney}`,
      },
      cryptoLeaderboardReward: {
        title: 'Crypto Leaderboard Reward',
        body: (rank, rewardMoney, periodLabel) =>
          `You finished #${rank} in ${periodLabel}. Reward: EUR ${rewardMoney}`,
      },
      casinoLowBalance: {
        title: 'Casino Low Balance',
        body: (casinoName, currentBalance, threshold) => `${casinoName} balance: EUR ${currentBalance} (min: EUR ${threshold})`,
      },
    },
    common: {
      footer: '© 2026 The Mob State. All rights reserved.',
      automatedMessage: 'This is an automated message, please do not reply.',
      appName: 'THE MOB STATE',
    },
  },
  nl: {
    email: {
      verification: {
        subject: '✅ Verifieer Je Email - The Mob State',
        title: '✅ Verifieer Je Email',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: 'Welkom bij The Mob State! Voordat je kunt beginnen met het bouwen van je criminele imperium, moeten we je e-mailadres verifiëren. Klik op de knop hieronder om je account te bevestigen:',
        buttonText: 'VERIFIEER EMAIL',
        expiryNote: 'Deze link verloopt om veiligheidsredenen over 24 uur.',
        ignoreNote: 'Als je geen account hebt aangemaakt, kun je deze e-mail veilig negeren.',
      },
      passwordReset: {
        subject: '🔐 Reset Je Wachtwoord - The Mob State',
        title: '🔐 Reset Je Wachtwoord',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: 'We hebben een verzoek ontvangen om je wachtwoord te resetten. Klik op de knop hieronder om een nieuw wachtwoord aan te maken:',
        buttonText: 'RESET WACHTWOORD',
        expiryNote: 'Deze link verloopt om veiligheidsredenen over 1 uur.',
        ignoreNote: 'Als je dit niet hebt aangevraagd, blijft je wachtwoord ongewijzigd.',
      },
      friendRequest: {
        subject: '🤝 Nieuw Vriendschapsverzoek - The Mob State',
        title: '🤝 Nieuw Vriendschapsverzoek',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (senderUsername) => `<strong style="color: #D4A574;">${senderUsername}</strong> wil met je verbinden in The Mob State. Bouw je criminele netwerk en domineer samen de onderwereld!`,
        buttonText: 'BEKIJK VERZOEK',
        settingsNote: 'Je kunt je vriendschapsverzoeken en meldingsinstellingen beheren in het spel.',
      },
      friendAccepted: {
        subject: '🎉 Vriendschapsverzoek Geaccepteerd - The Mob State',
        title: '🎉 Vriendschapsverzoek Geaccepteerd',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (acceptorUsername) => `Goed nieuws! <strong style="color: #D4A574;">${acceptorUsername}</strong> heeft je vriendschapsverzoek geaccepteerd. Je criminele netwerk groeit!`,
        buttonText: 'BEKIJK VRIENDEN',
        settingsNote: 'Je kunt je vrienden en meldingsinstellingen beheren in het spel.',
      },
      crewJoinRequest: {
        subject: '👥 Crew Verzoek - The Mob State',
        title: '👥 Crew Verzoek',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (requesterUsername, crewName) => `<strong style="color: #D4A574;">${requesterUsername}</strong> wil zich aansluiten bij jouw crew <strong style="color: #D4A574;">${crewName}</strong>.`,
        buttonText: 'BEKIJK VERZOEK',
        settingsNote: 'Je kunt crew‑verzoeken en meldingen beheren in het spel.',
      },
      crewJoinApproved: {
        subject: '✅ Crew Verzoek Goedgekeurd - The Mob State',
        title: '✅ Crew Verzoek Goedgekeurd',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName) => `Je verzoek om je aan te sluiten bij <strong style="color: #D4A574;">${crewName}</strong> is goedgekeurd. Welkom!`,
        buttonText: 'OPEN CREW',
        settingsNote: 'Je kunt crew‑meldingen beheren in het spel.',
      },
      crewJoinRejected: {
        subject: '❌ Crew Verzoek Afgewezen - The Mob State',
        title: '❌ Crew Verzoek Afgewezen',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName) => `Je verzoek om je aan te sluiten bij <strong style="color: #D4A574;">${crewName}</strong> is afgewezen.`,
        buttonText: 'ZOEK CREWS',
        settingsNote: 'Je kunt crew‑meldingen beheren in het spel.',
      },
      crewKicked: {
        subject: '⚠️ Verwijderd Uit Crew - The Mob State',
        title: '⚠️ Verwijderd Uit Crew',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName) => `Je bent verwijderd uit <strong style="color: #D4A574;">${crewName}</strong>.`,
        buttonText: 'ZOEK CREWS',
        settingsNote: 'Je kunt crew‑meldingen beheren in het spel.',
      },
      crewRoleChanged: {
        subject: '⭐ Crew Rol Gewijzigd - The Mob State',
        title: '⭐ Crew Rol Gewijzigd',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName, role) => `Je rol in <strong style="color: #D4A574;">${crewName}</strong> is nu <strong style="color: #D4A574;">${role}</strong>.`,
        buttonText: 'OPEN CREW',
        settingsNote: 'Je kunt crew‑meldingen beheren in het spel.',
      },
      crewHeistResult: {
        subject: (success) => success
            ? '💰 Crew Heist Gelukt - The Mob State'
            : '🚨 Crew Heist Mislukt - The Mob State',
        title: (success) => success ? '💰 Crew Heist Gelukt' : '🚨 Crew Heist Mislukt',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (crewName, heistName, success) => success
            ? `Jouw crew <strong style="color: #D4A574;">${crewName}</strong> heeft <strong style="color: #D4A574;">${heistName}</strong> succesvol afgerond.`
            : `Jouw crew <strong style="color: #D4A574;">${crewName}</strong> heeft <strong style="color: #D4A574;">${heistName}</strong> niet gehaald.`,
        buttonText: 'BEKIJK CREW',
        settingsNote: 'Je kunt crew‑meldingen beheren in het spel.',
      },
      casinoLowBalance: {
        subject: '⚠️ Casino Laag Saldo Waarschuwing - The Mob State',
        title: '⚠️ Casino Laag Saldo Waarschuwing',
        greeting: (username) => `Hé <strong style="color: #D4A574;">${username}</strong>,`,
        body: (casinoName, currentBalance, threshold) => `Je casino <strong style="color: #D4A574;">${casinoName}</strong> heeft weinig geld. Huidig saldo: <strong style="color: #ff4444;">€${currentBalance}</strong>. Stort meer geld om je casino operationeel te houden (minimum: €${threshold}).`,
        buttonText: 'BEHEER CASINO',
        settingsNote: 'Je kunt je casino en meldingsinstellingen beheren in het spel.',
      },
    },
    notification: {
      friendRequest: {
        title: 'Nieuw Vriendschapsverzoek',
        body: (senderUsername) => `${senderUsername} wil met je verbinden`,
      },
      friendAccepted: {
        title: 'Vriendschapsverzoek Geaccepteerd',
        body: (acceptorUsername) => `${acceptorUsername} heeft je verzoek geaccepteerd`,
      },
      crewJoinRequest: {
        title: 'Crew Verzoek',
        body: (requesterUsername, crewName) => `${requesterUsername} wil bij ${crewName}`,
      },
      crewJoinApproved: {
        title: 'Crew Verzoek Goedgekeurd',
        body: (crewName) => `Je verzoek voor ${crewName} is goedgekeurd`,
      },
      crewJoinRejected: {
        title: 'Crew Verzoek Afgewezen',
        body: (crewName) => `Je verzoek voor ${crewName} is afgewezen`,
      },
      crewKicked: {
        title: 'Verwijderd Uit Crew',
        body: (crewName) => `Je bent verwijderd uit ${crewName}`,
      },
      crewRoleChanged: {
        title: 'Crew Rol Gewijzigd',
        body: (crewName, role) => `Je rol in ${crewName} is nu ${role}`,
      },
      crewHeistResult: {
        title: (success) => success ? 'Crew Heist Gelukt' : 'Crew Heist Mislukt',
        body: (crewName, heistName, success) => success
            ? `${crewName} heeft ${heistName} voltooid`
            : `${crewName} faalde bij ${heistName}`,
      },
      directMessage: {
        title: 'Nieuw Bericht',
        body: (senderUsername, message) => `${senderUsername}: ${message}`,
      },
      crewMessage: {
        title: (crewName) => `${crewName}`,
        body: (senderUsername, message) => `${senderUsername}: ${message}`,
      },
      cryptoTradeExecuted: {
        title: (side) => side === 'BUY' ? 'Crypto aankoop uitgevoerd' : 'Crypto verkoop uitgevoerd',
        body: (symbol, quantity, totalValue, realizedProfit) => {
          const base = `${sideLabelNl(side)} ${quantity} ${symbol} voor EUR ${totalValue}`;
          if (realizedProfit !== undefined) {
            return `${base} (Resultaat: EUR ${realizedProfit})`;
          }
          return base;
        },
      },
      cryptoPriceAlert: {
        title: 'Crypto prijsalarm',
        body: (symbol, currentPrice, changePct) => `${symbol} staat op EUR ${currentPrice} (${changePct}% in 24u)`,
      },
      cryptoOrderFilled: {
        title: 'Crypto order uitgevoerd',
        body: (symbol, orderType, side, quantity, fillPrice) =>
          `${orderTypeLabelNl(orderType)} ${sideLabelNl(side)}: ${quantity} ${symbol} op EUR ${fillPrice}`,
      },
      cryptoOrderTriggered: {
        title: 'Crypto order geactiveerd',
        body: (symbol, triggerType, triggerPrice) =>
          `${orderTypeLabelNl(triggerType)} geactiveerd voor ${symbol} op EUR ${triggerPrice}`,
      },
      cryptoMarketRegime: {
        title: 'Crypto marktregime gewijzigd',
        body: (regime, marketMovePct) =>
          `Markt schakelde naar ${regimeLabelNl(regime)} regime (24u beweging ${marketMovePct}%)`,
      },
      cryptoMarketNews: {
        title: 'Crypto marktnieuws',
        body: (headline, impact) =>
          `${impactLabelNl(impact)}: ${headline}`,
      },
      cryptoMissionCompleted: {
        title: (missionType) => missionType === 'DAILY'
          ? 'Dagelijkse crypto missie voltooid'
          : 'Wekelijkse crypto missie voltooid',
        body: (missionTitle, rewardMoney) =>
          `${missionTitle} voltooid. Beloning: EUR ${rewardMoney}`,
      },
      cryptoLeaderboardReward: {
        title: 'Crypto leaderboard beloning',
        body: (rank, rewardMoney, periodLabel) =>
          `Je eindigde op plek #${rank} in ${periodLabel}. Beloning: EUR ${rewardMoney}`,
      },
      casinoLowBalance: {
        title: 'Casino Laag Saldo',
        body: (casinoName, currentBalance, threshold) => `${casinoName} saldo: €${currentBalance} (min: €${threshold})`,
      },
    },
    common: {
      footer: '© 2026 The Mob State. Alle rechten voorbehouden.',
      automatedMessage: 'Dit is een geautomatiseerd bericht, gelieve niet te antwoorden.',
      appName: 'THE MOB STATE',
    },
  },
};

function sideLabel(side: 'BUY' | 'SELL'): string {
  return side === 'BUY' ? 'Bought' : 'Sold';
}

function sideLabelNl(side: 'BUY' | 'SELL'): string {
  return side === 'BUY' ? 'Kocht' : 'Verkocht';
}

function orderTypeLabel(type: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT'): string {
  if (type === 'LIMIT') {
    return 'Limit order';
  }
  if (type === 'STOP_LOSS') {
    return 'Stop-loss order';
  }
  return 'Take-profit order';
}

function orderTypeLabelNl(type: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT'): string {
  if (type === 'LIMIT') {
    return 'Limietorder';
  }
  if (type === 'STOP_LOSS') {
    return 'Stop-loss order';
  }
  return 'Take-profit order';
}

function regimeLabelEn(regime: 'BULL' | 'BEAR' | 'SIDEWAYS'): string {
  if (regime === 'BULL') {
    return 'bull';
  }
  if (regime === 'BEAR') {
    return 'bear';
  }
  return 'sideways';
}

function regimeLabelNl(regime: 'BULL' | 'BEAR' | 'SIDEWAYS'): string {
  if (regime === 'BULL') {
    return 'stijgend';
  }
  if (regime === 'BEAR') {
    return 'dalend';
  }
  return 'zijwaarts';
}

function impactLabelEn(impact: 'BULLISH' | 'BEARISH' | 'NEUTRAL'): string {
  if (impact === 'BULLISH') {
    return 'Bullish';
  }
  if (impact === 'BEARISH') {
    return 'Bearish';
  }
  return 'Neutral';
}

function impactLabelNl(impact: 'BULLISH' | 'BEARISH' | 'NEUTRAL'): string {
  if (impact === 'BULLISH') {
    return 'Positief';
  }
  if (impact === 'BEARISH') {
    return 'Negatief';
  }
  return 'Neutraal';
}

export const translationService = {
  /**
   * Get translations for a specific language
   */
  getTranslations(language: Language = 'en'): Translations {
    return translations[language] || translations.en;
  },

  /**
   * Get player's preferred language
   */
  getPlayerLanguage(player: { preferredLanguage?: string }): Language {
    const lang = player.preferredLanguage?.toLowerCase();
    return (lang === 'nl' || lang === 'en') ? lang : 'en';
  },
};
