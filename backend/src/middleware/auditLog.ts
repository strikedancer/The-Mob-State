import { Request, Response, NextFunction } from 'express';
import prisma from '../lib/prisma';
import jwt from 'jsonwebtoken';
import config from '../config';

export interface AuditLogData {
  action: string;
  targetType?: string;
  targetId?: string;
  details?: any;
}

/**
 * Middleware to log admin actions to the AuditLog table
 * Usage: router.post('/ban', auditLog({ action: 'BAN_PLAYER' }), handler)
 */
export function auditLog(logData: AuditLogData) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      // Extract admin info from JWT token
      const token = req.headers.authorization?.split(' ')[1];
      if (!token) {
        return next(); // Skip if no token (will fail in auth middleware anyway)
      }

      let adminId: number | undefined;
      let actorPlayerId: number | undefined;
      let actorStaffRole: string | undefined;
      try {
        const decoded = jwt.verify(token, config.jwtSecret) as any;
        if (decoded.type === 'admin') {
          adminId = decoded.adminId;
          if (!adminId && decoded.playerId && decoded.staffRole) {
            actorPlayerId = Number(decoded.playerId);
            actorStaffRole = String(decoded.staffRole);
          }
        }
      } catch (err) {
        return next(); // Skip if invalid token
      }

      if (!adminId && !actorPlayerId) {
        return next(); // Not an admin or staff token
      }

      // Extract IP address (handle proxy headers)
      const ipAddress = (
        req.headers['x-forwarded-for'] as string ||
        req.headers['x-real-ip'] as string ||
        req.socket.remoteAddress ||
        'unknown'
      ).split(',')[0].trim();

      // Extract user agent
      const userAgent = req.headers['user-agent'] || 'unknown';

      // Merge static log data with dynamic data from request
      const action = logData.action;
      const targetType = logData.targetType || req.body.targetType;
      // Try multiple sources for targetId
      const targetId = logData.targetId || 
                       req.body.playerId?.toString() ||
                       req.body.targetId?.toString() || 
                       req.params.id;
      
      // Include request body as details (sanitize sensitive data)
      const details = logData.details || {
        ...req.body,
        // Remove sensitive fields
        password: undefined,
        passwordHash: undefined,
      };

      // Store in res.locals so we can log AFTER the action completes
      res.locals.auditLogData = {
        adminId: adminId ?? null,
        actorPlayerId: actorPlayerId ?? null,
        actorStaffRole: actorStaffRole ?? null,
        action,
        targetType,
        targetId: targetId?.toString(),
        details: JSON.stringify(details),
        ipAddress,
        userAgent,
      };

      // Hook into response finish event to log after action completes
      const originalJson = res.json.bind(res);
      res.json = function (body: any) {
        // Only log if request was successful (2xx status)
        if (res.statusCode >= 200 && res.statusCode < 300) {
          const overrideDetails = res.locals.auditLogDetails;
          if (overrideDetails !== undefined) {
            res.locals.auditLogData.details = JSON.stringify(overrideDetails);
          }

          const logData = res.locals.auditLogData as {
            adminId: number | null;
            actorPlayerId: number | null;
            actorStaffRole: string | null;
            action: string;
            targetType?: string;
            targetId?: string;
            details?: string;
            ipAddress?: string;
            userAgent?: string;
          };
          if (logData.adminId) {
            prisma.auditLog
              .create({
                data: {
                  adminId: logData.adminId,
                  action: logData.action,
                  targetType: logData.targetType,
                  targetId: logData.targetId,
                  details: logData.details,
                  ipAddress: logData.ipAddress,
                  userAgent: logData.userAgent,
                },
              })
              .catch((err) => {
                console.error('[Audit Log] Failed to create log:', err);
              });
          } else if (logData.actorPlayerId) {
            prisma
              .$executeRawUnsafe(
                `INSERT INTO audit_logs
                  (adminId, action, targetType, targetId, details, ipAddress, userAgent, createdAt, actorPlayerId, actorStaffRole)
                 VALUES (NULL, ?, ?, ?, ?, ?, ?, NOW(), ?, ?)`,
                logData.action,
                logData.targetType ?? null,
                logData.targetId ?? null,
                logData.details ?? null,
                logData.ipAddress ?? null,
                logData.userAgent ?? null,
                logData.actorPlayerId,
                logData.actorStaffRole,
              )
              .catch((err) => {
                console.error('[Audit Log] Failed to create staff log:', err);
              });
          }
        }
        return originalJson(body);
      };

      next();
    } catch (error) {
      console.error('[Audit Log] Error in middleware:', error);
      next(); // Don't block request if audit logging fails
    }
  };
}

/**
 * Helper function to manually create audit logs (for actions outside of HTTP requests)
 */
export async function createAuditLog(data: {
  adminId?: number;
  action: string;
  targetType?: string;
  targetId?: string;
  details?: any;
  ipAddress?: string;
  userAgent?: string;
  actorPlayerId?: number;
  actorStaffRole?: string;
}) {
  try {
    const actorPlayerId =
      data.actorPlayerId ??
      (data.details && typeof data.details === 'object'
        ? Number(data.details.actorPlayerId || 0) || undefined
        : undefined);
    const actorStaffRole =
      data.actorStaffRole ??
      (data.details && typeof data.details === 'object'
        ? String(data.details.actorStaffRole || '')
        : undefined);

    if (data.adminId && data.adminId > 0) {
      await prisma.auditLog.create({
        data: {
          adminId: data.adminId,
          action: data.action,
          targetType: data.targetType,
          targetId: data.targetId?.toString(),
          details: data.details ? JSON.stringify(data.details) : null,
          ipAddress: data.ipAddress || null,
          userAgent: data.userAgent || null,
        },
      });
      return;
    }

    if (actorPlayerId) {
      await prisma.$executeRawUnsafe(
        `INSERT INTO audit_logs
          (adminId, action, targetType, targetId, details, ipAddress, userAgent, createdAt, actorPlayerId, actorStaffRole)
         VALUES (NULL, ?, ?, ?, ?, ?, ?, NOW(), ?, ?)`,
        data.action,
        data.targetType ?? null,
        data.targetId?.toString() ?? null,
        data.details ? JSON.stringify(data.details) : null,
        data.ipAddress || null,
        data.userAgent || null,
        actorPlayerId,
        actorStaffRole || null,
      );
    }
  } catch (error) {
    console.error('[Audit Log] Failed to create manual log:', error);
  }
}
