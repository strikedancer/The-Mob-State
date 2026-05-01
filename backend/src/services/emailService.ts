import nodemailer from 'nodemailer';
import crypto from 'crypto';
import { translationService, type Language } from './translationService';
import { normalizePlayerLanguage } from '../config/supportedLanguages';
import config from '../config';

const normalizeBaseUrl = (url: string) => url.replace(/\/+$/, '');
const appBaseUrl = normalizeBaseUrl(config.appBaseUrl);
const apiBaseUrl = normalizeBaseUrl(config.apiBaseUrl);

// SMTP Configuration
const transporter = nodemailer.createTransport({
  host: 'themobstate.com',
  port: 465,
  secure: true, // SSL
  auth: {
    user: 'noreply@themobstate.com',
    pass: 'Noreply@841215',
  },
  tls: {
    rejectUnauthorized: false, // Accept self-signed certificates
  },
  pool: true, // Use pooled connections
  maxConnections: 5,
  debug: false, // Disable debug output
  logger: false, // Disable logging
});

function buildCrewEmailHtml(params: {
  title: string;
  greeting: string;
  body: string;
  buttonText: string;
  settingsNote: string;
  footer: string;
  automatedMessage: string;
}) {
  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${params.title} - The Mob State</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Arial', sans-serif; background-color: #1a1a1a;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #1a1a1a; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); border: 2px solid #D4A574; border-radius: 10px; overflow: hidden;">
          <tr>
            <td style="background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); padding: 30px; text-align: center;">
              <h1 style="margin: 0; color: #000000; font-size: 32px; font-weight: bold; letter-spacing: 2px; text-shadow: 1px 1px 2px rgba(0,0,0,0.3);">
                THE MOB STATE
              </h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #D4A574; margin: 0 0 20px 0; font-size: 24px; text-align: center;">
                ${params.title}
              </h2>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                ${params.greeting}
              </p>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;">
                ${params.body}
              </p>
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 20px 0;">
                    <a href="${appBaseUrl}" style="display: inline-block; background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); color: #000000; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-weight: bold; font-size: 18px; letter-spacing: 1.5px; box-shadow: 0 4px 8px rgba(212, 165, 116, 0.3);">
                      ${params.buttonText}
                    </a>
                  </td>
                </tr>
              </table>
              <p style="color: #999999; font-size: 13px; line-height: 1.6; margin: 30px 0 0 0; border-top: 1px solid #333333; padding-top: 20px;">
                ${params.settingsNote}
              </p>
            </td>
          </tr>
          <tr>
            <td style="background-color: #0d0d0d; padding: 20px; text-align: center;">
              <p style="color: #666666; font-size: 12px; margin: 0;">
                ${params.footer}
              </p>
              <p style="color: #666666; font-size: 12px; margin: 10px 0 0 0;">
                ${params.automatedMessage}
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

// Verify SMTP connection (but don't fail if it's not available)
transporter.verify((error) => {
  if (error) {
    console.warn('[EmailService] ⚠️  SMTP server not reachable (emails will fail):', error.message);
  } else {
    console.log('[EmailService] ✅ SMTP server ready to send emails');
  }
});

export const emailService = {
  /**
   * Generate a random verification token
   */
  generateToken(): string {
    return crypto.randomBytes(32).toString('hex');
  },

  /**
   * Send email verification link (copy follows player preferredLanguage: nl, en, de, fr, es, it, pl, pt).
   */
  async sendVerificationEmail(
    email: string,
    username: string,
    token: string,
    language: Language = 'en',
  ): Promise<void> {
    const lang = normalizePlayerLanguage(language);
    const t = translationService.getTranslations(lang);
    const v = t.email.verification;
    const verificationUrl = `${apiBaseUrl}/auth/verify-email?token=${token}`;

    const htmlContent = `
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${v.title} - ${t.common.appName}</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Arial', sans-serif; background-color: #1a1a1a;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #1a1a1a; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); border: 2px solid #D4A574; border-radius: 10px; overflow: hidden;">
          <tr>
            <td style="background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); padding: 30px; text-align: center;">
              <h1 style="margin: 0; color: #000000; font-size: 32px; font-weight: bold; letter-spacing: 2px; text-shadow: 1px 1px 2px rgba(0,0,0,0.3);">
                ${t.common.appName}
              </h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #D4A574; margin: 0 0 20px 0; font-size: 24px; text-align: center;">
                ${v.title}
              </h2>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                ${v.greeting(username)}
              </p>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;">
                ${v.body}
              </p>
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 20px 0;">
                    <a href="${verificationUrl}" style="display: inline-block; background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); color: #000000; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-weight: bold; font-size: 18px; letter-spacing: 1.5px; box-shadow: 0 4px 8px rgba(212, 165, 116, 0.3);">
                      ${v.buttonText}
                    </a>
                  </td>
                </tr>
              </table>
              <p style="color: #999999; font-size: 14px; line-height: 1.6; margin: 30px 0 0 0; text-align: center;">
                ${v.copyLinkHint}
              </p>
              <p style="color: #D4A574; font-size: 12px; word-break: break-all; text-align: center; margin: 10px 0;">
                ${verificationUrl}
              </p>
              <p style="color: #999999; font-size: 13px; line-height: 1.6; margin: 30px 0 0 0; border-top: 1px solid #333333; padding-top: 20px;">
                <strong>${v.securityLabel}:</strong> ${v.expiryNote} ${v.ignoreNote}
              </p>
            </td>
          </tr>
          <tr>
            <td style="background-color: #0d0d0d; padding: 20px; text-align: center;">
              <p style="color: #666666; font-size: 12px; margin: 0;">
                ${t.common.footer}
              </p>
              <p style="color: #666666; font-size: 12px; margin: 10px 0 0 0;">
                ${t.common.automatedMessage}
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: email,
      subject: v.subject,
      html: htmlContent,
    });

    console.log(`[EmailService] Verification email sent to ${email} (${lang})`);
  },

  /**
   * Send password reset link (localized like verification).
   */
  async sendPasswordResetEmail(
    email: string,
    username: string,
    token: string,
    language: Language = 'en',
  ): Promise<void> {
    const lang = normalizePlayerLanguage(language);
    const t = translationService.getTranslations(lang);
    const p = t.email.passwordReset;
    const resetUrl = `${appBaseUrl}/auth/reset-password?token=${token}`;

    const htmlContent = `
<!DOCTYPE html>
<html lang="${lang}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${p.title} - ${t.common.appName}</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Arial', sans-serif; background-color: #1a1a1a;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #1a1a1a; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); border: 2px solid #D4A574; border-radius: 10px; overflow: hidden;">
          <tr>
            <td style="background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); padding: 30px; text-align: center;">
              <h1 style="margin: 0; color: #000000; font-size: 32px; font-weight: bold; letter-spacing: 2px; text-shadow: 1px 1px 2px rgba(0,0,0,0.3);">
                ${t.common.appName}
              </h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #D4A574; margin: 0 0 20px 0; font-size: 24px; text-align: center;">
                ${p.title}
              </h2>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                ${p.greeting(username)}
              </p>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;">
                ${p.body}
              </p>
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 20px 0;">
                    <a href="${resetUrl}" style="display: inline-block; background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); color: #000000; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-weight: bold; font-size: 18px; letter-spacing: 1.5px; box-shadow: 0 4px 8px rgba(212, 165, 116, 0.3);">
                      ${p.buttonText}
                    </a>
                  </td>
                </tr>
              </table>
              <p style="color: #999999; font-size: 14px; line-height: 1.6; margin: 30px 0 0 0; text-align: center;">
                ${p.copyLinkHint}
              </p>
              <p style="color: #D4A574; font-size: 12px; word-break: break-all; text-align: center; margin: 10px 0;">
                ${resetUrl}
              </p>
              <p style="color: #999999; font-size: 13px; line-height: 1.6; margin: 30px 0 0 0; border-top: 1px solid #333333; padding-top: 20px;">
                <strong>${p.securityLabel}:</strong> ${p.expiryNote} ${p.ignoreNote}
              </p>
            </td>
          </tr>
          <tr>
            <td style="background-color: #0d0d0d; padding: 20px; text-align: center;">
              <p style="color: #666666; font-size: 12px; margin: 0;">
                ${t.common.footer}
              </p>
              <p style="color: #666666; font-size: 12px; margin: 10px 0 0 0;">
                ${t.common.automatedMessage}
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: email,
      subject: p.subject,
      html: htmlContent,
    });

    console.log(`[EmailService] Password reset email sent to ${email} (${lang})`);
  },

  /**
   * Send friend request notification email
   */
  async sendFriendRequestEmail(recipientEmail: string, recipientUsername: string, senderUsername: string, language: Language = 'en'): Promise<void> {
    const t = translationService.getTranslations(language);
    
    const htmlContent = `
<!DOCTYPE html>
<html lang="${language}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${t.email.friendRequest.title} - ${t.common.appName}</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Arial', sans-serif; background-color: #1a1a1a;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #1a1a1a; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); border: 2px solid #D4A574; border-radius: 10px; overflow: hidden;">
          <tr>
            <td style="background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); padding: 30px; text-align: center;">
              <h1 style="margin: 0; color: #000000; font-size: 32px; font-weight: bold; letter-spacing: 2px; text-shadow: 1px 1px 2px rgba(0,0,0,0.3);">
                ${t.common.appName}
              </h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #D4A574; margin: 0 0 20px 0; font-size: 24px; text-align: center;">
                ${t.email.friendRequest.title}
              </h2>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                ${t.email.friendRequest.greeting(recipientUsername)}
              </p>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;">
                ${t.email.friendRequest.body(senderUsername)}
              </p>
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 20px 0;">
                    <a href="${appBaseUrl}" style="display: inline-block; background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); color: #000000; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-weight: bold; font-size: 18px; letter-spacing: 1.5px; box-shadow: 0 4px 8px rgba(212, 165, 116, 0.3);">
                      ${t.email.friendRequest.buttonText}
                    </a>
                  </td>
                </tr>
              </table>
              <p style="color: #999999; font-size: 13px; line-height: 1.6; margin: 30px 0 0 0; border-top: 1px solid #333333; padding-top: 20px;">
                ${t.email.friendRequest.settingsNote}
              </p>
            </td>
          </tr>
          <tr>
            <td style="background-color: #0d0d0d; padding: 20px; text-align: center;">
              <p style="color: #666666; font-size: 12px; margin: 0;">
                ${t.common.footer}
              </p>
              <p style="color: #666666; font-size: 12px; margin: 10px 0 0 0;">
                ${t.common.automatedMessage}
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.friendRequest.subject,
      html: htmlContent,
    });

    console.log(`[EmailService] Friend request email sent to ${recipientEmail} (${language})`);
  },

  /**
   * Send friend request accepted notification email
   */
  async sendFriendAcceptedEmail(recipientEmail: string, recipientUsername: string, acceptorUsername: string, language: Language = 'en'): Promise<void> {
    const t = translationService.getTranslations(language);
    
    const htmlContent = `
<!DOCTYPE html>
<html lang="${language}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${t.email.friendAccepted.title} - ${t.common.appName}</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Arial', sans-serif; background-color: #1a1a1a;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #1a1a1a; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background: linear-gradient(135deg, #2d2d2d 0%, #1a1a1a 100%); border: 2px solid #D4A574; border-radius: 10px; overflow: hidden;">
          <tr>
            <td style="background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); padding: 30px; text-align: center;">
              <h1 style="margin: 0; color: #000000; font-size: 32px; font-weight: bold; letter-spacing: 2px; text-shadow: 1px 1px 2px rgba(0,0,0,0.3);">
                ${t.common.appName}
              </h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 40px 30px;">
              <h2 style="color: #D4A574; margin: 0 0 20px 0; font-size: 24px; text-align: center;">
                ${t.email.friendAccepted.title}
              </h2>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 20px 0;">
                ${t.email.friendAccepted.greeting(recipientUsername)}
              </p>
              <p style="color: #cccccc; font-size: 16px; line-height: 1.6; margin: 0 0 30px 0;">
                ${t.email.friendAccepted.body(acceptorUsername)}
              </p>
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr>
                  <td align="center" style="padding: 20px 0;">
                    <a href="${appBaseUrl}" style="display: inline-block; background: linear-gradient(90deg, #D4A574 0%, #B8945E 50%, #D4A574 100%); color: #000000; text-decoration: none; padding: 15px 40px; border-radius: 5px; font-weight: bold; font-size: 18px; letter-spacing: 1.5px; box-shadow: 0 4px 8px rgba(212, 165, 116, 0.3);">
                      ${t.email.friendAccepted.buttonText}
                    </a>
                  </td>
                </tr>
              </table>
              <p style="color: #999999; font-size: 13px; line-height: 1.6; margin: 30px 0 0 0; border-top: 1px solid #333333; padding-top: 20px;">
                ${t.email.friendAccepted.settingsNote}
              </p>
            </td>
          </tr>
          <tr>
            <td style="background-color: #0d0d0d; padding: 20px; text-align: center;">
              <p style="color: #666666; font-size: 12px; margin: 0;">
                ${t.common.footer}
              </p>
              <p style="color: #666666; font-size: 12px; margin: 10px 0 0 0;">
                ${t.common.automatedMessage}
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
    `;

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.friendAccepted.subject,
      html: htmlContent,
    });

    console.log(`[EmailService] Friend accepted email sent to ${recipientEmail} (${language}`);
  },

  async sendCrewJoinRequestEmail(
    recipientEmail: string,
    recipientUsername: string,
    requesterUsername: string,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.crewJoinRequest.title,
      greeting: t.email.crewJoinRequest.greeting(recipientUsername),
      body: t.email.crewJoinRequest.body(requesterUsername, crewName),
      buttonText: t.email.crewJoinRequest.buttonText,
      settingsNote: t.email.crewJoinRequest.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.crewJoinRequest.subject,
      html: htmlContent,
    });
  },

  async sendCrewJoinApprovedEmail(
    recipientEmail: string,
    recipientUsername: string,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.crewJoinApproved.title,
      greeting: t.email.crewJoinApproved.greeting(recipientUsername),
      body: t.email.crewJoinApproved.body(crewName),
      buttonText: t.email.crewJoinApproved.buttonText,
      settingsNote: t.email.crewJoinApproved.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.crewJoinApproved.subject,
      html: htmlContent,
    });
  },

  async sendCrewJoinRejectedEmail(
    recipientEmail: string,
    recipientUsername: string,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.crewJoinRejected.title,
      greeting: t.email.crewJoinRejected.greeting(recipientUsername),
      body: t.email.crewJoinRejected.body(crewName),
      buttonText: t.email.crewJoinRejected.buttonText,
      settingsNote: t.email.crewJoinRejected.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.crewJoinRejected.subject,
      html: htmlContent,
    });
  },

  async sendCrewKickedEmail(
    recipientEmail: string,
    recipientUsername: string,
    crewName: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.crewKicked.title,
      greeting: t.email.crewKicked.greeting(recipientUsername),
      body: t.email.crewKicked.body(crewName),
      buttonText: t.email.crewKicked.buttonText,
      settingsNote: t.email.crewKicked.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.crewKicked.subject,
      html: htmlContent,
    });
  },

  async sendCrewRoleChangedEmail(
    recipientEmail: string,
    recipientUsername: string,
    crewName: string,
    roleLabel: string,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.crewRoleChanged.title,
      greeting: t.email.crewRoleChanged.greeting(recipientUsername),
      body: t.email.crewRoleChanged.body(crewName, roleLabel),
      buttonText: t.email.crewRoleChanged.buttonText,
      settingsNote: t.email.crewRoleChanged.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.crewRoleChanged.subject,
      html: htmlContent,
    });
  },

  async sendCrewHeistResultEmail(
    recipientEmail: string,
    recipientUsername: string,
    crewName: string,
    heistName: string,
    success: boolean,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.crewHeistResult.title(success),
      greeting: t.email.crewHeistResult.greeting(recipientUsername),
      body: t.email.crewHeistResult.body(crewName, heistName, success),
      buttonText: t.email.crewHeistResult.buttonText,
      settingsNote: t.email.crewHeistResult.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.crewHeistResult.subject(success),
      html: htmlContent,
    });
  },

  async sendCasinoLowBalanceEmail(
    recipientEmail: string,
    recipientUsername: string,
    casinoName: string,
    currentBalance: number,
    threshold: number,
    language: Language = 'en'
  ): Promise<void> {
    const t = translationService.getTranslations(language);
    const htmlContent = buildCrewEmailHtml({
      title: t.email.casinoLowBalance.title,
      greeting: t.email.casinoLowBalance.greeting(recipientUsername),
      body: t.email.casinoLowBalance.body(
        casinoName,
        currentBalance.toFixed(0),
        threshold.toFixed(0)
      ),
      buttonText: t.email.casinoLowBalance.buttonText,
      settingsNote: t.email.casinoLowBalance.settingsNote,
      footer: t.common.footer,
      automatedMessage: t.common.automatedMessage,
    });

    await transporter.sendMail({
      from: '"The Mob State" <noreply@themobstate.com>',
      to: recipientEmail,
      subject: t.email.casinoLowBalance.subject,
      html: htmlContent,
    });

    console.log(`[EmailService] Casino low balance email sent to ${recipientEmail} (${language})`);
  },
};
