import crypto from 'crypto';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import prisma from '../lib/prisma';
import config from '../config';
import countries from '../../content/countries.json';
import { normalizePlayerLanguage } from '../config/supportedLanguages';
import { authService } from './authService';

const SALT_ROUNDS = 10;
const DISCORD_API = 'https://discord.com/api/v10';
const DISCORD_USER_AGENT = 'TheMobState (https://themobstate.com, 1.0)';

type DiscordProfile = {
  id: string;
  name?: string;
  email?: string;
};

const discordClientId = () => (process.env.DISCORD_CLIENT_ID ?? '').trim();
const discordClientSecret = () => (process.env.DISCORD_CLIENT_SECRET ?? '').trim();

export const discordOAuthRedirectUri = (): string => {
  const explicit = (process.env.DISCORD_OAUTH_REDIRECT_URI ?? '').trim();
  if (explicit) return explicit;
  const apiBase = (config.apiBaseUrl || 'https://api.themobstate.com').replace(/\/+$/, '');
  return `${apiBase}/auth/discord/callback`;
};

export const isDiscordLoginConfigured = (): boolean =>
  Boolean(discordClientId() && discordClientSecret());

const suggestUsername = (name: string): string => {
  const cleaned = name.replace(/[^a-zA-Z0-9_]/g, '').slice(0, 16);
  return cleaned.length >= 3 ? cleaned : `player${crypto.randomInt(1000, 9999)}`;
};

type OauthStatePayload = {
  t?: string;
  intent?: 'login' | 'link';
  playerId?: number;
};

const signState = (intent: 'login' | 'link' = 'login', playerId?: number): string =>
  jwt.sign(
    {
      t: 'discord_oauth',
      intent,
      playerId,
      n: crypto.randomBytes(8).toString('hex'),
    },
    config.jwtSecret,
    { expiresIn: '10m' },
  );

const readState = (state: string): OauthStatePayload | null => {
  try {
    const payload = jwt.verify(state, config.jwtSecret) as OauthStatePayload;
    if (payload.t !== 'discord_oauth') return null;
    return payload;
  } catch {
    return null;
  }
};

const signPending = (profile: DiscordProfile): string =>
  jwt.sign(
    {
      t: 'discord_pending',
      discordId: profile.id,
      email: profile.email ?? '',
      name: profile.name ?? '',
    },
    config.jwtSecret,
    { expiresIn: '20m' },
  );

type PendingPayload = {
  t: string;
  discordId: string;
  email: string;
  name: string;
};

const verifyPending = (token: string): PendingPayload => {
  const payload = jwt.verify(token, config.jwtSecret) as PendingPayload;
  if (payload.t !== 'discord_pending' || !payload.discordId) {
    throw new Error('DISCORD_PENDING_INVALID');
  }
  return payload;
};

const appRedirect = (params: Record<string, string>): string => {
  const base = (config.appBaseUrl || 'https://themobstate.com').replace(/\/+$/, '');
  const query = new URLSearchParams(params);
  return `${base}/login?${query.toString()}`;
};

const appLinkRedirect = (params: Record<string, string>): string => {
  const base = (config.appBaseUrl || 'https://themobstate.com').replace(/\/+$/, '');
  const query = new URLSearchParams({ section: 'settings', ...params });
  return `${base}/dashboard?${query.toString()}`;
};

const isLinkState = (state: OauthStatePayload | null): boolean =>
  state?.intent === 'link' && typeof state.playerId === 'number' && state.playerId > 0;

const authorizeUrl = (intent: 'login' | 'link' = 'login', playerId?: number): string => {
  if (!isDiscordLoginConfigured()) {
    throw new Error('DISCORD_NOT_CONFIGURED');
  }
  const url = new URL(`${DISCORD_API}/oauth2/authorize`);
  url.searchParams.set('client_id', discordClientId());
  url.searchParams.set('redirect_uri', discordOAuthRedirectUri());
  url.searchParams.set('response_type', 'code');
  url.searchParams.set('scope', 'identify email');
  url.searchParams.set('state', signState(intent, playerId));
  url.searchParams.set('prompt', 'consent');
  return url.toString();
};

