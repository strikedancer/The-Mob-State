import { Router, Request, Response } from 'express';
import { authenticate } from '../middleware/authenticate';
import { drugFacilityService } from '../services/drugFacilityService';

const router = Router();

// GET /drug-facilities/config — facility definitions + quality tiers
router.get('/config', authenticate, async (_req: Request, res: Response) => {
  try {
    const config = drugFacilityService.getFacilityConfig();
    res.json({ success: true, config });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Server fout' });
  }
});

// GET /drug-facilities — get all player facilities
router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as any).player.id as number;
    const [facilities, catalog] = await Promise.all([
      drugFacilityService.getPlayerFacilities(playerId),
      drugFacilityService.getFacilityCatalog(playerId),
    ]);
    res.json({ success: true, facilities, catalog });
  } catch (err) {
    console.error('GET /drug-facilities error:', err);
    res.status(500).json({ success: false, message: 'Server fout' });
  }
});

// POST /drug-facilities/buy — buy a facility
router.post('/buy', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as any).player.id as number;
    const { facilityType } = req.body as { facilityType: string };

    if (!facilityType) {
      return res.status(400).json({ success: false, message: 'facilityType is verplicht' });
    }

    const result = await drugFacilityService.buyFacility(playerId, facilityType);
    res.json(result);
  } catch (err) {
    console.error('POST /drug-facilities/buy error:', err);
    res.status(500).json({ success: false, message: 'Server fout' });
  }
});

// POST /drug-facilities/:id/upgrade-slots — buy extra slot
router.post('/:id/upgrade-slots', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as any).player.id as number;
    const facilityId = parseInt(req.params.id, 10);

    if (isNaN(facilityId)) {
      return res.status(400).json({ success: false, message: 'Ongeldig faciliteits-ID' });
    }

    const result = await drugFacilityService.upgradeSlots(playerId, facilityId);
    if (!result.success && (result as any).error === 'EDUCATION_REQUIREMENTS_NOT_MET') {
      return res.status(403).json({
        ...result,
        reason: 'EDUCATION_REQUIREMENTS_NOT_MET',
      });
    }
    res.json(result);
  } catch (err) {
    console.error('POST /drug-facilities/:id/upgrade-slots error:', err);
    res.status(500).json({ success: false, message: 'Server fout' });
  }
});

// POST /drug-facilities/:id/upgrade-equipment — upgrade specific equipment
router.post('/:id/upgrade-equipment', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as any).player.id as number;
    const facilityId = parseInt(req.params.id, 10);
    const { upgradeType } = req.body as { upgradeType: string };

    if (isNaN(facilityId)) {
      return res.status(400).json({ success: false, message: 'Ongeldig faciliteits-ID' });
    }
    if (!upgradeType) {
      return res.status(400).json({ success: false, message: 'upgradeType is verplicht' });
    }

    const result = await drugFacilityService.upgradeEquipment(playerId, facilityId, upgradeType);
    if (!result.success && (result as any).error === 'EDUCATION_REQUIREMENTS_NOT_MET') {
      return res.status(403).json({
        ...result,
        reason: 'EDUCATION_REQUIREMENTS_NOT_MET',
      });
    }
    res.json(result);
  } catch (err) {
    console.error('POST /drug-facilities/:id/upgrade-equipment error:', err);
    res.status(500).json({ success: false, message: 'Server fout' });
  }
});

router.post('/:id/auto-sale', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as any).player.id as number;
    const facilityId = parseInt(req.params.id, 10);
    const enabled = Boolean((req.body as { enabled?: boolean })?.enabled);

    if (isNaN(facilityId)) {
      return res.status(400).json({ success: false, message: 'Ongeldig faciliteits-ID' });
    }

    const result = await drugFacilityService.setAutoSaleEnabled(playerId, facilityId, enabled);
    if (!result.success) {
      return res.status(400).json(result);
    }
    res.json(result);
  } catch (err) {
    console.error('POST /drug-facilities/:id/auto-sale error:', err);
    res.status(500).json({ success: false, message: 'Server fout' });
  }
});

export default router;
