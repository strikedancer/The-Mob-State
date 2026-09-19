import { PROFANITY_WORDS } from '../data/profanityLists';

const LEET: Record<string, string> = {
  '0': 'o',
  '1': 'i',
  '3': 'e',
  '4': 'a',
  '5': 's',
  '7': 't',
  '@': 'a',
  $: 's',
  '!': 'i',
};

function foldChar(ch: string): string {
  const lower = ch.toLowerCase();
  return LEET[lower] ?? lower.normalize('NFD').replace(/\p{M}/gu, '');
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function wordToFuzzyPattern(word: string): string {
  return word
    .split('')
    .map((letter) => {
      const folded = foldChar(letter);
      const classes: string[] = [escapeRegExp(letter), escapeRegExp(folded)];
      for (const [leet, plain] of Object.entries(LEET)) {
        if (plain === folded) classes.push(escapeRegExp(leet));
      }
      const unique = [...new Set(classes.filter(Boolean))];
      return unique.length === 1 ? unique[0] : `[${unique.join('')}]`;
    })
    .join('[^\\p{L}\\p{N}]{0,2}');
}

function compilePatterns(extraWords: string[]): RegExp[] {
  const words = [
    ...PROFANITY_WORDS,
    ...extraWords
      .map((word) => word.trim().toLowerCase())
      .filter((word) => word.length >= 3),
  ];
  const unique = [...new Set(words)];
  return unique.map(
    (word) =>
      new RegExp(`(?<![\\p{L}\\p{N}])${wordToFuzzyPattern(word)}(?![\\p{L}\\p{N}])`, 'giu'),
  );
}

let cachedExtraKey = '';
let cachedPatterns: RegExp[] = compilePatterns([]);

function patternsFor(extraWords: string[]): RegExp[] {
  const key = extraWords.join('\n').toLowerCase();
  if (key === cachedExtraKey) return cachedPatterns;
  cachedExtraKey = key;
  cachedPatterns = compilePatterns(extraWords);
  return cachedPatterns;
}

export function parseExtraBlocklist(raw: string | null | undefined): string[] {
  if (!raw) return [];
  return raw
    .split(/[\n,;]+/)
    .map((word) => word.trim())
    .filter((word) => word.length >= 3);
}

export function stripChatMentions(text: string): string {
  return text
    .replace(/@everyone/gi, '')
    .replace(/@here/gi, '')
    .replace(/<@!?\d+>/g, '')
    .replace(/<#\d+>/g, '')
    .replace(/<@&\d+>/g, '');
}

export function filterProfanity(
  input: string,
  extraWords: string[] = [],
): { text: string; filtered: boolean } {
  const stripped = stripChatMentions(input);
  let text = stripped;
  let filtered = stripped !== input;
  for (const pattern of patternsFor(extraWords)) {
    pattern.lastIndex = 0;
    const next = text.replace(pattern, '****');
    if (next !== text) {
      filtered = true;
      text = next;
    }
  }
  return { text, filtered };
}
