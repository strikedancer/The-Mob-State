import crypto from 'crypto';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import prisma from '../lib/prisma';
import config from '../config';
import countries from '../../content/countries.json';
import { normalizePlayerLanguage } from '../config/supportedLanguages';
import { authService } from './authService';

const GRAPH_VERSION = 'v21.0';
const SALT_ROUNDS = 10;

type FacebookProfile = {
  id: string;
  name?: string;
  email?: string;
};

const facebookAppId = () => (process.env.FACEBOOK_APP_ID ?? '').trim();
const facebookAppSecret = () => (process.env.FACEBOOK_APP_SECRET ?? '').trim();
const facebookPageId = () => (process.env.FACEBOOK_PAGE_ID ?? '').trim();
const facebookPageToken = () => (process.env.FACEBOOK_PAGE_ACCESS_TOKEN ?? '').trim();

export const facebookOAuthRedirectUri = (): string => {
  const explicit = (process.env.FACEBOOK_OAUTH_REDIRECT_URI ?? '').trim();
  if (explicit) return explicit;
  const apiBase = (config.apiBaseUrl || 'https://api.themobstate.com').replace(/\/+$/, '');
  return `${apiBase}/auth/facebook/callback`;
};

export const isFacebookLoginConfigured = (): boolean =>
  Boolean(facebookAppId() && facebookAppSecret());

export const isFacebookPageConfigured = (): boolean =>
  Boolean(facebookPageId() && facebookPageToken());

const suggestUsername = (name: string): string => {
  const cleaned = name.replace(/[^a-zA-Z0-9_]/g, '').slice(0, 16);
  return cleaned.length >= 3 ? cleaned : `player${crypto.randomInt(1000, 9999)}`;
};

const signState = (): string =>
  jwt.sign({ t: 'fb_oauth', n: crypto.randomBytes(8).toString('hex') }, config.jwtSecret, {
    expiresIn: '10m',
  });

const verifyState = (state: string): boolean => {
  try {
    const payload = jwt.verify(state, config.jwtSecret) as { t?: string };
    return payload.t === 'fb_oauth';
  } catch {
    return false;
  }
};

const signPending = (profile: FacebookProfile): string =>
  jwt.sign(
    {
      t: 'fb_pending',
      facebookId: profile.id,
      email: profile.email ?? '',
      name: profile.name ?? '',
    },
    config.jwtSecret,
    { expiresIn: '20m' },
  );

type PendingPayload = {
  t: string;
  facebookId: string;
  email: string;
  name: string;
};

const verifyPending = (token: string): PendingPayload => {
  const payload = jwt.verify(token, config.jwtSecret) as PendingPayload;
  if (payload.t !== 'fb_pending' || !payload.facebookId) {
    throw new Error('FACEBOOK_PENDING_INVALID');
  }
  return payload;
};

const appRedirect = (params: Record<string, string>): string => {
  const base = (config.appBaseUrl || 'https://themobstate.com').replace(/\/+$/, '');
  const query = new URLSearchParams(params);
  return `${base}/login?${query.toString()}`;
};

const graphGet = async (url: string): Promise<Record<string, unknown>> => {
  const response = await fetch(url);
  const data = (await response.json()) as Record<string, unknown>;
  if (!response.ok) {
    const error = data.error as { message?: string } | undefined;
    throw new Error(error?.message || 'FACEBOOK_GRAPH_ERROR');
  }
  return data;
};

