import admin from 'firebase-admin';
import prisma from '../lib/prisma';
import { translationService, type Language } from './translationService';
import { playerNotificationPreferenceService } from './playerNotificationPreferenceService';
/**
 * NotificationService
 * Handles sending push notifications via Firebase Cloud Messaging
 */
export class NotificationService {
  private static instance: NotificationService;
  private initialized = false;

  private constructor() {}

  private async createInAppWorldEvent(
    playerId: number,
    eventKey: string,
    params: Record<string, unknown>
  ): Promise<void> {
    await prisma.worldEvent.create({
      data: {
        playerId,
        eventKey,
        params: JSON.stringify(params),
      },
    });
  }

  private async resolveLanguageForPlayer(playerId: number, language?: Language): Promise<Language> {
    if (language) {
      return language;
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { preferredLanguage: true }
    });

    return translationService.getPlayerLanguage(player ?? {});
  }

  public static getInstance(): NotificationService {
    if (!NotificationService.instance) {
      NotificationService.instance = new NotificationService();
    }
    return NotificationService.instance;
  }

  /**
   * Initialize Firebase Admin SDK
   * Call this once on server startup
   */
  public async initialize(serviceAccountPath?: string): Promise<void> {
    if (this.initialized) {
      return;
    }

    try {
      // Initialize with service account JSON file or default credentials
      if (serviceAccountPath) {
        const serviceAccount = require(serviceAccountPath);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount)
        });
      } else {
        // Attempt to initialize with default credentials (for production)
        // For now, we'll skip initialization if no service account provided
        console.warn('[NotificationService] Firebase Admin not initialized - no service account provided');
        console.warn('[NotificationService] Push notifications will not work until Firebase is configured');
        return;
      }

      this.initialized = true;
      console.log('[NotificationService] Firebase Admin SDK initialized');
    } catch (error) {
      console.error('[NotificationService] Failed to initialize Firebase Admin SDK:', error);
    }
  }

  /**
   * Send push notification to a specific player
   * @param playerId - ID of the player to notify
   * @param title - Notification title
   * @param body - Notification body
   * @param data - Additional data payload
   */
  public async sendToPlayer(
    playerId: number,
    title: string,
    body: string,
    data?: Record<string, string>
  ): Promise<void> {
    if (!this.initialized) {
      console.warn('[NotificationService] Cannot send notification - Firebase not initialized');
      return;
    }

    try {
      // Get all device tokens for this player
      const devices = await prisma.playerDevice.findMany({
        where: { playerId }
      });

      if (devices.length === 0) {
        console.log(`[NotificationService] No devices registered for player ${playerId}`);
        return;
      }

      const tokens = devices.map((device: any) => device.deviceToken);

      // Prepare notification payload
      const message = {
        notification: {
          title,
          body
        },
        data: data || {},
        tokens
      };

      // Send multicast message
      const response = await admin.messaging().sendEachForMulticast(message);

      console.log(`[NotificationService] Sent notification to player ${playerId}: ${response.successCount} succeeded, ${response.failureCount} failed`);

      // Remove invalid tokens
      if (response.failureCount > 0) {
        const invalidTokens: string[] = [];
        response.responses.forEach((resp, idx) => {
          if (!resp.success && resp.error) {
            // Check if error is due to invalid registration
            const errorCode = resp.error.code;
            if (
              errorCode === 'messaging/invalid-registration-token' ||
              errorCode === 'messaging/registration-token-not-registered'
            ) {
              invalidTokens.push(tokens[idx]);
            }
          }
        });

        if (invalidTokens.length > 0) {
          await prisma.playerDevice.deleteMany({
            where: {
              deviceToken: { in: invalidTokens }
            }
          });
          console.log(`[NotificationService] Removed ${invalidTokens.length} invalid device tokens`);
        }
      }
    } catch (error) {
      console.error('[NotificationService] Error sending notification:', error);
      // Don't throw - notification failures should not block main operations
    }
  }

  /**
   * Send friend request notification
   */
  public async sendFriendRequestNotification(
    addresseeId: number,
    senderUsername: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      addresseeId,
      t.notification.friendRequest.title,
      t.notification.friendRequest.body(senderUsername),
      {
        type: 'friend_request',
        senderUsername
      }
    );
  }

  /**
   * Send friend accepted notification
   */
  public async sendFriendAcceptedNotification(
    requesterId: number,
    acceptorUsername: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      requesterId,
      t.notification.friendAccepted.title,
      t.notification.friendAccepted.body(acceptorUsername),
      {
        type: 'friend_accepted',
        acceptorUsername
      }
    );
  }

  /**
   * Send direct message notification
   */
  public async sendDirectMessageNotification(
    receiverId: number,
    senderUsername: string,
    message: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    // Truncate message if too long (max 100 chars for notification)
    const truncatedMessage = message.length > 100 ? message.substring(0, 97) + '...' : message;
    await this.sendToPlayer(
      receiverId,
      t.notification.directMessage.title,
      t.notification.directMessage.body(senderUsername, truncatedMessage),
      {
        type: 'direct_message',
        senderUsername
      }
    );
  }

  /**
   * Send crew message notification
   */
  public async sendCrewMessageNotification(
    receiverId: number,
    crewName: string,
    senderUsername: string,
    message: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    // Truncate message if too long (max 100 chars for notification)
    const truncatedMessage = message.length > 100 ? message.substring(0, 97) + '...' : message;
    await this.sendToPlayer(
      receiverId,
      t.notification.crewMessage.title(crewName),
      t.notification.crewMessage.body(senderUsername, truncatedMessage),
      {
        type: 'crew_message',
        crewName,
        senderUsername
      }
    );
  }

  public async sendCrewJoinRequestNotification(
    leaderId: number,
    requesterUsername: string,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      leaderId,
      t.notification.crewJoinRequest.title,
      t.notification.crewJoinRequest.body(requesterUsername, crewName),
      {
        type: 'crew_join_request',
        requesterUsername,
        crewName,
      }
    );
  }

  public async sendCrewJoinApprovedNotification(
    requesterId: number,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      requesterId,
      t.notification.crewJoinApproved.title,
      t.notification.crewJoinApproved.body(crewName),
      {
        type: 'crew_join_approved',
        crewName,
      }
    );
  }

  public async sendCrewJoinRejectedNotification(
    requesterId: number,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      requesterId,
      t.notification.crewJoinRejected.title,
      t.notification.crewJoinRejected.body(crewName),
      {
        type: 'crew_join_rejected',
        crewName,
      }
    );
  }

  public async sendCrewKickedNotification(
    playerId: number,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      playerId,
      t.notification.crewKicked.title,
      t.notification.crewKicked.body(crewName),
      {
        type: 'crew_kicked',
        crewName,
      }
    );
  }

  public async sendCrewRoleChangedNotification(
    playerId: number,
    crewName: string,
    roleLabel: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      playerId,
      t.notification.crewRoleChanged.title,
      t.notification.crewRoleChanged.body(crewName, roleLabel),
      {
        type: 'crew_role_changed',
        crewName,
        role: roleLabel,
      }
    );
  }

  public async sendCrewHeistResultNotification(
    playerId: number,
    crewName: string,
    heistName: string,
    success: boolean,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      playerId,
      t.notification.crewHeistResult.title(success),
      t.notification.crewHeistResult.body(crewName, heistName, success),
      {
        type: success ? 'crew_heist_success' : 'crew_heist_failure',
        crewName,
        heistName,
      }
    );
  }

  public async sendCasinoLowBalanceNotification(
    playerId: number,
    casinoName: string,
    currentBalance: number,
    threshold: number,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    await this.sendToPlayer(
      playerId,
      t.notification.casinoLowBalance.title,
      t.notification.casinoLowBalance.body(
        casinoName,
        currentBalance.toFixed(0),
        threshold.toFixed(0)
      ),
      {
        type: 'casino_low_balance',
        casinoName,
        currentBalance: currentBalance.toString(),
        threshold: threshold.toString(),
      }
    );
  }

  public async sendCryptoTradeNotification(
    playerId: number,
    side: 'buy' | 'sell',
    symbol: string,
    quantity: number,
    totalValue: number,
    realizedProfit?: number,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoTrade) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);
    const normalizedSide = side.toUpperCase() as 'BUY' | 'SELL';
    const data: Record<string, string> = {
      type: side === 'buy' ? 'crypto_trade_buy' : 'crypto_trade_sell',
      eventKey: side === 'buy' ? 'crypto.buy' : 'crypto.sell',
      symbol,
      side: normalizedSide,
      quantity: quantity.toFixed(8),
      totalValue: totalValue.toFixed(2)
    };

    if (realizedProfit !== undefined) {
      data.realizedProfit = realizedProfit.toFixed(2);
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoTradeExecuted.title(normalizedSide),
      t.notification.cryptoTradeExecuted.body(
        symbol,
        quantity.toFixed(8),
        totalValue.toFixed(2),
        realizedProfit !== undefined ? realizedProfit.toFixed(2) : undefined
      ),
      data
    );
  }

  public async sendCryptoPriceAlertNotification(
    playerId: number,
    symbol: string,
    currentPrice: number,
    changePct: number,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoPriceAlert && !preferences.inAppCryptoPriceAlert) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);

    const data = {
      type: 'crypto_price_alert',
      eventKey: 'crypto.alert.price',
      symbol,
      currentPrice: currentPrice.toFixed(8),
      changePct: changePct.toFixed(2)
    };

    if (preferences.inAppCryptoPriceAlert) {
      await this.createInAppWorldEvent(playerId, 'crypto.alert.price', {
        symbol,
        currentPrice,
        changePct,
      });
    }

    if (!preferences.pushCryptoPriceAlert) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoPriceAlert.title,
      t.notification.cryptoPriceAlert.body(
        symbol,
        currentPrice.toFixed(8),
        changePct.toFixed(2)
      ),
      data
    );
  }

  public async sendCryptoMarketRegimeNotification(
    playerId: number,
    regime: 'BULL' | 'BEAR' | 'SIDEWAYS',
    marketMovePct: number,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoPriceAlert && !preferences.inAppCryptoPriceAlert) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);

    if (preferences.inAppCryptoPriceAlert) {
      await this.createInAppWorldEvent(playerId, 'crypto.market.regime', {
        regime,
        marketMovePct,
      });
    }

    if (!preferences.pushCryptoPriceAlert) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoMarketRegime.title,
      t.notification.cryptoMarketRegime.body(regime, marketMovePct.toFixed(2)),
      {
        type: 'crypto_market_regime',
        eventKey: 'crypto.market.regime',
        regime,
        marketMovePct: marketMovePct.toFixed(2),
      }
    );
  }

  public async sendCryptoMarketNewsNotification(
    playerId: number,
    headline: string,
    impact: 'BULLISH' | 'BEARISH' | 'NEUTRAL',
    symbols: string[],
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoPriceAlert && !preferences.inAppCryptoPriceAlert) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);

    const compactHeadline = headline.length > 180 ? `${headline.slice(0, 177)}...` : headline;

    if (preferences.inAppCryptoPriceAlert) {
      await this.createInAppWorldEvent(playerId, 'crypto.market.news', {
        headline: compactHeadline,
        impact,
        symbols,
      });
    }

    if (!preferences.pushCryptoPriceAlert) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoMarketNews.title,
      t.notification.cryptoMarketNews.body(compactHeadline, impact),
      {
        type: 'crypto_market_news',
        eventKey: 'crypto.market.news',
        headline: compactHeadline,
        impact,
        symbols: symbols.join(','),
      }
    );
  }

  public async sendCryptoOrderFilledNotification(
    playerId: number,
    symbol: string,
    orderType: 'LIMIT' | 'STOP_LOSS' | 'TAKE_PROFIT',
    side: 'BUY' | 'SELL',
    quantity: number,
    fillPrice: number,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoOrder && !preferences.inAppCryptoOrder) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);

    if (preferences.inAppCryptoOrder) {
      await this.createInAppWorldEvent(playerId, 'crypto.order.filled', {
        symbol,
        orderType,
        side,
        quantity,
        fillPrice,
      });
    }

    if (!preferences.pushCryptoOrder) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoOrderFilled.title,
      t.notification.cryptoOrderFilled.body(
        symbol,
        orderType,
        side,
        quantity.toFixed(8),
        fillPrice.toFixed(8)
      ),
      {
        type: 'crypto_order_filled',
        eventKey: 'crypto.order.filled',
        symbol,
        orderType,
        side,
        quantity: quantity.toFixed(8),
        fillPrice: fillPrice.toFixed(8)
      }
    );
  }

  public async sendCryptoOrderTriggeredNotification(
    playerId: number,
    symbol: string,
    triggerType: 'STOP_LOSS' | 'TAKE_PROFIT',
    triggerPrice: number,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoOrder && !preferences.inAppCryptoOrder) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);

    if (preferences.inAppCryptoOrder) {
      await this.createInAppWorldEvent(playerId, 'crypto.order.triggered', {
        symbol,
        triggerType,
        triggerPrice,
      });
    }

    if (!preferences.pushCryptoOrder) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoOrderTriggered.title,
      t.notification.cryptoOrderTriggered.body(
        symbol,
        triggerType,
        triggerPrice.toFixed(8)
      ),
      {
        type: 'crypto_order_triggered',
        eventKey: 'crypto.order.triggered',
        symbol,
        triggerType,
        triggerPrice: triggerPrice.toFixed(8)
      }
    );
  }

  public async sendCryptoMissionCompletedNotification(
    playerId: number,
    missionType: 'DAILY' | 'WEEKLY',
    missionKey: string,
    missionTitleEn: string,
    missionTitleNl: string,
    rewardMoney: number,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoMission && !preferences.inAppCryptoMission) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);
    const missionTitle = resolvedLanguage === 'nl' ? missionTitleNl : missionTitleEn;

    if (preferences.inAppCryptoMission) {
      await this.createInAppWorldEvent(playerId, 'crypto.mission.completed', {
        missionType,
        missionKey,
        missionTitle,
        rewardMoney,
      });
    }

    if (!preferences.pushCryptoMission) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoMissionCompleted.title(missionType),
      t.notification.cryptoMissionCompleted.body(missionTitle, rewardMoney.toFixed(2)),
      {
        type: 'crypto_mission_completed',
        eventKey: 'crypto.mission.completed',
        missionType,
        missionKey,
        missionTitle,
        rewardMoney: rewardMoney.toFixed(2),
      }
    );
  }

  public async sendCryptoLeaderboardRewardNotification(
    playerId: number,
    rank: number,
    rewardMoney: number,
    weekStartAtIso: string,
    weekEndAtIso: string,
    language?: Language
  ): Promise<void> {
    const preferences = await playerNotificationPreferenceService.getPreferences(playerId);
    if (!preferences.pushCryptoLeaderboard && !preferences.inAppCryptoLeaderboard) {
      return;
    }

    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const t = translationService.getTranslations(resolvedLanguage);

    const periodLabel = resolvedLanguage === 'nl' ? 'de wekelijkse crypto ranking' : 'the weekly crypto ranking';

    if (preferences.inAppCryptoLeaderboard) {
      await this.createInAppWorldEvent(playerId, 'crypto.leaderboard.reward', {
        rank,
        rewardMoney,
        weekStartAt: weekStartAtIso,
        weekEndAt: weekEndAtIso,
      });
    }

    if (!preferences.pushCryptoLeaderboard) {
      return;
    }

    await this.sendToPlayer(
      playerId,
      t.notification.cryptoLeaderboardReward.title,
      t.notification.cryptoLeaderboardReward.body(
        rank.toString(),
        rewardMoney.toFixed(2),
        periodLabel
      ),
      {
        type: 'crypto_leaderboard_reward',
        eventKey: 'crypto.leaderboard.reward',
        rank: rank.toString(),
        rewardMoney: rewardMoney.toFixed(2),
        weekStartAt: weekStartAtIso,
        weekEndAt: weekEndAtIso,
      }
    );
  }
}

export const notificationService = NotificationService.getInstance();
