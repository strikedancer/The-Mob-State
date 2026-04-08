import prisma from '../lib/prisma';
import educationTracksData from '../../content/educationTracks.json';
import { worldEventService } from './worldEventService';
import { timeProvider } from '../utils/timeProvider';

type EducationTrackId =
  | 'aviation'
  | 'law'
  | 'medicine'
  | 'finance'
  | 'engineering'
  | 'it';

interface CertificationDefinition {
  id: string;
  name: string;
  requiredLevel: number;
}

interface EducationTrackDefinition {
  id: EducationTrackId;
  name: string;
  description: string;
  maxLevel: number;
  minPlayerRank?: number;
  certifications: CertificationDefinition[];
}

interface EducationGate {
  id: string;
  label: string;
  labelKey: string;
  targetType: 'job' | 'asset' | 'system';
  targetId: string;
  requirements: {
    trackId?: EducationTrackId;
    level?: number;
    certifications?: string[];
    rank?: number;
  };
}

const TRACKS = (educationTracksData as { tracks: EducationTrackDefinition[] }).tracks;

const TRACK_MIN_PLAYER_RANK: Record<EducationTrackId, number> = {
  aviation: 15,
  law: 10,
  medicine: 12,
  finance: 8,
  engineering: 6,
  it: 5,
};

const EDUCATION_GATES: EducationGate[] = [
  {
    id: 'gate_job_programmer',
    label: 'Job: Programmeur',
    labelKey: 'education.gate.job.programmer',
    targetType: 'job',
    targetId: 'programmer',
    requirements: { trackId: 'it', level: 2, certifications: ['software_engineer'] },
  },
  {
    id: 'gate_job_lawyer',
    label: 'Job: Advocaat',
    labelKey: 'education.gate.job.lawyer',
    targetType: 'job',
    targetId: 'lawyer',
    requirements: { trackId: 'law', level: 4, certifications: ['bar_exam'] },
  },
  {
    id: 'gate_job_doctor',
    label: 'Job: Dokter',
    labelKey: 'education.gate.job.doctor',
    targetType: 'job',
    targetId: 'doctor',
    requirements: { trackId: 'medicine', level: 5, certifications: ['medical_license'] },
  },
  {
    id: 'gate_job_airline_pilot',
    label: 'Job: Piloot',
    labelKey: 'education.gate.job.airline_pilot',
    targetType: 'job',
    targetId: 'airline_pilot',
    requirements: { trackId: 'aviation', level: 4, certifications: ['flight_commercial'] },
  },
  {
    id: 'gate_asset_casino_purchase',
    label: 'Asset: Casino aankoop',
    labelKey: 'education.gate.asset.casino_purchase',
    targetType: 'asset',
    targetId: 'casino_purchase',
    requirements: { trackId: 'finance', level: 4, certifications: ['casino_management'] },
  },
  {
    id: 'gate_asset_ammo_factory_purchase',
    label: 'Asset: Munitiefabriek aankoop',
    labelKey: 'education.gate.asset.ammo_factory_purchase',
    targetType: 'asset',
    targetId: 'ammo_factory_purchase',
    requirements: { trackId: 'engineering', level: 3, certifications: ['industrial_safety'] },
  },
  {
    id: 'gate_asset_ammo_factory_upgrade_output',
    label: 'Asset: Munitiefabriek output-upgrade',
    labelKey: 'education.gate.asset.ammo_factory_upgrade_output',
    targetType: 'asset',
    targetId: 'ammo_factory_upgrade_output',
    requirements: { trackId: 'engineering', level: 4 },
  },
  {
    id: 'gate_asset_ammo_factory_upgrade_quality',
    label: 'Asset: Munitiefabriek quality-upgrade',
    labelKey: 'education.gate.asset.ammo_factory_upgrade_quality',
    targetType: 'asset',
    targetId: 'ammo_factory_upgrade_quality',
    requirements: { trackId: 'engineering', level: 5 },
  },
];

interface TrackProgress {
  level: number;
  xp: number;
}

interface PlayerEducationProfile {
  playerId: number;
  tracks: Record<string, TrackProgress>;
  certifications: string[];
}

interface EducationMissingRequirement {
  code:
    | 'RANK_REQUIRED'
    | 'TRACK_LEVEL_REQUIRED'
    | 'CERTIFICATION_REQUIRED';
  reasonKey: string;
  params: Record<string, unknown>;
}

interface EducationEligibilityResult {
  allowed: boolean;
  gateId?: string;
  gateLabelKey?: string;
  missing: EducationMissingRequirement[];
}

interface TrackTrainingResult {
  trackId: string;
  xpGain: number;
  totalXp: number;
  previousLevel: number;
  newLevel: number;
  levelUps: number;
  certificationsEarned: string[];
  cooldownSeconds: number;
}

class EducationService {
  private getTrackMinPlayerRank(trackId: EducationTrackId): number {
    return TRACK_MIN_PLAYER_RANK[trackId] ?? 1;
  }

