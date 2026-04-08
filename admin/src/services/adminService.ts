const resolveApiUrl = (): string => {
  const envUrl = import.meta.env.VITE_ADMIN_API_URL?.trim();
  if (envUrl) return envUrl;

  if (typeof window !== 'undefined' && window.location.protocol === 'https:') {
    return `https://${window.location.hostname}:3443`;
  }

  return 'http://localhost:3000';
};

const API_URL = resolveApiUrl();

const parseErrorMessage = async (response: Response, fallback: string): Promise<string> => {
  const payload = await response.json().catch(() => null as any);
  return payload?.message || payload?.error || fallback;
};

const ensureOk = async (response: Response, fallback: string): Promise<void> => {
  if (response.status === 401) {
    adminAuthService.logout();
    throw new Error('UNAUTHORIZED');
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
  rewardType: 'money' | 'ammo';
  moneyAmount: number | null;
  ammoType: string | null;
  ammoQuantity: number | null;
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
  rewardType: 'money' | 'ammo';
  moneyAmount: number | null;
  ammoType: string | null;
  ammoQuantity: number | null;
  isActive: boolean;
  showPopupOnOpen: boolean;
  notifyAllPlayers: boolean;
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
    ammo: any[];
    weapons: any[];
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
    premiumFulfillments: Array<{
      id: number;
      stripeSessionId: string;
      productKey: string;
      fulfilledAt: string;
    }>;
  };
}

export interface ManagePlayerPayload {
  playerId: number;
  reason?: string;
  set?: {
    money?: number;
    rank?: number;
    xp?: number;
    health?: number;
    currentCountry?: string;
  };
  add?: {
    money?: number;
    xp?: number;
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
  status: 'ok' | 'degraded' | 'down';
  timestamp: string;
  uptime: number;
  environment: string;
  responseTimeMs: number;
  components: {
    api: { status: 'ok' | 'degraded' | 'down' };
    database: { status: 'ok' | 'degraded' | 'down'; error?: string | null };
    redis: { status: 'ok' | 'degraded' | 'down' };
    queue: { status: 'ok' | 'degraded' | 'down' };
    cron: {
      status: 'ok' | 'degraded' | 'down';
      jobs: Record<string, string>;
      lastExecutions: Record<string, string>;
    };
  };
}

export interface DashboardOverview {
  alerts: Array<{
    severity: 'danger' | 'warning' | 'info';
    title: string;
    description: string;
  }>;
  activityFeed: Array<{
    id: string;
    type: 'audit' | 'system';
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

export interface AdminAccount {
  id: number;
  username: string;
  role: 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER';
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

export const adminAuthService = {
  async login(username: string, password: string): Promise<AdminLoginResponse> {
    const response = await fetch(`${API_URL}/admin/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    });

    if (!response.ok) {
      throw new Error('Login failed');
    }

    const data = await response.json();
    localStorage.setItem('admin_token', data.token);
    if (data?.admin?.role) {
      localStorage.setItem('admin_role', data.admin.role);
    }
    return data;
  },

  logout() {
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_role');
  },

  getToken() {
    return localStorage.getItem('admin_token');
  },

  isAuthenticated() {
    return !!this.getToken();
  },

  getAdminRole() {
    return localStorage.getItem('admin_role') as 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER' | null;
  },
};

export const adminService = {
  async getDashboardOverview(): Promise<DashboardOverview> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/dashboard-overview`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch dashboard overview');
    return response.json();
  },

  async getSystemHealthDetails(): Promise<SystemHealthDetails> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/health/details`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch system health details');
    return response.json();
  },

  async getStats() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/stats`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch stats');

    return response.json();
  },

  async getPlayers(page = 1, limit = 20, search = '') {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      page: String(page),
      limit: String(limit),
      search,
    });
    const response = await fetch(`${API_URL}/admin/players?${query.toString()}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch players');

    return response.json();
  },

  async getAuditLogs(page = 1, limit = 50) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/audit-logs?page=${page}&limit=${limit}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch audit logs');

    return response.json();
  },

  async getSystemLogs(page = 1, limit = 50) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/system-logs?page=${page}&limit=${limit}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch system logs');

    return response.json();
  },

  async getAdmins() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/admins`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch admins');

    return response.json();
  },

  async createAdmin(payload: { username: string; password: string; role: 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER' }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/admins`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to create admin');

    return response.json();
  },

  async updateAdmin(adminId: number, payload: { role?: 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER'; isActive?: boolean; password?: string }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/admins/${adminId}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to update admin');

    return response.json();
  },

  async banPlayer(playerId: number, reason: string, duration?: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/ban`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ playerId, reason, duration }),
    });

    await ensureOk(response, 'Failed to ban player');

    return response.json();
  },

  async unbanPlayer(playerId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/unban`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ playerId }),
    });

