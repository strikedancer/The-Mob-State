/**
 * Lightweight terminology pass to keep game/admin terms consistent across MT locales.
 * This is intentionally conservative: it only rewrites a small set of common mistranslations.
 */
export function applyTerminology(lang, input) {
  if (!input || typeof input !== 'string') return input;

  // Protect ICU-like placeholders: {foo}, {count}, etc.
  const placeholders = [];
  const masked = input.replace(/\{[^{}]+\}/g, (m) => {
    placeholders.push(m);
    return `⟦PH_${placeholders.length - 1}⟧`;
  });

  const rules = TERMINOLOGY_RULES[lang] ?? [];
  let out = masked;
  for (const { from, to } of rules) {
    out = out.replace(from, to);
  }

  // Restore placeholders.
  for (let i = 0; i < placeholders.length; i++) {
    out = out.replace(`⟦PH_${i}⟧`, placeholders[i]);
  }
  return out;
}

/**
 * Rules are applied in order. Keep them specific to avoid unwanted global rewrites.
 *
 * Notes:
 * - We prefer keeping core game terms in English branding form (Crew/Nightclub/VIP).
 * - This can be expanded over time as you spot problematic MT terms.
 */
const TERMINOLOGY_RULES = {
  de: [
    { from: /\b(Mannschaft|Besatzung)\b/g, to: 'Crew' },
    { from: /\bNachtclub\b/gi, to: 'Nightclub' },
  ],
  fr: [
    { from: /\b(équipage|équipe)\b/gi, to: 'Crew' },
    { from: /\bboîte de nuit\b/gi, to: 'Nightclub' },
  ],
  es: [
    { from: /\b(tripulación)\b/gi, to: 'Crew' },
    { from: /\bclub nocturno\b/gi, to: 'Nightclub' },
  ],
  it: [
    { from: /\b(equipaggio)\b/gi, to: 'Crew' },
    { from: /\blocale notturno\b/gi, to: 'Nightclub' },
  ],
  pl: [
    { from: /\b(załoga)\b/gi, to: 'Crew' },
    { from: /\bklub nocny\b/gi, to: 'Nightclub' },
  ],
  pt: [
    { from: /\b(tripulação)\b/gi, to: 'Crew' },
    { from: /\bclube noturno\b/gi, to: 'Nightclub' },
  ],
};

