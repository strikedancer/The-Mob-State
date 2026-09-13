import crypto from 'crypto';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import prisma from '../lib/prisma';
import config from '../config';
import countries from '../../content/countries.json';
import { normalizePlayerLanguage } from '../config/supportedLanguages';
import { authService } from './authService';

const SALT_ROUNDS = 10;

type GoogleProfile = {
  id: string;
  name?: string;
  email?: string;
};

const googleClientId = () => (process.env.GOOGLE_CLIENT_ID ?? '').trim();
const googleClientSecret = () => (process.env.GOOGLE_CLIENT_SECRET ?? '').trim();

export const googleOAuthRedirectUri = (): string => {
  const explicit = (process.env.GOOGLE_OAUTH_REDIRECT_URI ?? '').trim();
  if (explicit) return explicit;
  const apiBase = (config.apiBaseUrl || 'https://api.themobstate.com').replace(/\/+$/, '');
  return `${apiBase}/auth/google/callback`;
};

export const isGoogleLoginConfigured = (): boolean =>
  Boolean(googleClientId() && googleClientSecret());

const suggestUsername = (name: string): string => {
  const cleaned = name.replace(/[^a-zA-Z0-9_]/g, '').slice(0, 16);
  return cleaned.length >= 3 ? cleaned : `player${crypto.randomInt(1000, 9999)}`;
};

const signState = (): string =>
  jwt.sign({ t: 'google_oauth', n: crypto.randomBytes(8).toString('hex') }, config.jwtSecret, {
    expiresIn: '10m',
  });

const verifyState = (state: string): boolean => {
  try {
    const payload = jwt.verify(state, config.jwtSecret) as { t?: string };
    return payload.t === 'google_oauth';
  } catch {
    return false;
  }
};

const signPending = (profile: GoogleProfile): string =>
  jwt.sign(
    {
      t: 'google_pending',
      googleId: profile.id,
      email: profile.email ?? '',
      name: profile.name ?? '',
    },
    config.jwtSecret,
    { expiresIn: '20m' },
  );

type PendingPayload = {
  t: string;
  googleId: string;
  email: string;
  name: string;
};

const verifyPending = (token: string): PendingPayload => {
  const payload = jwt.verify(token, config.jwtSecret) as PendingPayload;
  if (payload.t !== 'google_pending' || !payload.googleId) {
    throw new Error('GOOGLE_PENDING_INVALID');
  }
  return payload;
};

const appRedirect = (params: Record<string, string>): string => {
  const base = (config.appBaseUrl || 'https://themobstate.com').replace(/\/+$/, '');
  const query = new URLSearchParams(params);
  return `${base}/login?${query.toString()}`;
};

const readJson = async (response: Response): Promise<Record<string, unknown>> => {
  const data = (await response.json()) as Record<string, unknown>;
  if (!response.ok) {
    const error = data.error as string | { message?: string } | undefined;
    const message =
      typeof error === 'string'
        ? error
        : error?.message || (typeof data.error_description === 'string' ? data.error_description : '');
    throw new Error(message || 'GOOGLE_OAUTH_ERROR');
  }
  return data;
};

