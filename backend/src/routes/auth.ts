import { Router, Request, Response } from 'express';
import { authService } from '../services/authService';
import { facebookAuthService } from '../services/facebookAuthService';
import { googleAuthService } from '../services/googleAuthService';
import { discordAuthService } from '../services/discordAuthService';
import { emailService } from '../services/emailService';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import prisma from '../lib/prisma';
import bcrypt from 'bcrypt';
import { normalizePlayerLanguage } from '../config/supportedLanguages';

const router = Router();

router.get('/facebook/status', (_req: Request, res: Response) => {
  return res.json({
    event: 'auth.facebook.status',
    params: facebookAuthService.status(),
  });
});

router.get('/facebook/start', (_req: Request, res: Response) => {
  try {
    return res.redirect(facebookAuthService.startUrl());
  } catch (error) {
    console.error('[AUTH] Facebook start error:', error);
    return res.redirect(facebookAuthService.errorRedirect('FACEBOOK_NOT_CONFIGURED'));
  }
});

router.get('/facebook/callback', async (req: Request, res: Response) => {
  try {
    if (typeof req.query.error === 'string' && req.query.error) {
      return res.redirect(facebookAuthService.errorRedirect('FACEBOOK_AUTH_FAILED'));
    }
    const code = typeof req.query.code === 'string' ? req.query.code : undefined;
    const state = typeof req.query.state === 'string' ? req.query.state : undefined;
    return res.redirect(await facebookAuthService.handleCallback(code, state));
  } catch (error) {
    console.error('[AUTH] Facebook callback error:', error);
    return res.redirect(facebookAuthService.errorRedirect('FACEBOOK_AUTH_FAILED'));
  }
});

router.get('/google/status', (_req: Request, res: Response) => {
  return res.json({
    event: 'auth.google.status',
    params: googleAuthService.status(),
  });
});

router.get('/google/start', (_req: Request, res: Response) => {
  try {
    return res.redirect(googleAuthService.startUrl());
  } catch (error) {
    console.error('[AUTH] Google start error:', error);
    return res.redirect(googleAuthService.errorRedirect('GOOGLE_NOT_CONFIGURED'));
  }
});

router.get('/google/callback', async (req: Request, res: Response) => {
  try {
    if (typeof req.query.error === 'string' && req.query.error) {
      return res.redirect(googleAuthService.errorRedirect('GOOGLE_AUTH_FAILED'));
    }
    const code = typeof req.query.code === 'string' ? req.query.code : undefined;
    const state = typeof req.query.state === 'string' ? req.query.state : undefined;
    return res.redirect(await googleAuthService.handleCallback(code, state));
  } catch (error) {
    console.error('[AUTH] Google callback error:', error);
    return res.redirect(googleAuthService.errorRedirect('GOOGLE_AUTH_FAILED'));
  }
});

router.post('/google/complete', async (req: Request, res: Response) => {
  try {
    const { pendingToken, username, gender, preferredLanguage, acceptedTerms } = req.body ?? {};
    const result = await googleAuthService.completeRegistration({
      pendingToken: String(pendingToken ?? ''),
      username: String(username ?? ''),
      gender,
      preferredLanguage,
      acceptedTerms: Boolean(acceptedTerms),
      referralCode: req.body?.referralCode,
    });

    return res.status(201).json({
      event: 'auth.registered',
      params: {},
      token: result.token,
      player: result.player,
    });
  } catch (error) {
    console.error('[AUTH] Google complete error:', error);
    if (error instanceof Error) {
      const reason = error.message;
      if (
        reason === 'TERMS_REQUIRED' ||
        reason === 'USERNAME_INVALID' ||
        reason === 'USERNAME_TAKEN' ||
        reason === 'GENDER_REQUIRED' ||
        reason === 'GOOGLE_PENDING_INVALID' ||
        reason === 'PLAYER_BANNED'
      ) {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason },
        });
      }
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/discord/status', (_req: Request, res: Response) => {
  return res.json({
    event: 'auth.discord.status',
    params: discordAuthService.status(),
  });
});

router.get('/discord/start', (_req: Request, res: Response) => {
  try {
    return res.redirect(discordAuthService.startUrl());
  } catch (error) {
    console.error('[AUTH] Discord start error:', error);
    return res.redirect(discordAuthService.errorRedirect('DISCORD_NOT_CONFIGURED'));
  }
});

