import { Response, NextFunction } from 'express';
import type { AdminRequest } from './adminAuth';
import { isPlayerStaff, type PlayerStaffRole } from '../utils/staffRole';

type AllowedRule = { method: string; pattern: RegExp };

const MOD_RULES: AllowedRule[] = [
  { method: 'GET', pattern: /^\/global-chat\/overview$/ },
  { method: 'DELETE', pattern: /^\/global-chat\/messages\/\d+$/ },
  { method: 'POST', pattern: /^\/global-chat\/mutes$/ },
  { method: 'DELETE', pattern: /^\/global-chat\/mutes\/\d+$/ },
];

const OPS_EXTRA_RULES: AllowedRule[] = [
  { method: 'GET', pattern: /^\/players$/ },
  { method: 'GET', pattern: /^\/players\/\d+\/overview$/ },
  { method: 'GET', pattern: /^\/players\/\d+\/recent-activities$/ },
  { method: 'GET', pattern: /^\/players\/\d+\/portraits$/ },
  { method: 'GET', pattern: /^\/tickets$/ },
  { method: 'GET', pattern: /^\/tickets\/\d+$/ },
  { method: 'GET', pattern: /^\/tickets\/attachments\/\d+$/ },
  { method: 'POST', pattern: /^\/tickets\/\d+\/reply$/ },
  { method: 'PATCH', pattern: /^\/tickets\/\d+$/ },
  { method: 'POST', pattern: /^\/tickets\/\d+\/todos$/ },
  { method: 'PATCH', pattern: /^\/tickets\/todos\/\d+$/ },
  { method: 'DELETE', pattern: /^\/tickets\/todos\/\d+$/ },
];

function staffRules(role: PlayerStaffRole): AllowedRule[] {
  if (role === 'OPS') return [...MOD_RULES, ...OPS_EXTRA_RULES];
  return MOD_RULES;
}

function isAllowed(method: string, path: string, role: PlayerStaffRole): boolean {
  return staffRules(role).some(
    (rule) => rule.method === method.toUpperCase() && rule.pattern.test(path),
  );
}

export function restrictPlayerStaffAdminRoutes(
  req: AdminRequest,
  res: Response,
  next: NextFunction,
) {
  const staffRole = req.admin?.staffRole;
  if (!isPlayerStaff(staffRole)) {
    return next();
  }

  const path = req.path || '';
  if (isAllowed(req.method, path, staffRole)) {
    return next();
  }

  return res.status(403).json({
    error: 'FORBIDDEN',
    message: 'This admin page is not available for player staff',
  });
}

export function denyPlayerStaff(req: AdminRequest, res: Response, next: NextFunction) {
  if (isPlayerStaff(req.admin?.staffRole)) {
    return res.status(403).json({
      error: 'FORBIDDEN',
      message: 'This admin page is not available for player staff',
    });
  }
  return next();
}
