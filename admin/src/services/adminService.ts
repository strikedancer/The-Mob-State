const resolveApiUrl = (): string => {
  const envUrl = import.meta.env.VITE_ADMIN_API_URL?.trim();
  if (envUrl) return envUrl;

  if (typeof window !== "undefined" && window.location.protocol === "https:") {
    return `https://${window.location.hostname}:3443`;
  }

  return "http://localhost:3000";
};

const API_URL = resolveApiUrl();

/** Game origin where `/images/*` is served (custom portraits). Override with `VITE_GAME_PUBLIC_ORIGIN` in admin `.env` if needed. */
export function resolveGamePublicOrigin(): string {
  const v = import.meta.env.VITE_GAME_PUBLIC_ORIGIN?.trim();
  if (v) return v.replace(/\/$/, "");
  if (typeof window !== "undefined") {
    const { protocol, hostname } = window.location;
    if (hostname === "localhost" || hostname === "127.0.0.1") {
      return "http://localhost:8080";
    }
    if (hostname.startsWith("admin.")) {
      return `${protocol}//${hostname.replace(/^admin\./, "")}`;
    }
    return window.location.origin;
  }
  return "https://themobstate.com";
}

export function portraitPublicImageUrl(imagePath: string): string {
  const path = imagePath.replace(/^\/+/, "");
  return `${resolveGamePublicOrigin()}/images/${path}`;
}

const parseErrorMessage = async (
  response: Response,
  fallback: string,
): Promise<string> => {
  const payload = await response.json().catch(() => null as any);
  const base = payload?.message || payload?.error || fallback;
  if (Array.isArray(payload?.details) && payload.details.length > 0) {
    const extra = payload.details
      .map((detail: { path?: Array<string | number>; message?: string }) => {
        const path = Array.isArray(detail?.path) ? detail.path.join(".") : "";
        return [path, detail?.message].filter(Boolean).join(": ");
      })
      .filter(Boolean)
      .join("; ");
    return extra ? `${base} (${extra})` : base;
  }
  return base;
};

const ensureOk = async (
  response: Response,
  fallback: string,
): Promise<void> => {
  if (response.status === 401) {
    adminAuthService.logout();
    throw new Error("UNAUTHORIZED");
  }

  if (!response.ok) {
    throw new Error(await parseErrorMessage(response, fallback));
  }
};

interface AdminLoginResponse {
  token: string;
  admin: {
    id: number;
    username: string;
    role: string;
  };
}

export interface PremiumOffer {
  id: number;
  key: string;
  titleNl: string;
  titleEn: string;
  imageUrl: string | null;
  priceEurCents: number;
  rewardType: "money" | "ammo" | "credits";
  moneyAmount: number | null;
  ammoType: string | null;
  ammoQuantity: number | null;
  creditAmount: number | null;
  isActive: boolean;
  showPopupOnOpen: boolean;
  sortOrder: number;
}

export interface CreatePremiumOfferPayload {
  key: string;
  titleNl: string;
  titleEn: string;
  imageUrl: string | null;
  priceEurCents: number;
  rewardType: "money" | "ammo" | "credits";
  moneyAmount: number | null;
  ammoType: string | null;
  ammoQuantity: number | null;
  creditAmount: number | null;
  isActive: boolean;
  showPopupOnOpen: boolean;
  notifyAllPlayers: boolean;
  sortOrder: number;
}

export interface CreditShopItem {
  id: number;
  key: string;
  titleNl: string;
  titleEn: string;
  descriptionNl: string | null;
  descriptionEn: string | null;
  creditCost: number;
  effectType:
    | "CASH_BUNDLE"
    | "HIT_PROTECTION"
    | "VEHICLE_REPAIR_FINISH"
    | "VEHICLE_TUNE_RESET"
    | "ACTION_COOLDOWN_RESET"
    | "EVENT_BOOST";
  moneyAmount: number | null;
  durationHours: number | null;
  actionType: string | null;
  metadataJson: string | null;
  isActive: boolean;
  sortOrder: number;
}

export interface CreateCreditShopItemPayload {
  key: string;
  titleNl: string;
  titleEn: string;
  descriptionNl: string | null;
  descriptionEn: string | null;
  creditCost: number;
  effectType: CreditShopItem["effectType"];
  moneyAmount: number | null;
  durationHours: number | null;
  actionType: string | null;
  metadataJson: string | null;
  isActive: boolean;
  sortOrder: number;
}

export interface PlayerOverview {
  player: {
    id: number;
    username: string;
    email: string | null;
    money: number;
    rank: number;
    xp: number;
    health: number;
    currentCountry: string;
    isVip: boolean;
    vipExpiresAt: string | null;
    isBanned: boolean;
    bannedUntil: string | null;
    banReason: string | null;
    wantedLevel: number;
    fbiHeat: number;
    reputation: number;
    premiumCredits: number;
    killCount: number;
    hitCount: number;
    inventory_slots_used: number;
    max_inventory_slots: number;
    createdAt: string;
    updatedAt: string;
  };
  stats: {
    crimes: {
      total: number;
      success: number;
      failed: number;
      jailed: number;
      totalReward: number;
      totalXp: number;
      totalJailTime: number;
      totalLoot: number;
    };
    jobs: {
      total: number;
      totalEarnings: number;
      totalXp: number;
    };
    flights: {
      total: number;
    };
  };
  projections: {
    crimesPerDay: number;
    jobsPerDay: number;
    travelsPerDay: number;
    avgDailyIncome: number;
    avgDailyXp: number;
    xpToNextRank: number;
    estimatedDaysToNextRank: number | null;
  };
  assets: {
    properties: any[];
    tools: any[];
    inventory: any[];
    vehicles: any[];
    ammo: Array<{
      ammoType: string;
      quantity: number;
      quality: number;
      name?: string;
    }>;
    weapons: Array<{
      weaponId: string;
      quantity: number;
      condition: number | null;
      name?: string;
      location?: string;
    }>;
  };
  assetSummary?: {
    ammoTotalRounds: number;
    ammoDistinctTypes: number;
    weaponTotalUnits: number;
    weaponDistinctTypes: number;
  };
  history: {
    recentActivities: any[];
    recentCrimes: any[];
    recentJobs: any[];
  };
  financial: {
    bankAccount: {
      balance: number;
      interestRate: number;
      updatedAt: string;
    } | null;
    casinoAsPlayer: Array<{
      id: number;
      casinoId: string;
      gameType: string;
      betAmount: number;
      payout: number;
      ownerCut: number;
      createdAt: string;
    }>;
    casinoAsOwner: Array<{
      id: number;
      playerId: number;
      casinoId: string;
      gameType: string;
      betAmount: number;
      payout: number;
      ownerCut: number;
      createdAt: string;
    }>;
    casinoAsPlayerTotals: {
      totalBet: number;
      totalPayout: number;
      netResult: number;
    };
    casinoAsOwnerTotals: {
      totalOwnerCut: number;
      totalBet: number;
      totalPayout: number;
    };
    premiumTransactions: Array<{
      id: number;
      checkoutType: "PLAYER_VIP" | "CREW_VIP" | "ONE_TIME";
      productKey: string | null;
      status: "OPEN" | "PENDING" | "PAID" | "CANCELED" | "FAILED" | "EXPIRED";
      amountValue: string;
      providerPaymentId: string | null;
      providerSubscriptionId: string | null;
      paidAt: string | null;
      createdAt: string;
    }>;
    premiumFulfillments: Array<{
      id: number;
      stripeSessionId: string;
      productKey: string;
      fulfilledAt: string;
    }>;
  };
}

