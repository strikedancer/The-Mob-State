import type { SupportedPlayerLanguage } from '../config/supportedLanguages';
import { ACHIEVEMENT_ARB_BY_LANG } from './generated/achievementArbBundles';

type ArbRow = { title?: string; description?: string };

const bundles = ACHIEVEMENT_ARB_BY_LANG as Record<
  SupportedPlayerLanguage,
  Record<string, ArbRow>
>;

/**
 * Resolves achievement title/description from Flutter ARB exports (per player language),
 * falling back to English ARB, then to server definition strings.
 */
export function resolveAchievementCopy(
  lang: SupportedPlayerLanguage,
  achievementId: string,
  fallback: { title: string; description: string }
): { title: string; description: string } {
  const enRow = bundles.en[achievementId];
  const locRow = bundles[lang]?.[achievementId];
  return {
    title: locRow?.title ?? enRow?.title ?? fallback.title,
    description: locRow?.description ?? enRow?.description ?? fallback.description,
  };
}
