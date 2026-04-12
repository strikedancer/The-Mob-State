import { Router, Request, Response } from 'express';
import { authService } from '../services/authService';
import { emailService } from '../services/emailService';
import prisma from '../lib/prisma';
import bcrypt from 'bcrypt';

const router = Router();

router.post('/register', async (req: Request, res: Response) => {
  try {
    const { username, password, email, preferredLanguage } = req.body;

    const result = await authService.register({ username, password, email, preferredLanguage });

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
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
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
    console.error('[AUTH] Login error:', error);
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
      await emailService.sendPasswordResetEmail(email, player.username, resetToken);
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
