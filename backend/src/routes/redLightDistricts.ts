import express from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { redLightDistrictService } from '../services/redLightDistrictService';

const router = express.Router();

/**
 * GET /red-light-districts/available
 * Get all available (unowned) red light districts
 */
router.get('/available', authenticate, async (req: AuthRequest, res) => {
  try {
    const districts = await redLightDistrictService.getAvailableDistricts();

    res.json({
      success: true,
      districts
    });
  } catch (error) {
    console.error('Error fetching available districts:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /red-light-districts/my-districts
 * Get all districts owned by the authenticated player
 */
router.get('/my-districts', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;

    const districts = await redLightDistrictService.getPlayerDistricts(playerId);

    // Get stats for each district
    const districtsWithStats = await Promise.all(
      districts.map(async (district) => {
        const stats = await redLightDistrictService.getDistrictStats(district.id);
        return {
          ...district,
          stats
        };
      })
    );

    res.json({
      success: true,
      districts: districtsWithStats
    });
  } catch (error) {
    console.error('Error fetching player districts:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /red-light-districts/country/:countryCode
 * Get red light district for a specific country
 */
router.get('/country/:countryCode', authenticate, async (req: AuthRequest, res) => {
  try {
    const countryCodeParam = req.params.countryCode;
    const countryCode = Array.isArray(countryCodeParam)
      ? countryCodeParam[0]
      : countryCodeParam;

    const district = await redLightDistrictService.getByCountry(countryCode);

    if (!district) {
      return res.status(404).json({
        success: false,
        message: 'Red Light District niet gevonden in dit land'
      });
    }

    const stats = await redLightDistrictService.getDistrictStats(district.id);

    res.json({
      success: true,
      district,
      stats
    });
  } catch (error) {
    console.error('Error fetching district by country:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /red-light-districts/purchase
 * Purchase a red light district
 */
router.post('/purchase', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const { countryCode } = req.body;

    if (!countryCode) {
      return res.status(400).json({
        success: false,
        message: 'countryCode is vereist'
      });
    }

    const result = await redLightDistrictService.purchaseDistrict(playerId, countryCode);

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error purchasing district:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /red-light-districts/:id
 * Get a specific red light district by ID with rooms and stats
 */
router.get('/:id', authenticate, async (req: AuthRequest, res) => {
  try {
    const districtId = parseInt(String(req.params.id), 10);
    const playerId = req.player!.id;
    const playerCountry = req.player!.currentCountry;

    const district = await redLightDistrictService.getDistrictById(districtId);

    if (!district) {
      return res.status(404).json({
        success: false,
        message: 'Red Light District niet gevonden'
      });
    }

    // Allow access for owner OR players currently in that country
    const canAccess = district.ownerId === playerId || district.countryCode === playerCountry;
    if (!canAccess) {
      return res.status(403).json({
        success: false,
        message: 'Je hebt geen toegang tot dit district vanuit je huidige land'
      });
    }

    if (!district.ownerId) {
      return res.status(400).json({
        success: false,
        message: 'Dit Red Light District heeft nog geen eigenaar'
      });
    }

    const stats = await redLightDistrictService.getDistrictStats(districtId);

    res.json({
      success: true,
      district,
      stats
    });
  } catch (error) {
    console.error('Error fetching district by ID:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /red-light-districts/:id/available-rooms
 * Get available rooms in a district
 */
router.get('/:id/available-rooms', authenticate, async (req: AuthRequest, res) => {
  try {
    const districtId = parseInt(String(req.params.id), 10);

    const district = await redLightDistrictService.getDistrictById(districtId);
    if (!district) {
      return res.status(404).json({
        success: false,
        message: 'Red Light District niet gevonden'
      });
    }

    if (!district.ownerId) {
      return res.status(400).json({
        success: false,
        message: 'Dit Red Light District heeft nog geen eigenaar'
      });
    }

    const playerId = req.player!.id;
    const playerCountry = req.player!.currentCountry;
    const canAccess = district.ownerId === playerId || district.countryCode === playerCountry;
    if (!canAccess) {
      return res.status(403).json({
        success: false,
        message: 'Je kunt alleen kamers bekijken in het district van je huidige land'
      });
    }

    const rooms = await redLightDistrictService.getAvailableRooms(districtId);

    res.json({
      success: true,
      rooms
    });
  } catch (error) {
    console.error('Error fetching available rooms:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /red-light-districts/:id/stats
 * Get statistics for a district
 */
router.get('/:id/stats', authenticate, async (req: AuthRequest, res) => {
  try {
    const districtId = parseInt(String(req.params.id), 10);

    const stats = await redLightDistrictService.getDistrictStats(districtId);

    if (!stats) {
      return res.status(404).json({
        success: false,
        message: 'District niet gevonden'
      });
    }

    res.json({
      success: true,
      stats
    });
  } catch (error) {
    console.error('Error fetching district stats:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /red-light-districts/:id/upgrade-tier
 * Upgrade district tier (Basic -> Luxury -> VIP)
 */
router.post('/:id/upgrade-tier', authenticate, async (req: AuthRequest, res) => {
  try {
    const districtId = parseInt(String(req.params.id), 10);
    const playerId = req.player!.id;

    const result = await redLightDistrictService.upgradeTier(districtId, playerId);

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error upgrading district tier:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /red-light-districts/:id/upgrade-security
 * Upgrade district security level
 */
router.post('/:id/upgrade-security', authenticate, async (req: AuthRequest, res) => {
  try {
    const districtId = parseInt(String(req.params.id), 10);
    const playerId = req.player!.id;

    const result = await redLightDistrictService.upgradeSecurity(districtId, playerId);

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error upgrading district security:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /red-light-districts/:id/upgrade-info
 * Get upgrade information for a district
 */
router.get('/:id/upgrade-info', authenticate, async (req: AuthRequest, res) => {
  try {
    const districtId = parseInt(String(req.params.id), 10);

    const info = await redLightDistrictService.getUpgradeInfo(districtId);

    if (!info) {
      return res.status(404).json({
        success: false,
        message: 'District niet gevonden'
      });
    }

    res.json({
      success: true,
      upgradeInfo: info
    });
  } catch (error) {
    console.error('Error fetching upgrade info:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

export default router;
