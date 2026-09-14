export type GlobalChatSticker = {
  id: string;
  emoji: string;
};

/** Curated world-chat stickers. Same ids as the Flutter catalog. */
export const GLOBAL_CHAT_STICKERS: GlobalChatSticker[] = [
  { id: 'cash', emoji: '💵' },
  { id: 'gun', emoji: '🔫' },
  { id: 'skull', emoji: '💀' },
  { id: 'fire', emoji: '🔥' },
  { id: 'car', emoji: '🚗' },
  { id: 'plane', emoji: '✈️' },
  { id: 'crown', emoji: '👑' },
  { id: 'dice', emoji: '🎲' },
  { id: 'heart', emoji: '❤️' },
  { id: 'laugh', emoji: '😂' },
  { id: 'cool', emoji: '😎' },
  { id: 'angry', emoji: '😡' },
  { id: 'thumbs', emoji: '👍' },
  { id: 'clap', emoji: '👏' },
  { id: 'cop', emoji: '👮' },
  { id: 'lock', emoji: '🔒' },
  { id: 'bomb', emoji: '💣' },
  { id: 'diamond', emoji: '💎' },
  { id: 'cheers', emoji: '🥃' },
  { id: 'rose', emoji: '🌹' },
  { id: 'smoke', emoji: '🚬' },
  { id: 'night', emoji: '🌃' },
  { id: 'wolf', emoji: '🐺' },
  { id: 'eye', emoji: '👁️' },
];

const BY_ID = new Map(GLOBAL_CHAT_STICKERS.map((sticker) => [sticker.id, sticker]));

export function getGlobalChatSticker(id: string | null | undefined): GlobalChatSticker | null {
  if (!id) return null;
  return BY_ID.get(id) ?? null;
}

export function isGlobalChatStickerId(id: string | null | undefined): boolean {
  return Boolean(id && BY_ID.has(id));
}
