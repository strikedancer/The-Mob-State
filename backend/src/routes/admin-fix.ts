import { Router } from 'express';
import prisma from '../lib/prisma';

const router = Router();

// Emergency endpoint to set all players to Dutch
router.post('/fix-languages', async (_req, res) => {
  try {
    const result = await prisma.$executeRaw`UPDATE players SET preferredLanguage = 'nl' WHERE preferredLanguage = 'en'`;
    
    const all = await prisma.player.findMany({
      select: { id: true, username: true, preferredLanguage: true }
    });
    
    res.json({
      updated: result,
      players: all
    });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