export interface AdminTestPushResponse {
  message: string;
  player: {
    id: number;
    username: string;
  };
  deviceCount: number;
}

export interface AdminTerritoryOverview {
  config: {
    contestPrepMinutes: number;
    contestActiveMinutes: number;
    contestLockdownMinutes: number;
    actionCooldownSeconds: number;
    actionDailyCap: number;
    captureThresholdPercent: number;
    maxRegionsPerCrew: number;
    maxConcurrentContestsPerCrew: number;
    passiveIncomeIntervalMinutes: number;
    hqRegionCapPerLevel?: number;
    hqRegionCapBonusCap?: number;
    hqContestCapPerLevel?: number;
    hqContestCapBonusCap?: number;
    hqActionPointBonusPerLevel?: number;
    hqActionPointBonusCap?: number;
    crewMissionActionPointBonusPerLevel?: number;
    crewMissionActionPointBonusCap?: number;
    weaponStorageDefenseBonusPerLevel?: number;
    ammoStorageDefenseBonusPerLevel?: number;
    carStorageRaidBonusPerLevel?: number;
    boatStorageSupplyBonusPerLevel?: number;
    drugStorageSabotageBonusPerLevel?: number;
    buildingActionBonusCap?: number;
    actionUnlockHqLevelPatrol?: number;
    actionUnlockHqLevelIntelScan?: number;
    actionUnlockHqLevelSabotage?: number;
    actionUnlockHqLevelSupplyRun?: number;
    actionUnlockHqLevelRaid?: number;
    actionUnlockHqLevelDefense?: number;
  };
  activeSeason: {
    seasonKey: string;
    status: string;
    startsAt: string;
    endsAt: string;
  } | null;
  seasons: Array<{
    seasonKey: string;
    status: string;
    startsAt: string;
    endsAt: string;
  }>;
  countries: Array<{
    id: number;
    countryCode: string;
    displayNameNl: string;
    displayNameEn: string;
    svgAssetKey: string;
    enabled: number;
  }>;
  crews: Array<{
    id: number;
    name: string;
  }>;
  leaderboard: Array<{
    crewId: number;
    crewName: string;
    regionsOwned: number;
    totalControl: number;
  }>;
  summary: {
    enabledCountries: number;
    enabledRegions: number;
    activeContests: number;
    controlledRegions: number;
  };
  telemetry?: {
    windowHours: number;
    rewardPerMinute: {
      totalCash: number;
      totalXp: number;
      totalRewards: number;
      cashPerMinute: number;
      rewardsPerMinute: number;
      byValueTier: Array<{
        valueTier: number;
        cashAmount: number;
        rewards: number;
        cashPerMinute: number;
      }>;
    };
    contestWinrateByHqBand: Array<{
      hqBand: string;
      contests: number;
      wins: number;
      winratePercent: number;
    }>;
    regionGrowthByCrewSize: Array<{
      crewSizeBand: string;
      crews: number;
      totalRegionsCaptured: number;
      avgRegionsCaptured: number;
    }>;
    bonusUsageByTier: {
      hqBand: Array<{
        hqBand: string;
        actions: number;
        totalBonusPoints: number;
        avgBonusPoints: number;
      }>;
      buildingTier: Array<{
        buildingTier: string;
        actions: number;
        totalBonusPoints: number;
        avgBonusPoints: number;
      }>;
    };
  };
  contests: Array<{
    id: number;
    regionKey: string;
    regionNameNl: string;
    countryCode: string;
    status: string;
    attackerCrewId: number;
    attackerCrewName: string | null;
    defenderCrewId: number | null;
    defenderCrewName: string | null;
    winnerCrewId: number | null;
    winnerCrewName: string | null;
    startedAt: string;
    activeAt: string | null;
    lockdownAt: string | null;
    resolveAt: string | null;
    resolvedAt: string | null;
  }>;
  regions: Array<{
    regionKey: string;
    countryCode: string;
    nameNl: string;
    nameEn: string;
    svgElementId: string;
    valueTier: number;
    ownerCrewId: number | null;
    ownerCrewName: string | null;
    stability: number;
    activeContestId: number | null;
    activeContestStatus: string | null;
  }>;
}

export interface ManagePlayerPayload {
  playerId: number;
  reason?: string;
  set?: {
    money?: number;
    rank?: number;
    xp?: number;
    health?: number;
    premiumCredits?: number;
    currentCountry?: string;
  };
  add?: {
    money?: number;
    xp?: number;
    premiumCredits?: number;
  };
  vip?: {
    enabled: boolean;
    days?: number;
  };
  ammo?: {
    ammoType: string;
    quantity: number;
  };
  tool?: {
    toolId: string;
    quantity: number;
    durability?: number;
    location?: string;
  };
}

export interface RecentActivityItem {
  id: number;
  activityType: string;
  description: string;
  details: any;
  createdAt: string;
}

export interface PlayerRecentActivitiesResponse {
  items: RecentActivityItem[];
  total: number;
  page: number;
  totalPages: number;
  availableTypes: string[];
  summary: {
    totalMoney: number;
    totalXp: number;
  };
  trend: Array<{
    date: string;
    count: number;
    money: number;
    xp: number;
  }>;
}