router.get('/discord/callback', async (req: Request, res: Response) => {
  try {
    const state = typeof req.query.state === 'string' ? req.query.state : undefined;
    if (typeof req.query.error === 'string' && req.query.error) {
      return res.redirect(discordAuthService.callbackErrorRedirect(state));
    }
    const code = typeof req.query.code === 'string' ? req.query.code : undefined;
    return res.redirect(await discordAuthService.handleCallback(code, state));
  } catch (error) {
    console.error('[AUTH] Discord callback error:', error);
    const state = typeof req.query.state === 'string' ? req.query.state : undefined;
    return res.redirect(discordAuthService.callbackErrorRedirect(state));
  }
});

router.get('/discord/link/start', authenticate, (req: AuthRequest, res: Response) => {
  try {
    const url = discordAuthService.linkStartUrl(req.player!.id);
    return res.json({
      event: 'auth.discord.link.start',
      params: { url },
    });
  } catch (error) {
    console.error('[AUTH] Discord link start error:', error);
    return res.status(400).json({
      event: 'auth.error',
      params: { reason: 'DISCORD_NOT_CONFIGURED' },
    });
  }
});

router.delete('/discord/link', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    await discordAuthService.unlink(req.player!.id);
    return res.json({
      event: 'auth.discord.unlinked',
      params: {},
    });
  } catch (error) {
    const reason = error instanceof Error ? error.message : 'DISCORD_AUTH_FAILED';
    const status = reason === 'DISCORD_NOT_LINKED' || reason === 'DISCORD_UNLINK_BLOCKED' ? 400 : 500;
    return res.status(status).json({
      event: 'auth.error',
      params: { reason },
    });
  }
});

