import admin from 'firebase-admin';
import fs from 'fs';
import prisma from '../lib/prisma';
import { normalizePlayerLanguage, type SupportedPlayerLanguage } from '../config/supportedLanguages';
import { translationService, type Language } from './translationService';
import { playerNotificationPreferenceService } from './playerNotificationPreferenceService';
import { systemLogService } from './systemLogService';

/** Push body uses this word for `cooldown_expired` per language. */
const COOLDOWN_ACTION_LABEL: Record<string, Partial<Record<SupportedPlayerLanguage, string>>> = {
  crime: { en: 'crime', nl: 'misdaad', es: 'crimen', de: 'Verbrechen', fr: 'crime', it: 'reato', pl: 'przestępstwo', pt: 'crime' },
  job: { en: 'job', nl: 'werk', es: 'trabajo', de: 'Job', fr: 'travail', it: 'lavoro', pl: 'praca', pt: 'trabalho' },
  vehicle_theft: {
    en: 'vehicle theft',
    nl: 'voertuig stelen',
    es: 'robo de vehículo',
    de: 'Fahrzeugdiebstahl',
    fr: 'vol de véhicule',
    it: 'furto di veicolo',
    pl: 'kradzież pojazdu',
    pt: 'roubo de veículo',
  },
  motorcycle_theft: {
    en: 'motorcycle theft',
    nl: 'motor stelen',
    es: 'robo de moto',
    de: 'Motorraddiebstahl',
    fr: 'vol de moto',
    it: 'furto di moto',
    pl: 'kradzież motocykla',
    pt: 'roubo de mota',
  },
  boat_theft: {
    en: 'boat theft',
    nl: 'boot stelen',
    es: 'robo de barco',
    de: 'Bootsdiebstahl',
    fr: 'vol de bateau',
    it: 'furto di barca',
    pl: 'kradzież łodzi',
    pt: 'roubo de barco',
  },
  prostitute_recruit: {
    en: 'prostitute recruitment',
    nl: 'hoeren werven',
    es: 'reclutamiento',
    de: 'Rekrutierung',
    fr: 'recrutement',
    it: 'reclutamento',
    pl: 'rekrutacja',
    pt: 'recrutamento',
  },
  school: {
    en: 'school',
    nl: 'opleiding',
    es: 'escuela',
    de: 'Schule',
    fr: 'école',
    it: 'scuola',
    pl: 'szkoła',
    pt: 'escola',
  },
  ammo_factory: {
    en: 'ammo factory',
    nl: 'munitiefabriek',
    es: 'fábrica de munición',
    de: 'Munitionsfabrik',
    fr: 'usine de munitions',
    it: 'fabbrica di munizioni',
    pl: 'fabryka amunicji',
    pt: 'fábrica de munições',
  },
};

function labelForCooldownAction(actionType: string, lang: SupportedPlayerLanguage): string {
  const row = COOLDOWN_ACTION_LABEL[actionType];
  if (row) {
    return row[lang] ?? row.en ?? actionType;
  }
  return actionType;
}

type FirebaseServiceAccountShape = {
  project_id?: string;
  client_email?: string;
  private_key?: string;
};

