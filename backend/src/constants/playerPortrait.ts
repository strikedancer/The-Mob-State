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

export const PORTRAIT_POSITIVE_PROMPT =
  'Film noir bust portrait of the same person as a 1940s gangster, fedora or period hat, ' +
  'stern confident expression, dark moody lighting, muted browns and deep shadows, ' +
  'semi-realistic game avatar style, transparent or simple dark gradient background, no text, no watermark';

export const PORTRAIT_NEGATIVE_PROMPT =
  'text, logo, watermark, letters, numbers, UI labels, blurry, low detail, ' +
  'anime, oversaturated neon, frame, border, collage, gore, extra faces';
