/** Premium credits charged only when a portrait PNG is saved successfully. */
export const PORTRAIT_SELFIE_CREDIT_COST = 100;

/** Max stored custom portraits per player (abuse / storage bound). */
export const MAX_PLAYER_PORTRAITS = 20;

/** Max upload size for selfie (bytes). */
export const SELFIE_MAX_BYTES = 5 * 1024 * 1024;

/** Leonardo Kino XL — supports Character Reference (133) per Leonardo docs. */
export const LEONARDO_MODEL_ID_KINO_XL = 'aa77f04e-3eec-4034-9c07-d0f619684628';

/** Character Reference preprocessor (face likeness). */
export const LEONARDO_PREPROCESSOR_CHARACTER_REF = 133;

/** Allowed selfie→portrait look presets (client sends `portraitStyle` multipart field). */
export const PORTRAIT_STYLE_IDS = [
  'classic_noir',
  'street_casual',
  'sharp_suit',
  'velvet_charm',
] as const;

export type PortraitStyleId = (typeof PORTRAIT_STYLE_IDS)[number];

export function parsePortraitStyleId(raw: unknown): PortraitStyleId {
  const s = typeof raw === 'string' ? raw.trim() : '';
  if ((PORTRAIT_STYLE_IDS as readonly string[]).includes(s)) {
    return s as PortraitStyleId;
  }
  return 'classic_noir';
}

export const PORTRAIT_NEGATIVE_PROMPT =
  'text, logo, watermark, letters, numbers, UI labels, blurry, low detail, ' +
  'anime, oversaturated neon, frame, border, collage, gore, extra faces';

/**
 * Build Leonardo prompts from account gender + player-chosen style.
 * Gender comes from the server (Player.gender), not the multipart body.
 */
export function buildGangsterPortraitPrompts(
  gender: string | null | undefined,
  style: PortraitStyleId
): { prompt: string; negative_prompt: string } {
  const g = (gender ?? '').toLowerCase();
  const genderPhrase =
    g === 'female'
      ? 'woman, female gangster, preserve feminine facial likeness from the reference face'
      : g === 'male'
        ? 'man, male gangster, preserve masculine facial likeness from the reference face'
        : 'person, gangster, preserve facial likeness and gender presentation from the reference face';

  const styleParts: Record<
    PortraitStyleId,
    { visual: string; negativeExtra?: string }
  > = {
    classic_noir: {
      visual:
        '1940s film noir bust portrait, fedora or period hat, stern confident expression, ' +
        'dark moody lighting, muted browns and deep shadows',
    },
    street_casual: {
      visual:
        'urban streetwise gangster, leather jacket or casual coat, relaxed confident stance, ' +
        'neo-noir, dusk city rim light',
    },
    sharp_suit: {
      visual:
        'tailored three-piece suit, power-broker energy, sharp silhouette, dramatic rim light, ' +
        'underworld executive',
    },
    velvet_charm: {
      visual:
        'elegant evening attire, charismatic confident expression, polished old-Hollywood glamour ' +
        'in a crime-drama tone, tasteful and classy, fully dressed',
      negativeExtra:
        'nudity, lingerie, revealing clothing, explicit, adult themes, fetish, strip club, ' +
        'provocative undressing, sheer fabric on skin',
    },
  };

  const part = styleParts[style];
  const negative =
    part.negativeExtra != null && part.negativeExtra.length > 0
      ? `${PORTRAIT_NEGATIVE_PROMPT}, ${part.negativeExtra}`
      : PORTRAIT_NEGATIVE_PROMPT;

  const prompt =
    'Film noir bust portrait of the same person as a gangster. ' +
    genderPhrase +
    '. ' +
    part.visual +
    ', semi-realistic game avatar style, transparent or simple dark gradient background, ' +
    'no text, no watermark';

  return { prompt, negative_prompt: negative };
}
