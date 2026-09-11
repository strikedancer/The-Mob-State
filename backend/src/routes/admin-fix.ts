import { Router } from 'express';
import prisma from '../lib/prisma';
import { adminAuthMiddleware, requireAdminRole } from '../middleware/adminAuth';
import { AdminRole } from '@prisma/client';

const router = Router();

router.use(adminAuthMiddleware);

// Emergency language reset — SUPER_ADMIN only. Do not expose player PII.
router.post(
  '/fix-languages',
  requireAdminRole(AdminRole.SUPER_ADMIN),
  async (_req, res) => {
    try {
      const updated = await prisma.$executeRaw`UPDATE players SET preferredLanguage = 'nl' WHERE preferredLanguage = 'en'`;
      return res.json({ updated });
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : 'Language fix failed';
      return res.status(500).json({ error: message });
    }
  }
);

export default router;