export interface SystemHealthDetails {
  status: "ok" | "degraded" | "down";
  timestamp: string;
  uptime: number;
  environment: string;
  responseTimeMs: number;
  components: {
    api: { status: "ok" | "degraded" | "down" };
    database: { status: "ok" | "degraded" | "down"; error?: string | null };
    redis: { status: "ok" | "degraded" | "down" };
    queue: { status: "ok" | "degraded" | "down" };
    cron: {
      status: "ok" | "degraded" | "down";
      jobs: Record<string, string>;
      lastExecutions: Record<string, string>;
    };
  };
}

export interface DashboardOverview {
  alerts: Array<{
    severity: "danger" | "warning" | "info";
    title: string;
    description: string;
  }>;
  activityFeed: Array<{
    id: string;
    type: "audit" | "system";
    title: string;
    description: string;
    createdAt: string;
  }>;
  trends: {
    activePlayers: Array<{ date: string; value: number }>;
    registrations: Array<{ date: string; value: number }>;
    adminActions: Array<{ date: string; value: number }>;
  };
  riskPlayers: Array<{
    id: number;
    username: string;
    money: number;
    rank: number;
    health: number;
    isBanned: boolean;
    wantedLevel: number;
    fbiHeat: number;
    updatedAt: string;
    currentCountry: string;
    riskScore: number;
  }>;
  quickStats: {
    systemErrors24h: number;
    adminActions24h: number;
  };
}

export interface EconomyLoopTelemetry {
  attempts: number;
  successes: number;
  failures: number;
  jailed: number;
  successRate: number;
  failRate: number;
  jailRate: number;
  payoutPerMinute: number;
  xpPerMinute: number;
  averageCooldownSeconds: number;
  totalPayout: number;
  totalXp: number;
}

export interface EconomyBalanceTelemetry {
  generatedAt: string;
  windowHours: number;
  from: string;
  diminishing: {
    sessionWindowMinutes: number;
    curve: Array<{
      minAttempts: number;
      multiplier: number;
    }>;
  };
  loops: {
    crimes: EconomyLoopTelemetry;
    jobs: EconomyLoopTelemetry;
    vehicleTheft: EconomyLoopTelemetry;
  };
  cooldownSkips: {
    total: number;
    byActionType: Record<string, number>;
  };
}

export interface CrewMissionRoleTelemetry {
  roleKey: string;
  assignments: number;
  distinctPlayers: number;
  avgContributionScore: number;
  avgPayoutMultiplier: number;
  avgRewardXp: number;
}

export interface CrewMissionTopContributorTelemetry {
  playerId: number;
  username: string;
  assignments: number;
  avgContributionScore: number;
  avgPayoutMultiplier: number;
  totalRewardXp: number;
}

export interface CrewMissionTelemetry {
  windowHours: number;
  summary: {
    started: number;
    completed: number;
    successCount: number;
    partialCount: number;
    failCount: number;
    successRate: number;
    rewardCrewCash: number;
    rewardCrewXp: number;
    rewardPersonalXp: number;
  };
  byMission: Array<{
    missionKey: string;
    tier: number;
    started: number;
    completed: number;
    successCount: number;
    partialCount: number;
    failCount: number;
    rewardCrewCash: number;
    payoutPerMinute: number;
  }>;
  speedups: {
    total: number;
    byTier: Record<string, number>;
  };
  contributions: {
    assignments: number;
    distinctPlayers: number;
    avgContributionScore: number;
    avgPayoutMultiplier: number;
    reducedPayoutCount: number;
    totalRewardXp: number;
    byRole: CrewMissionRoleTelemetry[];
    topContributors: CrewMissionTopContributorTelemetry[];
  };
  serverTime: string;
}

export interface CrewMissionRuntimeConfigView {
  defaults: Record<string, string>;
  values: Record<string, string | number>;
  keys: string[];
}

export type CountryPoliceRuntimeConfigView = CrewMissionRuntimeConfigView;
export type CasinoRuntimeConfigView = CrewMissionRuntimeConfigView;
export type DrugRuntimeConfigView = CrewMissionRuntimeConfigView;

export interface VehicleOpsTelemetry {
  windowHours: number;
  from: string;
  to: string;
  totals: {
    events: number;
    attempts: number;
    successes: number;
    failures: number;
    moneyIn: number;
    moneyOut: number;
  };
  byActionType: Record<
    string,
    {
      attempts: number;
      successes: number;
      failures: number;
      moneyIn: number;
      moneyOut: number;
    }
  >;
  mapLayers: {
    byVehicleType: Record<
      string,
      {
        attempts: number;
        successes: number;
        failures: number;
      }
    >;
    byRegion: Record<
      string,
      {
        attempts: number;
        successes: number;
        failures: number;
      }
    >;
  };
}

export interface SupportTicketSummary {
  id: number;
  playerId: number;
  username: string;
  category: string;
  subject: string;
  status:
    | "new"
    | "open"
    | "triage"
    | "in_progress"
    | "waiting_player"
    | "blocked"
    | "resolved"
    | "closed"
    | "archived";
  priority: "low" | "normal" | "high" | "urgent";
  sourceModule?: string | null;
  referenceCode?: string | null;
  assignedAdminId?: number | null;
  assignedAdminUsername?: string | null;
  updatedAt: string;
  createdAt: string;
  firstResponseAt?: string | null;
  resolvedAt?: string | null;
  archivedAt?: string | null;
  attachmentCount: number;
  openTodoCount: number;
  ageHours?: number;
  lastMessageBy?: "player" | "admin" | "none";
}

export interface SupportTicketMessage {
  id: number;
  ticketId: number;
  senderType: "player" | "admin" | "system";
  messageType?: "public_reply" | "internal_note";
  message: string;
  createdAt: string;
  playerId?: number | null;
  adminId?: number | null;
  adminUsername?: string | null;
  isInternal?: number;
}

export interface SupportTicketTodoComment {
  id: number;
  todoId: number;
  adminId: number;
  adminUsername?: string | null;
  comment: string;
  createdAt: string;
  updatedAt: string;
}

export interface SupportTicketTodo {
  id: number;
  ticketId: number | null;
  title: string;
  description: string | null;
  status: "open" | "in_progress" | "blocked" | "done";
  priority?: "low" | "normal" | "high" | "urgent";
  moduleKey?: string | null;
  dueAt?: string | null;
  assignedAdminId?: number | null;
  assignedAdminUsername?: string | null;
  createdAt: string;
  updatedAt: string;
  resolvedAt: string | null;
  ticketSubject?: string | null;
  ticketStatus?:
    | "new"
    | "open"
    | "triage"
    | "in_progress"
    | "waiting_player"
    | "blocked"
    | "resolved"
    | "closed"
    | "archived"
    | null;
  playerUsername?: string | null;
  comments?: SupportTicketTodoComment[];
}