router.post('/discord/complete', async (req: Request, res: Response) => {
  try {
    const { pendingToken, username, gender, preferredLanguage, acceptedTerms } = req.body ?? {};
    const result = await discordAuthService.completeRegistration({
      pendingToken: String(pendingToken ?? ''),
      username: String(username ?? ''),
      gender,
      preferredLanguage,
      acceptedTerms: Boolean(acceptedTerms),
      referralCode: req.body?.referralCode,
    });

    return res.status(201).json({
      event: 'auth.registered',
      params: {},
      token: result.token,
      player: result.player,
    });
  } catch (error) {
    console.error('[AUTH] Discord complete error:', error);
    if (error instanceof Error) {
      const reason = error.message;
      if (
        reason === 'TERMS_REQUIRED' ||
        reason === 'USERNAME_INVALID' ||
        reason === 'USERNAME_TAKEN' ||
        reason === 'GENDER_REQUIRED' ||
        reason === 'DISCORD_PENDING_INVALID' ||
        reason === 'PLAYER_BANNED'
      ) {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason },
        });
      }
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/facebook/complete', async (req: Request, res: Response) => {
  try {
    const { pendingToken, username, gender, preferredLanguage, acceptedTerms } = req.body ?? {};
    const result = await facebookAuthService.completeRegistration({
      pendingToken: String(pendingToken ?? ''),
      username: String(username ?? ''),
      gender,
      preferredLanguage,
      acceptedTerms: Boolean(acceptedTerms),
      referralCode: req.body?.referralCode,
    });

    return res.status(201).json({
      event: 'auth.registered',
      params: {},
      token: result.token,
      player: result.player,
    });
  } catch (error) {
    console.error('[AUTH] Facebook complete error:', error);
    if (error instanceof Error) {
      const reason = error.message;
      if (
        reason === 'TERMS_REQUIRED' ||
        reason === 'USERNAME_INVALID' ||
        reason === 'USERNAME_TAKEN' ||
        reason === 'GENDER_REQUIRED' ||
        reason === 'FACEBOOK_PENDING_INVALID' ||
        reason === 'PLAYER_BANNED'
      ) {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason },
        });
      }
    }
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/register', async (req: Request, res: Response) => {
  try {
    const { username, password, email, preferredLanguage, gender, referralCode } = req.body;

    const result = await authService.register({
      username,
      password,
      email,
      preferredLanguage,
      gender,
      referralCode,
    });

    if (result.requiresEmailVerification) {
      return res.status(201).json({
        event: 'auth.registration_pending_verification',
        params: { reason: 'EMAIL_VERIFICATION_REQUIRED' },
        requiresEmailVerification: true,
        message: result.message,
      });
    }

    return res.status(201).json({
      event: 'auth.registered',
      params: {},
      token: result.token,
      player: result.player,
    });
  } catch (error) {
    console.error('[AUTH] Register error:', error);

    if (error instanceof Error) {
      if (error.message === 'USERNAME_TAKEN') {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason: 'USERNAME_TAKEN' },
        });
      }

      if (error.message === 'USERNAME_INVALID') {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason: 'USERNAME_INVALID' },
        });
      }

      if (error.message === 'PASSWORD_TOO_SHORT') {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason: 'PASSWORD_TOO_SHORT' },
        });
      }

      if (error.message === 'EMAIL_INVALID') {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason: 'EMAIL_INVALID' },
        });
      }

      if (error.message === 'GENDER_REQUIRED') {
        return res.status(400).json({
          event: 'auth.error',
          params: { reason: 'GENDER_REQUIRED' },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/resend-verification', async (req: Request, res: Response) => {
  try {
    const { username, password } = req.body ?? {};
    const result = await authService.resendVerificationEmail(
      String(username ?? ''),
      String(password ?? ''),
    );
    return res.status(200).json({
      event: 'auth.verification_resent',
      params: { status: result },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'INVALID_CREDENTIALS') {
        return res.status(401).json({
          event: 'auth.error',
          params: { reason: 'INVALID_CREDENTIALS' },
        });
      }
      if (error.message === 'VERIFICATION_RESEND_COOLDOWN') {
        return res.status(429).json({
          event: 'auth.error',
          params: { reason: 'VERIFICATION_RESEND_COOLDOWN' },
        });
      }
    }
    console.error('[AUTH] Resend verification error:', error);
    return res.status(503).json({
      event: 'auth.error',
      params: { reason: 'EMAIL_SEND_FAILED' },
    });
  }
});

router.post('/login', async (req: Request, res: Response) => {
  try {
    const { username, password } = req.body;
    console.log('[AUTH] Login attempt for:', username);

    const result = await authService.login({ username, password });
    console.log('[AUTH] Login successful for:', username);

    return res.status(200).json({
      event: 'auth.login',
      params: {},
      token: result.token,
      player: result.player,
    });
  } catch (error) {
    const loginReason = error instanceof Error ? error.message : '';
    if (
      loginReason === 'INVALID_CREDENTIALS' ||
      loginReason === 'EMAIL_NOT_VERIFIED' ||
      loginReason === 'PLAYER_BANNED'
    ) {
      console.log('[AUTH] Login rejected:', loginReason);
    } else {
      console.error('[AUTH] Login error:', error);
    }
    if (error instanceof Error) {
      if (error.message === 'INVALID_CREDENTIALS') {
        return res.status(401).json({
          event: 'auth.error',
          params: { reason: 'INVALID_CREDENTIALS' },
        });
      }

      if (error.message === 'EMAIL_NOT_VERIFIED') {
        return res.status(403).json({
          event: 'auth.error',
          params: { reason: 'EMAIL_NOT_VERIFIED' },
        });
      }

      if (error.message === 'PLAYER_BANNED') {
        const banError = error as any;
        return res.status(403).json({
          event: 'auth.banned',
          params: {
            reason: banError.banReason || 'You have been banned',
            bannedUntil: banError.bannedUntil,
            isPermanent: !banError.bannedUntil,
          },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/request-password-reset', async (req: Request, res: Response) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({
        event: 'auth.error',
        params: { reason: 'EMAIL_REQUIRED' },
      });
    }

    // Find player by email
    const player = await prisma.player.findFirst({
      where: { email },
      select: { id: true, username: true, preferredLanguage: true },
    });

    // Always return success to prevent email enumeration
    if (!player) {
      return res.status(200).json({
        event: 'auth.password_reset_requested',
        params: { email },
      });
    }

    // Generate reset token
    const resetToken = emailService.generateToken();
    const resetTokenExpiry = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

    // Save token to database
    await prisma.player.update({
      where: { id: player.id },
      data: {
        resetPasswordToken: resetToken,
        resetPasswordTokenExpiry: resetTokenExpiry,
      },
    });

    // Send password reset email
    try {
      await emailService.sendPasswordResetEmail(
        email,
        player.username,
        resetToken,
        normalizePlayerLanguage(player.preferredLanguage),
      );
      console.log(`[Auth] Password reset email sent to ${email}`);
    } catch (error) {
      console.error('[Auth] Failed to send password reset email:', error);
    }
    
    return res.status(200).json({
      event: 'auth.password_reset_requested',
      params: { email },
    });
  } catch (error) {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/verify-email', async (req: Request, res: Response) => {
  try {
    const { token } = req.query;

    if (!token || typeof token !== 'string') {
      return res.status(400).send(`
        <!DOCTYPE html>
        <html>
        <head><title>Invalid Token - The Mob State</title></head>
        <body style="font-family: Arial; background-color: #1a1a1a; color: #cccccc; text-align: center; padding: 50px;">
          <h1 style="color: #D4A574;">❌ Invalid Verification Link</h1>
          <p>The verification link is invalid or malformed.</p>
        </body>
        </html>
      `);
    }

    // Find player with this token
    const player = await prisma.player.findFirst({
      where: {
        verificationToken: token,
        verificationTokenExpiry: {
          gte: new Date(), // Token not expired
        },
      },
    });

    if (!player) {
      return res.status(400).send(`
        <!DOCTYPE html>
        <html>
        <head><title>Expired Token - The Mob State</title></head>
        <body style="font-family: Arial; background-color: #1a1a1a; color: #cccccc; text-align: center; padding: 50px;">
          <h1 style="color: #D4A574;">⏰ Verification Link Expired</h1>
          <p>This verification link has expired or is invalid.</p>
          <p>Please register again or request a new verification email.</p>
        </body>
        </html>
      `);
    }

    // Verify email
    await prisma.player.update({
      where: { id: player.id },
      data: {
        emailVerified: true,
        verificationToken: null,
        verificationTokenExpiry: null,
      },
    });

    return res.status(200).send(`
      <!DOCTYPE html>
      <html>
      <head><title>Email Verified - The Mob State</title></head>
      <body style="font-family: Arial; background-color: #1a1a1a; color: #cccccc; text-align: center; padding: 50px;">
        <div style="max-width: 600px; margin: 0 auto; background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); border: 2px solid #D4A574; border-radius: 10px; padding: 40px;">
          <h1 style="color: #D4A574; margin-bottom: 20px;">✅ Email Verified!</h1>
          <p style="font-size: 18px; margin-bottom: 30px;">Welcome to <strong style="color: #D4A574;">The Mob State</strong>, ${player.username}!</p>
          <p>Your email has been successfully verified. You can now close this window and return to the game.</p>
          <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #333333;">
            <p style="color: #666666; font-size: 12px;">© 2026 The Mob State. All rights reserved.</p>
          </div>
        </div>
      </body>
      </html>
    `);
  } catch (error) {
    console.error('[Auth] Email verification error:', error);
    return res.status(500).send(`
      <!DOCTYPE html>
      <html>
      <head><title>Error - The Mob State</title></head>
      <body style="font-family: Arial; background-color: #1a1a1a; color: #cccccc; text-align: center; padding: 50px;">
        <h1 style="color: #D4A574;">⚠️ Verification Error</h1>
        <p>An error occurred during verification. Please try again later.</p>
      </body>
      </html>
    `);
  }
});

router.post('/reset-password', async (req: Request, res: Response) => {
  try {
    const { token, newPassword } = req.body;

    if (!token || !newPassword) {
      return res.status(400).json({
        event: 'auth.error',
        params: { reason: 'MISSING_FIELDS' },
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        event: 'auth.error',
        params: { reason: 'PASSWORD_TOO_SHORT' },
      });
    }

    // Find player with valid reset token
    const player = await prisma.player.findFirst({
      where: {
        resetPasswordToken: token,
        resetPasswordTokenExpiry: {
          gte: new Date(), // Token not expired
        },
      },
    });

    if (!player) {
      return res.status(400).json({
        event: 'auth.error',
        params: { reason: 'INVALID_OR_EXPIRED_TOKEN' },
      });
    }

    // Hash new password
    const passwordHash = await bcrypt.hash(newPassword, 10);

    // Update password and clear reset token
    await prisma.player.update({
      where: { id: player.id },
      data: {
        passwordHash,
        resetPasswordToken: null,
        resetPasswordTokenExpiry: null,
      },
    });

    return res.status(200).json({
      event: 'auth.password_reset_success',
      params: {},
    });
  } catch (error) {
    console.error('[Auth] Password reset error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