async function linkDiscordToPlayer(playerId: number, discordId: string): Promise<string> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { id: true, discordId: true, isBanned: true },
  });
  if (!player || player.isBanned) {
    return appLinkRedirect({ discord_link: 'error', reason: 'DISCORD_AUTH_FAILED' });
  }
  if (player.discordId && player.discordId !== discordId) {
    return appLinkRedirect({ discord_link: 'error', reason: 'DISCORD_ALREADY_LINKED' });
  }
  const taken = await prisma.player.findUnique({
    where: { discordId },
    select: { id: true },
  });
  if (taken && taken.id !== playerId) {
    return appLinkRedirect({ discord_link: 'error', reason: 'DISCORD_IN_USE' });
  }
  const firstLink = !player.discordId;
  if (firstLink) {
    await prisma.player.update({
      where: { id: playerId },
      data: { discordId },
    });
  }
  let bonus = 0;
  if (firstLink) {
    const { discordLinkPromptService } = await import('./discordLinkPromptService');
    bonus = await discordLinkPromptService.payLinkBonus(playerId);
  }
  return appLinkRedirect(
    bonus > 0
      ? { discord_link: 'ok', bonus: String(bonus) }
      : { discord_link: 'ok' },
  );
}

const readJson = async (response: Response): Promise<Record<string, unknown>> => {
  const data = (await response.json()) as Record<string, unknown>;
  if (!response.ok) {
    const error = data.error as string | { message?: string } | undefined;
    const message =
      typeof error === 'string'
        ? error
        : error?.message || (typeof data.error_description === 'string' ? data.error_description : '');
    throw new Error(message || 'DISCORD_OAUTH_ERROR');
  }
  return data;
};