export const googleAuthService = {
  status() {
    return {
      loginEnabled: isGoogleLoginConfigured(),
    };
  },

  errorRedirect(reason = 'GOOGLE_AUTH_FAILED'): string {
    return appRedirect({ g: 'error', reason });
  },

  startUrl(): string {
    if (!isGoogleLoginConfigured()) {
      throw new Error('GOOGLE_NOT_CONFIGURED');
    }
    const url = new URL('https://accounts.google.com/o/oauth2/v2/auth');
    url.searchParams.set('client_id', googleClientId());
    url.searchParams.set('redirect_uri', googleOAuthRedirectUri());
    url.searchParams.set('response_type', 'code');
    url.searchParams.set('scope', 'openid email profile');
    url.searchParams.set('state', signState());
    url.searchParams.set('access_type', 'online');
    url.searchParams.set('prompt', 'select_account');
    url.searchParams.set('include_granted_scopes', 'true');
    return url.toString();
  },

  async handleCallback(code: string | undefined, state: string | undefined): Promise<string> {
    if (!isGoogleLoginConfigured()) {
      return appRedirect({ g: 'error', reason: 'GOOGLE_NOT_CONFIGURED' });
    }
    if (!code || !state || !verifyState(state)) {
      return appRedirect({ g: 'error', reason: 'GOOGLE_AUTH_FAILED' });
    }

    try {
      const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
          code,
          client_id: googleClientId(),
          client_secret: googleClientSecret(),
          redirect_uri: googleOAuthRedirectUri(),
          grant_type: 'authorization_code',
        }),
      });
      const tokenData = await readJson(tokenResponse);
      const accessToken = String(tokenData.access_token ?? '');
      if (!accessToken) {
        return appRedirect({ g: 'error', reason: 'GOOGLE_AUTH_FAILED' });
      }

      const userResponse = await fetch('https://openidconnect.googleapis.com/v1/userinfo', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const me = await readJson(userResponse);
      const emailVerified = me.email_verified === true || me.email_verified === 'true';
      const email = typeof me.email === 'string' && emailVerified ? me.email : undefined;
      const profile: GoogleProfile = {
        id: String(me.sub ?? ''),
        name: typeof me.name === 'string' ? me.name : undefined,
        email,
      };
      if (!profile.id) {
        return appRedirect({ g: 'error', reason: 'GOOGLE_AUTH_FAILED' });
      }

      const existingByGoogle = await prisma.player.findUnique({
        where: { googleId: profile.id },
        select: { id: true },
      });
      if (existingByGoogle) {
        try {
          const session = await authService.issueSession(existingByGoogle.id);
          if (!session.token) {
            return appRedirect({ g: 'error', reason: 'GOOGLE_AUTH_FAILED' });
          }
          return appRedirect({ g: 'ok', token: session.token });
        } catch (error) {
          if (error instanceof Error && error.message === 'PLAYER_BANNED') {
            return appRedirect({ g: 'error', reason: 'PLAYER_BANNED' });
          }
          throw error;
        }
      }

      if (profile.email) {
        const existingByEmail = await prisma.player.findFirst({
          where: { email: profile.email },
          select: { id: true, emailVerified: true, googleId: true },
        });
        if (existingByEmail?.googleId && existingByEmail.googleId !== profile.id) {
          return appRedirect({ g: 'error', reason: 'GOOGLE_EMAIL_IN_USE' });
        }
        if (existingByEmail && existingByEmail.emailVerified) {
          await prisma.player.update({
            where: { id: existingByEmail.id },
            data: { googleId: profile.id },
          });
          try {
            const session = await authService.issueSession(existingByEmail.id);
            if (!session.token) {
              return appRedirect({ g: 'error', reason: 'GOOGLE_AUTH_FAILED' });
            }
            return appRedirect({ g: 'ok', token: session.token });
          } catch (error) {
            if (error instanceof Error && error.message === 'PLAYER_BANNED') {
              return appRedirect({ g: 'error', reason: 'PLAYER_BANNED' });
            }
            throw error;
          }
        }
        if (existingByEmail && !existingByEmail.emailVerified) {
          return appRedirect({ g: 'error', reason: 'GOOGLE_EMAIL_IN_USE' });
        }
      }

      return appRedirect({
        g: 'pending',
        pending: signPending(profile),
        suggested: suggestUsername(profile.name ?? ''),
      });
    } catch (error) {
      console.error('[GoogleAuth] callback failed', error);
      return appRedirect({ g: 'error', reason: 'GOOGLE_AUTH_FAILED' });
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
      throw new Error('GOOGLE_PENDING_INVALID');
    }
    const username = (input.username ?? '').trim();
    if (username.length < 3 || username.length > 50) {
      throw new Error('USERNAME_INVALID');
    }
    if (input.gender !== 'male' && input.gender !== 'female') {
      throw new Error('GENDER_REQUIRED');
    }

    const alreadyLinked = await prisma.player.findUnique({
      where: { googleId: pending.googleId },
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
        googleId: pending.googleId,
        ...(email
          ? {
              email,
              emailVerified: true,
            }
          : {}),
      },
    });

    try {
      const { referralService } = await import('./referralService');
      await referralService.attachOnRegister(player.id, input.referralCode);
    } catch (error) {
      console.error('[GoogleAuth] Failed to attach referral:', error);
    }

    return authService.issueSession(player.id);
  },
};