function parseServiceAccountFromEnv(): FirebaseServiceAccountShape | null {
  const rawJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON?.trim();
  const rawBase64 = process.env.FIREBASE_SERVICE_ACCOUNT_BASE64?.trim();

  if (rawJson) {
    return JSON.parse(rawJson) as FirebaseServiceAccountShape;
  }

  if (rawBase64) {
    const decoded = Buffer.from(rawBase64, 'base64').toString('utf8');
    return JSON.parse(decoded) as FirebaseServiceAccountShape;
  }

  const projectId = process.env.FIREBASE_PROJECT_ID?.trim();
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL?.trim();
  const privateKey = process.env.FIREBASE_PRIVATE_KEY
    ?.replace(/\\n/g, '\n')
    .trim();

  if (projectId && clientEmail && privateKey) {
    return {
      project_id: projectId,
      client_email: clientEmail,
      private_key: privateKey,
    };
  }

  return null;
}
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

  private normalizeArrestAuthorityLabel(authority: string, language: Language): string {
    const raw = String(authority || '').trim();
    if (!raw) {
      return language === 'nl' ? 'politie' : 'police';
    }

    const normalized = raw.toLowerCase().replace(/[^a-z]/g, '');
    if (normalized.includes('fbi')) {
      return 'FBI';
    }
    if (normalized.includes('border') || normalized.includes('grens')) {
      return language === 'nl' ? 'grenspolitie' : 'border police';
    }
    if (normalized.includes('police') || normalized.includes('pilice') || normalized.includes('politie')) {
      return language === 'nl' ? 'politie' : 'police';
    }

    return language === 'nl' ? raw : raw.toLowerCase();
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
      const serviceAccountFromEnv = parseServiceAccountFromEnv();
      const normalizedPath = serviceAccountPath?.trim();
      const hasServiceAccountFile = normalizedPath ? fs.existsSync(normalizedPath) : false;

      if (serviceAccountFromEnv) {
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccountFromEnv as admin.ServiceAccount)
        });
        console.log('[NotificationService] Firebase Admin SDK initialized from environment credentials');
      } else if (normalizedPath && hasServiceAccountFile) {
        const serviceAccount = JSON.parse(fs.readFileSync(normalizedPath, 'utf8')) as admin.ServiceAccount;
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount)
        });
        console.log(`[NotificationService] Firebase Admin SDK initialized from service account file: ${normalizedPath}`);
      } else {
        console.warn('[NotificationService] Firebase Admin not initialized - no service account provided');
        console.warn('[NotificationService] Push notifications will not work until Firebase is configured');
        if (normalizedPath) {
          console.warn(`[NotificationService] Missing Firebase service account file at: ${normalizedPath}`);
        }
        return;
      }

      this.initialized = true;
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
      await systemLogService.logError('NotificationService.sendToPlayer', 'Firebase Admin not initialized for push send', {
        playerId,
        title,
        data,
      });
      return;
    }

    try {
      // Get all device tokens for this player
      const devices = await prisma.playerDevice.findMany({
        where: { playerId }
      });

      if (devices.length === 0) {
        console.log(`[NotificationService] No devices registered for player ${playerId}`);
        await systemLogService.logError('NotificationService.sendToPlayer', 'No registered devices found for push target', {
          playerId,
          title,
          data,
        });
        return;
      }

      // Split tokens by platform: web tokens must receive data-only messages to
      // prevent duplicate notifications (FCM auto-shows notification AND the
      // service worker's onBackgroundMessage would show a second one).
      const webTokens = devices
        .filter((d: any) => d.deviceType === 'web')
        .map((d: any) => d.deviceToken);
      const nativeTokens = devices
        .filter((d: any) => d.deviceType !== 'web')
        .map((d: any) => d.deviceToken);

      const invalidTokens: string[] = [];

      const collectInvalidTokens = (
        tokens: string[],
        responses: admin.messaging.SendResponse[]
      ) => {
        responses.forEach((resp, idx) => {
          if (!resp.success && resp.error) {
            const errorCode = resp.error.code;
            if (
              errorCode === 'messaging/invalid-registration-token' ||
              errorCode === 'messaging/registration-token-not-registered'
            ) {
              invalidTokens.push(tokens[idx]);
            }
          }
        });
      };

      let totalSuccess = 0;
      let totalFailure = 0;
      const failedResponses: Array<{ token: string; platform: 'web' | 'native'; errorCode: string; errorMessage: string }> = [];

      const collectFailedResponses = (
        tokens: string[],
        platform: 'web' | 'native',
        responses: admin.messaging.SendResponse[]
      ) => {
        responses.forEach((resp, idx) => {
          if (!resp.success && resp.error) {
            failedResponses.push({
              token: tokens[idx],
              platform,
              errorCode: resp.error.code,
              errorMessage: resp.error.message,
            });
          }
        });
      };

      // Web: data-only so the service worker shows exactly one notification
      if (webTokens.length > 0) {
        const webMessage = {
          data: { title, body, ...(data || {}) },
          tokens: webTokens
        };
        const webResponse = await admin.messaging().sendEachForMulticast(webMessage);
        totalSuccess += webResponse.successCount;
        totalFailure += webResponse.failureCount;
        collectInvalidTokens(webTokens, webResponse.responses);
        collectFailedResponses(webTokens, 'web', webResponse.responses);
      }

      // Native (Android / iOS): include notification key for platform handling
      if (nativeTokens.length > 0) {
        const nativeMessage = {
          notification: { title, body },
          data: data || {},
          tokens: nativeTokens
        };
        const nativeResponse = await admin.messaging().sendEachForMulticast(nativeMessage);
        totalSuccess += nativeResponse.successCount;
        totalFailure += nativeResponse.failureCount;
        collectInvalidTokens(nativeTokens, nativeResponse.responses);
        collectFailedResponses(nativeTokens, 'native', nativeResponse.responses);
      }

      console.log(`[NotificationService] Sent notification to player ${playerId}: ${totalSuccess} succeeded, ${totalFailure} failed`);

      if (totalFailure > 0) {
        await systemLogService.logError('NotificationService.sendToPlayer', 'Push delivery had failed recipients', {
          playerId,
          title,
          data,
          deviceCount: devices.length,
          webDeviceCount: webTokens.length,
          nativeDeviceCount: nativeTokens.length,
          totalSuccess,
          totalFailure,
          failures: failedResponses.map((failure) => ({
            ...failure,
            tokenPreview: failure.token.slice(0, 16),
          })),
        });
      }

      // Remove invalid tokens
      if (invalidTokens.length > 0) {
        await prisma.playerDevice.deleteMany({
          where: {
            deviceToken: { in: invalidTokens }
          }
        });
        console.log(`[NotificationService] Removed ${invalidTokens.length} invalid device tokens`);
      }
    } catch (error) {
      await systemLogService.logError('NotificationService.sendToPlayer', 'Push send threw an exception', {
        playerId,
        title,
        data,
        error,
      });
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

  public async sendArrestAwaitingHelpNotifications(
    arrestedPlayerId: number,
    jailTimeMinutes: number,
    authority: string,
    source?: string
  ): Promise<void> {
    try {
      const [player, friendships, crewMembership] = await Promise.all([
        prisma.player.findUnique({
          where: { id: arrestedPlayerId },
          select: {
            id: true,
            username: true,
          },
        }),
        prisma.friendship.findMany({
          where: {
            status: 'accepted',
            OR: [
              { requesterId: arrestedPlayerId },
              { addresseeId: arrestedPlayerId },
            ],
          },
          select: {
            requesterId: true,
            addresseeId: true,
          },
        }),
        prisma.crewMember.findUnique({
          where: { playerId: arrestedPlayerId },
          select: {
            crewId: true,
            crew: {
              select: {
                name: true,
              },
            },
          },
        }),
      ]);

      if (!player) {
        return;
      }

      const recipients = new Map<number, { isFriend: boolean; isCrew: boolean }>();

      for (const friendship of friendships) {
        const recipientId = friendship.requesterId === arrestedPlayerId
          ? friendship.addresseeId
          : friendship.requesterId;
        const current = recipients.get(recipientId) ?? { isFriend: false, isCrew: false };
        current.isFriend = true;
        recipients.set(recipientId, current);
      }

      if (crewMembership) {
        const crewMembers = await prisma.crewMember.findMany({
          where: {
            crewId: crewMembership.crewId,
            playerId: {
              not: arrestedPlayerId,
            },
          },
          select: {
            playerId: true,
          },
        });

        for (const member of crewMembers) {
          const current = recipients.get(member.playerId) ?? { isFriend: false, isCrew: false };
          current.isCrew = true;
          recipients.set(member.playerId, current);
        }
      }

      if (recipients.size === 0) {
        return;
      }

      await Promise.allSettled(
        Array.from(recipients.entries()).map(async ([recipientId, relation]) => {
          const language = await this.resolveLanguageForPlayer(recipientId);
          const isCrewRelation = relation.isCrew;
          const crewName = crewMembership?.crew.name;
          const authorityLabel = this.normalizeArrestAuthorityLabel(authority, language);
          const title = language === 'nl'
            ? (isCrewRelation ? 'Crewlid opgepakt' : 'Vriend opgepakt')
            : (isCrewRelation ? 'Crewmate Arrested' : 'Friend Arrested');
          const body = language === 'nl'
            ? isCrewRelation
              ? `${player.username}${crewName ? ` van ${crewName}` : ''} is opgepakt door de ${authorityLabel} en wacht op hulp in de gevangenis (${jailTimeMinutes} min).`
              : `${player.username} is opgepakt door de ${authorityLabel} en wacht op hulp in de gevangenis (${jailTimeMinutes} min).`
            : isCrewRelation
              ? `${player.username}${crewName ? ` from ${crewName}` : ''} was arrested by ${authorityLabel} and is waiting for help in prison (${jailTimeMinutes} min).`
              : `${player.username} was arrested by ${authorityLabel} and is waiting for help in prison (${jailTimeMinutes} min).`;

          await this.sendToPlayer(recipientId, title, body, {
            type: 'ally_arrested',
            arrestedPlayerId: String(arrestedPlayerId),
            username: player.username,
            authority,
            jailTimeMinutes: String(jailTimeMinutes),
            relation: relation.isCrew && relation.isFriend
              ? 'friend_crew'
              : relation.isCrew
                ? 'crew'
                : 'friend',
            source: source ?? 'UNKNOWN',
          });
        })
      );
    } catch (error) {
      console.error('[NotificationService] Failed to send arrest awaiting help notifications:', error);
    }
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

  public async sendSupportTicketUpdateNotification(
    playerId: number,
    ticketId: number,
    subject: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const trimmedSubject = subject.length > 80
      ? `${subject.substring(0, 77)}...`
      : subject;

    await this.sendToPlayer(
      playerId,
      t.notification.supportTicketUpdate.title,
      t.notification.supportTicketUpdate.body(String(ticketId), trimmedSubject),
      {
        type: 'support_ticket_update',
        ticketId: String(ticketId),
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

  public async sendCrewWarDeclaredNotification(
    playerId: number,
    warId: number,
    opposingCrewName: string,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const title = resolvedLanguage === 'nl' ? 'Crew-oorlog verklaard' : 'Crew war declared';
    const body = resolvedLanguage === 'nl'
      ? `Oorlog #${warId} tegen ${opposingCrewName} start binnenkort.`
      : `War #${warId} against ${opposingCrewName} begins soon.`;

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_war_declared',
      warId: String(warId),
      opposingCrewName,
    });
  }

  public async sendCrewWarStartedNotification(
    playerId: number,
    warId: number,
    opposingCrewName: string,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const title = resolvedLanguage === 'nl' ? 'Crew-oorlog gestart' : 'Crew war started';
    const body = resolvedLanguage === 'nl'
      ? `Oorlog #${warId} tegen ${opposingCrewName} is nu live.`
      : `War #${warId} against ${opposingCrewName} is now live.`;

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_war_started',
      warId: String(warId),
      opposingCrewName,
    });
  }

  public async sendCrewWarLockdownNotification(
    playerId: number,
    warId: number,
    opposingCrewName: string,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const title = resolvedLanguage === 'nl' ? 'Crew-oorlog lockdown' : 'Crew war lockdown';
    const body = resolvedLanguage === 'nl'
      ? `Oorlog #${warId} tegen ${opposingCrewName} zit nu in lockdown.`
      : `War #${warId} against ${opposingCrewName} is now in lockdown.`;

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_war_lockdown',
      warId: String(warId),
      opposingCrewName,
    });
  }

  public async sendCrewWarEndedNotification(
    playerId: number,
    warId: number,
    winnerCrewId: number,
    winnerCrewName?: string | null,
    territoryAftermath?: {
      theaterRegionKey?: string | null;
      affectedRegionKeys?: string[];
      endsAt?: Date | string | null;
    } | null,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const title = resolvedLanguage === 'nl' ? 'Crew-oorlog afgelopen' : 'Crew war ended';
    const affectedCount = territoryAftermath?.affectedRegionKeys?.length ?? 0;
    const rawEndsAt = territoryAftermath?.endsAt;
    const aftermathEndsAt = rawEndsAt instanceof Date
      ? rawEndsAt
      : (typeof rawEndsAt === 'string' ? new Date(rawEndsAt) : null);
    const hasAftermath = affectedCount > 0 && aftermathEndsAt && !Number.isNaN(aftermathEndsAt.getTime());
    const winnerLabel = winnerCrewName?.trim()
      ? (resolvedLanguage === 'nl'
          ? `${winnerCrewName} (#${winnerCrewId})`
          : `${winnerCrewName} (#${winnerCrewId})`)
      : `#${winnerCrewId}`;
    const aftermathSuffix = hasAftermath
      ? (resolvedLanguage === 'nl'
          ? ` Tijdelijke oorlogsdruk is actief op ${affectedCount} Territory-regio${affectedCount === 1 ? '' : '\'s'} tot ${aftermathEndsAt.toLocaleString('nl-NL', { hour12: false })}.`
          : ` Temporary war pressure is active on ${affectedCount} Territory region${affectedCount === 1 ? '' : 's'} until ${aftermathEndsAt.toLocaleString('en-GB', { hour12: false })}.`)
      : '';
    const body = resolvedLanguage === 'nl'
      ? `Oorlog #${warId} is afgerond. Winnende crew: ${winnerLabel}.${aftermathSuffix}`
      : `War #${warId} has been resolved. Winning crew: ${winnerLabel}.${aftermathSuffix}`;

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_war_ended',
      warId: String(warId),
      winnerCrewId: String(winnerCrewId),
      winnerCrewName: winnerCrewName ?? '',
      territoryAftermathActive: hasAftermath ? '1' : '0',
      territoryAftermathRegionCount: String(affectedCount),
      territoryAftermathEndsAt: aftermathEndsAt?.toISOString() ?? '',
      territoryAftermathTheaterRegionKey: territoryAftermath?.theaterRegionKey ?? '',
    });
  }

  public async sendCrewMissionStartedNotification(
    playerId: number,
    runId: number,
    crewName: string,
    missionTitleNl: string,
    missionTitleEn: string,
    startedByUsername: string,
    endsAt: Date | string,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const missionTitle = resolvedLanguage === 'nl' ? missionTitleNl : missionTitleEn;
    const parsedEndsAt = endsAt instanceof Date ? endsAt : new Date(endsAt);
    const endsAtText = Number.isNaN(parsedEndsAt.getTime())
      ? ''
      : parsedEndsAt.toLocaleString(resolvedLanguage === 'nl' ? 'nl-NL' : 'en-GB', { hour12: false });

    const title = resolvedLanguage === 'nl'
      ? 'Crew missie gestart'
      : 'Crew mission started';
    const body = resolvedLanguage === 'nl'
      ? `${startedByUsername} heeft "${missionTitle}" gestart voor ${crewName}.${endsAtText ? ` Eindigt rond ${endsAtText}.` : ''}`
      : `${startedByUsername} started "${missionTitle}" for ${crewName}.${endsAtText ? ` Ends around ${endsAtText}.` : ''}`;

    await this.createInAppWorldEvent(playerId, 'crew.mission.started', {
      runId,
      crewName,
      missionTitle,
      startedByUsername,
      endsAt: parsedEndsAt.toISOString(),
    });

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_mission_started',
      runId: String(runId),
      crewName,
      missionTitle,
      startedByUsername,
      endsAt: parsedEndsAt.toISOString(),
    });
  }

  public async sendCrewMissionResolvedNotification(
    playerId: number,
    runId: number,
    crewName: string,
    missionTitleNl: string,
    missionTitleEn: string,
    outcome: 'success' | 'partial' | 'fail',
    rewardCrewCash: number,
    rewardCrewXp: number,
    cooldownUntil?: Date | string | null,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const missionTitle = resolvedLanguage === 'nl' ? missionTitleNl : missionTitleEn;
    const outcomeLabel = resolvedLanguage === 'nl'
      ? (outcome === 'success' ? 'Succes' : outcome === 'partial' ? 'Gedeeltelijk' : 'Mislukt')
      : (outcome === 'success' ? 'Success' : outcome === 'partial' ? 'Partial' : 'Failed');
    const parsedCooldownUntil = cooldownUntil
      ? (cooldownUntil instanceof Date ? cooldownUntil : new Date(cooldownUntil))
      : null;
    const cooldownText = parsedCooldownUntil && !Number.isNaN(parsedCooldownUntil.getTime())
      ? parsedCooldownUntil.toLocaleString(resolvedLanguage === 'nl' ? 'nl-NL' : 'en-GB', { hour12: false })
      : '';

    const title = resolvedLanguage === 'nl'
      ? `Crew missie ${outcome === 'success' ? 'geslaagd' : outcome === 'partial' ? 'afgerond' : 'mislukt'}`
      : `Crew mission ${outcome === 'success' ? 'succeeded' : outcome === 'partial' ? 'completed' : 'failed'}`;
    const body = resolvedLanguage === 'nl'
      ? `"${missionTitle}" (${crewName}) - ${outcomeLabel}. Reward: €${Math.round(rewardCrewCash).toLocaleString('nl-NL')} en ${Math.round(rewardCrewXp)} crew XP.${cooldownText ? ` Cooldown tot ${cooldownText}.` : ''}`
      : `"${missionTitle}" (${crewName}) - ${outcomeLabel}. Reward: €${Math.round(rewardCrewCash).toLocaleString('en-GB')} and ${Math.round(rewardCrewXp)} crew XP.${cooldownText ? ` Cooldown until ${cooldownText}.` : ''}`;

    await this.createInAppWorldEvent(playerId, 'crew.mission.resolved', {
      runId,
      crewName,
      missionTitle,
      outcome,
      rewardCrewCash: Math.round(rewardCrewCash),
      rewardCrewXp: Math.round(rewardCrewXp),
      cooldownUntil: parsedCooldownUntil?.toISOString() ?? null,
    });

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_mission_resolved',
      runId: String(runId),
      crewName,
      missionTitle,
      outcome,
      rewardCrewCash: String(Math.round(rewardCrewCash)),
      rewardCrewXp: String(Math.round(rewardCrewXp)),
      cooldownUntil: parsedCooldownUntil?.toISOString() ?? '',
    });
  }

  public async sendCrewMissionCooldownReadyNotification(
    playerId: number,
    runId: number,
    crewName: string,
    missionTitleNl: string,
    missionTitleEn: string,
    language?: Language
  ): Promise<void> {
    const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
    const missionTitle = resolvedLanguage === 'nl' ? missionTitleNl : missionTitleEn;
    const title = resolvedLanguage === 'nl'
      ? 'Crew missie cooldown klaar'
      : 'Crew mission cooldown ready';
    const body = resolvedLanguage === 'nl'
      ? `"${missionTitle}" voor ${crewName} is weer beschikbaar.`
      : `"${missionTitle}" for ${crewName} is available again.`;

    await this.createInAppWorldEvent(playerId, 'crew.mission.cooldown_ready', {
      runId,
      crewName,
      missionTitle,
    });

    await this.sendToPlayer(playerId, title, body, {
      type: 'crew_mission_cooldown_ready',
      runId: String(runId),
      crewName,
      missionTitle,
    });
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

  public async sendCooldownExpiredNotification(
    playerId: number,
    actionType: string,
    language?: Language
  ): Promise<void> {
    try {
      const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
      const t = translationService.getTranslations(resolvedLanguage);
      const actionName = labelForCooldownAction(actionType, resolvedLanguage);
      await this.sendToPlayer(
        playerId,
        t.notification.cooldownExpired.title,
        t.notification.cooldownExpired.body(actionName),
        { type: 'cooldown_expired', actionType }
      );
    } catch {
      // Non-critical — never throw
    }
  }

  public async sendVehicleRepairCompletedNotification(
    playerId: number,
    vehicleName: string,
    vehicleType: 'car' | 'boat' | 'motorcycle',
    vehicleInventoryId?: number,
    language?: Language
  ): Promise<void> {
    try {
      const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);

      const labels: Record<'car' | 'boat' | 'motorcycle', Record<Language, string>> = {
        car: { nl: 'Auto', en: 'Car' },
        motorcycle: { nl: 'Motor', en: 'Motorcycle' },
        boat: { nl: 'Boot', en: 'Boat' },
      };

      const title = resolvedLanguage === 'nl'
        ? 'Voertuigreparatie gereed'
        : 'Vehicle repair complete';
      const typeLabel = labels[vehicleType]?.[resolvedLanguage] ?? labels.car[resolvedLanguage];
      const body = resolvedLanguage === 'nl'
        ? `${typeLabel} ${vehicleName} is gerepareerd en klaar voor gebruik.`
        : `${typeLabel} ${vehicleName} has been repaired and is ready to use.`;

      await this.createInAppWorldEvent(playerId, 'vehicle.repair.completed', {
        vehicleName,
        vehicleType,
        vehicleInventoryId: vehicleInventoryId ?? null,
      });

      await this.sendToPlayer(
        playerId,
        title,
        body,
        {
          type: 'vehicle_repair_completed',
          vehicleName,
          vehicleType,
          vehicleInventoryId: String(vehicleInventoryId ?? ''),
        }
      );
    } catch {
      // Non-critical — never throw
    }
  }

  public async sendBankTransferReceivedNotification(
    playerId: number,
    senderUsername: string,
    amount: number,
    language?: Language
  ): Promise<void> {
    try {
      const resolvedLanguage = await this.resolveLanguageForPlayer(playerId, language);
      const t = translationService.getTranslations(resolvedLanguage);
      await this.sendToPlayer(
        playerId,
        t.notification.bankTransferReceived.title,
        t.notification.bankTransferReceived.body(senderUsername, amount.toFixed(0)),
        { type: 'bank_transfer_received', senderUsername, amount: amount.toString() }
      );
    } catch {
      // Non-critical — never throw
    }
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

  /**
   * Localized FCM for live game event start/end. Respects `push_game_events` in player settings
   * (default on; no row = opted in). No-op if Firebase is not initialized.
   */
  public async broadcastLocalizedGameEventPushes(payload: {
    titleNl: string;
    titleEn: string;
    titleEs?: string;
    bodyNl: string;
    bodyEn: string;
    bodyEs?: string;
    data?: Record<string, string>;
  }): Promise<void> {
    if (!this.initialized) {
      return;
    }

    const players = await prisma.player.findMany({
      where: {
        OR: [
          { player_notification_preferences: { is: null } },
          { player_notification_preferences: { push_game_events: true } },
        ],
      },
      select: { id: true, preferredLanguage: true },
    });

    const batchSize = 50;
    for (let i = 0; i < players.length; i += batchSize) {
      const batch = players.slice(i, i + batchSize);
      await Promise.all(
        batch.map((p) => {
          const lang = normalizePlayerLanguage(p.preferredLanguage);
          let title = payload.titleEn;
          let body = payload.bodyEn;
          if (lang === 'nl') {
            title = payload.titleNl;
            body = payload.bodyNl;
          } else if (lang === 'es' && payload.titleEs && payload.bodyEs) {
            title = payload.titleEs;
            body = payload.bodyEs;
          }
          return this.sendToPlayer(p.id, title, body, payload.data);
        })
      );
    }
  }
}

export const notificationService = NotificationService.getInstance();
