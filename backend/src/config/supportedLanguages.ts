/**
 * Player-facing UI languages (BCP-47 language subtags, base language only).
 * Keep in sync with Flutter ARB files and client/lib/config/supported_languages.dart
 */
export const SUPPORTED_PLAYER_LANGUAGES = [
  'nl',
  'en',
  'de',
  'fr',
  'es',
  'it',
  'pl',
  'pt',
] as const;

export type SupportedPlayerLanguage = (typeof SUPPORTED_PLAYER_LANGUAGES)[number];

const ALLOWED = new Set<string>(SUPPORTED_PLAYER_LANGUAGES);

/** Normalize request input: strips region (e.g. de-AT → de), defaults to en if unknown. */
export function normalizePlayerLanguage(input?: string | null): SupportedPlayerLanguage {
  const raw = (input ?? '').trim().toLowerCase();
  if (!raw) return 'en';
  const primary = raw.split(/[-_]/)[0] ?? raw;
  if (ALLOWED.has(primary)) {
    return primary as SupportedPlayerLanguage;
  }
  return 'en';
}

export function isSupportedPlayerLanguage(input: string): input is SupportedPlayerLanguage {
  const primary = input.trim().toLowerCase().split(/[-_]/)[0] ?? '';
  return ALLOWED.has(primary);
}
