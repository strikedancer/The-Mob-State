class GlobalChatSticker {
  final String id;
  final String emoji;

  const GlobalChatSticker({required this.id, required this.emoji});
}

const List<GlobalChatSticker> kGlobalChatStickers = [
  GlobalChatSticker(id: 'cash', emoji: '💵'),
  GlobalChatSticker(id: 'gun', emoji: '🔫'),
  GlobalChatSticker(id: 'skull', emoji: '💀'),
  GlobalChatSticker(id: 'fire', emoji: '🔥'),
  GlobalChatSticker(id: 'car', emoji: '🚗'),
  GlobalChatSticker(id: 'plane', emoji: '✈️'),
  GlobalChatSticker(id: 'crown', emoji: '👑'),
  GlobalChatSticker(id: 'dice', emoji: '🎲'),
  GlobalChatSticker(id: 'heart', emoji: '❤️'),
  GlobalChatSticker(id: 'laugh', emoji: '😂'),
  GlobalChatSticker(id: 'cool', emoji: '😎'),
  GlobalChatSticker(id: 'angry', emoji: '😡'),
  GlobalChatSticker(id: 'thumbs', emoji: '👍'),
  GlobalChatSticker(id: 'clap', emoji: '👏'),
  GlobalChatSticker(id: 'cop', emoji: '👮'),
  GlobalChatSticker(id: 'lock', emoji: '🔒'),
  GlobalChatSticker(id: 'bomb', emoji: '💣'),
  GlobalChatSticker(id: 'diamond', emoji: '💎'),
  GlobalChatSticker(id: 'cheers', emoji: '🥃'),
  GlobalChatSticker(id: 'rose', emoji: '🌹'),
  GlobalChatSticker(id: 'smoke', emoji: '🚬'),
  GlobalChatSticker(id: 'night', emoji: '🌃'),
  GlobalChatSticker(id: 'wolf', emoji: '🐺'),
  GlobalChatSticker(id: 'eye', emoji: '👁️'),
];

GlobalChatSticker? globalChatStickerById(String? id) {
  if (id == null) return null;
  for (final sticker in kGlobalChatStickers) {
    if (sticker.id == id) return sticker;
  }
  return null;
}