export interface SupportTicketAttachment {
  id: number;
  ticketId: number;
  playerId: number;
  originalName: string;
  mimeType: string;
  fileSize: number;
  createdAt: string;
  url: string;
  previewDataUrl?: string | null;
}

export interface SupportTicketDetailResponse {
  ticket: SupportTicketSummary;
  messages: SupportTicketMessage[];
  todos: SupportTicketTodo[];
  attachments: SupportTicketAttachment[];
}

export interface SupportReplyTemplate {
  key: string;
  labelNl: string;
  labelEn: string;
  bodyNl: string;
  bodyEn: string;
  suggestedStatus: SupportTicketSummary["status"];
}

export interface SupportAnalyticsResponse {
  totals: {
    totalTickets: number;
    activeTickets: number;
    urgentTickets: number;
    avgFirstResponseMinutes: number;
    avgResolutionMinutes: number;
  };
  byCategory: Array<{ category: string; total: number }>;
  byAssignee: Array<{ label: string; total: number }>;
}

export interface SystemLogEntry {
  id: number;
  eventKey: string;
  params: {
    source?: string;
    message?: string;
    details?: string | null;
    loggedAt?: string;
  };
  createdAt: string;
}

export interface SystemLogFilters {
  dateRange?: "1h" | "24h" | "7d" | "30d" | "all";
  source?: string;
  search?: string;
}

export interface AdminAccount {
  id: number;
  username: string;
  role: "SUPER_ADMIN" | "MODERATOR" | "VIEWER";
  isActive: boolean;
  createdAt: string;
  lastLoginAt: string | null;
}

export interface GameEventTemplate {
  id: number;
  key: string;
  category: string;
  eventType: string;
  titleNl: string;
  titleEn: string;
  shortDescriptionNl?: string | null;
  shortDescriptionEn?: string | null;
  descriptionNl?: string | null;
  descriptionEn?: string | null;
  icon?: string | null;
  bannerImage?: string | null;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CreateGameEventTemplatePayload {
  key: string;
  category: string;
  eventType: string;
  titleNl: string;
  titleEn: string;
  shortDescriptionNl?: string | null;
  shortDescriptionEn?: string | null;
  descriptionNl?: string | null;
  descriptionEn?: string | null;
  icon?: string | null;
  bannerImage?: string | null;
  isActive?: boolean;
}

export interface GameEventSchedule {
  id: number;
  templateId: number;
  scheduleType: string;
  intervalMinutes?: number | null;
  durationMinutes?: number | null;
  cooldownMinutes?: number | null;
  enabled: boolean;
  weight: number;
  createdAt: string;
  updatedAt: string;
}

export interface CreateGameEventSchedulePayload {
  templateId: number;
  scheduleType: string;
  intervalMinutes?: number | null;
  durationMinutes?: number | null;
  cooldownMinutes?: number | null;
  enabled?: boolean;
  weight?: number;
}

export interface GameLiveEvent {
  id: number;
  templateId: number;
  status: string;
  startedAt?: string | null;
  endsAt?: string | null;
  resolvedAt?: string | null;
  createdAt: string;
  updatedAt: string;
  template?: {
    id: number;
    key: string;
    titleNl?: string;
    titleEn?: string;
  };
}

export interface CreateGameLiveEventPayload {
  templateId: number;
  status?: string;
  startedAt?: string | null;
  endsAt?: string | null;
  configJson?: Record<string, unknown>;
  stateJson?: Record<string, unknown>;
  announcementJson?: Record<string, unknown>;
  scopeJson?: Record<string, unknown>;
}

export interface AdminCrewWarStanding {
  rank: number;
  crewId: number;
  totalPoints: number;
  totalKills: number;
  totalLoot: number;
  crew: {
    id: number;
    name: string;
    isVip?: boolean;
    vipExpiresAt?: string | null;
    bankBalance?: number;
  } | null;
}

export interface AdminCrewWarDetail {
  id: number;
  seasonId?: number | null;
  warType: "kill_war" | "economy_war" | "territory_war" | "total_war";
  status:
    | "preparing"
    | "active"
    | "lockdown"
    | "resolved"
    | "archived"
    | "cancelled";
  attackerCrewId: number;
  defenderCrewId: number;
  winnerCrewId?: number | null;
  activeFrom: string;
  lockDownFrom: string;
  endTime: string;
  createdAt: string;
  attackerCrew?: { id: number; name: string } | null;
  defenderCrew?: { id: number; name: string } | null;
  standings: Array<{
    crewId: number;
    totalPoints: number;
    totalKills: number;
    totalDeaths: number;
    totalLoot: number;
    territoriesHeld: number;
    rank: number;
    crew: { id: number; name: string } | null;
  }>;
  recentActions: Array<{
    id: number;
    actionType: string;
    result: string;
    pointsAwarded: number;
    moneyDelta: number;
    createdAt: string;
    actor?: { id: number; username: string } | null;
    target?: { id: number; username: string } | null;
  }>;
}

export interface AdminCrewWarOverview {
  season: {
    id: number;
    seasonKey: string;
    startsAt: string;
    endsAt: string;
    status: string;
  };
  flaggedActions: number;
  crews: Array<{
    id: number;
    name: string;
    isVip?: boolean;
    vipExpiresAt?: string | null;
    bankBalance?: number;
  }>;
  activeWars: AdminCrewWarDetail[];
  recentWars: Array<{
    id: number;
    warType: string;
    status: string;
    attackerCrewId: number;
    defenderCrewId: number;
    winnerCrewId?: number | null;
    createdAt: string;
    resolvedAt?: string | null;
  }>;
  seasonLeaderboard: AdminCrewWarStanding[];
}

export interface AdminImageLibraryFolder {
  name: string;
  path: string;
}

export interface AdminImageLibraryFile {
  name: string;
  path: string;
  sizeBytes: number;
  updatedAt: string;
  url: string;
}

export interface AdminImageLibraryResponse {
  root: string;
  folder: string;
  parentFolder: string;
  folders: AdminImageLibraryFolder[];
  files: AdminImageLibraryFile[];
}

export interface AdminImageModuleOverviewResponse {
  root: string;
  moduleFilter: string;
  search: string;
  modules: Array<{ module: string; count: number }>;
  totalMatches: number;
  files: Array<AdminImageLibraryFile & { module: string }>;
}

export const adminAuthService = {
  async login(username: string, password: string): Promise<AdminLoginResponse> {
    const response = await fetch(`${API_URL}/admin/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    });

    if (!response.ok) {
      throw new Error("Login failed");
    }

    const data = await response.json();
    localStorage.setItem("admin_token", data.token);
    if (data?.admin?.role) {
      localStorage.setItem("admin_role", data.admin.role);
    }
    return data;
  },

  logout() {
    localStorage.removeItem("admin_token");
    localStorage.removeItem("admin_role");
  },

  getToken() {
    return localStorage.getItem("admin_token");
  },

  isAuthenticated() {
    return !!this.getToken();
  },

  getAdminRole() {
    return localStorage.getItem("admin_role") as
      | "SUPER_ADMIN"
      | "MODERATOR"
      | "VIEWER"
      | null;
  },
};

export const adminService = {
  async getDashboardOverview(): Promise<DashboardOverview> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/dashboard-overview`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch dashboard overview");
    return response.json();
  },

  async getEconomyBalanceTelemetry(
    hours = 24,
  ): Promise<EconomyBalanceTelemetry> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      hours: String(hours),
    });
    const response = await fetch(
      `${API_URL}/admin/economy/balance-telemetry?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch economy balance telemetry");
    return response.json();
  },

  async getCrewMissionTelemetry(hours = 24): Promise<CrewMissionTelemetry> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      hours: String(hours),
    });
    const response = await fetch(
      `${API_URL}/admin/crew-missions/telemetry?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch crew mission telemetry");
    return response.json();
  },

