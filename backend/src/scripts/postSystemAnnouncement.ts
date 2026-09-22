/**
 * Post a system line to in-game world chat (and Discord #wereldchat mirror).
 *
 * Usage:
 *   node dist/scripts/postSystemAnnouncement.js --message "NL...\n\nEN..."
 *   node dist/scripts/postSystemAnnouncement.js --b64 <base64-utf8>
 * Optional: --name "The Mob State"
 */
import { globalChatService } from '../services/globalChatService';

function argValue(flag: string): string | null {
  const idx = process.argv.indexOf(flag);
  if (idx < 0 || idx + 1 >= process.argv.length) return null;
  return process.argv[idx + 1] ?? null;
}

function decodeMessage(): string {
  const b64 = argValue('--b64');
  if (b64) {
    return Buffer.from(b64, 'base64').toString('utf8');
  }
  const message = argValue('--message');
  if (message) return message;
  const fromEnv = process.env.ANNOUNCEMENT_MESSAGE;
  if (fromEnv && fromEnv.trim()) return fromEnv;
  throw new Error('Provide --message, --b64, or ANNOUNCEMENT_MESSAGE');
}

async function main(): Promise<void> {
  const displayName = (argValue('--name') || process.env.ANNOUNCEMENT_NAME || 'The Mob State').trim();
  const message = decodeMessage().trim();
  if (!message) {
    throw new Error('Announcement message is empty');
  }
  const posted = await globalChatService.sendSystemAnnouncement(displayName, message, { force: true });
  console.log(
    JSON.stringify({
      ok: Boolean(posted),
      announcementId: posted?.id ?? null,
      length: message.length,
    }),
  );
  if (!posted) {
    process.exitCode = 2;
  }
}

void main().catch((error) => {
  console.error(error);
  process.exit(1);
});
