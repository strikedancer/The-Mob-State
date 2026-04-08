import { Router } from 'express';
import { AdminRole } from '@prisma/client';
import { z } from 'zod';
import { adminAuthMiddleware, requireAdminRole, type AdminRequest } from '../../middleware/adminAuth';
import { gameEventService } from '../../services/gameEventService';

const router = Router();

router.use(adminAuthMiddleware);
router.use(requireAdminRole(AdminRole.SUPER_ADMIN, AdminRole.MODERATOR));

const nullableString = z.string().trim().min(1).nullable().optional();
const jsonRecord = z.record(z.unknown());

const templateSchema = z.object({
  key: z.string().trim().min(2).max(100).regex(/^[a-z0-9_\-.]+$/),
  category: z.string().trim().min(2).max(50),
  eventType: z.string().trim().min(2).max(50),
  titleNl: z.string().trim().min(1).max(255),
  titleEn: z.string().trim().min(1).max(255),
  shortDescriptionNl: nullableString,
  shortDescriptionEn: nullableString,
  descriptionNl: nullableString,
  descriptionEn: nullableString,
  icon: nullableString,
  bannerImage: nullableString,
  configSchemaJson: jsonRecord.optional(),
  uiSchemaJson: jsonRecord.optional(),
  isActive: z.boolean().optional(),
});

const scheduleSchema = z.object({
  templateId: z.number().int().positive(),
  scheduleType: z.string().trim().min(2).max(50),
  intervalMinutes: z.number().int().positive().nullable().optional(),
  durationMinutes: z.number().int().positive().nullable().optional(),
  cronExpression: nullableString,
  startWindowUtc: nullableString,
  endWindowUtc: nullableString,
  cooldownMinutes: z.number().int().min(0).nullable().optional(),
  enabled: z.boolean().optional(),
  weight: z.number().int().positive().optional(),
});

const modifierSchema = z.object({
  targetSystem: z.string().trim().min(2).max(50),
  modifierKey: z.string().trim().min(2).max(100),
  operation: z.string().trim().min(2).max(30),
  valueJson: jsonRecord.optional(),
  conditionsJson: jsonRecord.optional(),
});

const rewardRuleSchema = z.object({
  triggerType: z.string().trim().min(2).max(50),
  triggerConfigJson: jsonRecord.optional(),
  rewardsJson: jsonRecord,
  sortOrder: z.number().int().min(0).optional(),
  isActive: z.boolean().optional(),
});

const liveEventSchema = z.object({
  templateId: z.number().int().positive(),
  status: z.string().trim().min(2).max(30).optional(),
  startedAt: z.string().datetime().nullable().optional(),
  endsAt: z.string().datetime().nullable().optional(),
  configJson: jsonRecord.optional(),
  stateJson: jsonRecord.optional(),
  announcementJson: jsonRecord.optional(),
  scopeJson: jsonRecord.optional(),
  modifiers: z.array(modifierSchema).optional(),
  rewardRules: z.array(rewardRuleSchema).optional(),
});

const liveEventUpdateSchema = z.object({
  status: z.string().trim().min(2).max(30).optional(),
  startedAt: z.string().datetime().nullable().optional(),
  endsAt: z.string().datetime().nullable().optional(),
  resolvedAt: z.string().datetime().nullable().optional(),
  configJson: jsonRecord.nullable().optional(),
  stateJson: jsonRecord.nullable().optional(),
  announcementJson: jsonRecord.nullable().optional(),
  scopeJson: jsonRecord.nullable().optional(),
});

router.get('/templates', async (_req, res) => {
  try {
    const templates = await gameEventService.listTemplates();
    return res.status(200).json({ templates });
  } catch (error) {
    console.error('[Admin Game Events] Failed to list templates', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to list event templates' });
  }
});

router.post('/templates', async (req: AdminRequest, res) => {
  try {
    const payload = templateSchema.parse(req.body);
    const template = await gameEventService.createTemplate(payload);
    return res.status(201).json({ template, adminId: req.admin?.id ?? null });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_ERROR', issues: error.issues });
    }
    console.error('[Admin Game Events] Failed to create template', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to create event template' });
  }
});

router.patch('/templates/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id as string, 10);
    const payload = templateSchema.partial().parse(req.body);
    const template = await gameEventService.updateTemplate(id, payload);
    return res.status(200).json({ template });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_ERROR', issues: error.issues });
    }
    console.error('[Admin Game Events] Failed to update template', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to update event template' });
  }
});

router.get('/schedules', async (_req, res) => {
  try {
    const schedules = await gameEventService.listSchedules();
    return res.status(200).json({ schedules });
  } catch (error) {
    console.error('[Admin Game Events] Failed to list schedules', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to list event schedules' });
  }
});

router.post('/schedules', async (req, res) => {
  try {
    const payload = scheduleSchema.parse(req.body);
    const schedule = await gameEventService.createSchedule(payload);
    return res.status(201).json({ schedule });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_ERROR', issues: error.issues });
    }
    console.error('[Admin Game Events] Failed to create schedule', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to create event schedule' });
  }
});

router.patch('/schedules/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id as string, 10);
    const payload = scheduleSchema.partial().parse(req.body);
    const schedule = await gameEventService.updateSchedule(id, payload);
    return res.status(200).json({ schedule });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_ERROR', issues: error.issues });
    }
    console.error('[Admin Game Events] Failed to update schedule', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to update event schedule' });
  }
});

router.get('/live', async (req, res) => {
  try {
    const status = typeof req.query.status === 'string' ? req.query.status : undefined;
    const liveEvents = await gameEventService.listLiveEvents(status);
    return res.status(200).json({ liveEvents });
  } catch (error) {
    console.error('[Admin Game Events] Failed to list live events', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to list live events' });
  }
});

router.post('/live', async (req: AdminRequest, res) => {
  try {
    const payload = liveEventSchema.parse(req.body);
    const liveEvent = await gameEventService.createLiveEvent({
      ...payload,
      startedAt: payload.startedAt ? new Date(payload.startedAt) : null,
      endsAt: payload.endsAt ? new Date(payload.endsAt) : null,
      createdByAdminId: req.admin?.id,
    });
    return res.status(201).json({ liveEvent });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_ERROR', issues: error.issues });
    }
    console.error('[Admin Game Events] Failed to create live event', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to create live event' });
  }
});

router.patch('/live/:id', async (req, res) => {
  try {
    const id = parseInt(req.params.id as string, 10);
    const payload = liveEventUpdateSchema.parse(req.body);
    const liveEvent = await gameEventService.updateLiveEvent(id, {
      ...payload,
      startedAt: payload.startedAt === undefined ? undefined : payload.startedAt ? new Date(payload.startedAt) : null,
      endsAt: payload.endsAt === undefined ? undefined : payload.endsAt ? new Date(payload.endsAt) : null,
      resolvedAt: payload.resolvedAt === undefined ? undefined : payload.resolvedAt ? new Date(payload.resolvedAt) : null,
    });
    return res.status(200).json({ liveEvent });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_ERROR', issues: error.issues });
    }
    console.error('[Admin Game Events] Failed to update live event', error);
    return res.status(500).json({ error: 'INTERNAL_ERROR', message: 'Failed to update live event' });
  }
});

export default router;