  async getCrewMissionRuntimeConfig(): Promise<CrewMissionRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crew-missions/runtime-config`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch crew mission runtime config");
    return response.json();
  },

  async updateCrewMissionRuntimeConfig(
    updates: Record<string, string | number>,
  ): Promise<CrewMissionRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crew-missions/runtime-config`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ updates }),
    });

    await ensureOk(response, "Failed to update crew mission runtime config");
    return response.json();
  },

  async getCasinoRuntimeConfig(): Promise<CasinoRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/casino/runtime-config`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch casino runtime config");
    return response.json();
  },

  async updateCasinoRuntimeConfig(
    updates: Record<string, string | number>,
  ): Promise<CasinoRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/casino/runtime-config`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ updates }),
    });

    await ensureOk(response, "Failed to update casino runtime config");
    return response.json();
  },

  async getDrugRuntimeConfig(): Promise<DrugRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/drugs/runtime-config`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch drugs runtime config");
    return response.json();
  },

  async updateDrugRuntimeConfig(
    updates: Record<string, string | number>,
  ): Promise<DrugRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/drugs/runtime-config`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ updates }),
    });

    await ensureOk(response, "Failed to update drugs runtime config");
    return response.json();
  },

  async getCountryPoliceRuntimeConfig(): Promise<CountryPoliceRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/country-police/runtime-config`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch country police runtime config");
    return response.json();
  },

  async updateCountryPoliceRuntimeConfig(
    updates: Record<string, string | number>,
  ): Promise<CountryPoliceRuntimeConfigView> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/country-police/runtime-config`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ updates }),
    });

    await ensureOk(response, "Failed to update country police runtime config");
    return response.json();
  },

  async getVehicleOpsTelemetry(hours = 24): Promise<VehicleOpsTelemetry> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      hours: String(hours),
    });
    const response = await fetch(
      `${API_URL}/admin/vehicle-ops/telemetry?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch vehicle ops telemetry");
    return response.json();
  },

  async getSystemHealthDetails(): Promise<SystemHealthDetails> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/health/details`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch system health details");
    return response.json();
  },

  async getStats() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/stats`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch stats");

    return response.json();
  },

  async getPlayers(page = 1, limit = 20, search = "") {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      page: String(page),
      limit: String(limit),
      search,
    });
    const response = await fetch(
      `${API_URL}/admin/players?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch players");

    return response.json();
  },

  async getAuditLogs(page = 1, limit = 50) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/audit-logs?page=${page}&limit=${limit}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch audit logs");

    return response.json();
  },

  async getSystemLogs(page = 1, limit = 50, filters: SystemLogFilters = {}) {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      page: String(page),
      limit: String(limit),
      dateRange: filters.dateRange || "7d",
      source: filters.source || "all",
      search: filters.search || "",
    });
    const response = await fetch(
      `${API_URL}/admin/system-logs?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch system logs");

    return response.json();
  },

  async clearSystemLogs(filters: SystemLogFilters = {}) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/system-logs`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        dateRange: filters.dateRange || "7d",
        source: filters.source || "all",
        search: filters.search || "",
      }),
    });

    await ensureOk(response, "Failed to clear system logs");

    return response.json();
  },

  async getAdmins() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/admins`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch admins");

    return response.json();
  },

  async createAdmin(payload: {
    username: string;
    password: string;
    role: "SUPER_ADMIN" | "MODERATOR" | "VIEWER";
  }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/admins`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to create admin");

    return response.json();
  },

  async updateAdmin(
    adminId: number,
    payload: {
      role?: "SUPER_ADMIN" | "MODERATOR" | "VIEWER";
      isActive?: boolean;
      password?: string;
    },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/admins/${adminId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to update admin");

    return response.json();
  },

  async banPlayer(playerId: number, reason: string, duration?: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/ban`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ playerId, reason, duration }),
    });

    await ensureOk(response, "Failed to ban player");

    return response.json();
  },

  async unbanPlayer(playerId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/unban`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ playerId }),
    });

    if (!response.ok) {
      throw new Error("Failed to unban player");
    }

    return response.json();
  },

  async editPlayer(playerId: number, updates: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/edit`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ playerId, updates }),
    });

    await ensureOk(response, "Failed to edit player");

    return response.json();
  },

  async getPlayerOverview(playerId: number): Promise<PlayerOverview> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/players/${playerId}/overview`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch player overview");

    return response.json();
  },

  async sendPlayerTestPush(
    playerId: number,
    payload: {
      title: string;
      body: string;
      dataType?: string;
    },
  ): Promise<AdminTestPushResponse> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/players/${playerId}/test-push`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );

    await ensureOk(response, "Failed to send test push");

    return response.json();
  },

  async getPlayerRecentActivities(params: {
    playerId: number;
    page?: number;
    limit?: number;
    dateRange?: "24h" | "7d" | "30d" | "all";
    typeFilter?: string;
    search?: string;
    sort?: "date_desc" | "date_asc" | "type_asc" | "type_desc";
  }): Promise<PlayerRecentActivitiesResponse> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      page: String(params.page ?? 1),
      limit: String(params.limit ?? 10),
      dateRange: params.dateRange ?? "7d",
      typeFilter: params.typeFilter ?? "all",
      search: params.search ?? "",
      sort: params.sort ?? "date_desc",
    });

    const response = await fetch(
      `${API_URL}/admin/players/${params.playerId}/recent-activities?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch recent activities");

    return response.json();
  },

  async exportPlayerRecentActivities(params: {
    playerId: number;
    dateRange?: "24h" | "7d" | "30d" | "all";
    typeFilter?: string;
    search?: string;
    sort?: "date_desc" | "date_asc" | "type_asc" | "type_desc";
  }): Promise<Blob> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      dateRange: params.dateRange ?? "7d",
      typeFilter: params.typeFilter ?? "all",
      search: params.search ?? "",
      sort: params.sort ?? "date_desc",
    });

    const response = await fetch(
      `${API_URL}/admin/players/${params.playerId}/recent-activities/export?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to export recent activities");
    return response.blob();
  },

  async bulkPlayerAction(payload: {
    playerIds: number[];
    action: "warn" | "ban_temp" | "add_money";
    reason: string;
    durationHours?: number;
    amount?: number;
  }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/bulk-action`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to execute bulk action");
    return response.json();
  },

  async managePlayer(payload: ManagePlayerPayload) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/manage`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to manage player");

    return response.json();
  },

  async resetPlayerProgress(playerId: number, reason?: string): Promise<{
    message: string;
    playerId: number;
    username: string;
    preservedPaidCredits: number;
    previousCredits: number;
    vipKept: { isVip: boolean; vipExpiresAt: string | null; autoRenewActive: boolean };
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/${playerId}/reset`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ reason }),
    });

    await ensureOk(response, "Failed to reset player progress");
    return response.json();
  },

  async resetAllPlayersProgress(reason?: string): Promise<{
    message: string;
    affectedPlayers: number;
    preservedPaidCreditsTotal: number;
    vipKept: boolean;
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/reset-all`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ reason }),
    });

    await ensureOk(response, "Failed to reset all players progress");
    return response.json();
  },

  async getTickets(
    status:
      | "all"
      | "new"
      | "open"
      | "triage"
      | "in_progress"
      | "waiting_player"
      | "blocked"
      | "resolved"
      | "closed"
      | "archived" = "all",
  ): Promise<{ tickets: SupportTicketSummary[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/tickets?status=${encodeURIComponent(status)}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch tickets");
    return response.json();
  },

  async getTicketDetail(
    ticketId: number,
  ): Promise<SupportTicketDetailResponse> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tickets/${ticketId}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch ticket detail");
    return response.json();
  },

  async getSupportAnalytics(): Promise<SupportAnalyticsResponse> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/support-analytics`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch support analytics");
    return response.json();
  },

  async getSupportReplyTemplates(): Promise<{
    templates: SupportReplyTemplate[];
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/support-reply-templates`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch support reply templates");
    return response.json();
  },

  async replyToTicket(
    ticketId: number,
    payload: {
      message?: string;
      templateKey?: string;
      messageType?: "public_reply" | "internal_note";
      status?: SupportTicketSummary["status"];
    },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tickets/${ticketId}/reply`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to reply to ticket");
    return response.json();
  },

  async updateTicket(
    ticketId: number,
    payload: {
      assignedAdminId?: number | null;
      priority?: "low" | "normal" | "high" | "urgent";
      status?: SupportTicketSummary["status"];
      archive?: boolean;
    },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tickets/${ticketId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to update ticket");
    return response.json();
  },

  async createTicketTodo(
    ticketId: number,
    payload: {
      title: string;
      description?: string;
      assignedAdminId?: number | null;
      priority?: "low" | "normal" | "high" | "urgent";
      dueAt?: string | null;
      moduleKey?: string | null;
    },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tickets/${ticketId}/todos`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to create ticket todo");
    return response.json();
  },

  async getSupportTodos(
    status: "all" | "open" | "in_progress" | "blocked" | "done" = "all",
  ): Promise<{ todos: SupportTicketTodo[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/support-todos?status=${encodeURIComponent(status)}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch support todos");
    return response.json();
  },

  async createSupportTodo(payload: {
    title: string;
    description?: string;
    ticketId?: number | null;
    assignedAdminId?: number | null;
    priority?: "low" | "normal" | "high" | "urgent";
    dueAt?: string | null;
    moduleKey?: string | null;
  }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/support-todos`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to create support todo");
    return response.json();
  },

  async updateSupportTodo(
    todoId: number,
    payload: {
      title?: string;
      description?: string | null;
      status?: "open" | "in_progress" | "blocked" | "done";
      assignedAdminId?: number | null;
      priority?: "low" | "normal" | "high" | "urgent";
      dueAt?: string | null;
      moduleKey?: string | null;
    },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/support-todos/${todoId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to update support todo");
    return response.json();
  },

  async updateTicketTodo(
    todoId: number,
    payload: {
      title?: string;
      description?: string | null;
      status?: "open" | "in_progress" | "blocked" | "done";
      assignedAdminId?: number | null;
      priority?: "low" | "normal" | "high" | "urgent";
      dueAt?: string | null;
      moduleKey?: string | null;
    },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tickets/todos/${todoId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to update ticket todo");
    return response.json();
  },

  async deleteSupportTodo(todoId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/support-todos/${todoId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to delete support todo");
    return response.json();
  },

  async getSupportTodoComments(
    todoId: number,
  ): Promise<{ comments: SupportTicketTodoComment[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/support-todos/${todoId}/comments`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch support todo comments");
    return response.json();
  },

  async createSupportTodoComment(todoId: number, payload: { comment: string }) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/support-todos/${todoId}/comments`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );

    await ensureOk(response, "Failed to create support todo comment");
    return response.json();
  },

  async deleteTicket(ticketId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tickets/${ticketId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to delete ticket");
    return response.json();
  },

  async getEmailVerificationGate(): Promise<{
    key: string;
    required: boolean;
    defaultRequired: boolean;
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/auth/email-verification`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    await ensureOk(response, "Failed to fetch email verification setting");
    return response.json();
  },

  async updateEmailVerificationGate(required: boolean): Promise<{
    key: string;
    required: boolean;
    defaultRequired: boolean;
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/auth/email-verification`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ required }),
    });
    await ensureOk(response, "Failed to update email verification setting");
    return response.json();
  },

  async getConfig() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/config`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch config");

    return response.json();
  },

  async updateConfig(updates: Record<string, string>) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/config`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ updates }),
    });

    if (!response.ok) {
      throw new Error("Failed to update config");
    }

    return response.json();
  },

  async getImageLibrary(folder = ""): Promise<AdminImageLibraryResponse> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      folder,
    });
    const response = await fetch(
      `${API_URL}/admin/image-library?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch image library");
    return response.json();
  },

  async uploadImageLibraryFile(payload: {
    file: File;
    folder?: string;
    fileName?: string;
    replacePath?: string;
    overwrite?: boolean;
  }): Promise<{ message: string; file: AdminImageLibraryFile }> {
    const token = adminAuthService.getToken();
    const formData = new FormData();
    formData.append("file", payload.file);
    if (payload.folder) formData.append("folder", payload.folder);
    if (payload.fileName) formData.append("fileName", payload.fileName);
    if (payload.replacePath)
      formData.append("replacePath", payload.replacePath);
    if (payload.overwrite) formData.append("overwrite", "true");

    const response = await fetch(`${API_URL}/admin/image-library/upload`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: formData,
    });

    await ensureOk(response, "Failed to upload image file");
    return response.json();
  },

  async getImageLibraryModules(
    module = "all",
    search = "",
  ): Promise<AdminImageModuleOverviewResponse> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      module,
      search,
    });
    const response = await fetch(
      `${API_URL}/admin/image-library/modules?${query.toString()}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    await ensureOk(response, "Failed to fetch image module overview");
    return response.json();
  },

  async getPremiumOffers(): Promise<{ offers: PremiumOffer[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch premium offers");

    return response.json();
  },

  async updatePremiumOffer(
    id: number,
    payload: Omit<PremiumOffer, "id" | "key"> & { key?: string },
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to update premium offer" }));
      throw new Error(error.error || "Failed to update premium offer");
    }

    return response.json();
  },

  async createPremiumOffer(payload: CreatePremiumOfferPayload) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to create premium offer" }));
      throw new Error(error.error || "Failed to create premium offer");
    }

    return response.json();
  },

  async deletePremiumOffer(id: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers/${id}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to delete premium offer" }));
      throw new Error(error.error || "Failed to delete premium offer");
    }

    return response.json();
  },

  async getCreditShopItems(): Promise<{ items: CreditShopItem[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/credit-shop-items`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    await ensureOk(response, "Failed to fetch credit shop items");
    return response.json();
  },

  async createCreditShopItem(payload: CreateCreditShopItemPayload) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/credit-shop-items`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to create credit shop item" }));
      throw new Error(error.error || "Failed to create credit shop item");
    }

    return response.json();
  },

  async updateCreditShopItem(
    id: number,
    payload: Omit<CreateCreditShopItemPayload, "key">,
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/credit-shop-items/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to update credit shop item" }));
      throw new Error(error.error || "Failed to update credit shop item");
    }

    return response.json();
  },

  async deleteCreditShopItem(id: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/credit-shop-items/${id}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to delete credit shop item" }));
      throw new Error(error.error || "Failed to delete credit shop item");
    }

    return response.json();
  },

  async getVehicles() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/vehicles`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error("Failed to fetch vehicles");
    }

    return response.json();
  },

  async addVehicle(payload: { category: "cars" | "boats"; vehicle: any }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/vehicles`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to add vehicle" }));
      throw new Error(error.error || "Failed to add vehicle");
    }

    return response.json();
  },

  async deleteVehicle(category: "cars" | "boats", vehicleId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/vehicles/${category}/${encodeURIComponent(vehicleId)}`,
      {
        method: "DELETE",
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    if (!response.ok) {
      const error = await response
        .json()
        .catch(() => ({ error: "Failed to delete vehicle" }));
      throw new Error(error.error || "Failed to delete vehicle");
    }

    return response.json();
  },

  // NPC Management
  async getNPCs() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error("Failed to fetch NPCs");
    }

    return response.json();
  },

  async getNPCStats(npcId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs/${npcId}/stats`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error("Failed to fetch NPC stats");
    }

    return response.json();
  },

  async createNPC(
    username: string,
    activityLevel: string,
    gender: "male" | "female" = "male",
  ) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ username, activityLevel, gender }),
    });

    if (!response.ok) {
      const data = await response.json().catch(() => ({}));
      throw new Error(
        (data as { message?: string }).message || "Failed to create NPC",
      );
    }

    return response.json();
  },

  async deleteNPC(npcId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs/${npcId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      const data = await response.json().catch(() => ({}));
      throw new Error(
        (data as { message?: string }).message || "Failed to delete NPC",
      );
    }

    return response.json();
  },

  async simulateNPC(npcId: number, hours: number = 1) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs/${npcId}/simulate`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ hours }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || "Failed to simulate NPC");
    }

    return response.json();
  },

  // ─── Aircraft ─────────────────────────────────────────────────────────────
  async getAircraft() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/aircraft`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!response.ok) throw new Error("Failed to fetch aircraft");
    return response.json();
  },

  async addAircraft(payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/aircraft`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  async updateAircraft(aircraftId: string, payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/aircraft/${encodeURIComponent(aircraftId)}`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  async deleteAircraft(aircraftId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/aircraft/${encodeURIComponent(aircraftId)}`,
      {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      },
    );
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  // ─── Tools ────────────────────────────────────────────────────────────────
  async getTools() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tools`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!response.ok) throw new Error("Failed to fetch tools");
    return response.json();
  },

  async addTool(payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tools`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  async updateTool(toolId: string, payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/tools/${encodeURIComponent(toolId)}`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  async deleteTool(toolId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/tools/${encodeURIComponent(toolId)}`,
      {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      },
    );
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  // ─── Crimes ───────────────────────────────────────────────────────────────
  async getCrimes() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crimes`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (!response.ok) throw new Error("Failed to fetch crimes");
    return response.json();
  },

  async addCrime(payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crimes`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  async updateCrime(crimeId: string, payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/crimes/${encodeURIComponent(crimeId)}`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  async deleteCrime(crimeId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/crimes/${encodeURIComponent(crimeId)}`,
      {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      },
    );
    if (!response.ok) {
      const e = await response.json().catch(() => ({ error: "Failed" }));
      throw new Error(e.error);
    }
    return response.json();
  },

  // --- Game Events ---------------------------------------------------------
  async getEventTemplates(): Promise<{ templates: GameEventTemplate[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/templates`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    await ensureOk(response, "Failed to fetch event templates");
    return response.json();
  },

  async createEventTemplate(
    payload: CreateGameEventTemplatePayload,
  ): Promise<{ template: GameEventTemplate }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/templates`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to create event template");
    return response.json();
  },

  async updateEventTemplate(
    id: number,
    payload: Partial<CreateGameEventTemplatePayload>,
  ): Promise<{ template: GameEventTemplate }> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/game-events/templates/${id}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );

    await ensureOk(response, "Failed to update event template");
    return response.json();
  },

  async getEventSchedules(): Promise<{ schedules: GameEventSchedule[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/schedules`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    await ensureOk(response, "Failed to fetch event schedules");
    return response.json();
  },

  async createEventSchedule(
    payload: CreateGameEventSchedulePayload,
  ): Promise<{ schedule: GameEventSchedule }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/schedules`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to create event schedule");
    return response.json();
  },

  async updateEventSchedule(
    id: number,
    payload: Partial<CreateGameEventSchedulePayload>,
  ): Promise<{ schedule: GameEventSchedule }> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/game-events/schedules/${id}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(payload),
      },
    );

    await ensureOk(response, "Failed to update event schedule");
    return response.json();
  },

  async getLiveEvents(
    status?: string,
  ): Promise<{ liveEvents: GameLiveEvent[] }> {
    const token = adminAuthService.getToken();
    const suffix = status ? `?status=${encodeURIComponent(status)}` : "";
    const response = await fetch(`${API_URL}/admin/game-events/live${suffix}`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    await ensureOk(response, "Failed to fetch live events");
    return response.json();
  },

  async createLiveEvent(
    payload: CreateGameLiveEventPayload,
  ): Promise<{ liveEvent: GameLiveEvent }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/live`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to create live event");
    return response.json();
  },

  async updateLiveEvent(
    id: number,
    payload: Partial<
      Pick<CreateGameLiveEventPayload, "status" | "startedAt" | "endsAt">
    > & { resolvedAt?: string | null },
  ): Promise<{ liveEvent: GameLiveEvent }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/live/${id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to update live event");
    return response.json();
  },

  async getCrewWarsOverview(): Promise<AdminCrewWarOverview> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crew-wars/overview`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    await ensureOk(response, "Failed to fetch crew wars overview");
    return response.json();
  },

  async declareCrewWar(payload: {
    attackerCrewId: number;
    defenderCrewId: number;
    warType: "kill_war" | "economy_war" | "territory_war" | "total_war";
    startsInMinutes?: number;
  }): Promise<{ war: AdminCrewWarDetail }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crew-wars/declare`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to declare crew war");
    return response.json();
  },

  async updateCrewWarStatus(
    warId: number,
    action: "start_now" | "enter_lockdown" | "resolve" | "archive" | "cancel",
  ): Promise<{ war: AdminCrewWarDetail }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crew-wars/${warId}/status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ action }),
    });

    await ensureOk(response, "Failed to update crew war status");
    return response.json();
  },

  async getTerritoryOverview(): Promise<AdminTerritoryOverview> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/territory/admin/overview`, {
      headers: { Authorization: `Bearer ${token}` },
    });

    await ensureOk(response, "Failed to fetch territory overview");
    const payload = await response.json();
    return payload.params;
  },

  async getNightclubOverview(): Promise<{
    venues: Array<{
      venueId: number
      playerId: number
      ownerUsername: string
      country: string
      isOpen: boolean
      crowdSize: number
      crowdVibe: string
      sales24hCount: number
      sales24hRevenue: number
      thefts24hCount: number
      thefts24hLoss: number
      activeEvents: number
    }>
    generatedAt?: string
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/nightclubs/overview`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    await ensureOk(response, "Failed to fetch nightclub overview");
    return response.json();
  },

  async territoryAssignRegion(
    regionKey: string,
    crewId: number | null,
  ): Promise<void> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/territory/admin/region/assign`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ regionKey, crewId }),
    });

    await ensureOk(response, "Failed to assign territory region");
  },

  async territoryResetRegion(regionKey: string): Promise<void> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/territory/admin/region/reset`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ regionKey }),
    });

    await ensureOk(response, "Failed to reset territory region");
  },

  async territoryResolveContest(contestId: number): Promise<void> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/territory/admin/contest/resolve`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ contestId }),
    });

    await ensureOk(response, "Failed to resolve territory contest");
  },

  async territoryStartSeason(payload: {
    seasonKey: string;
    startsAt: string;
    endsAt: string;
  }): Promise<void> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/territory/admin/season/start`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, "Failed to start territory season");
  },

  async territoryCloseSeason(seasonKey: string): Promise<{
    seasonKey?: string;
    alreadyDistributed?: boolean;
    awards?: Array<Record<string, unknown>>;
    totalCashPaid?: number;
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/territory/admin/season/close`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ seasonKey }),
    });

    await ensureOk(response, "Failed to close territory season");
    const payload = await response.json().catch(() => ({}));
    return (payload?.params ?? {}) as {
      seasonKey?: string;
      alreadyDistributed?: boolean;
      awards?: Array<Record<string, unknown>>;
      totalCashPaid?: number;
    };
  },

  async getPlayerPortraits(playerId: number): Promise<{
    portraits: Array<{
      id: number;
      imagePath: string;
      styleKey?: string | null;
      createdAt: string;
    }>;
  }> {
    const token = adminAuthService.getToken();
    const response = await fetch(
      `${API_URL}/admin/players/${playerId}/portraits`,
      {
        headers: { Authorization: `Bearer ${token}` },
      },
    );
    await ensureOk(response, "Failed to list player portraits");
    return response.json();
  },

  async deletePlayerPortrait(
    playerId: number,
    portraitId: number,
    reason?: string,
  ): Promise<void> {
    const token = adminAuthService.getToken();
    const q = reason
      ? `?reason=${encodeURIComponent(reason.slice(0, 500))}`
      : "";
    const response = await fetch(
      `${API_URL}/admin/players/${playerId}/portraits/${portraitId}${q}`,
      {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      },
    );
    await ensureOk(response, "Failed to delete portrait");
  },
};