export const discordAuthService = {
  status() {
    return {
      loginEnabled: isDiscordLoginConfigured(),
    };
  },

  errorRedirect(reason = 'DISCORD_AUTH_FAILED'): string {
    return appRedirect({ d: 'error', reason });
  },

  callbackErrorRedirect(state: string | undefined, reason = 'DISCORD_AUTH_FAILED'): string {
    const payload = state ? readState(state) : null;
    if (isLinkState(payload)) {
      return appLinkRedirect({ discord_link: 'error', reason });
    }
    return appRedirect({ d: 'error', reason });
  },

  startUrl(): string {
    return authorizeUrl('login');
  },

  linkStartUrl(playerId: number): string {
    return authorizeUrl('link', playerId);
  },

  async unlink(playerId: number): Promise<void> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { discordId: true, googleId: true, facebookId: true, email: true },
    });
    if (!player?.discordId) {
      throw new Error('DISCORD_NOT_LINKED');
    }
    const hasOtherLogin = Boolean(player.googleId || player.facebookId || player.email);
    if (!hasOtherLogin) {
      throw new Error('DISCORD_UNLINK_BLOCKED');
    }
    await prisma.player.update({
      where: { id: playerId },
      data: { discordId: null },
    });
  },

  async handleCallback(code: string | undefined, state: string | undefined): Promise<string> {
    if (!isDiscordLoginConfigured()) {
      return appRedirect({ d: 'error', reason: 'DISCORD_NOT_CONFIGURED' });
    }
    const statePayload = state ? readState(state) : null;
    if (!code || !statePayload) {
      return this.callbackErrorRedirect(state);
    }

    try {
      const tokenResponse = await fetch(`${DISCORD_API}/oauth2/token`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': DISCORD_USER_AGENT,
        },
        body: new URLSearchParams({
          client_id: discordClientId(),
          client_secret: discordClientSecret(),
          grant_type: 'authorization_code',
          code,
          redirect_uri: discordOAuthRedirectUri(),
        }),
      });
      const tokenData = await readJson(tokenResponse);
      const accessToken = String(tokenData.access_token ?? '');
      if (!accessToken) {
        return this.callbackErrorRedirect(state);
      }

      const userResponse = await fetch(`${DISCORD_API}/users/@me`, {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'User-Agent': DISCORD_USER_AGENT,
        },
      });
      const me = await readJson(userResponse);
      const emailVerified = me.verified === true;
      const email =
        typeof me.email === 'string' && emailVerified ? me.email : undefined;
      const displayName =
        typeof me.global_name === 'string' && me.global_name.trim()
          ? me.global_name
          : typeof me.username === 'string'
            ? me.username
            : undefined;
      const profile: DiscordProfile = {
        id: String(me.id ?? ''),
        name: displayName,
        email,
      };
      if (!profile.id) {
        return this.callbackErrorRedirect(state);
      }

      if (isLinkState(statePayload) && statePayload.playerId) {
        return linkDiscordToPlayer(statePayload.playerId, profile.id);
      }

      const existingByDiscord = await prisma.player.findUnique({
        where: { discordId: profile.id },
        select: { id: true },
      });
      if (existingByDiscord) {
        try {
          const session = await authService.issueSession(existingByDiscord.id);
          if (!session.token) {
            return appRedirect({ d: 'error', reason: 'DISCORD_AUTH_FAILED' });
          }
          return appRedirect({ d: 'ok', token: session.token });
        } catch (error) {
          if (error instanceof Error && error.message === 'PLAYER_BANNED') {
            return appRedirect({ d: 'error', reason: 'PLAYER_BANNED' });
          }
          throw error;
        }
      }

      if (profile.email) {
        const existingByEmail = await prisma.player.findFirst({
          where: { email: profile.email },
          select: { id: true, emailVerified: true, discordId: true },
        });
        if (existingByEmail?.discordId && existingByEmail.discordId !== profile.id) {
          return appRedirect({ d: 'error', reason: 'DISCORD_EMAIL_IN_USE' });
        }
        if (existingByEmail && existingByEmail.emailVerified) {
          const firstLink = !existingByEmail.discordId;
          await prisma.player.update({
            where: { id: existingByEmail.id },
            data: { discordId: profile.id },
          });
          if (firstLink) {
            const { discordLinkPromptService } = await import('./discordLinkPromptService');
            await discordLinkPromptService.payLinkBonus(existingByEmail.id);
          }
          try {
            const session = await authService.issueSession(existingByEmail.id);
            if (!session.token) {
              return appRedirect({ d: 'error', reason: 'DISCORD_AUTH_FAILED' });
            }
            return appRedirect({ d: 'ok', token: session.token });
          } catch (error) {
            if (error instanceof Error && error.message === 'PLAYER_BANNED') {
              return appRedirect({ d: 'error', reason: 'PLAYER_BANNED' });
            }
            throw error;
          }
        }
        if (existingByEmail && !existingByEmail.emailVerified) {
          return appRedirect({ d: 'error', reason: 'DISCORD_EMAIL_IN_USE' });
        }
      }

      return appRedirect({
        d: 'pending',
        pending: signPending(profile),
        suggested: suggestUsername(profile.name ?? ''),
      });
    } catch (error) {
      console.error('[DiscordAuth] callback failed', error);
      return this.callbackErrorRedirect(state);
    }
  },

  async completeRegistration(input: {
    pendingToken: string;
    username: string;
    gender: 'male' | 'female';
    preferredLanguage?: string;
    acceptedTerms: boolean;
    referralCode?: string;
  }) {
    if (!input.acceptedTerms) {
      throw new Error('TERMS_REQUIRED');
    }
    let pending: PendingPayload;
    try {
      pending = verifyPending(input.pendingToken);
    } catch {
      throw new Error('DISCORD_PENDING_INVALID');
    }
    const username = (input.username ?? '').trim();
    if (username.length < 3 || username.length > 50) {
      throw new Error('USERNAME_INVALID');
    }
    if (input.gender !== 'male' && input.gender !== 'female') {
      throw new Error('GENDER_REQUIRED');
    }

    const alreadyLinked = await prisma.player.findUnique({
      where: { discordId: pending.discordId },
      select: { id: true },
    });
    if (alreadyLinked) {
      return authService.issueSession(alreadyLinked.id);
    }

    const taken = await prisma.player.findUnique({ where: { username } });
    if (taken) {
      throw new Error('USERNAME_TAKEN');
    }

    const randomPassword = crypto.randomBytes(24).toString('hex');
    const passwordHash = await bcrypt.hash(randomPassword, SALT_ROUNDS);
    const randomCountry = countries[Math.floor(Math.random() * countries.length)];
    const starterAvatar = input.gender === 'female' ? 'default_2' : 'default_1';
    const email = pending.email && /^\S+@\S+\.\S+$/.test(pending.email) ? pending.email : undefined;

    const player = await prisma.player.create({
      data: {
        username,
        passwordHash,
        preferredLanguage: normalizePlayerLanguage(input.preferredLanguage),
        currentCountry: randomCountry.id,
        gender: input.gender,
        avatar: starterAvatar,
        discordId: pending.discordId,
        ...(email
          ? {
              email,
              emailVerified: true,
            }
          : {}),
      },
    });

    try {
      const { playerStartService } = await import('./playerStartService');
      await playerStartService.grantStarterBundle(player.id);
    } catch (error) {
      console.error('[DiscordAuth] Failed to grant starter bundle:', error);
    }

    try {
      const { referralService } = await import('./referralService');
      await referralService.attachOnRegister(player.id, input.referralCode);
    } catch (error) {
      console.error('[DiscordAuth] Failed to attach referral:', error);
    }

    return authService.issueSession(player.id);
  },
};