    if (!response.ok) {
      throw new Error('Failed to unban player');
    }

    return response.json();
  },

  async editPlayer(playerId: number, updates: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/edit`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ playerId, updates }),
    });

    await ensureOk(response, 'Failed to edit player');

    return response.json();
  },

  async getPlayerOverview(playerId: number): Promise<PlayerOverview> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/${playerId}/overview`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch player overview');

    return response.json();
  },

  async getPlayerRecentActivities(params: {
    playerId: number;
    page?: number;
    limit?: number;
    dateRange?: '24h' | '7d' | '30d' | 'all';
    typeFilter?: string;
    search?: string;
    sort?: 'date_desc' | 'date_asc' | 'type_asc' | 'type_desc';
  }): Promise<PlayerRecentActivitiesResponse> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      page: String(params.page ?? 1),
      limit: String(params.limit ?? 10),
      dateRange: params.dateRange ?? '7d',
      typeFilter: params.typeFilter ?? 'all',
      search: params.search ?? '',
      sort: params.sort ?? 'date_desc',
    });

    const response = await fetch(`${API_URL}/admin/players/${params.playerId}/recent-activities?${query.toString()}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch recent activities');

    return response.json();
  },

  async exportPlayerRecentActivities(params: {
    playerId: number;
    dateRange?: '24h' | '7d' | '30d' | 'all';
    typeFilter?: string;
    search?: string;
    sort?: 'date_desc' | 'date_asc' | 'type_asc' | 'type_desc';
  }): Promise<Blob> {
    const token = adminAuthService.getToken();
    const query = new URLSearchParams({
      dateRange: params.dateRange ?? '7d',
      typeFilter: params.typeFilter ?? 'all',
      search: params.search ?? '',
      sort: params.sort ?? 'date_desc',
    });

    const response = await fetch(`${API_URL}/admin/players/${params.playerId}/recent-activities/export?${query.toString()}`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to export recent activities');
    return response.blob();
  },

  async bulkPlayerAction(payload: {
    playerIds: number[];
    action: 'warn' | 'ban_temp' | 'add_money';
    reason: string;
    durationHours?: number;
    amount?: number;
  }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/bulk-action`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to execute bulk action');
    return response.json();
  },

  async managePlayer(payload: ManagePlayerPayload) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/players/manage`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to manage player');

    return response.json();
  },

  async getConfig() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/config`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch config');

    return response.json();
  },

  async updateConfig(updates: Record<string, string>) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/config`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ updates }),
    });

    if (!response.ok) {
      throw new Error('Failed to update config');
    }

    return response.json();
  },

  async getPremiumOffers(): Promise<{ offers: PremiumOffer[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    await ensureOk(response, 'Failed to fetch premium offers');

    return response.json();
  },

  async updatePremiumOffer(id: number, payload: Omit<PremiumOffer, 'id' | 'key'> & { key?: string }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({ error: 'Failed to update premium offer' }));
      throw new Error(error.error || 'Failed to update premium offer');
    }

    return response.json();
  },

  async createPremiumOffer(payload: CreatePremiumOfferPayload) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({ error: 'Failed to create premium offer' }));
      throw new Error(error.error || 'Failed to create premium offer');
    }

    return response.json();
  },

  async deletePremiumOffer(id: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/premium-offers/${id}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({ error: 'Failed to delete premium offer' }));
      throw new Error(error.error || 'Failed to delete premium offer');
    }

    return response.json();
  },

  async getVehicles() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/vehicles`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch vehicles');
    }

    return response.json();
  },

  async addVehicle(payload: { category: 'cars' | 'boats'; vehicle: any }) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/vehicles`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({ error: 'Failed to add vehicle' }));
      throw new Error(error.error || 'Failed to add vehicle');
    }

    return response.json();
  },

  async deleteVehicle(category: 'cars' | 'boats', vehicleId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/vehicles/${category}/${encodeURIComponent(vehicleId)}`, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({ error: 'Failed to delete vehicle' }));
      throw new Error(error.error || 'Failed to delete vehicle');
    }

    return response.json();
  },

  // NPC Management
  async getNPCs() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch NPCs');
    }

    return response.json();
  },

  async getNPCStats(npcId: number) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs/${npcId}/stats`, {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch NPC stats');
    }

    return response.json();
  },

  async createNPC(username: string, activityLevel: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ username, activityLevel }),
    });

    if (!response.ok) {
      throw new Error('Failed to create NPC');
    }

    return response.json();
  },

  async simulateNPC(npcId: number, hours: number = 1) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/npcs/${npcId}/simulate`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({ hours }),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Failed to simulate NPC');
    }

    return response.json();
  },

  // ─── Aircraft ─────────────────────────────────────────────────────────────
  async getAircraft() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/aircraft`, { headers: { 'Authorization': `Bearer ${token}` } });
    if (!response.ok) throw new Error('Failed to fetch aircraft');
    return response.json();
  },

  async addAircraft(payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/aircraft`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(payload),
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  async updateAircraft(aircraftId: string, payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/aircraft/${encodeURIComponent(aircraftId)}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(payload),
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  async deleteAircraft(aircraftId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/aircraft/${encodeURIComponent(aircraftId)}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${token}` },
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  // ─── Tools ────────────────────────────────────────────────────────────────
  async getTools() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tools`, { headers: { 'Authorization': `Bearer ${token}` } });
    if (!response.ok) throw new Error('Failed to fetch tools');
    return response.json();
  },

  async addTool(payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tools`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(payload),
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  async updateTool(toolId: string, payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tools/${encodeURIComponent(toolId)}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(payload),
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  async deleteTool(toolId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/tools/${encodeURIComponent(toolId)}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${token}` },
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  // ─── Crimes ───────────────────────────────────────────────────────────────
  async getCrimes() {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crimes`, { headers: { 'Authorization': `Bearer ${token}` } });
    if (!response.ok) throw new Error('Failed to fetch crimes');
    return response.json();
  },

  async addCrime(payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crimes`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(payload),
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  async updateCrime(crimeId: string, payload: any) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crimes/${encodeURIComponent(crimeId)}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(payload),
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  async deleteCrime(crimeId: string) {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/crimes/${encodeURIComponent(crimeId)}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${token}` },
    });
    if (!response.ok) { const e = await response.json().catch(() => ({ error: 'Failed' })); throw new Error(e.error); }
    return response.json();
  },

  // --- Game Events ---------------------------------------------------------
  async getEventTemplates(): Promise<{ templates: GameEventTemplate[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/templates`, {
      headers: { 'Authorization': `Bearer ${token}` },
    });

    await ensureOk(response, 'Failed to fetch event templates');
    return response.json();
  },

  async createEventTemplate(payload: CreateGameEventTemplatePayload): Promise<{ template: GameEventTemplate }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/templates`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to create event template');
    return response.json();
  },

  async updateEventTemplate(id: number, payload: Partial<CreateGameEventTemplatePayload>): Promise<{ template: GameEventTemplate }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/templates/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to update event template');
    return response.json();
  },

  async getEventSchedules(): Promise<{ schedules: GameEventSchedule[] }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/schedules`, {
      headers: { 'Authorization': `Bearer ${token}` },
    });

    await ensureOk(response, 'Failed to fetch event schedules');
    return response.json();
  },

  async createEventSchedule(payload: CreateGameEventSchedulePayload): Promise<{ schedule: GameEventSchedule }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/schedules`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to create event schedule');
    return response.json();
  },

  async updateEventSchedule(id: number, payload: Partial<CreateGameEventSchedulePayload>): Promise<{ schedule: GameEventSchedule }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/schedules/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to update event schedule');
    return response.json();
  },

  async getLiveEvents(status?: string): Promise<{ liveEvents: GameLiveEvent[] }> {
    const token = adminAuthService.getToken();
    const suffix = status ? `?status=${encodeURIComponent(status)}` : '';
    const response = await fetch(`${API_URL}/admin/game-events/live${suffix}`, {
      headers: { 'Authorization': `Bearer ${token}` },
    });

    await ensureOk(response, 'Failed to fetch live events');
    return response.json();
  },

  async createLiveEvent(payload: CreateGameLiveEventPayload): Promise<{ liveEvent: GameLiveEvent }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/live`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to create live event');
    return response.json();
  },

  async updateLiveEvent(
    id: number,
    payload: Partial<Pick<CreateGameLiveEventPayload, 'status' | 'startedAt' | 'endsAt'>> & { resolvedAt?: string | null },
  ): Promise<{ liveEvent: GameLiveEvent }> {
    const token = adminAuthService.getToken();
    const response = await fetch(`${API_URL}/admin/game-events/live/${id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify(payload),
    });

    await ensureOk(response, 'Failed to update live event');
    return response.json();
  },
};
