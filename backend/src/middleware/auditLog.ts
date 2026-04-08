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
      try {
        const decoded = jwt.verify(token, config.jwtSecret) as any;
        if (decoded.type === 'admin') {
          adminId = decoded.adminId;
        }
      } catch (err) {
        return next(); // Skip if invalid token
      }

      if (!adminId) {
        return next(); // Not an admin token
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
        adminId,
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

          prisma.auditLog
            .create({
              data: res.locals.auditLogData,
            })
            .catch((err) => {
              console.error('[Audit Log] Failed to create log:', err);
            });
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
  adminId: number;
  action: string;
  targetType?: string;
  targetId?: string;
  details?: any;
  ipAddress?: string;
  userAgent?: string;
}) {
  try {
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
  } catch (error) {
    console.error('[Audit Log] Failed to create manual log:', error);
  }
}
