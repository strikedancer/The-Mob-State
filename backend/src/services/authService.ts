import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import prisma from '../lib/prisma';
import config from '../config';
import { getRankFromXP } from '../config';
import { emailService } from './emailService';
import countries from '../../content/countries.json';

const SALT_ROUNDS = 10;

interface RegisterInput {
  username: string;
  password: string;
  email?: string;
  preferredLanguage?: string;
}

interface LoginInput {
  username: string;
  password: string;
}

interface AuthResponse {
  token?: string;
  player?: {
    id: number;
    username: string;
    money: number;
    health: number;
    rank: number;
    xp: number;
    currentCountry: string;
    preferredLanguage: string;
  };
  requiresEmailVerification?: boolean;
  message?: string;
}

export const authService = {
  async register(input: RegisterInput): Promise<AuthResponse> {
    const { username, password, email, preferredLanguage } = input;

    // Validation
    if (!username || username.length < 3 || username.length > 50) {
      throw new Error('USERNAME_INVALID');
    }

    if (!password || password.length < 6) {
      throw new Error('PASSWORD_TOO_SHORT');
    }

    // Validate and normalize language (only 'en' or 'nl' allowed)
    const normalizedLanguage = preferredLanguage === 'nl' ? 'nl' : 'en';
    console.log(`[AuthService] Registration - received language: ${preferredLanguage}, normalized: ${normalizedLanguage}`);

    // Check if username already exists
    const existingPlayer = await prisma.player.findUnique({
      where: { username },
    });

    if (existingPlayer) {
      throw new Error('USERNAME_TAKEN');
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);

    // Select random starting country
    const randomCountry = countries[Math.floor(Math.random() * countries.length)];
    console.log(`[AuthService] New player ${username} starting in ${randomCountry.name}`);

    // Generate verification token if email provided
    let verificationToken: string | undefined;
    let verificationTokenExpiry: Date | undefined;
    
    if (email) {
      verificationToken = emailService.generateToken();
      verificationTokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
    }

    // Create player with optional email and verification token
    const player = await prisma.player.create({
      data: {
        username,
        passwordHash,
        preferredLanguage: normalizedLanguage,
        currentCountry: randomCountry.id,
        ...(email && { 
          email,
          verificationToken,
          verificationTokenExpiry,
        }),
      },
    });

    // Send verification email if email provided
    if (email && verificationToken) {
      try {
        await emailService.sendVerificationEmail(email, username, verificationToken);
        console.log(`[AuthService] Verification email sent to ${email}`);
      } catch (error) {
        console.error('[AuthService] Failed to send verification email:', error);
        // Don't fail registration if email sending fails
      }
    }

    if (email) {
      return {
        requiresEmailVerification: true,
        message: 'VERIFICATION_EMAIL_SENT',
      };
    }

    // Generate JWT token
    const token = jwt.sign({ playerId: player.id, username: player.username }, config.jwtSecret, {
      expiresIn: '7d',
    });

    await prisma.worldEvent.create({
      data: {
        eventKey: 'auth.session.login',
        playerId: player.id,
        params: {
          username: player.username,
        },
      },
    });

    return {
      token,
      player: {
        id: player.id,
        username: player.username,
        money: player.money,
        health: player.health,
        rank: player.rank,
        xp: player.xp,
        currentCountry: player.currentCountry,
        preferredLanguage: player.preferredLanguage,
      },
    };
  },

  async login(input: LoginInput): Promise<AuthResponse> {
    const { username, password } = input;

    // Find player
    const player = await prisma.player.findUnique({
      where: { username },
    });

    if (!player) {
      throw new Error('INVALID_CREDENTIALS');
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, player.passwordHash);

    if (!isValidPassword) {
      throw new Error('INVALID_CREDENTIALS');
    }

    if (player.email && !player.emailVerified) {
      throw new Error('EMAIL_NOT_VERIFIED');
    }

    // Check if player is banned
    if (player.isBanned) {
      // Check if temporary ban has expired
      if (player.bannedUntil && new Date() > player.bannedUntil) {
        // Ban expired, automatically unban
        await prisma.player.update({
          where: { id: player.id },
          data: { isBanned: false, bannedUntil: null, banReason: null },
        });
      } else {
        // Player is still banned
        const banError = new Error('PLAYER_BANNED') as any;
        banError.banReason = player.banReason;
        banError.bannedUntil = player.bannedUntil;
        throw banError;
      }
    }

    const correctedRank = getRankFromXP(player.xp);
    if (correctedRank !== player.rank) {
      await prisma.player.update({
        where: { id: player.id },
        data: { rank: correctedRank },
      });
    }

    // Generate JWT token
    const token = jwt.sign({ playerId: player.id, username: player.username }, config.jwtSecret, {
      expiresIn: '7d',
    });

    return {
      token,
      player: {
        id: player.id,
        username: player.username,
        money: player.money,
        health: player.health,
        rank: correctedRank,
        xp: player.xp,
        currentCountry: player.currentCountry,
        preferredLanguage: player.preferredLanguage,
      },
    };
  },
};
