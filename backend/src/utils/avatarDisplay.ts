/**
 * Relative path after `/images/` for nginx + Flutter WebAssetHelper (e.g. `player_avatars/5/uuid.png`).
 */
export function activePortraitPathFromRow(imagePath: string | null | undefined): string | null {
  if (!imagePath || !imagePath.trim()) return null;
  return imagePath.trim();
}