export const facebookAuthService = {
  status() {
    return {
      loginEnabled: isFacebookLoginConfigured(),
      pageEnabled: isFacebookPageConfigured(),
    };
  },

  errorRedirect(reason = 'FACEBOOK_AUTH_FAILED'): string {
    return appRedirect({ fb: 'error', reason });
  },

  startUrl(): string {
    if (!isFacebookLoginConfigured()) {
      throw new Error('FACEBOOK_NOT_CONFIGURED');
    }
    const redirectUri = facebookOAuthRedirectUri();
    const url = new URL(`https://www.facebook.com/${GRAPH_VERSION}/dialog/oauth`);
    url.searchParams.set('client_id', facebookAppId());
    url.searchParams.set('redirect_uri', redirectUri);
    url.searchParams.set('state', signState());
    url.searchParams.set('scope', 'email,public_profile');
    url.searchParams.set('response_type', 'code');
    return url.toString();
  },

  async handleCallback(code: string | undefined, state: string | undefined): Promise<string> {
    if (!isFacebookLoginConfigured()) {
      return appRedirect({ fb: 'error', reason: 'FACEBOOK_NOT_CONFIGURED' });
    }
    if (!code || !state || !verifyState(state)) {
      return appRedirect({ fb: 'error', reason: 'FACEBOOK_AUTH_FAILED' });
    }

    try {
      const tokenUrl = new URL(`https://graph.facebook.com/${GRAPH_VERSION}/oauth/access_token`);
      tokenUrl.searchParams.set('client_id', facebookAppId());
      tokenUrl.searchParams.set('client_secret', facebookAppSecret());
      tokenUrl.searchParams.set('redirect_uri', facebookOAuthRedirectUri());
      tokenUrl.searchParams.set('code', code);
      const tokenData = await graphGet(tokenUrl.toString());
      const accessToken = String(tokenData.access_token ?? '');
      if (!accessToken) {
        return appRedirect({ fb: 'error', reason: 'FACEBOOK_AUTH_FAILED' });
      }

      const meUrl = new URL(`https://graph.facebook.com/${GRAPH_VERSION}/me`);
      meUrl.searchParams.set('fields', 'id,name,email');
      meUrl.searchParams.set('access_token', accessToken);
      const me = await graphGet(meUrl.toString());
      const profile: FacebookProfile = {
        id: String(me.id ?? ''),
        name: typeof me.name === 'string' ? me.name : undefined,
        email: typeof me.email === 'string' ? me.email : undefined,
      };
      if (!profile.id) {
        return appRedirect({ fb: 'error', reason: 'FACEBOOK_AUTH_FAILED' });
      }

      const existingByFacebook = await prisma.player.findUnique({
        where: { facebookId: profile.id },
        select: { id: true },
      });
      if (existingByFacebook) {
        try {
          const session = await authService.issueSession(existingByFacebook.id);
          if (!session.token) {
            return appRedirect({ fb: 'error', reason: 'FACEBOOK_AUTH_FAILED' });
          }
          return appRedirect({ fb: 'ok', token: session.token });
        } catch (error) {
          if (error instanceof Error && error.message === 'PLAYER_BANNED') {
            return appRedirect({ fb: 'error', reason: 'PLAYER_BANNED' });
          }
          throw error;
        }
      }

      if (profile.email) {
        const existingByEmail = await prisma.player.findFirst({
          where: { email: profile.email },
          select: { id: true, emailVerified: true, facebookId: true },
        });
        if (existingByEmail?.facebookId && existingByEmail.facebookId !== profile.id) {
          return appRedirect({ fb: 'error', reason: 'FACEBOOK_EMAIL_IN_USE' });
        }
        if (existingByEmail && existingByEmail.emailVerified) {
          await prisma.player.update({
            where: { id: existingByEmail.id },
            data: { facebookId: profile.id },
          });
          try {
            const session = await authService.issueSession(existingByEmail.id);
            if (!session.token) {
              return appRedirect({ fb: 'error', reason: 'FACEBOOK_AUTH_FAILED' });
            }
            return appRedirect({ fb: 'ok', token: session.token });
          } catch (error) {
            if (error instanceof Error && error.message === 'PLAYER_BANNED') {
              return appRedirect({ fb: 'error', reason: 'PLAYER_BANNED' });
            }
            throw error;
          }
        }
        if (existingByEmail && !existingByEmail.emailVerified) {
          return appRedirect({ fb: 'error', reason: 'FACEBOOK_EMAIL_IN_USE' });
        }
      }

      return appRedirect({
        fb: 'pending',
        pending: signPending(profile),
        suggested: suggestUsername(profile.name ?? ''),
      });
    } catch (error) {
      console.error('[FacebookAuth] callback failed', error);
      return appRedirect({ fb: 'error', reason: 'FACEBOOK_AUTH_FAILED' });
    }
  },

  async completeRegistration(input: {
    pendingToken: string;
    username: string;
    gender: 'male' | 'female';
    preferredLanguage?: string;
    acceptedTerms: boolean;
  }) {
    if (!input.acceptedTerms) {
      throw new Error('TERMS_REQUIRED');
    }
    let pending: PendingPayload;
    try {
      pending = verifyPending(input.pendingToken);
    } catch {
      throw new Error('FACEBOOK_PENDING_INVALID');
    }
    const username = (input.username ?? '').trim();
    if (username.length < 3 || username.length > 50) {
      throw new Error('USERNAME_INVALID');
    }
    if (input.gender !== 'male' && input.gender !== 'female') {
      throw new Error('GENDER_REQUIRED');
    }

    const alreadyLinked = await prisma.player.findUnique({
      where: { facebookId: pending.facebookId },
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
        facebookId: pending.facebookId,
        ...(email
          ? {
              email,
              emailVerified: true,
            }
          : {}),
      },
    });

    return authService.issueSession(player.id);
  },

  async publishPagePost(input: { message: string; link?: string }) {
    if (!isFacebookPageConfigured()) {
      throw new Error('FACEBOOK_PAGE_NOT_CONFIGURED');
    }
    const message = input.message.trim();
    if (message.length < 1 || message.length > 5000) {
      throw new Error('FACEBOOK_MESSAGE_INVALID');
    }
    const body = new URLSearchParams();
    body.set('message', message);
    body.set('access_token', facebookPageToken());
    const link = (input.link ?? '').trim();
    if (link) {
      if (!/^https?:\/\//i.test(link)) {
        throw new Error('FACEBOOK_MESSAGE_INVALID');
      }
      body.set('link', link);
    }

    const response = await fetch(
      `https://graph.facebook.com/${GRAPH_VERSION}/${facebookPageId()}/feed`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body,
      },
    );
    const data = (await response.json()) as { id?: string; error?: { message?: string } };
    if (!response.ok) {
      throw new Error(data.error?.message || 'FACEBOOK_PUBLISH_FAILED');
    }
    return { postId: data.id ?? null };
  },
};