  private getRequiredXpForLevel(level: number): number {
    const safeLevel = Math.max(0, Math.floor(level));
    if (safeLevel <= 0) return 0;
    if (safeLevel == 1) return 30;
    return 30 + (safeLevel - 1) * 100;
  }

  private randomTrainingXpGain(): number {
    return Math.floor(Math.random() * 16) + 20;
  }

  private getTrainingCooldownSecondsForLevel(level: number): number {
    const safeLevel = Math.max(0, Math.floor(level));
    const baseSeconds = 90;
    const perLevelSeconds = 180;
    const highLevelExtraSeconds = safeLevel > 3 ? (safeLevel - 3) * 120 : 0;

    return Math.min(2400, baseSeconds + safeLevel * perLevelSeconds + highLevelExtraSeconds);
  }

  private async getRemainingTrainingCooldownSeconds(
    playerId: number,
    cooldownSeconds: number
  ): Promise<number> {
    if (cooldownSeconds <= 0) {
      return 0;
    }

    const latestTrackProgressEvents = await prisma.worldEvent.findMany({
      where: {
        playerId,
        eventKey: 'school.track_progress',
      },
      orderBy: { createdAt: 'desc' },
      take: 150,
      select: { createdAt: true, params: true },
    });

    const latestEvent = latestTrackProgressEvents[0];
    if (!latestEvent) {
      return 0;
    }

    const elapsedSeconds = Math.floor(
      (timeProvider.now().getTime() - latestEvent.createdAt.getTime()) / 1000
    );
    const remaining = cooldownSeconds - elapsedSeconds;

    return remaining > 0 ? remaining : 0;
  }

  getTracks(): EducationTrackDefinition[] {
    return TRACKS.map((track) => ({
      ...track,
      minPlayerRank: this.getTrackMinPlayerRank(track.id),
    }));
  }

  getTrack(trackId: string): EducationTrackDefinition | undefined {
    const track = TRACKS.find((entry) => entry.id === trackId);
    if (!track) {
      return undefined;
    }

    return {
      ...track,
      minPlayerRank: this.getTrackMinPlayerRank(track.id),
    };
  }

  getEducationGates(): EducationGate[] {
    return EDUCATION_GATES;
  }

  getJobGate(jobId: string): EducationGate | undefined {
    return EDUCATION_GATES.find(
      (gate) => gate.targetType === 'job' && gate.targetId === jobId
    );
  }

  getAssetGate(assetId: string): EducationGate | undefined {
    return EDUCATION_GATES.find(
      (gate) => gate.targetType === 'asset' && gate.targetId === assetId
    );
  }

  async getPlayerEducationProfile(playerId: number): Promise<PlayerEducationProfile> {
    const educationEvents = await prisma.worldEvent.findMany({
      where: {
        playerId,
        eventKey: {
          in: ['school.track_progress', 'school.level_up', 'school.certification_earned'],
        },
      },
      orderBy: { createdAt: 'asc' },
    });

    const tracks: Record<string, TrackProgress> = {};
    const certifications = new Set<string>();

    for (const track of TRACKS) {
      tracks[track.id] = { level: 0, xp: 0 };
    }

    for (const event of educationEvents) {
      const params = (event.params || {}) as any;

      if (event.eventKey === 'school.track_progress') {
        const trackId = String(params.trackId ?? '');
        if (!tracks[trackId]) continue;

        const xpGain = Number(params.xpGain ?? 0);
        tracks[trackId].xp += Number.isFinite(xpGain) ? Math.max(0, Math.floor(xpGain)) : 0;
      }

      if (event.eventKey === 'school.level_up') {
        const trackId = String(params.trackId ?? '');
        if (!tracks[trackId]) continue;

        const newLevel = Number(params.newLevel ?? 0);
        if (Number.isFinite(newLevel) && newLevel > tracks[trackId].level) {
          tracks[trackId].level = Math.floor(newLevel);
        }
      }

      if (event.eventKey === 'school.certification_earned') {
        const certificationId = String(params.certificationId ?? '');
        if (certificationId) {
          certifications.add(certificationId);
        }
      }
    }

    for (const track of TRACKS) {
      const progress = tracks[track.id];
      let derivedLevel = 0;

      while (
        derivedLevel < track.maxLevel &&
        progress.xp >= this.getRequiredXpForLevel(derivedLevel + 1)
      ) {
        derivedLevel += 1;
      }

      if (derivedLevel > progress.level) {
        progress.level = derivedLevel;
      }
    }

    return {
      playerId,
      tracks,
      certifications: Array.from(certifications),
    };
  }

