export const ADMIN_USERNAME_REGEX = /^[a-zA-Z0-9_\-.]+$/;

export function normalizeAdminUsername(raw: string): string {
  return raw.trim().replace(/[\s\u00A0]+/g, ' ');
}

export function compactAdminUsername(raw: string): string {
  return normalizeAdminUsername(raw).replace(/ /g, '');
}