  async trainTrack(
    playerId: number,
    trackId: string,
    playerRank: number
  ): Promise<TrackTrainingResult> {
    const track = this.getTrack(trackId);
    if (!track) {
      throw new Error('TRACK_NOT_FOUND');
    }

    const minPlayerRank = track.minPlayerRank ?? this.getTrackMinPlayerRank(track.id);
    if (playerRank < minPlayerRank) {
      throw new Error(`TRACK_RANK_TOO_LOW:${minPlayerRank}`);
    }

    const profile = await this.getPlayerEducationProfile(playerId);
    const currentProgress = profile.tracks[track.id] ?? { level: 0, xp: 0 };

    const cooldownSeconds = this.getTrainingCooldownSecondsForLevel(currentProgress.level);
    const remainingCooldown = await this.getRemainingTrainingCooldownSeconds(
      playerId,
      cooldownSeconds
    );
    if (remainingCooldown > 0) {
      throw new Error(`TRACK_ON_COOLDOWN:${remainingCooldown}:${cooldownSeconds}`);
    }

    if (currentProgress.level >= track.maxLevel) {
      throw new Error('TRACK_MAX_LEVEL_REACHED');
    }

    const xpGain = this.randomTrainingXpGain();
    const totalXp = currentProgress.xp + xpGain;
    const previousLevel = currentProgress.level;

    let newLevel = previousLevel;
    while (
      newLevel < track.maxLevel &&
      totalXp >= this.getRequiredXpForLevel(newLevel + 1)
    ) {
      newLevel += 1;
    }

    const certificationsEarned: string[] = [];

    await worldEventService.createEvent(
      'school.track_progress',
      {
        trackId: track.id,
        xpGain,
        totalXp,
      },
      playerId
    );

    if (newLevel > previousLevel) {
      for (let level = previousLevel + 1; level <= newLevel; level += 1) {
        await worldEventService.createEvent(
          'school.level_up',
          {
            trackId: track.id,
            newLevel: level,
            educationLevel: level,
          },
          playerId
        );
      }
    }

    const ownedCertifications = new Set(profile.certifications);
    for (const certification of track.certifications) {
      if (certification.requiredLevel <= newLevel && !ownedCertifications.has(certification.id)) {
        certificationsEarned.push(certification.id);
        await worldEventService.createEvent(
          'school.certification_earned',
          {
            trackId: track.id,
            certificationId: certification.id,
            certificationName: certification.name,
          },
          playerId
        );
      }
    }

    return {
      trackId: track.id,
      xpGain,
      totalXp,
      previousLevel,
      newLevel,
      levelUps: Math.max(0, newLevel - previousLevel),
      certificationsEarned,
      cooldownSeconds,
    };
  }

  async checkJobEligibility(
    playerId: number,
    jobId: string,
    playerRank: number
  ): Promise<EducationEligibilityResult> {
    const profile = await this.getPlayerEducationProfile(playerId);
    return this.checkJobEligibilityWithProfile(profile, jobId, playerRank);
  }

  checkJobEligibilityWithProfile(
    profile: PlayerEducationProfile,
    jobId: string,
    playerRank: number
  ): EducationEligibilityResult {
    const gate = this.getJobGate(jobId);
    if (!gate) {
      return { allowed: true, missing: [] };
    }

    return this.checkEligibilityWithGate(profile, gate, playerRank);
  }

  async checkAssetEligibility(
    playerId: number,
    assetId: string,
    playerRank: number
  ): Promise<EducationEligibilityResult> {
    const profile = await this.getPlayerEducationProfile(playerId);
    return this.checkAssetEligibilityWithProfile(profile, assetId, playerRank);
  }

  checkAssetEligibilityWithProfile(
    profile: PlayerEducationProfile,
    assetId: string,
    playerRank: number
  ): EducationEligibilityResult {
    const gate = this.getAssetGate(assetId);
    if (!gate) {
      return { allowed: true, missing: [] };
    }

    return this.checkEligibilityWithGate(profile, gate, playerRank);
  }

  private checkEligibilityWithGate(
    profile: PlayerEducationProfile,
    gate: EducationGate,
    _playerRank: number
  ): EducationEligibilityResult {

    const missing: EducationMissingRequirement[] = [];

    if (gate.requirements.trackId && typeof gate.requirements.level === 'number') {
      const currentLevel = profile.tracks[gate.requirements.trackId]?.level ?? 0;
      if (currentLevel < gate.requirements.level) {
        missing.push({
          code: 'TRACK_LEVEL_REQUIRED',
          reasonKey: 'education.requirement.track_level',
          params: {
            trackId: gate.requirements.trackId,
            requiredLevel: gate.requirements.level,
            currentLevel,
          },
        });
      }
    }

    for (const certificationId of gate.requirements.certifications ?? []) {
      if (!profile.certifications.includes(certificationId)) {
        missing.push({
          code: 'CERTIFICATION_REQUIRED',
          reasonKey: 'education.requirement.certification',
          params: { certificationId },
        });
      }
    }

    return {
      allowed: missing.length === 0,
      gateId: gate.id,
      gateLabelKey: gate.labelKey,
      missing,
    };
  }
}

export const educationService = new EducationService();
