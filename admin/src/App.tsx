import { useState, useEffect, useMemo } from 'react'
import './App.css'
import { adminAuthService, adminService, type PremiumOffer, type CreatePremiumOfferPayload, type PlayerOverview, type SystemLogEntry, type AdminAccount, type GameEventTemplate, type GameEventSchedule, type GameLiveEvent, type CreateGameEventTemplatePayload, type CreateGameEventSchedulePayload, type CreateGameLiveEventPayload, type RecentActivityItem, type SystemHealthDetails, type DashboardOverview } from './services/adminService'

type TabType = 'dashboard' | 'players' | 'player-detail' | 'vehicles' | 'npcs' | 'audit-logs' | 'system-logs' | 'admins' | 'config' | 'premium-offers' | 'tools' | 'crimes' | 'events'
type Language = 'nl' | 'en'
type PlayerDetailTab = 'overview' | 'manage' | 'financial'
type DateRangeFilter = '24h' | '7d' | '30d' | 'all'
const RECENT_ACTIONS_PAGE_SIZE = 10
const RECENT_ACTIONS_PREFS_KEY = 'admin_recent_actions_prefs_v1'
const RECENT_ACTIONS_VIEWS_KEY = 'admin_recent_actions_views_v1'
const PLAYER_SEARCH_DEBOUNCE_MS = 250
const PROSTITUTION_BALANCE_PROFILE_KEY = 'PROSTITUTION_BALANCE_PROFILE'
const PROSTITUTION_BALANCE_PROFILES = ['casual', 'normal', 'hardcore'] as const
type ProstitutionBalanceProfile = typeof PROSTITUTION_BALANCE_PROFILES[number]
const VIP_HOUSING_BONUS_KEY = 'VIP_HOUSING_BONUS_PER_PROPERTY'
const VIP_HOUSING_BONUS_DEFAULT = '5'
const HOUSING_RENT_STANDARD_KEY = 'PROSTITUTION_HOUSING_RENT_STANDARD_PER_DAY'
const HOUSING_RENT_VIP_KEY = 'PROSTITUTION_HOUSING_RENT_VIP_PER_DAY'
const HOUSING_RENT_STANDARD_DEFAULT = '35'
const HOUSING_RENT_VIP_DEFAULT = '60'
type ActivitySort = 'date_desc' | 'date_asc' | 'type_asc' | 'type_desc'
type ActivityTimezone = 'local' | 'utc'
type SavedRecentActionsView = {
  id: string
  name: string
  dateRange: DateRangeFilter
  typeFilter: string
  search: string
  sort: ActivitySort
}

const getStoredRecentActionsPrefs = (): { dateRange: DateRangeFilter; typeFilter: string; search: string; sort: ActivitySort } => {
  if (typeof window === 'undefined') {
    return { dateRange: '7d', typeFilter: 'all', search: '', sort: 'date_desc' }
  }

  const defaults = { dateRange: '7d' as DateRangeFilter, typeFilter: 'all', search: '', sort: 'date_desc' as ActivitySort }
  try {
    const raw = localStorage.getItem(RECENT_ACTIONS_PREFS_KEY)
    if (!raw) return defaults
    const parsed = JSON.parse(raw)
    const dateRange = ['24h', '7d', '30d', 'all'].includes(parsed?.dateRange) ? parsed.dateRange : defaults.dateRange
    const sort = ['date_desc', 'date_asc', 'type_asc', 'type_desc'].includes(parsed?.sort) ? parsed.sort : defaults.sort
    return {
      dateRange,
      typeFilter: typeof parsed?.typeFilter === 'string' ? parsed.typeFilter : defaults.typeFilter,
      search: typeof parsed?.search === 'string' ? parsed.search : defaults.search,
      sort,
    }
  } catch {
    return defaults
  }
}

const getStoredRecentActionsViews = (): SavedRecentActionsView[] => {
  if (typeof window === 'undefined') return []

  try {
    const raw = localStorage.getItem(RECENT_ACTIONS_VIEWS_KEY)
    if (!raw) return []
    const parsed = JSON.parse(raw)
    if (!Array.isArray(parsed)) return []
    return parsed.filter((view) =>
      view &&
      typeof view.id === 'string' &&
      typeof view.name === 'string' &&
      ['24h', '7d', '30d', 'all'].includes(view.dateRange) &&
      typeof view.typeFilter === 'string' &&
      typeof view.search === 'string' &&
      ['date_desc', 'date_asc', 'type_asc', 'type_desc'].includes(view.sort),
    )
  } catch {
    return []
  }
}

const translations = {
  nl: {
    loginTitle: 'Mafia Admin Dashboard',
    loginSubtitle: 'Log in om het platform te beheren',
    username: 'Gebruikersnaam',
    password: 'Wachtwoord',
    login: 'Inloggen',
    loggingIn: 'Inloggen...',
    loginFailed: 'Inloggen mislukt. Controleer je gegevens.',
    logout: 'Uitloggen',
    language: 'Taal',
    navDashboard: 'Dashboard',
    navPlayers: 'Spelers',
    navVehicles: 'Voertuigen',
    navTools: 'Gereedschappen',
    navCrimes: 'Misdaden',
    navNpcs: 'NPCs',
    navAudit: 'Audit Logs',
    navPremium: 'Premium Offers',
    navConfig: 'Config',
    totalPlayers: 'Totaal spelers',
    activePlayers: 'Actieve spelers',
    bannedPlayers: 'Gebande spelers',
    apiWarningTitle: 'Data laden mislukt',
    dashboardTitle: 'Dashboard',
    playersTitle: 'Spelers',
    vehiclesTitle: 'Voertuigen',
    toolsTitle: 'Gereedschappen',
    crimesTitle: 'Misdaden',
    auditLogsTitle: 'Audit Logs',
    configEditorTitle: 'Config Editor',
    prostitutionBalanceTitle: 'Prostitutie balansprofiel',
    prostitutionBalanceDescription: 'Kies een preset voor risico en straf bij verraad: casual, normal of hardcore.',
    prostitutionBalanceApply: 'Pas profiel toe',
    vipHousingBonusTitle: 'VIP woningbonus',
    vipHousingBonusDescription: 'Extra hoerplekken per residentieel eigendom (huis/appartement) voor VIP-spelers, bovenop de normale capaciteit.',
    vipHousingBonusSave: 'Opslaan',
    vipHousingBonusLabel: 'Extra plekken per eigendom',
    vipHousingBonusHint: '(standaard: 5)',
    vipHousingBonusSaved: 'VIP Woningbonus opgeslagen',
    vipHousingBonusError: 'Voer een geldig getal in (0 of hoger)',
    vipHousingBonusCurrentValue: 'Huidige waarde',
    prostitutionHousingRentTitle: 'Prostitutie huur (dagtarief)',
    prostitutionHousingRentDescription: 'Stel de daghuur in voor normale en VIP hoeren. Weekhuur = dagtarief x 7.',
    prostitutionHousingRentSave: 'Opslaan',
    prostitutionHousingRentStandardLabel: 'Normaal per dag',
    prostitutionHousingRentVipLabel: 'VIP per dag',
    prostitutionHousingRentSaved: 'Prostitutie huur opgeslagen',
    prostitutionHousingRentError: 'Voer geldige bedragen in (0 of hoger)',

    premiumOffersTitle: 'Premium One-time Offers',
    npcManagementTitle: 'NPC Beheer',
    searchByUsernameOrId: 'Zoek op gebruikersnaam of ID...',
    searchConfigKeys: 'Zoek config keys...',
    save: 'Opslaan',
    delete: 'Verwijderen',
    edit: 'Bewerken',
    ban: 'Ban',
    cancel: 'Annuleren',
    refresh: 'Verversen',
    loading: 'Laden...',
    creating: 'Aanmaken...',
    previous: 'Vorige',
    next: 'Volgende',
    pageOf: 'Pagina {page} van {total}',
    actions: 'Acties',
    warning: 'Waarschuwing',
    noChangesToSave: 'Geen wijzigingen om op te slaan',
    failedUpdateConfig: 'Config bijwerken mislukt',
    unknownError: 'Onbekende fout',
    yes: 'Ja',
    no: 'Nee',
    close: 'Sluiten',
    statsLoadError: 'Statistieken konden niet geladen worden. Controleer backend/API verbinding.',
    playersLoadError: 'Spelers konden niet geladen worden. Controleer backend/API verbinding.',
    auditLoadError: 'Audit logs konden niet geladen worden. Controleer backend/API verbinding.',
    configLoadError: 'Config kon niet geladen worden. Controleer backend/API verbinding.',
    premiumLoadError: 'Premium offers konden niet geladen worden. Controleer backend/API verbinding.',
    npcsLoadError: 'NPCs konden niet geladen worden. Controleer backend/API verbinding.',
    vehiclesLoadError: 'Voertuigen konden niet geladen worden. Controleer backend/API verbinding.',
    aircraftLoadError: 'Aircraft konden niet geladen worden. Controleer backend/API verbinding.',
    toolsLoadError: 'Gereedschappen konden niet geladen worden. Controleer backend/API verbinding.',
    crimesLoadError: 'Misdaden konden niet geladen worden. Controleer backend/API verbinding.',
    failedLoadPremium: 'Laden van premium offers mislukt',
    failedLoadNpcs: 'Laden van NPCs mislukt',
    failedLoadVehicles: 'Laden van voertuigen mislukt',
    failedLoadTools: 'Laden van gereedschappen mislukt',
    failedLoadCrimes: 'Laden van misdaden mislukt',
    addVehicleSuccess: 'Voertuig toegevoegd',
    addAircraftSuccess: 'Vliegtuig toegevoegd',
    addToolSuccess: 'Gereedschap toegevoegd',
    addCrimeSuccess: 'Misdaad toegevoegd',
    saved: 'Opgeslagen',
    failedAddVehicle: 'Voertuig toevoegen mislukt',
    failedDeleteVehicle: 'Voertuig verwijderen mislukt',
    errorPrefix: 'Fout',
    npcUsernameRequired: 'NPC gebruikersnaam is verplicht',
    failedCreateNpc: 'NPC aanmaken mislukt',
    invalidSimHours: 'Voer een geldig aantal uren in tussen 0 en 24',
    simulationComplete: 'Simulatie voltooid!',
    failedSimNpc: 'NPC simulatie mislukt',
    keyRequired: 'Key is verplicht',
    moneyAmountRequired: 'Money amount moet groter zijn dan 0 voor type money',
    ammoRequired: 'Ammo type en quantity zijn verplicht voor type ammo',
    savedOffer: 'Offer opgeslagen',
    createdOffer: 'Offer aangemaakt',
    failedSaveOffer: 'Opslaan van offer mislukt',
    failedDeleteOffer: 'Verwijderen van offer mislukt',
    failedCreateOffer: 'Aanmaken van offer mislukt',
    confirmDeleteOffer: 'Weet je zeker dat je aanbieding "{key}" wilt verwijderen?',
    enterBanReason: 'Vul een banreden in',
    playerBanned: 'Speler succesvol geband',
    failedBanPlayer: 'Speler bannen mislukt',
    playerUpdated: 'Speler succesvol bijgewerkt',
    failedUpdatePlayer: 'Speler bijwerken mislukt',
    confirmDeleteVehicle: 'Weet je zeker dat je voertuig "{id}" wilt verwijderen?',
    confirmDeleteAircraft: 'Weet je zeker dat je vliegtuig "{id}" wilt verwijderen?',
    confirmDeleteTool: 'Weet je zeker dat je gereedschap "{id}" wilt verwijderen?',
    confirmDeleteCrime: 'Weet je zeker dat je misdaad "{id}" wilt verwijderen?',
    enterCountryCode: 'Voer minimaal één landcode in',
    editPlayerTitle: 'Speler bewerken',
    banPlayerTitle: 'Speler bannen',
    banReason: 'Ban reden',
    banType: 'Ban type',
    temporaryBan: 'Tijdelijke ban',
    permanentBan: 'Permanente ban',
    durationHours: 'Duur (uren)',
    permanentBanAction: 'Speler permanent bannen',
    banForHours: 'Ban voor {hours} uur',
    configRestartWarning: 'Wijzigingen in configuratie vereisen een server-restart om actief te worden.',
    saveChanges: 'Wijzigingen opslaan',
    reset: 'Reset',
    noNpcsFound: 'Geen NPCs gevonden. Maak je eerste NPC aan om te starten.',
    createNpc: 'NPC aanmaken',
    createNpcTitle: 'Nieuwe NPC aanmaken',
    addVehicle: 'Voertuig toevoegen',
    addAircraft: 'Vliegtuig toevoegen',
    addTool: 'Gereedschap toevoegen',
    addCrime: 'Misdaad toevoegen',
    activityLevel: 'Activiteitsniveau',
    simulate: 'Simuleren',
    details: 'Details',
    simulateNpcTitle: 'NPC activiteit simuleren',
    startSimulation: 'Start simulatie',
    hoursToSimulate: 'Uren om te simuleren',
    npcDetails: 'NPC details',
    playerInfo: 'Speler info',
    crimeStats: 'Misdaad statistieken',
    jobStats: 'Job statistieken',
    earningsPerformance: 'Verdiensten & prestaties',
    otherStats: 'Overige statistieken',
  },
  en: {
    loginTitle: 'Mafia Admin Dashboard',
    loginSubtitle: 'Sign in to manage the game platform',
    username: 'Username',
    password: 'Password',
    login: 'Login',
    loggingIn: 'Logging in...',
    loginFailed: 'Login failed. Check your credentials.',
    logout: 'Logout',
    language: 'Language',
    navDashboard: 'Dashboard',
    navPlayers: 'Players',
    navVehicles: 'Vehicles',
    navTools: 'Tools',
    navCrimes: 'Crimes',
    navNpcs: 'NPCs',
    navAudit: 'Audit Logs',
    navPremium: 'Premium Offers',
    navConfig: 'Config',
    totalPlayers: 'Total players',
    activePlayers: 'Active players',
    bannedPlayers: 'Banned players',
    apiWarningTitle: 'Failed to load data',
    dashboardTitle: 'Dashboard',
    playersTitle: 'Players',
    vehiclesTitle: 'Vehicles',
    toolsTitle: 'Tools',
    crimesTitle: 'Crimes',
    auditLogsTitle: 'Audit Logs',
    configEditorTitle: 'Config Editor',
    prostitutionBalanceTitle: 'Prostitution balance profile',
    prostitutionBalanceDescription: 'Choose a preset for betrayal risk and punishment: casual, normal or hardcore.',
    prostitutionBalanceApply: 'Apply profile',
    vipHousingBonusTitle: 'VIP housing bonus',
    vipHousingBonusDescription: 'Extra prostitute slots per residential property (house/apartment) for VIP players, on top of normal capacity.',
    vipHousingBonusSave: 'Save',
    vipHousingBonusLabel: 'Extra slots per property',
    vipHousingBonusHint: '(default: 5)',
    vipHousingBonusSaved: 'VIP housing bonus saved',
    vipHousingBonusError: 'Enter a valid number (0 or higher)',
    vipHousingBonusCurrentValue: 'Current value',
    prostitutionHousingRentTitle: 'Prostitution housing rent (daily)',
    prostitutionHousingRentDescription: 'Set daily rent for regular and VIP prostitutes. Weekly rent = daily x 7.',
    prostitutionHousingRentSave: 'Save',
    prostitutionHousingRentStandardLabel: 'Regular per day',
    prostitutionHousingRentVipLabel: 'VIP per day',
    prostitutionHousingRentSaved: 'Prostitution rent saved',
    prostitutionHousingRentError: 'Enter valid amounts (0 or higher)',

    premiumOffersTitle: 'Premium One-time Offers',
    npcManagementTitle: 'NPC Management',
    searchByUsernameOrId: 'Search by username or ID...',
    searchConfigKeys: 'Search config keys...',
    save: 'Save',
    delete: 'Delete',
    edit: 'Edit',
    ban: 'Ban',
    cancel: 'Cancel',
    refresh: 'Refresh',
    loading: 'Loading...',
    creating: 'Creating...',
    previous: 'Previous',
    next: 'Next',
    pageOf: 'Page {page} of {total}',
    actions: 'Actions',
    warning: 'Warning',
    noChangesToSave: 'No changes to save',
    failedUpdateConfig: 'Failed to update config',
    unknownError: 'Unknown error',
    yes: 'Yes',
    no: 'No',
    close: 'Close',
    statsLoadError: 'Stats could not be loaded. Check backend/API connectivity.',
    playersLoadError: 'Players could not be loaded. Check backend/API connectivity.',
    auditLoadError: 'Audit logs could not be loaded. Check backend/API connectivity.',
    configLoadError: 'Config could not be loaded. Check backend/API connectivity.',
    premiumLoadError: 'Premium offers could not be loaded. Check backend/API connectivity.',
    npcsLoadError: 'NPCs could not be loaded. Check backend/API connectivity.',
    vehiclesLoadError: 'Vehicles could not be loaded. Check backend/API connectivity.',
    aircraftLoadError: 'Aircraft could not be loaded. Check backend/API connectivity.',
    toolsLoadError: 'Tools could not be loaded. Check backend/API connectivity.',
    crimesLoadError: 'Crimes could not be loaded. Check backend/API connectivity.',
    failedLoadPremium: 'Failed to load premium offers',
    failedLoadNpcs: 'Failed to load NPCs',
    failedLoadVehicles: 'Failed to load vehicles',
    failedLoadTools: 'Failed to load tools',
    failedLoadCrimes: 'Failed to load crimes',
    addVehicleSuccess: 'Vehicle added',
    addAircraftSuccess: 'Aircraft added',
    addToolSuccess: 'Tool added',
    addCrimeSuccess: 'Crime added',
    saved: 'Saved',
    failedAddVehicle: 'Failed to add vehicle',
    failedDeleteVehicle: 'Failed to delete vehicle',
    errorPrefix: 'Error',
    npcUsernameRequired: 'NPC username is required',
    failedCreateNpc: 'Failed to create NPC',
    invalidSimHours: 'Please enter a valid number of hours between 0 and 24',
    simulationComplete: 'Simulation complete!',
    failedSimNpc: 'Failed to simulate NPC',
    keyRequired: 'Key is required',
    moneyAmountRequired: 'Money amount must be greater than 0 for money reward',
    ammoRequired: 'Ammo type and quantity are required for ammo reward',
    savedOffer: 'Saved offer',
    createdOffer: 'Created offer',
    failedSaveOffer: 'Failed to save premium offer',
    failedDeleteOffer: 'Failed to delete premium offer',
    failedCreateOffer: 'Failed to create premium offer',
    confirmDeleteOffer: 'Are you sure you want to delete offer "{key}"?',
    enterBanReason: 'Please enter a ban reason',
    playerBanned: 'Player banned successfully',
    failedBanPlayer: 'Failed to ban player',
    playerUpdated: 'Player updated successfully',
    failedUpdatePlayer: 'Failed to update player',
    confirmDeleteVehicle: 'Are you sure you want to delete vehicle "{id}"?',
    confirmDeleteAircraft: 'Are you sure you want to delete aircraft "{id}"?',
    confirmDeleteTool: 'Are you sure you want to delete tool "{id}"?',
    confirmDeleteCrime: 'Are you sure you want to delete crime "{id}"?',
    enterCountryCode: 'Enter at least one country code',
    editPlayerTitle: 'Edit player',
    banPlayerTitle: 'Ban player',
    banReason: 'Ban reason',
    banType: 'Ban type',
    temporaryBan: 'Temporary ban',
    permanentBan: 'Permanent ban',
    durationHours: 'Duration (hours)',
    permanentBanAction: 'Permanently ban player',
    banForHours: 'Ban for {hours} hours',
    configRestartWarning: 'Changes to configuration require a server restart to take effect.',
    saveChanges: 'Save changes',
    reset: 'Reset',
    noNpcsFound: 'No NPCs found. Create your first NPC to get started.',
    createNpc: 'Create NPC',
    createNpcTitle: 'Create new NPC',
    addVehicle: 'Add vehicle',
    addAircraft: 'Add aircraft',
    addTool: 'Add tool',
    addCrime: 'Add crime',
    activityLevel: 'Activity level',
    simulate: 'Simulate',
    details: 'Details',
    simulateNpcTitle: 'Simulate NPC activity',
    startSimulation: 'Start simulation',
    hoursToSimulate: 'Hours to simulate',
    npcDetails: 'NPC details',
    playerInfo: 'Player info',
    crimeStats: 'Crime statistics',
    jobStats: 'Job statistics',
    earningsPerformance: 'Earnings & performance',
    otherStats: 'Other stats',
  },
} as const

interface AdminAircraft {
  id: string
  name: string
  type: string
  description: string
  price: number
  minRank: number
  maxRange: number
  fuelCapacity: number
  fuelCostPerKm: number
  repairCost: number
  speedMultiplier: number
  cargoCapacity: number
  image?: string
}

interface AdminTool {
  id: string
  name: string
  type: string
  basePrice: number
  maxDurability: number
  loseChance: number
  wearPerUse: number
  requiredFor: string[]
  image?: string
}

interface AdminCrime {
  id: string
  name: string
  description: string
  minLevel: number
  baseSuccessChance: number
  minReward: number
  maxReward: number
  xpReward: number
  minXpReward?: number
  maxXpReward?: number
  jailTime: number
  requiredVehicle: boolean
  requiredVehicleType?: 'car' | 'boat' | 'aircraft' | null
  breakdownChance: number
  requiredTools?: string[]
  requiredWeapon?: boolean
  isFederal?: boolean
}

interface Player {
  id: number
  username: string
  money: number
  rank: number
  health: number
  currentCountry: string
  avatar: string | null
  isOnline: boolean
  createdAt: string
  updatedAt: string
}

interface PlayerManageForm {
  setMoney: string
  setRank: string
  setXp: string
  setHealth: string
  setCountry: string
  addMoney: string
  addXp: string
  vipEnabled: boolean
  vipDays: string
  ammoType: string
  ammoQuantity: string
  toolId: string
  toolQuantity: string
}

interface AuditLog {
  id: number
  action: string
  targetType: string | null
  targetId: string | null
  details: string | null
  ipAddress: string | null
  createdAt: string
  admin: {
    username: string
    role: string
  }
}

interface NewAdminForm {
  username: string
  password: string
  role: 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER'
}

interface NPC {
  id: number
  username: string
  activityLevel: string
  stats: {
    totalCrimes: number
    successfulCrimes: number
    failedCrimes: number
    totalJobs: number
    totalMoneyEarned: number
    totalXpEarned: number
    totalJailTime: number
    arrests: number
    crimesPerHour: number
    jobsPerHour: number
    moneyPerHour: number
    xpPerHour: number
  }
  npcPlayer: {
    money: number
    rank: number
    health: number
    currentCountry: string
  }
  createdAt: string
}

interface AdminVehicle {
  id: string
  name: string
  type: string
  image: string
  imageNew?: string
  imageDirty?: string
  imageDamaged?: string
  stats: {
    speed: number
    armor: number
    cargo: number
    stealth: number
  }
  description: string
  availableInCountries: string[]
  baseValue: number
  marketValue: Record<string, number>
  fuelCapacity: number
  requiredRank: number
  rarity?: string
}

interface NewVehicleForm {
  category: 'cars' | 'boats'
  id: string
  name: string
  type: string
  rarity: string
  imageNew: string
  imageDirty: string
  imageDamaged: string
  description: string
  availableInCountries: string
  baseValue: string
  fuelCapacity: string
  requiredRank: string
  speed: string
  armor: string
  cargo: string
  stealth: string
  marketValueJson: string
}

interface PremiumOfferPreview {
  key: string
  titleNl: string
  titleEn: string
  imageUrl: string | null
  priceEurCents: number
  rewardType: 'money' | 'ammo'
  moneyAmount: number | null
  ammoType: string | null
  ammoQuantity: number | null
}

const defaultNewVehicleForm: NewVehicleForm = {
  category: 'cars',
  id: '',
  name: '',
  type: '',
  rarity: 'common',
  imageNew: '',
  imageDirty: '',
  imageDamaged: '',
  description: '',
  availableInCountries: 'netherlands,belgium,germany',
  baseValue: '10000',
  fuelCapacity: '50',
  requiredRank: '1',
  speed: '50',
  armor: '10',
  cargo: '20',
  stealth: '50',
  marketValueJson: '{\n  "netherlands": 10000\n}',
}

const defaultNewPremiumOffer: CreatePremiumOfferPayload = {
  key: '',
  titleNl: '',
  titleEn: '',
  imageUrl: '',
  priceEurCents: 199,
  rewardType: 'money',
  moneyAmount: 10000,
  ammoType: '9mm',
  ammoQuantity: 100,
  isActive: true,
  showPopupOnOpen: false,
  notifyAllPlayers: false,
  sortOrder: 50,
}

const defaultNewEventTemplate: CreateGameEventTemplatePayload = {
  key: '',
  category: 'vehicle',
  eventType: 'boost',
  titleNl: '',
  titleEn: '',
  shortDescriptionNl: '',
  shortDescriptionEn: '',
  descriptionNl: '',
  descriptionEn: '',
  icon: '',
  bannerImage: '',
  isActive: true,
}

const defaultNewEventSchedule: CreateGameEventSchedulePayload = {
  templateId: 0,
  scheduleType: 'interval',
  intervalMinutes: 180,
  durationMinutes: 45,
  cooldownMinutes: 0,
  enabled: true,
  weight: 100,
}

const defaultNewLiveEvent: CreateGameLiveEventPayload = {
  templateId: 0,
  status: 'active',
  startedAt: null,
  endsAt: null,
}

function App() {
  const initialRecentActionsPrefs = getStoredRecentActionsPrefs()
  const initialRecentActionsViews = getStoredRecentActionsViews()
  const [language, setLanguage] = useState<Language>('nl')
  const [theme, setTheme] = useState<'light' | 'dark'>(() => (localStorage.getItem('theme') === 'dark' ? 'dark' : 'light'))
  const t = translations[language]
  const l = (nl: string, en: string) => (language === 'nl' ? nl : en)
  const tr = (template: string, vars: Record<string, string | number>) =>
    Object.entries(vars).reduce((acc, [key, value]) => acc.replace(`{${key}}`, String(value)), template)
  const [isAuthenticated, setIsAuthenticated] = useState(adminAuthService.isAuthenticated())
  const [adminRole, setAdminRole] = useState<'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER' | null>(adminAuthService.getAdminRole())
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [stats, setStats] = useState({ totalPlayers: 0, activePlayers: 0, bannedPlayers: 0 })
  const [systemHealth, setSystemHealth] = useState<SystemHealthDetails | null>(null)
  const [systemHealthLoading, setSystemHealthLoading] = useState(false)
  const [dashboardOverview, setDashboardOverview] = useState<DashboardOverview | null>(null)
  const [dashboardOverviewLoading, setDashboardOverviewLoading] = useState(false)
  const [dashboardSectionOpen, setDashboardSectionOpen] = useState({
    system: true,
    alerts: true,
    quickActions: true,
    trends: true,
    liveActivity: true,
    riskPlayers: true,
  })
  const [dashboardLastUpdated, setDashboardLastUpdated] = useState<{
    stats: string | null
    system: string | null
    overview: string | null
  }>({
    stats: null,
    system: null,
    overview: null,
  })
  const [error, setError] = useState('')
  const [apiError, setApiError] = useState('')
  const [loading, setLoading] = useState(false)
  const [activeTab, setActiveTab] = useState<TabType>('dashboard')
  const [isTopbarScrolled, setIsTopbarScrolled] = useState(false)
  
  // Players state
  const [players, setPlayers] = useState<Player[]>([])
  const [playersPage, setPlayersPage] = useState(1)
  const [playersTotalPages, setPlayersTotalPages] = useState(1)
  const [playerSearch, setPlayerSearch] = useState('')
  const [playerSearchFilter, setPlayerSearchFilter] = useState('')
  const [selectedPlayerIds, setSelectedPlayerIds] = useState<number[]>([])
  const [bulkActionLoading, setBulkActionLoading] = useState(false)
  const [selectedPlayerId, setSelectedPlayerId] = useState<number | null>(null)
  const [selectedPlayerOverview, setSelectedPlayerOverview] = useState<PlayerOverview | null>(null)
  const [selectedPlayerAvatar, setSelectedPlayerAvatar] = useState<string | null>(null)
  const [playerDetailTab, setPlayerDetailTab] = useState<PlayerDetailTab>('overview')
  const [actionsDateRange, setActionsDateRange] = useState<DateRangeFilter>(initialRecentActionsPrefs.dateRange)
  const [actionsTypeFilter, setActionsTypeFilter] = useState(initialRecentActionsPrefs.typeFilter)
  const [actionsSearchInput, setActionsSearchInput] = useState(initialRecentActionsPrefs.search)
  const [actionsSearchFilter, setActionsSearchFilter] = useState(initialRecentActionsPrefs.search)
  const [actionsSort, setActionsSort] = useState<ActivitySort>(initialRecentActionsPrefs.sort)
  const [actionsPage, setActionsPage] = useState(1)
  const [recentActivitiesRows, setRecentActivitiesRows] = useState<RecentActivityItem[]>([])
  const [recentActivitiesTotal, setRecentActivitiesTotal] = useState(0)
  const [recentActivitiesTotalPages, setRecentActivitiesTotalPages] = useState(1)
  const [recentActivitiesAvailableTypes, setRecentActivitiesAvailableTypes] = useState<string[]>([])
  const [recentActivitiesSummary, setRecentActivitiesSummary] = useState({ totalMoney: 0, totalXp: 0 })
  const [recentActivitiesTrend, setRecentActivitiesTrend] = useState<Array<{ date: string; count: number; money: number; xp: number }>>([])
  const [recentActivitiesLoading, setRecentActivitiesLoading] = useState(false)
  const [recentActivitiesError, setRecentActivitiesError] = useState('')
  const [recentActionsRefreshTick, setRecentActionsRefreshTick] = useState(0)
  const [recentActionsTimezone, setRecentActionsTimezone] = useState<ActivityTimezone>(() => {
    const raw = localStorage.getItem('admin_recent_actions_tz')
    return raw === 'utc' ? 'utc' : 'local'
  })
  const [recentActionsSavedViews, setRecentActionsSavedViews] = useState<SavedRecentActionsView[]>(initialRecentActionsViews)
  const [recentActionsAutoRefreshSeconds, setRecentActionsAutoRefreshSeconds] = useState<0 | 15 | 30 | 60>(0)
  const [financialDateRange, setFinancialDateRange] = useState<DateRangeFilter>('30d')
  const [financialPlayerSort, setFinancialPlayerSort] = useState<'date_desc' | 'date_asc' | 'bet_desc' | 'bet_asc' | 'result_desc' | 'result_asc'>('date_desc')
  const [financialOwnerSort, setFinancialOwnerSort] = useState<'date_desc' | 'date_asc' | 'cut_desc' | 'cut_asc' | 'player_desc' | 'player_asc'>('date_desc')
  const [financialPremiumSort, setFinancialPremiumSort] = useState<'date_desc' | 'date_asc' | 'id_desc' | 'id_asc' | 'product_asc' | 'product_desc'>('date_desc')
  const [playerDetailLoading, setPlayerDetailLoading] = useState(false)
  const [isSavingPlayerManage, setIsSavingPlayerManage] = useState(false)
  const [playerManageForm, setPlayerManageForm] = useState<PlayerManageForm>({
    setMoney: '',
    setRank: '',
    setXp: '',
    setHealth: '',
    setCountry: '',
    addMoney: '',
    addXp: '',
    vipEnabled: false,
    vipDays: '7',
    ammoType: '9mm',
    ammoQuantity: '0',
    toolId: '',
    toolQuantity: '1',
  })
  const [banningPlayer, setBanningPlayer] = useState<Player | null>(null)
  const [banReason, setBanReason] = useState('')
  const [banType, setBanType] = useState<'temporary' | 'permanent'>('temporary')
  const [banDuration, setBanDuration] = useState('24')
  const [playerManageReason, setPlayerManageReason] = useState('')
  
  // Audit logs state
  const [auditLogs, setAuditLogs] = useState<AuditLog[]>([])
  const [auditPage, setAuditPage] = useState(1)
  const [auditTotalPages, setAuditTotalPages] = useState(1)
  const [systemLogs, setSystemLogs] = useState<SystemLogEntry[]>([])
  const [systemLogPage, setSystemLogPage] = useState(1)
  const [systemLogTotalPages, setSystemLogTotalPages] = useState(1)
  const [systemLogDateFilter, setSystemLogDateFilter] = useState<DateRangeFilter>('7d')
  const [systemLogSourceFilter, setSystemLogSourceFilter] = useState('all')
  const [systemLogSearchFilter, setSystemLogSearchFilter] = useState('')

  const [admins, setAdmins] = useState<AdminAccount[]>([])
  const [adminsLoading, setAdminsLoading] = useState(false)
  const [savingAdminId, setSavingAdminId] = useState<number | null>(null)
  const [newAdminForm, setNewAdminForm] = useState<NewAdminForm>({
    username: '',
    password: '',
    role: 'VIEWER',
  })
  const [isCreatingAdmin, setIsCreatingAdmin] = useState(false)

  // Config state
  const [config, setConfig] = useState<Record<string, string>>({})
  const [configSearch, setConfigSearch] = useState('')
  const [editingConfig, setEditingConfig] = useState<Record<string, string>>({})

  // Premium offers state
  const [premiumOffers, setPremiumOffers] = useState<PremiumOffer[]>([])
  const [premiumOffersLoading, setPremiumOffersLoading] = useState(false)
  const [newPremiumOffer, setNewPremiumOffer] = useState<CreatePremiumOfferPayload>(defaultNewPremiumOffer)
  const [previewOffer, setPreviewOffer] = useState<PremiumOfferPreview | null>(null)
  const [filterPopupOnly, setFilterPopupOnly] = useState(false)

  // NPC state
  const [npcs, setNPCs] = useState<NPC[]>([])
  const [npcLoading, setNPCLoading] = useState(false)
  const [selectedNPC, setSelectedNPC] = useState<NPC | null>(null)
  const [creatingNPC, setCreatingNPC] = useState(false)
  const [newNPCUsername, setNewNPCUsername] = useState('')
  const [newNPCActivityLevel, setNewNPCActivityLevel] = useState('MATIG')
  const [simulatingNPC, setSimulatingNPC] = useState<NPC | null>(null)
  const [simulateHours, setSimulateHours] = useState('1')

  // Vehicle content state
  const [vehiclesLoading, setVehiclesLoading] = useState(false)
  const [carDefinitions, setCarDefinitions] = useState<AdminVehicle[]>([])
  const [boatDefinitions, setBoatDefinitions] = useState<AdminVehicle[]>([])
  const [newVehicle, setNewVehicle] = useState<NewVehicleForm>(defaultNewVehicleForm)

  // Aircraft state
  const [aircraftList, setAircraftList] = useState<AdminAircraft[]>([])
  const [newAircraft, setNewAircraft] = useState({ id: '', name: '', type: 'light_aircraft', description: '', price: 250000, minRank: 20, maxRange: 1000, fuelCapacity: 200, fuelCostPerKm: 50, repairCost: 25000, speedMultiplier: 1.5, cargoCapacity: 100, image: '' })

  // Tools state
  const [toolsList, setToolsList] = useState<AdminTool[]>([])
  const [toolsLoading, setToolsLoading] = useState(false)
  const [newTool, setNewTool] = useState({ id: '', name: '', type: '', basePrice: 100, maxDurability: 100, loseChance: 0.1, wearPerUse: 10, requiredFor: '', image: '' })

  // Crimes state
  const [crimesList, setCrimesList] = useState<AdminCrime[]>([])
  const [crimesLoading, setCrimesLoading] = useState(false)
  const [newCrime, setNewCrime] = useState<{ id: string; name: string; description: string; minLevel: number; baseSuccessChance: number; minReward: number; maxReward: number; xpReward: number; minXpReward: number; maxXpReward: number; jailTime: number; requiredVehicle: boolean; requiredVehicleType: string; breakdownChance: number; requiredTools: string[]; isFederal: boolean }>({
    id: '', name: '', description: '', minLevel: 1, baseSuccessChance: 0.5, minReward: 100, maxReward: 500, xpReward: 20, minXpReward: 20, maxXpReward: 40, jailTime: 15, requiredVehicle: false, requiredVehicleType: 'none', breakdownChance: 0, requiredTools: [], isFederal: false,
  })

  // Game Events state
  const [eventTemplates, setEventTemplates] = useState<GameEventTemplate[]>([])
  const [eventSchedules, setEventSchedules] = useState<GameEventSchedule[]>([])
  const [liveEvents, setLiveEvents] = useState<GameLiveEvent[]>([])
  const [eventsLoading, setEventsLoading] = useState(false)
  const [newEventTemplate, setNewEventTemplate] = useState<CreateGameEventTemplatePayload>(defaultNewEventTemplate)
  const [newEventSchedule, setNewEventSchedule] = useState<CreateGameEventSchedulePayload>(defaultNewEventSchedule)
  const [newLiveEvent, setNewLiveEvent] = useState<CreateGameLiveEventPayload>(defaultNewLiveEvent)
  const [savingEventTemplateId, setSavingEventTemplateId] = useState<number | null>(null)
  const [savingEventScheduleId, setSavingEventScheduleId] = useState<number | null>(null)
  const [savingLiveEventId, setSavingLiveEventId] = useState<number | null>(null)

  useEffect(() => {
    if (isAuthenticated) {
      loadStats()
      loadSystemHealth()
      loadDashboardOverview()
    }
  }, [isAuthenticated])

  useEffect(() => {
    if (!isAuthenticated || activeTab !== 'dashboard') return

    const timer = window.setInterval(() => {
      loadSystemHealth()
      loadDashboardOverview()
    }, 30000)

    return () => window.clearInterval(timer)
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'players') {
      loadPlayers()
    }
  }, [isAuthenticated, activeTab, playersPage, playerSearchFilter])

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setPlayerSearchFilter(playerSearch.trim())
      setPlayersPage(1)
    }, PLAYER_SEARCH_DEBOUNCE_MS)
    return () => window.clearTimeout(timeout)
  }, [playerSearch])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'audit-logs') {
      loadAuditLogs()
    }
  }, [isAuthenticated, activeTab, auditPage])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'system-logs') {
      loadSystemLogs()
    }
  }, [isAuthenticated, activeTab, systemLogPage])

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setActionsSearchFilter(actionsSearchInput.trim())
    }, 250)
    return () => window.clearTimeout(timeout)
  }, [actionsSearchInput])

  useEffect(() => {
    if (typeof window === 'undefined') return
    localStorage.setItem(RECENT_ACTIONS_VIEWS_KEY, JSON.stringify(recentActionsSavedViews))
  }, [recentActionsSavedViews])

  useEffect(() => {
    if (typeof window === 'undefined') return
    localStorage.setItem('admin_recent_actions_tz', recentActionsTimezone)
  }, [recentActionsTimezone])

  useEffect(() => {
    setActionsPage(1)
  }, [selectedPlayerId, actionsDateRange, actionsTypeFilter, actionsSearchFilter, actionsSort])

  useEffect(() => {
    if (actionsPage > recentActivitiesTotalPages) {
      setActionsPage(recentActivitiesTotalPages)
    }
  }, [actionsPage, recentActivitiesTotalPages])

  useEffect(() => {
    if (typeof window === 'undefined') return
    localStorage.setItem(
      RECENT_ACTIONS_PREFS_KEY,
      JSON.stringify({
        dateRange: actionsDateRange,
        typeFilter: actionsTypeFilter,
        search: actionsSearchInput,
        sort: actionsSort,
      }),
    )
  }, [actionsDateRange, actionsTypeFilter, actionsSearchInput, actionsSort])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'admins') {
      loadAdmins()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'config') {
      loadConfig()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'premium-offers') {
      loadPremiumOffers()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'npcs') {
      loadNPCs()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'vehicles') {
      loadVehicles()
      loadAircraft()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'tools') {
      loadTools()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'crimes') {
      loadCrimes()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    if (isAuthenticated && activeTab === 'events') {
      loadEventAdminData()
    }
  }, [isAuthenticated, activeTab])

  useEffect(() => {
    const loadRecentActivities = async () => {
      if (!selectedPlayerId || activeTab !== 'player-detail' || playerDetailTab !== 'overview') return

      setRecentActivitiesLoading(true)
      setRecentActivitiesError('')
      try {
        const response = await adminService.getPlayerRecentActivities({
          playerId: selectedPlayerId,
          page: actionsPage,
          limit: RECENT_ACTIONS_PAGE_SIZE,
          dateRange: actionsDateRange,
          typeFilter: actionsTypeFilter,
          search: actionsSearchFilter,
          sort: actionsSort,
        })

        setRecentActivitiesRows(response.items)
        setRecentActivitiesTotal(response.total)
        setRecentActivitiesTotalPages(response.totalPages)
        setRecentActivitiesAvailableTypes(response.availableTypes || [])
        setRecentActivitiesSummary(response.summary || { totalMoney: 0, totalXp: 0 })
        setRecentActivitiesTrend(response.trend || [])
      } catch (err) {
        if (handleUnauthorized(err)) return
        const message = err instanceof Error ? err.message : t.unknownError
        setRecentActivitiesError(`${l('Recente handelingen laden mislukt', 'Failed to load recent activities')}: ${message}`)
      } finally {
        setRecentActivitiesLoading(false)
      }
    }

    loadRecentActivities()
  }, [
    selectedPlayerId,
    activeTab,
    playerDetailTab,
    actionsPage,
    actionsDateRange,
    actionsTypeFilter,
    actionsSearchFilter,
    actionsSort,
    isAuthenticated,
    recentActionsRefreshTick,
  ])

  useEffect(() => {
    if (recentActionsAutoRefreshSeconds === 0) return
    if (activeTab !== 'player-detail' || playerDetailTab !== 'overview' || !selectedPlayerId) return

    const timer = window.setInterval(() => {
      setRecentActionsRefreshTick((tick) => tick + 1)
    }, recentActionsAutoRefreshSeconds * 1000)

    return () => window.clearInterval(timer)
  }, [recentActionsAutoRefreshSeconds, activeTab, playerDetailTab, selectedPlayerId])

  useEffect(() => {
    const onScroll = () => {
      setIsTopbarScrolled(window.scrollY > 8)
    }

    onScroll()
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  useEffect(() => {
    if (theme === 'dark') {
      document.documentElement.setAttribute('data-color-theme', 'dark')
      localStorage.setItem('theme', 'dark')
      return
    }

    document.documentElement.removeAttribute('data-color-theme')
    localStorage.removeItem('theme')
  }, [theme])

  const handleUnauthorized = (err: unknown): boolean => {
    if ((err as Error)?.message === 'UNAUTHORIZED') {
      adminAuthService.logout()
      setIsAuthenticated(false)
      setAdminRole(null)
      setError(l('Je sessie is verlopen. Log opnieuw in.', 'Your session expired. Please log in again.'))
      setApiError('')
      return true
    }

    return false
  }

  const loadStats = async () => {
    try {
      const data = await adminService.getStats()
      setStats(data)
      setDashboardLastUpdated((current) => ({ ...current, stats: new Date().toISOString() }))
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load stats:', err)
      setApiError(t.statsLoadError)
    }
  }

  const loadSystemHealth = async () => {
    try {
      setSystemHealthLoading(true)
      const data = await adminService.getSystemHealthDetails()
      setSystemHealth(data)
      setDashboardLastUpdated((current) => ({ ...current, system: new Date().toISOString() }))
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load system health:', err)
    } finally {
      setSystemHealthLoading(false)
    }
  }

  const loadDashboardOverview = async () => {
    try {
      setDashboardOverviewLoading(true)
      const data = await adminService.getDashboardOverview()
      setDashboardOverview(data)
      setDashboardLastUpdated((current) => ({ ...current, overview: new Date().toISOString() }))
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load dashboard overview:', err)
    } finally {
      setDashboardOverviewLoading(false)
    }
  }

  const loadPlayers = async () => {
    try {
      const data = await adminService.getPlayers(playersPage, 20, playerSearchFilter)
      setPlayers(data.players)
      setPlayersTotalPages(data.totalPages)
      setSelectedPlayerIds((current) => current.filter((id) => data.players.some((p: Player) => p.id === id)))
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load players:', err)
      setApiError(t.playersLoadError)
    }
  }

  const loadAuditLogs = async () => {
    try {
      const data = await adminService.getAuditLogs(auditPage, 50)
      setAuditLogs(data.logs)
      setAuditTotalPages(data.totalPages)
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load audit logs:', err)
      setApiError(t.auditLoadError)
    }
  }

  const loadSystemLogs = async () => {
    try {
      const data = await adminService.getSystemLogs(systemLogPage, 50)
      setSystemLogs(data.logs || [])
      setSystemLogTotalPages(data.totalPages || 1)
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load system logs:', err)
      setApiError(l('Systeemlogs konden niet geladen worden.', 'System logs could not be loaded.'))
    }
  }

  const loadAdmins = async () => {
    try {
      setAdminsLoading(true)
      const data = await adminService.getAdmins()
      setAdmins(data.admins || [])
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load admins:', err)
      setApiError(l('Admins konden niet geladen worden.', 'Admins could not be loaded.'))
    } finally {
      setAdminsLoading(false)
    }
  }

  const handleCreateAdmin = async () => {
    if (!newAdminForm.username.trim() || !newAdminForm.password.trim()) {
      alert(l('Vul gebruikersnaam en wachtwoord in.', 'Please provide username and password.'))
      return
    }

    try {
      setIsCreatingAdmin(true)
      await adminService.createAdmin({
        username: newAdminForm.username.trim(),
        password: newAdminForm.password,
        role: newAdminForm.role,
      })
      setNewAdminForm({ username: '', password: '', role: 'VIEWER' })
      await loadAdmins()
      alert(l('Admin succesvol aangemaakt.', 'Admin created successfully.'))
    } catch (err) {
      if (handleUnauthorized(err)) return
      alert(`${l('Admin aanmaken mislukt', 'Failed to create admin')}: ${(err as Error).message}`)
    } finally {
      setIsCreatingAdmin(false)
    }
  }

  const handleUpdateAdmin = async (admin: AdminAccount, updates: { role?: 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER'; isActive?: boolean; password?: string }) => {
    try {
      setSavingAdminId(admin.id)
      await adminService.updateAdmin(admin.id, updates)
      await loadAdmins()
    } catch (err) {
      if (handleUnauthorized(err)) return
      alert(`${l('Admin bijwerken mislukt', 'Failed to update admin')}: ${(err as Error).message}`)
    } finally {
      setSavingAdminId(null)
    }
  }

  const loadConfig = async () => {
    try {
      const data = await adminService.getConfig()
      setConfig(data.env)
      setEditingConfig(data.env)
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load config:', err)
      setApiError(t.configLoadError)
    }
  }

  const loadPremiumOffers = async () => {
    try {
      setPremiumOffersLoading(true)
      const data = await adminService.getPremiumOffers()
      setPremiumOffers(data.offers || [])
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load premium offers:', err)
      alert(t.failedLoadPremium)
      setApiError(t.premiumLoadError)
    } finally {
      setPremiumOffersLoading(false)
    }
  }
  const loadNPCs = async () => {
    try {
      setNPCLoading(true)
      const data = await adminService.getNPCs()
      console.log('NPCs loaded:', data)
      console.log('NPCs count:', data.npcs?.length || 0)
      setNPCs(data.npcs || [])
      setApiError('')
    } catch (err) {
      console.error('Failed to load NPCs:', err)
      alert(`${t.failedLoadNpcs}: ${(err as Error).message}`)
      setApiError(t.npcsLoadError)
    } finally {
      setNPCLoading(false)
    }
  }

  const loadVehicles = async () => {
    try {
      setVehiclesLoading(true)
      const data = await adminService.getVehicles()
      setCarDefinitions(data.cars || [])
      setBoatDefinitions(data.boats || [])
      setApiError('')
    } catch (err) {
      console.error('Failed to load vehicles:', err)
      alert(t.failedLoadVehicles)
      setApiError(t.vehiclesLoadError)
    } finally {
      setVehiclesLoading(false)
    }
  }

  const handleAddVehicle = async () => {
    try {
      const availableInCountries = newVehicle.availableInCountries
        .split(',')
        .map((entry) => entry.trim())
        .filter(Boolean)

      if (!availableInCountries.length) {
        alert(t.enterCountryCode)
        return
      }

      const marketValue = JSON.parse(newVehicle.marketValueJson)

      await adminService.addVehicle({
        category: newVehicle.category,
        vehicle: {
          id: newVehicle.id.trim(),
          name: newVehicle.name.trim(),
          type: newVehicle.type.trim(),
          image: newVehicle.imageNew.trim(),
          imageNew: newVehicle.imageNew.trim(),
          imageDirty: newVehicle.imageDirty.trim(),
          imageDamaged: newVehicle.imageDamaged.trim(),
          description: newVehicle.description.trim(),
          availableInCountries,
          baseValue: parseInt(newVehicle.baseValue, 10),
          fuelCapacity: parseInt(newVehicle.fuelCapacity, 10),
          requiredRank: parseInt(newVehicle.requiredRank, 10),
          stats: {
            speed: parseInt(newVehicle.speed, 10),
            armor: parseInt(newVehicle.armor, 10),
            cargo: parseInt(newVehicle.cargo, 10),
            stealth: parseInt(newVehicle.stealth, 10),
          },
          marketValue,
          rarity: newVehicle.rarity,
        },
      })

      alert(t.addVehicleSuccess)
      setNewVehicle(defaultNewVehicleForm)
      await loadVehicles()
    } catch (err: any) {
      console.error('Failed to add vehicle:', err)
      alert(`${t.failedAddVehicle}: ${err.message || t.unknownError}`)
    }
  }

  const handleDeleteVehicle = async (category: 'cars' | 'boats', vehicleId: string) => {
    const confirmed = window.confirm(tr(t.confirmDeleteVehicle, { id: vehicleId }))
    if (!confirmed) return

    try {
      await adminService.deleteVehicle(category, vehicleId)
      await loadVehicles()
    } catch (err: any) {
      console.error('Failed to delete vehicle:', err)
      alert(`${t.failedDeleteVehicle}: ${err.message || t.unknownError}`)
    }
  }

  // Aircraft handlers
  const loadAircraft = async () => {
    try {
      const data = await adminService.getAircraft()
      setAircraftList(data.aircraft || [])
      setApiError('')
    } catch (err) {
      console.error('Failed to load aircraft:', err)
      setApiError(t.aircraftLoadError)
    }
  }

  const handleAddAircraft = async () => {
    try {
      await adminService.addAircraft({ ...newAircraft, image: newAircraft.image || undefined })
      alert(t.addAircraftSuccess)
      setNewAircraft({ id: '', name: '', type: 'light_aircraft', description: '', price: 250000, minRank: 20, maxRange: 1000, fuelCapacity: 200, fuelCostPerKm: 50, repairCost: 25000, speedMultiplier: 1.5, cargoCapacity: 100, image: '' })
      await loadAircraft()
    } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const handleDeleteAircraft = async (id: string) => {
    if (!window.confirm(tr(t.confirmDeleteAircraft, { id }))) return
    try { await adminService.deleteAircraft(id); await loadAircraft() } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  // Tools handlers
  const loadTools = async () => {
    try {
      setToolsLoading(true)
      const data = await adminService.getTools()
      setToolsList(data.tools || [])
      setApiError('')
    } catch (err) { console.error('Failed to load tools:', err); alert(t.failedLoadTools); setApiError(t.toolsLoadError) }
    finally { setToolsLoading(false) }
  }

  const handleAddTool = async () => {
    try {
      const payload = { ...newTool, requiredFor: newTool.requiredFor.split(',').map((s) => s.trim()).filter(Boolean), image: newTool.image || undefined }
      await adminService.addTool(payload)
      alert(t.addToolSuccess)
      setNewTool({ id: '', name: '', type: '', basePrice: 100, maxDurability: 100, loseChance: 0.1, wearPerUse: 10, requiredFor: '', image: '' })
      await loadTools()
    } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const handleDeleteTool = async (id: string) => {
    if (!window.confirm(tr(t.confirmDeleteTool, { id }))) return
    try { await adminService.deleteTool(id); await loadTools() } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const handleSaveTool = async (tool: AdminTool) => {
    try { await adminService.updateTool(tool.id, tool); alert(t.saved); await loadTools() } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const updateToolField = (id: string, key: keyof AdminTool, value: any) => {
    setToolsList((prev) => prev.map((t) => t.id === id ? { ...t, [key]: value } : t))
  }

  // Crimes handlers
  const loadCrimes = async () => {
    try {
      setCrimesLoading(true)
      const data = await adminService.getCrimes()
      setCrimesList((data.crimes || []).map((crime: AdminCrime) => ({
        ...crime,
        minXpReward: crime.minXpReward ?? crime.xpReward,
        maxXpReward: crime.maxXpReward ?? crime.xpReward,
      })))
      setApiError('')
    } catch (err) { console.error('Failed to load crimes:', err); alert(t.failedLoadCrimes); setApiError(t.crimesLoadError) }
    finally { setCrimesLoading(false) }
  }

  const handleAddCrime = async () => {
    try {
      const payload: any = { ...newCrime }
      if (payload.requiredVehicleType === 'none') delete payload.requiredVehicleType
      payload.xpReward = Math.round((payload.minXpReward + payload.maxXpReward) / 2)
      await adminService.addCrime(payload)
      alert(t.addCrimeSuccess)
      setNewCrime({ id: '', name: '', description: '', minLevel: 1, baseSuccessChance: 0.5, minReward: 100, maxReward: 500, xpReward: 20, minXpReward: 20, maxXpReward: 40, jailTime: 15, requiredVehicle: false, requiredVehicleType: 'none', breakdownChance: 0, requiredTools: [], isFederal: false })
      await loadCrimes()
    } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const handleDeleteCrime = async (id: string) => {
    if (!window.confirm(tr(t.confirmDeleteCrime, { id }))) return
    try { await adminService.deleteCrime(id); await loadCrimes() } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const handleSaveCrime = async (crime: AdminCrime) => {
    try {
      const payload: any = {
        ...crime,
        xpReward: Math.round(((crime.minXpReward ?? crime.xpReward) + (crime.maxXpReward ?? crime.xpReward)) / 2),
      }
      await adminService.updateCrime(crime.id, payload)
      alert(t.saved)
      await loadCrimes()
    } catch (err: any) { alert(`${t.errorPrefix}: ${err.message}`) }
  }

  const updateCrimeField = (id: string, key: keyof AdminCrime, value: any) => {
    setCrimesList((prev) => prev.map((c) => c.id === id ? { ...c, [key]: value } : c))
  }

  const loadEventAdminData = async () => {
    try {
      setEventsLoading(true)
      const [templatesRes, schedulesRes, liveRes] = await Promise.all([
        adminService.getEventTemplates(),
        adminService.getEventSchedules(),
        adminService.getLiveEvents(),
      ])

      const templates = templatesRes.templates || []
      setEventTemplates(templates)
      setEventSchedules(schedulesRes.schedules || [])
      setLiveEvents(liveRes.liveEvents || [])

      if (templates.length > 0) {
        const firstTemplateId = templates[0].id
        setNewEventSchedule((prev) => ({ ...prev, templateId: prev.templateId > 0 ? prev.templateId : firstTemplateId }))
        setNewLiveEvent((prev) => ({ ...prev, templateId: prev.templateId > 0 ? prev.templateId : firstTemplateId }))
      }

      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      console.error('Failed to load game events admin data:', err)
      setApiError(l('Event data kon niet geladen worden.', 'Failed to load event data.'))
    } finally {
      setEventsLoading(false)
    }
  }

  const handleCreateEventTemplate = async () => {
    if (!newEventTemplate.key?.trim() || !newEventTemplate.titleNl?.trim() || !newEventTemplate.titleEn?.trim()) {
      alert(l('Vul key, Nederlandse titel en Engelse titel in.', 'Fill key, Dutch title, and English title.'))
      return
    }

    try {
      await adminService.createEventTemplate({
        ...newEventTemplate,
        key: newEventTemplate.key.trim(),
        titleNl: newEventTemplate.titleNl.trim(),
        titleEn: newEventTemplate.titleEn.trim(),
      })
      setNewEventTemplate(defaultNewEventTemplate)
      await loadEventAdminData()
      alert(l('Event template aangemaakt.', 'Event template created.'))
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Template aanmaken mislukt', 'Failed to create template')}: ${err?.message || t.unknownError}`)
    }
  }

  const handleCreateEventSchedule = async () => {
    if (!newEventSchedule.templateId || newEventSchedule.templateId <= 0) {
      alert(l('Kies een template voor het schema.', 'Choose a template for the schedule.'))
      return
    }

    try {
      await adminService.createEventSchedule(newEventSchedule)
      setNewEventSchedule((prev) => ({ ...defaultNewEventSchedule, templateId: prev.templateId }))
      await loadEventAdminData()
      alert(l('Eventschema aangemaakt.', 'Event schedule created.'))
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Schema aanmaken mislukt', 'Failed to create schedule')}: ${err?.message || t.unknownError}`)
    }
  }

  const handleCreateLiveEvent = async () => {
    if (!newLiveEvent.templateId || newLiveEvent.templateId <= 0) {
      alert(l('Kies een template voor het live event.', 'Choose a template for the live event.'))
      return
    }

    try {
      await adminService.createLiveEvent({
        ...newLiveEvent,
        startedAt: newLiveEvent.startedAt || null,
        endsAt: newLiveEvent.endsAt || null,
      })
      setNewLiveEvent((prev) => ({ ...defaultNewLiveEvent, templateId: prev.templateId }))
      await loadEventAdminData()
      alert(l('Live event gestart.', 'Live event created.'))
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Live event starten mislukt', 'Failed to create live event')}: ${err?.message || t.unknownError}`)
    }
  }

  const handleToggleTemplateActive = async (template: GameEventTemplate) => {
    try {
      await adminService.updateEventTemplate(template.id, { isActive: !template.isActive })
      await loadEventAdminData()
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Template bijwerken mislukt', 'Failed to update template')}: ${err?.message || t.unknownError}`)
    }
  }

  const updateEventTemplateField = <K extends keyof GameEventTemplate>(id: number, key: K, value: GameEventTemplate[K]) => {
    setEventTemplates((prev) => prev.map((item) => item.id === id ? { ...item, [key]: value } : item))
  }

  const handleSaveEventTemplate = async (template: GameEventTemplate) => {
    try {
      setSavingEventTemplateId(template.id)
      await adminService.updateEventTemplate(template.id, {
        key: template.key,
        category: template.category,
        eventType: template.eventType,
        titleNl: template.titleNl,
        titleEn: template.titleEn,
        shortDescriptionNl: template.shortDescriptionNl ?? null,
        shortDescriptionEn: template.shortDescriptionEn ?? null,
        descriptionNl: template.descriptionNl ?? null,
        descriptionEn: template.descriptionEn ?? null,
        icon: template.icon ?? null,
        bannerImage: template.bannerImage ?? null,
        isActive: template.isActive,
      })
      await loadEventAdminData()
      alert(l('Template opgeslagen.', 'Template saved.'))
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Template opslaan mislukt', 'Failed to save template')}: ${err?.message || t.unknownError}`)
    } finally {
      setSavingEventTemplateId(null)
    }
  }

  const handleToggleScheduleEnabled = async (schedule: GameEventSchedule) => {
    try {
      await adminService.updateEventSchedule(schedule.id, { enabled: !schedule.enabled })
      await loadEventAdminData()
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Schema bijwerken mislukt', 'Failed to update schedule')}: ${err?.message || t.unknownError}`)
    }
  }

  const updateEventScheduleField = <K extends keyof GameEventSchedule>(id: number, key: K, value: GameEventSchedule[K]) => {
    setEventSchedules((prev) => prev.map((item) => item.id === id ? { ...item, [key]: value } : item))
  }

  const handleSaveEventSchedule = async (schedule: GameEventSchedule) => {
    try {
      setSavingEventScheduleId(schedule.id)
      await adminService.updateEventSchedule(schedule.id, {
        scheduleType: schedule.scheduleType,
        intervalMinutes: schedule.intervalMinutes ?? null,
        durationMinutes: schedule.durationMinutes ?? null,
        cooldownMinutes: schedule.cooldownMinutes ?? null,
        enabled: schedule.enabled,
        weight: schedule.weight,
      })
      await loadEventAdminData()
      alert(l('Schema opgeslagen.', 'Schedule saved.'))
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Schema opslaan mislukt', 'Failed to save schedule')}: ${err?.message || t.unknownError}`)
    } finally {
      setSavingEventScheduleId(null)
    }
  }

  const updateLiveEventField = <K extends keyof GameLiveEvent>(id: number, key: K, value: GameLiveEvent[K]) => {
    setLiveEvents((prev) => prev.map((item) => item.id === id ? { ...item, [key]: value } : item))
  }

  const handleSaveLiveEvent = async (liveEvent: GameLiveEvent) => {
    try {
      setSavingLiveEventId(liveEvent.id)
      await adminService.updateLiveEvent(liveEvent.id, {
        status: liveEvent.status,
        startedAt: liveEvent.startedAt ?? null,
        endsAt: liveEvent.endsAt ?? null,
      })
      await loadEventAdminData()
      alert(l('Live event opgeslagen.', 'Live event saved.'))
    } catch (err: any) {
      if (handleUnauthorized(err)) return
      alert(`${l('Live event opslaan mislukt', 'Failed to save live event')}: ${err?.message || t.unknownError}`)
    } finally {
      setSavingLiveEventId(null)
    }
  }

  const handleCreateNPC = async () => {
    if (!newNPCUsername.trim()) {
      alert(t.npcUsernameRequired)
      return
    }
    try {
      setNPCLoading(true)
      await adminService.createNPC(newNPCUsername, newNPCActivityLevel)
      setNewNPCUsername('')
      setNewNPCActivityLevel('MATIG')
      setCreatingNPC(false)
      await loadNPCs()
    } catch (err) {
      console.error('Failed to create NPC:', err)
      alert(t.failedCreateNpc)
    } finally {
      setNPCLoading(false)
    }
  }

  const handleSimulateNPC = async (npc: NPC) => {
    setSimulatingNPC(npc)
    setSimulateHours('1')
  }

  const handleConfirmSimulate = async () => {
    if (!simulatingNPC) return
    
    const hours = parseFloat(simulateHours)
    if (isNaN(hours) || hours <= 0 || hours > 24) {
      alert(t.invalidSimHours)
      return
    }

    try {
      setNPCLoading(true)
      const result = await adminService.simulateNPC(simulatingNPC.id, hours)
      console.log('Simulation result:', result)
      alert(`${t.simulationComplete}\n\n${l('Activiteiten', 'Activities')}: ${result.result.activitiesPerformed}\n${l('Geld verdiend', 'Money earned')}: €${result.result.moneyEarned}\n${l('XP verdiend', 'XP earned')}: ${result.result.xpEarned}\n${l('Arrestaties', 'Arrests')}: ${result.result.arrests}`)
      setSimulatingNPC(null)
      await loadNPCs()
    } catch (err: any) {
      console.error('Failed to simulate NPC:', err)
      alert(`${t.failedSimNpc}: ${err.message}`)
    } finally {
      setNPCLoading(false)
    }
  }

  const handleViewNPCDetails = async (npc: NPC) => {
    try {
      const stats = await adminService.getNPCStats(npc.id)
      setSelectedNPC({ ...npc, stats: stats.stats })
    } catch (err) {
      console.error('Failed to load NPC stats:', err)
    }
  }
  const handleSaveConfig = async () => {
    try {
      const updates: Record<string, string> = {}
      Object.keys(editingConfig).forEach(key => {
        if (editingConfig[key] !== config[key]) {
          updates[key] = editingConfig[key]
        }
      })

      if (Object.keys(updates).length === 0) {
        alert(t.noChangesToSave)
        return
      }

      const result = await adminService.updateConfig(updates)
      alert(result.message + '\n\n' + result.warning)
      loadConfig()
    } catch (err) {
      alert(t.failedUpdateConfig)
    }
  }

  const updatePremiumOfferField = <K extends keyof PremiumOffer>(id: number, key: K, value: PremiumOffer[K]) => {
    setPremiumOffers((prev) => prev.map((offer) => (offer.id === id ? { ...offer, [key]: value } : offer)))
  }

  const handleSavePremiumOffer = async (offer: PremiumOffer) => {
    try {
      await adminService.updatePremiumOffer(offer.id, {
        titleNl: offer.titleNl,
        titleEn: offer.titleEn,
        imageUrl: offer.imageUrl,
        priceEurCents: offer.priceEurCents,
        rewardType: offer.rewardType,
        moneyAmount: offer.rewardType === 'money' ? offer.moneyAmount : null,
        ammoType: offer.rewardType === 'ammo' ? offer.ammoType : null,
        ammoQuantity: offer.rewardType === 'ammo' ? offer.ammoQuantity : null,
        isActive: offer.isActive,
        showPopupOnOpen: offer.showPopupOnOpen,
        sortOrder: offer.sortOrder,
      })
      alert(`${t.savedOffer}: ${offer.key}`)
      await loadPremiumOffers()
    } catch (err: any) {
      console.error('Failed to save premium offer:', err)
      alert(`${t.failedSaveOffer}: ${err.message || t.unknownError}`)
    }
  }

  const handleDeletePremiumOffer = async (offer: PremiumOffer) => {
    const confirmed = window.confirm(tr(t.confirmDeleteOffer, { key: offer.key }))
    if (!confirmed) return

    try {
      await adminService.deletePremiumOffer(offer.id)
      await loadPremiumOffers()
    } catch (err: any) {
      console.error('Failed to delete premium offer:', err)
      alert(`${t.failedDeleteOffer}: ${err.message || t.unknownError}`)
    }
  }

  const openPreview = (offer: PremiumOfferPreview) => {
    setPreviewOffer(offer)
  }

  const handleCreatePremiumOffer = async () => {
    try {
      if (!newPremiumOffer.key.trim()) {
        alert(t.keyRequired)
        return
      }

      if (newPremiumOffer.rewardType === 'money' && (!newPremiumOffer.moneyAmount || newPremiumOffer.moneyAmount <= 0)) {
        alert(t.moneyAmountRequired)
        return
      }

      if (newPremiumOffer.rewardType === 'ammo' && (!newPremiumOffer.ammoType || !newPremiumOffer.ammoQuantity || newPremiumOffer.ammoQuantity <= 0)) {
        alert(t.ammoRequired)
        return
      }

      await adminService.createPremiumOffer({
        ...newPremiumOffer,
        key: newPremiumOffer.key.trim(),
        titleNl: newPremiumOffer.titleNl.trim(),
        titleEn: newPremiumOffer.titleEn.trim(),
      })

      alert(`${t.createdOffer}: ${newPremiumOffer.key}`)
      setNewPremiumOffer(defaultNewPremiumOffer)
      await loadPremiumOffers()
    } catch (err: any) {
      console.error('Failed to create premium offer:', err)
      alert(`${t.failedCreateOffer}: ${err.message || t.unknownError}`)
    }
  }

  const handleBanPlayer = async (player: Player) => {
    setBanningPlayer(player)
    setBanReason('')
    setBanType('temporary')
    setBanDuration('24')
  }

  const handleConfirmBan = async () => {
    if (!banningPlayer) return
    
    if (!banReason.trim()) {
      alert(t.enterBanReason)
      return
    }
    
    try {
      const duration = banType === 'temporary' ? parseInt(banDuration) : undefined
      await adminService.banPlayer(banningPlayer.id, banReason, duration)
      alert(t.playerBanned)
      setBanningPlayer(null)
      loadPlayers()
    } catch (err) {
      const message = err instanceof Error ? err.message : t.unknownError
      alert(`${t.failedBanPlayer}: ${message}`)
    }
  }

  const openPlayerDetails = async (player: Player) => {
    setSelectedPlayerId(player.id)
    setSelectedPlayerAvatar(player.avatar)
    setPlayerDetailTab('overview')
    setActionsPage(1)
    setPlayerManageReason('')
    setPlayerDetailLoading(true)
    setActiveTab('player-detail')

    try {
      const overview = await adminService.getPlayerOverview(player.id)
      setSelectedPlayerOverview(overview)
      setPlayerManageForm({
        setMoney: String(overview.player.money),
        setRank: String(overview.player.rank),
        setXp: String(overview.player.xp),
        setHealth: String(overview.player.health),
        setCountry: overview.player.currentCountry,
        addMoney: '0',
        addXp: '0',
        vipEnabled: overview.player.isVip,
        vipDays: '7',
        ammoType: '9mm',
        ammoQuantity: '0',
        toolId: '',
        toolQuantity: '1',
      })
      setApiError('')
    } catch (err) {
      if (handleUnauthorized(err)) return
      const message = err instanceof Error ? err.message : t.unknownError
      setApiError(`${l('Spelerdetails laden mislukt', 'Failed to load player details')}: ${message}`)
    } finally {
      setPlayerDetailLoading(false)
    }
  }

  const handleManagePlayer = async () => {
    if (!selectedPlayerId) return
    if (isSavingPlayerManage) return
    if (!canManagePlayers) {
      alert(l('Je hebt geen rechten om spelers te beheren.', 'You do not have permission to manage players.'))
      return
    }

    const currentPlayer = selectedPlayerOverview?.player
    const setMoney = Number(playerManageForm.setMoney)
    const setRank = Number(playerManageForm.setRank)
    const setXp = Number(playerManageForm.setXp)
    const addMoney = Number(playerManageForm.addMoney)
    const addXp = Number(playerManageForm.addXp)

    const isCriticalChange = !!currentPlayer && (
      Math.abs(setMoney - currentPlayer.money) >= 500000 ||
      Math.abs(addMoney) >= 500000 ||
      setRank !== currentPlayer.rank ||
      Math.abs(setXp - currentPlayer.xp) >= 10000 ||
      Math.abs(addXp) >= 10000 ||
      playerManageForm.vipEnabled !== currentPlayer.isVip
    )

    if (isCriticalChange) {
      if (playerManageReason.trim().length < 5) {
        alert(l('Geef eerst een duidelijke beheerreden (min. 5 tekens).', 'Provide a clear admin reason first (min. 5 chars).'))
        return
      }
      const confirmation = window.prompt(
        l('Kritieke wijziging. Typ CONFIRM om door te gaan.', 'Critical change. Type CONFIRM to proceed.'),
        'CONFIRM',
      )
      if (confirmation !== 'CONFIRM') {
        return
      }
    }

    setIsSavingPlayerManage(true)
    try {
      const payload: any = {
        playerId: selectedPlayerId,
        ...(playerManageReason.trim() ? { reason: playerManageReason.trim() } : {}),
      }

      payload.set = {
        money: Number(playerManageForm.setMoney),
        rank: Number(playerManageForm.setRank),
        xp: Number(playerManageForm.setXp),
        health: Number(playerManageForm.setHealth),
        currentCountry: playerManageForm.setCountry,
      }

      if (Number(playerManageForm.addMoney) !== 0 || Number(playerManageForm.addXp) !== 0) {
        payload.add = {
          money: Number(playerManageForm.addMoney),
          xp: Number(playerManageForm.addXp),
        }
      }

      payload.vip = {
        enabled: playerManageForm.vipEnabled,
        days: Number(playerManageForm.vipDays) || 7,
      }

      if (Number(playerManageForm.ammoQuantity) > 0 && playerManageForm.ammoType.trim()) {
        payload.ammo = {
          ammoType: playerManageForm.ammoType.trim(),
          quantity: Number(playerManageForm.ammoQuantity),
        }
      }

      if (playerManageForm.toolId.trim() && Number(playerManageForm.toolQuantity) > 0) {
        payload.tool = {
          toolId: playerManageForm.toolId.trim(),
          quantity: Number(playerManageForm.toolQuantity),
        }
      }

      await adminService.managePlayer(payload)
      const refreshed = await adminService.getPlayerOverview(selectedPlayerId)
      setSelectedPlayerOverview(refreshed)
      setPlayerManageForm((prev) => ({
        ...prev,
        setMoney: String(refreshed.player.money),
        setRank: String(refreshed.player.rank),
        setXp: String(refreshed.player.xp),
        setHealth: String(refreshed.player.health),
        setCountry: refreshed.player.currentCountry,
        addMoney: '0',
        addXp: '0',
        ammoQuantity: '0',
      }))
      setPlayerManageReason('')
      await loadPlayers()
      alert(l('Speler succesvol bijgewerkt', 'Player updated successfully'))
    } catch (err) {
      if (handleUnauthorized(err)) return
      const message = err instanceof Error ? err.message : t.unknownError
      alert(`${l('Speler bijwerken mislukt', 'Failed to update player')}: ${message}`)
    } finally {
      setIsSavingPlayerManage(false)
    }
  }

  const goBackToPlayers = () => {
    setActiveTab('players')
    setSelectedPlayerId(null)
    setSelectedPlayerOverview(null)
    setSelectedPlayerAvatar(null)
    setRecentActivitiesRows([])
    setRecentActivitiesTotal(0)
    setRecentActivitiesTotalPages(1)
    setRecentActivitiesAvailableTypes([])
    setRecentActivitiesSummary({ totalMoney: 0, totalXp: 0 })
    setRecentActivitiesTrend([])
    setRecentActivitiesError('')
  }

  const canManagePlayers = adminRole === 'SUPER_ADMIN' || adminRole === 'MODERATOR'

  const formatDateWithTimezone = (isoDate: string) => {
    const date = new Date(isoDate)
    if (Number.isNaN(date.getTime())) return isoDate
    return date.toLocaleString(undefined, {
      ...(recentActionsTimezone === 'utc' ? { timeZone: 'UTC', timeZoneName: 'short' } : {}),
    })
  }

  const saveCurrentRecentView = () => {
    const name = window.prompt(l('Naam voor deze view:', 'Name for this view:'))
    if (!name?.trim()) return

    const view: SavedRecentActionsView = {
      id: `${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
      name: name.trim(),
      dateRange: actionsDateRange,
      typeFilter: actionsTypeFilter,
      search: actionsSearchInput,
      sort: actionsSort,
    }
    setRecentActionsSavedViews((current) => [view, ...current].slice(0, 20))
  }

  const applyRecentView = (view: SavedRecentActionsView) => {
    setActionsDateRange(view.dateRange)
    setActionsTypeFilter(view.typeFilter)
    setActionsSearchInput(view.search)
    setActionsSort(view.sort)
    setActionsPage(1)
  }

  const removeRecentView = (viewId: string) => {
    setRecentActionsSavedViews((current) => current.filter((view) => view.id !== viewId))
  }

  const exportRecentActivitiesCsv = async () => {
    if (!selectedPlayerId) return

    try {
      const blob = await adminService.exportPlayerRecentActivities({
        playerId: selectedPlayerId,
        dateRange: actionsDateRange,
        typeFilter: actionsTypeFilter,
        search: actionsSearchFilter,
        sort: actionsSort,
      })

      const url = URL.createObjectURL(blob)
      const anchor = document.createElement('a')
      anchor.href = url
      anchor.download = `player_${selectedPlayerId}_recent_activities.csv`
      anchor.click()
      URL.revokeObjectURL(url)
    } catch (err) {
      if (handleUnauthorized(err)) return
      alert(`${l('Export mislukt', 'Export failed')}: ${(err as Error).message}`)
    }
  }

  const togglePlayerSelection = (playerId: number) => {
    setSelectedPlayerIds((current) =>
      current.includes(playerId) ? current.filter((id) => id !== playerId) : [...current, playerId],
    )
  }

  const toggleSelectAllPlayersOnPage = () => {
    const pageIds = filteredPlayers.map((player) => player.id)
    const allSelected = pageIds.every((id) => selectedPlayerIds.includes(id))
    if (allSelected) {
      setSelectedPlayerIds((current) => current.filter((id) => !pageIds.includes(id)))
      return
    }
    setSelectedPlayerIds((current) => Array.from(new Set([...current, ...pageIds])))
  }

  const executeBulkPlayerAction = async (action: 'warn' | 'ban_temp' | 'add_money') => {
    if (!canManagePlayers) {
      alert(l('Je hebt geen rechten voor bulk acties.', 'You do not have permission for bulk actions.'))
      return
    }

    if (selectedPlayerIds.length === 0) {
      alert(l('Selecteer eerst minimaal 1 speler.', 'Select at least 1 player first.'))
      return
    }

    const reason = window.prompt(l('Reden voor bulk actie (verplicht):', 'Reason for bulk action (required):'))
    if (!reason || reason.trim().length < 5) {
      alert(l('Reden moet minimaal 5 tekens zijn.', 'Reason must be at least 5 characters.'))
      return
    }

    const payload: { playerIds: number[]; action: 'warn' | 'ban_temp' | 'add_money'; reason: string; durationHours?: number; amount?: number } = {
      playerIds: selectedPlayerIds,
      action,
      reason: reason.trim(),
    }

    if (action === 'ban_temp') {
      const durationInput = window.prompt(l('Ban duur in uren (standaard 24):', 'Ban duration in hours (default 24):'), '24')
      payload.durationHours = Number(durationInput || '24')
    }

    if (action === 'add_money') {
      const amountInput = window.prompt(l('Bedrag per speler:', 'Amount per player:'), '10000')
      payload.amount = Number(amountInput || '0')
    }

    try {
      setBulkActionLoading(true)
      const result = await adminService.bulkPlayerAction(payload)
      alert(`${l('Bulk actie voltooid', 'Bulk action completed')}: ${result.affected}`)
      setSelectedPlayerIds([])
      await loadPlayers()
    } catch (err) {
      if (handleUnauthorized(err)) return
      alert(`${l('Bulk actie mislukt', 'Bulk action failed')}: ${(err as Error).message}`)
    } finally {
      setBulkActionLoading(false)
    }
  }

  const filteredPlayers = players

  const getHealthBadgeClass = (status: 'ok' | 'degraded' | 'down') => {
    if (status === 'ok') return 'bg-success'
    if (status === 'degraded') return 'bg-warning text-dark'
    return 'bg-danger'
  }

  const getAlertClass = (severity: 'danger' | 'warning' | 'info') => {
    if (severity === 'danger') return 'dashboard-alert-danger'
    if (severity === 'warning') return 'dashboard-alert-warning'
    return 'dashboard-alert-info'
  }

  const toggleDashboardSection = (section: keyof typeof dashboardSectionOpen) => {
    setDashboardSectionOpen((current) => ({
      ...current,
      [section]: !current[section],
    }))
  }

  const formatDashboardUpdatedAt = (value: string | null) => {
    if (!value) return l('Nog niet ververst', 'Not refreshed yet')
    return `${l('Laatst ververst', 'Last updated')}: ${new Date(value).toLocaleTimeString()}`
  }

  const filteredConfig = Object.entries(editingConfig).filter(([key, value]) =>
    key.toLowerCase().includes(configSearch.toLowerCase()) ||
    value.toLowerCase().includes(configSearch.toLowerCase())
  )

  const selectedProstitutionBalanceProfile: ProstitutionBalanceProfile = useMemo(() => {
    const raw = (editingConfig[PROSTITUTION_BALANCE_PROFILE_KEY] || 'normal').trim().toLowerCase()
    if (raw === 'casual' || raw === 'hardcore' || raw === 'normal') {
      return raw
    }
    return 'normal'
  }, [editingConfig])

  const applyProstitutionBalanceProfile = (profile: ProstitutionBalanceProfile) => {
    setEditingConfig((current) => ({
      ...current,
      [PROSTITUTION_BALANCE_PROFILE_KEY]: profile,
    }))
  }

  const [vipHousingBonusInput, setVipHousingBonusInput] = useState<string>(
    () => editingConfig[VIP_HOUSING_BONUS_KEY] ?? VIP_HOUSING_BONUS_DEFAULT
  )
  const [housingRentStandardInput, setHousingRentStandardInput] = useState<string>(
    () => editingConfig[HOUSING_RENT_STANDARD_KEY] ?? HOUSING_RENT_STANDARD_DEFAULT
  )
  const [housingRentVipInput, setHousingRentVipInput] = useState<string>(
    () => editingConfig[HOUSING_RENT_VIP_KEY] ?? HOUSING_RENT_VIP_DEFAULT
  )

  const handleSaveVipHousingBonus = async () => {
    const parsed = parseInt(vipHousingBonusInput, 10)
    if (isNaN(parsed) || parsed < 0) {
      alert(t.vipHousingBonusError)
      return
    }
    setEditingConfig((current) => ({
      ...current,
      [VIP_HOUSING_BONUS_KEY]: String(parsed),
    }))
    try {
      await adminService.updateConfig({ [VIP_HOUSING_BONUS_KEY]: String(parsed) })
      alert(t.vipHousingBonusSaved)
    } catch {
      // config will still be staged in editingConfig for bulk save
    }
  }

  const handleSaveHousingRent = async () => {
    const standard = parseInt(housingRentStandardInput, 10)
    const vip = parseInt(housingRentVipInput, 10)
    if (isNaN(standard) || isNaN(vip) || standard < 0 || vip < 0) {
      alert(t.prostitutionHousingRentError)
      return
    }

    setEditingConfig((current) => ({
      ...current,
      [HOUSING_RENT_STANDARD_KEY]: String(standard),
      [HOUSING_RENT_VIP_KEY]: String(vip),
    }))
    try {
      await adminService.updateConfig({
        [HOUSING_RENT_STANDARD_KEY]: String(standard),
        [HOUSING_RENT_VIP_KEY]: String(vip),
      })
      alert(t.prostitutionHousingRentSaved)
    } catch {
      // values remain staged in editingConfig for bulk save
    }
  }

  const systemLogSources = Array.from(
    new Set(
      systemLogs
        .map((log) => (log.params?.source || '').trim())
        .filter((source) => source.length > 0)
    )
  ).sort((a, b) => a.localeCompare(b))

  const filteredSystemLogs = systemLogs.filter((log) => {
    const source = (log.params?.source || '').trim()
    const message = (log.params?.message || '').toLowerCase()
    const details = (log.params?.details || '').toLowerCase()
    const search = systemLogSearchFilter.trim().toLowerCase()

    const createdAt = new Date(log.createdAt)
    const now = Date.now()
    const minTimestamp =
      systemLogDateFilter === '24h'
        ? now - 24 * 60 * 60 * 1000
        : systemLogDateFilter === '7d'
          ? now - 7 * 24 * 60 * 60 * 1000
          : systemLogDateFilter === '30d'
            ? now - 30 * 24 * 60 * 60 * 1000
            : null
    const byDate =
      minTimestamp === null ||
      (!Number.isNaN(createdAt.getTime()) && createdAt.getTime() >= minTimestamp)

    if (!byDate) {
      return false
    }

    if (systemLogSourceFilter !== 'all' && source !== systemLogSourceFilter) {
      return false
    }

    if (!search) {
      return true
    }

    return message.includes(search) || details.includes(search) || source.toLowerCase().includes(search)
  })

  const getRangeStart = (range: DateRangeFilter): Date | null => {
    const now = Date.now()
    if (range === '24h') return new Date(now - 24 * 60 * 60 * 1000)
    if (range === '7d') return new Date(now - 7 * 24 * 60 * 60 * 1000)
    if (range === '30d') return new Date(now - 30 * 24 * 60 * 60 * 1000)
    return null
  }

  const isInDateRange = (dateValue: string, range: DateRangeFilter): boolean => {
    const start = getRangeStart(range)
    if (!start) return true
    const value = new Date(dateValue)
    return !Number.isNaN(value.getTime()) && value >= start
  }

  const activityTypeOptions = recentActivitiesAvailableTypes

  const parseActivityDetails = (activity: any) => {
    if (!activity?.details) return null
    if (typeof activity.details === 'string') {
      try {
        return JSON.parse(activity.details)
      } catch {
        return null
      }
    }
    return activity.details
  }

  const getActivityMoneyAmount = (activity: any) => {
    const details = parseActivityDetails(activity)
    if (!details || typeof details !== 'object') return null

    if (typeof details.reward === 'number') return details.reward
    if (typeof details.earnings === 'number') return details.earnings
    return null
  }

  const getActivityXpAmount = (activity: any) => {
    const details = parseActivityDetails(activity)
    if (!details || typeof details !== 'object') return null

    if (typeof details.xpGained === 'number') return details.xpGained
    return null
  }

  const getActivityJailTime = (activity: any) => {
    const details = parseActivityDetails(activity)
    if (!details || typeof details !== 'object') return null

    if (typeof details.jailTime === 'number' && Number.isFinite(details.jailTime) && details.jailTime > 0) {
      return details.jailTime
    }
    return null
  }

  const actionsTotalPages = recentActivitiesTotalPages
  const currentActionsPage = actionsPage
  const recentActivitiesViewRows = useMemo(
    () =>
      recentActivitiesRows.map((activity) => ({
        activity,
        moneyAmount: getActivityMoneyAmount(activity),
        xpAmount: getActivityXpAmount(activity),
        jailTime: getActivityJailTime(activity),
      })),
    [recentActivitiesRows],
  )
  const recentActivityPageNumbers = useMemo(() => {
    const maxVisiblePages = 5
    const start = Math.max(1, Math.min(currentActionsPage - 2, actionsTotalPages - maxVisiblePages + 1))
    const end = Math.min(actionsTotalPages, start + maxVisiblePages - 1)
    const pages: number[] = []
    for (let p = start; p <= end; p += 1) {
      pages.push(p)
    }
    return pages
  }, [currentActionsPage, actionsTotalPages])

  const filteredCasinoAsPlayer = selectedPlayerOverview
    ? selectedPlayerOverview.financial.casinoAsPlayer.filter((entry) => isInDateRange(entry.createdAt, financialDateRange))
    : []

  const sortedCasinoAsPlayer = [...filteredCasinoAsPlayer].sort((a, b) => {
    if (financialPlayerSort === 'date_asc') return new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
    if (financialPlayerSort === 'date_desc') return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    if (financialPlayerSort === 'bet_asc') return a.betAmount - b.betAmount
    if (financialPlayerSort === 'bet_desc') return b.betAmount - a.betAmount
    const aResult = a.payout - a.betAmount
    const bResult = b.payout - b.betAmount
    if (financialPlayerSort === 'result_asc') return aResult - bResult
    return bResult - aResult
  })

  const filteredCasinoAsOwner = selectedPlayerOverview
    ? selectedPlayerOverview.financial.casinoAsOwner.filter((entry) => isInDateRange(entry.createdAt, financialDateRange))
    : []

  const sortedCasinoAsOwner = [...filteredCasinoAsOwner].sort((a, b) => {
    if (financialOwnerSort === 'date_asc') return new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
    if (financialOwnerSort === 'date_desc') return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    if (financialOwnerSort === 'cut_asc') return a.ownerCut - b.ownerCut
    if (financialOwnerSort === 'cut_desc') return b.ownerCut - a.ownerCut
    if (financialOwnerSort === 'player_asc') return a.playerId - b.playerId
    return b.playerId - a.playerId
  })

  const filteredPremiumFulfillments = selectedPlayerOverview
    ? selectedPlayerOverview.financial.premiumFulfillments.filter((entry) => isInDateRange(entry.fulfilledAt, financialDateRange))
    : []

  const sortedPremiumFulfillments = [...filteredPremiumFulfillments].sort((a, b) => {
    if (financialPremiumSort === 'date_asc') return new Date(a.fulfilledAt).getTime() - new Date(b.fulfilledAt).getTime()
    if (financialPremiumSort === 'date_desc') return new Date(b.fulfilledAt).getTime() - new Date(a.fulfilledAt).getTime()
    if (financialPremiumSort === 'id_asc') return a.id - b.id
    if (financialPremiumSort === 'id_desc') return b.id - a.id
    if (financialPremiumSort === 'product_asc') return a.productKey.localeCompare(b.productKey)
    return b.productKey.localeCompare(a.productKey)
  })

  const tabItems: Array<{ id: TabType; label: string; icon: string }> = [
    { id: 'dashboard', label: t.navDashboard, icon: 'bi-speedometer2' },
    { id: 'players', label: t.navPlayers, icon: 'bi-people-fill' },
    { id: 'vehicles', label: t.navVehicles, icon: 'bi-car-front-fill' },
    { id: 'tools', label: t.navTools, icon: 'bi-tools' },
    { id: 'crimes', label: t.navCrimes, icon: 'bi-shield-fill-exclamation' },
    { id: 'events', label: l('Events', 'Events'), icon: 'bi-calendar2-event-fill' },
    { id: 'npcs', label: t.navNpcs, icon: 'bi-robot' },
    { id: 'audit-logs', label: t.navAudit, icon: 'bi-journal-text' },
    { id: 'system-logs', label: l('Systeem Logs', 'System Logs'), icon: 'bi-bug-fill' },
    { id: 'admins', label: l('Admins', 'Admins'), icon: 'bi-person-gear' },
    { id: 'premium-offers', label: t.navPremium, icon: 'bi-gem' },
    { id: 'config', label: t.navConfig, icon: 'bi-sliders' },
  ]

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)
    
    try {
      await adminAuthService.login(username, password)
      setIsAuthenticated(true)
      setAdminRole(adminAuthService.getAdminRole())
    } catch (err) {
      setError(t.loginFailed)
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = () => {
    adminAuthService.logout()
    setIsAuthenticated(false)
    setAdminRole(null)
    setUsername('')
    setPassword('')
    setActiveTab('dashboard')
  }

  const handleTabSelect = (tabId: TabType) => {
    setActiveTab(tabId)
    document.body.classList.remove('sidebar-mobile-expanded')
  }

  const toggleTheme = () => {
    setTheme((current) => (current === 'dark' ? 'light' : 'dark'))
  }

  if (!isAuthenticated) {
    return (
      <div className="login-container d-flex align-items-center justify-content-center">
        <div className="card login-card shadow-lg border-0">
          <div className="card-body p-4 p-md-5">
            <div className="text-center mb-4">
              <img src="/title_mobstate.png" alt="The Mob State" className="admin-game-logo mb-3" />
              <span className="admin-kicker d-inline-block mb-2">Control Center</span>
              <h1 className="h3 mb-1">{t.loginTitle}</h1>
              <p className="text-muted mb-0">{t.loginSubtitle}</p>
            </div>
            <form className="login-box" onSubmit={handleLogin}>
              {error && <div className="alert alert-danger py-2">{error}</div>}
              <div className="mb-3">
                <label className="form-label">{t.language}</label>
                <select className="form-select" value={language} onChange={(e) => setLanguage(e.target.value as Language)}>
                  <option value="nl">Nederlands</option>
                  <option value="en">English</option>
                </select>
              </div>
              <div className="mb-3">
                <label className="form-label">{t.username}</label>
                <input
                  className="form-control"
                  type="text"
                  placeholder={t.username}
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  disabled={loading}
                />
              </div>
              <div className="mb-3">
                <label className="form-label">{t.password}</label>
                <input
                  className="form-control"
                  type="password"
                  placeholder={t.password}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  disabled={loading}
                />
              </div>
              <button type="submit" className="btn btn-primary w-100" disabled={loading}>
                {loading ? t.loggingIn : t.login}
              </button>
            </form>
          </div>
        </div>
      </div>
    )
  }

  return (
    <>
      <div className={`navbar navbar-dark navbar-expand-lg navbar-static border-bottom border-bottom-white border-opacity-10 ${isTopbarScrolled ? 'shadow-sm' : ''}`}>
        <div className="container-fluid">
          <div className="d-flex d-lg-none me-2">
            <button type="button" className="navbar-toggler sidebar-mobile-main-toggle rounded-pill" aria-label="Toggle sidebar">
              <i className="ph-list" />
            </button>
          </div>

          <div className="navbar-brand flex-1 flex-lg-0">
            <a href="#" className="d-inline-flex align-items-center" onClick={(e) => e.preventDefault()}>
              <img src="/title_mobstate.png" alt="The Mob State" className="app-shell-logo" />
            </a>
          </div>

          <ul className="nav flex-row ms-auto">
            <li className="nav-item d-none d-md-flex align-items-center">
              <span className="navbar-nav-link rounded-pill px-3">{username || 'admin'}</span>
            </li>
            <li className="nav-item">
              <button type="button" className="navbar-nav-link navbar-nav-link-icon rounded-pill" onClick={toggleTheme}>
                <i className={theme === 'dark' ? 'ph-sun' : 'ph-moon'} />
              </button>
            </li>
            <li className="nav-item d-flex align-items-center ms-2">
              <select className="form-select form-select-sm" value={language} onChange={(e) => setLanguage(e.target.value as Language)}>
                <option value="nl">NL</option>
                <option value="en">EN</option>
              </select>
            </li>
            <li className="nav-item ms-2">
              <button type="button" className="navbar-nav-link rounded-pill px-3" onClick={handleLogout}>
                <i className="ph-sign-out me-1" /> {t.logout}
              </button>
            </li>
          </ul>
        </div>
      </div>

      <div className="page-content">
        <div className="sidebar sidebar-dark sidebar-main sidebar-expand-lg">
          <div className="sidebar-content">
            <div className="sidebar-section">
              <div className="sidebar-section-body d-flex justify-content-center">
                <h5 className="sidebar-resize-hide flex-grow-1 my-auto">Navigation</h5>
                <div>
                  <button type="button" className="btn btn-flat-white btn-icon btn-sm rounded-pill border-transparent sidebar-control sidebar-main-resize d-none d-lg-inline-flex">
                    <i className="ph-arrows-left-right" />
                  </button>
                  <button type="button" className="btn btn-flat-white btn-icon btn-sm rounded-pill border-transparent sidebar-mobile-main-toggle d-lg-none">
                    <i className="ph-x" />
                  </button>
                </div>
              </div>
            </div>

            <div className="sidebar-section">
              <ul className="nav nav-sidebar" data-nav-type="accordion">
                <li className="nav-item-header pt-0">
                  <div className="text-uppercase fs-sm lh-sm opacity-50 sidebar-resize-hide">Main</div>
                  <i className="ph-dots-three sidebar-resize-show" />
                </li>
                {tabItems.map((item) => (
                  <li key={item.id} className="nav-item">
                    <a
                      href="#"
                      className={`nav-link ${activeTab === item.id ? 'active' : ''}`}
                      onClick={(e) => {
                        e.preventDefault()
                        handleTabSelect(item.id)
                      }}
                    >
                      <i className={`bi ${item.icon}`} />
                      <span>{item.label}</span>
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>

        <div className="content-wrapper">
          <div className="content-inner">
            <div className="page-header page-header-light shadow-sm">
              <div className="page-header-content d-lg-flex align-items-center">
                <div className="d-flex align-items-center">
                  <h4 className="page-title mb-0">
                    {activeTab === 'player-detail'
                      ? l('Spelerdetails', 'Player details')
                      : (tabItems.find((item) => item.id === activeTab)?.label ?? t.dashboardTitle)}
                  </h4>
                </div>

                <div className="ms-lg-auto mt-2 mt-lg-0 text-muted fs-sm d-flex align-items-center gap-2">
                  <span>{l('The Mob State admin omgeving', 'The Mob State administration environment')}</span>
                </div>
              </div>

              <div className="page-header-content d-lg-flex border-top">
                <div className="d-flex">
                  <div className="breadcrumb py-2">
                    <a href="#" className="breadcrumb-item" onClick={(e) => e.preventDefault()}><i className="ph-house" /></a>
                    <a href="#" className="breadcrumb-item" onClick={(e) => e.preventDefault()}>Admin</a>
                    <span className="breadcrumb-item active">
                      {activeTab === 'player-detail'
                        ? l('Spelerdetails', 'Player details')
                        : (tabItems.find((item) => item.id === activeTab)?.label ?? t.dashboardTitle)}
                    </span>
                  </div>
                </div>

                <div className="ms-lg-auto">
                  <div className="d-flex align-items-center py-2 gap-2">
                    <button
                      type="button"
                      className="btn btn-light btn-sm"
                      onClick={() => {
                        loadStats()
                        if (activeTab === 'dashboard') {
                          loadSystemHealth()
                          loadDashboardOverview()
                        }
                      }}
                    >
                      <i className="ph-arrows-clockwise me-1" /> {t.refresh}
                    </button>
                    <button type="button" className="btn btn-primary btn-sm" onClick={toggleTheme}>
                      <i className={`${theme === 'dark' ? 'ph-sun' : 'ph-moon'} me-1`} />
                      {theme === 'dark' ? l('Licht', 'Light') : l('Donker', 'Dark')}
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <main className="content">
        {apiError && (
          <div className="alert alert-warning" role="alert">
            <strong>{t.apiWarningTitle}:</strong> {apiError}
          </div>
        )}
        {activeTab === 'dashboard' && (
          <>
            <div className="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
              <h1 className="mb-0">{t.dashboardTitle}</h1>
              <div className="d-flex align-items-center gap-2 flex-wrap">
                <span className="badge bg-secondary-subtle text-body border">{l('Live overzicht', 'Live overview')}</span>
                <span className="badge bg-light text-body border">{formatDashboardUpdatedAt(dashboardLastUpdated.stats)}</span>
              </div>
            </div>

            <div className="row g-3 mb-3">
              {[
                {
                  key: 'total',
                  label: t.totalPlayers,
                  value: stats.totalPlayers,
                  icon: 'ph-users-three',
                  badgeClass: 'bg-primary-subtle text-primary',
                  badgeText: l('Totaal', 'Total'),
                },
                {
                  key: 'active',
                  label: t.activePlayers,
                  value: stats.activePlayers,
                  icon: 'ph-heartbeat',
                  badgeClass: 'bg-success-subtle text-success',
                  badgeText: l('Actief', 'Active'),
                },
                {
                  key: 'banned',
                  label: t.bannedPlayers,
                  value: stats.bannedPlayers,
                  icon: 'ph-prohibit-inset',
                  badgeClass: 'bg-danger-subtle text-danger',
                  badgeText: l('Moderatie', 'Moderation'),
                },
              ].map((item) => (
                <div key={item.key} className="col-sm-6 col-xl-4">
                  <div className="card dashboard-summary-card h-100">
                    <div className="card-body d-flex align-items-center gap-3">
                      <div className="dashboard-summary-icon">
                        <i className={item.icon} />
                      </div>
                      <div className="flex-fill">
                        <div className="d-flex align-items-center justify-content-between gap-2 mb-1">
                          <span className="text-muted small text-uppercase">{item.label}</span>
                          <span className={`badge ${item.badgeClass}`}>{item.badgeText}</span>
                        </div>
                        <div className="dashboard-summary-value">{item.value.toLocaleString()}</div>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <div className="row g-3 align-items-start">
              <div className="col-xl-8">
                <div className="card dashboard-panel mb-3">
                  <div className="card-header d-flex align-items-center justify-content-between">
                    <div>
                      <h5 className="mb-0 dashboard-section-title"><i className="ph-heartbeat me-2" />{l('Systeemstatus', 'System status')}</h5>
                      <small className="text-muted">{formatDashboardUpdatedAt(dashboardLastUpdated.system)}</small>
                    </div>
                    <div className="d-flex align-items-center gap-2">
                      {(systemHealthLoading || dashboardOverviewLoading) && <small className="text-muted">{t.loading}</small>}
                      <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => toggleDashboardSection('system')}>
                        <i className={`ph-caret-${dashboardSectionOpen.system ? 'up' : 'down'}`} />
                      </button>
                      <button
                        type="button"
                        className="btn btn-outline-secondary btn-sm"
                        onClick={() => {
                          loadSystemHealth()
                          loadDashboardOverview()
                        }}
                      >
                        <i className="ph-arrows-clockwise me-1" />{l('Ververs status', 'Refresh status')}
                      </button>
                    </div>
                  </div>
                  {dashboardSectionOpen.system && <div className="card-body">
                    {!systemHealth && (
                      <div className="text-muted">{l('Nog geen statusdata beschikbaar.', 'No status data available yet.')}</div>
                    )}

                    {systemHealth && (
                      <>
                        <div className="d-flex flex-wrap gap-2 mb-3">
                          <span className={`badge ${getHealthBadgeClass(systemHealth.status)}`}>
                            {l('Algemeen', 'Overall')}: {systemHealth.status.toUpperCase()}
                          </span>
                          <span className="badge bg-secondary">Uptime: {Math.floor(systemHealth.uptime)}s</span>
                          <span className="badge bg-secondary">RTT: {systemHealth.responseTimeMs}ms</span>
                          <span className="badge bg-secondary">{l('Omgeving', 'Environment')}: {systemHealth.environment}</span>
                        </div>

                        <div className="row g-2 mb-3">
                          {[
                            { key: 'api', label: 'API', status: systemHealth.components.api.status },
                            { key: 'database', label: 'Database', status: systemHealth.components.database.status },
                            { key: 'redis', label: 'Redis', status: systemHealth.components.redis.status },
                            { key: 'queue', label: 'Queue', status: systemHealth.components.queue.status },
                            { key: 'cron', label: 'Cron', status: systemHealth.components.cron.status },
                          ].map((component) => (
                            <div key={component.key} className="col-sm-6 col-lg-4">
                              <div className="dashboard-mini-stat d-flex align-items-center justify-content-between">
                                <span className="fw-semibold">{component.label}</span>
                                <span className={`badge ${getHealthBadgeClass(component.status)}`}>{component.status.toUpperCase()}</span>
                              </div>
                            </div>
                          ))}
                        </div>

                        {systemHealth.components.database.error && (
                          <div className="alert alert-warning mt-3 mb-0 py-2">
                            <strong>DB:</strong> {systemHealth.components.database.error}
                          </div>
                        )}
                      </>
                    )}
                  </div>}
                </div>

                <div className="row g-3 mb-3">
                  <div className="col-lg-6">
                    <div className="card dashboard-panel h-100">
                      <div className="card-header d-flex align-items-center justify-content-between">
                        <div>
                          <h5 className="mb-0 dashboard-section-title"><i className="ph-warning-circle me-2" />{l('Alerts', 'Alerts')}</h5>
                          <small className="text-muted">{formatDashboardUpdatedAt(dashboardLastUpdated.overview)}</small>
                        </div>
                        <div className="d-flex align-items-center gap-2">
                          <span className="badge bg-secondary">{dashboardOverview?.alerts.length || 0}</span>
                          <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => toggleDashboardSection('alerts')}>
                            <i className={`ph-caret-${dashboardSectionOpen.alerts ? 'up' : 'down'}`} />
                          </button>
                        </div>
                      </div>
                      {dashboardSectionOpen.alerts && <div className="card-body d-flex flex-column gap-2">
                        {dashboardOverview?.alerts?.map((alertItem, index) => (
                          <div key={`${alertItem.title}-${index}`} className={`dashboard-alert ${getAlertClass(alertItem.severity)}`}>
                            <div className="fw-semibold">{alertItem.title}</div>
                            <div className="small">{alertItem.description}</div>
                          </div>
                        ))}
                        {!dashboardOverview && <div className="text-muted">{t.loading}</div>}
                      </div>}
                    </div>
                  </div>

                  <div className="col-lg-6">
                    <div className="card dashboard-panel h-100">
                      <div className="card-header d-flex align-items-center justify-content-between">
                        <div>
                          <h5 className="mb-0 dashboard-section-title"><i className="ph-lightning me-2" />{l('Snelle acties', 'Quick actions')}</h5>
                          <small className="text-muted">{formatDashboardUpdatedAt(dashboardLastUpdated.overview)}</small>
                        </div>
                        <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => toggleDashboardSection('quickActions')}>
                          <i className={`ph-caret-${dashboardSectionOpen.quickActions ? 'up' : 'down'}`} />
                        </button>
                      </div>
                      {dashboardSectionOpen.quickActions && <div className="card-body d-grid gap-2">
                        <button type="button" className="btn btn-outline-primary text-start" onClick={() => handleTabSelect('players')}>
                          <i className="ph-users-three me-2" />{l('Open spelersbeheer', 'Open player management')}
                        </button>
                        <button type="button" className="btn btn-outline-primary text-start" onClick={() => handleTabSelect('audit-logs')}>
                          <i className="ph-clipboard-text me-2" />{l('Bekijk audit logs', 'View audit logs')}
                        </button>
                        <button type="button" className="btn btn-outline-primary text-start" onClick={() => handleTabSelect('system-logs')}>
                          <i className="ph-bug-beetle me-2" />{l('Open systeemlogs', 'Open system logs')}
                        </button>
                        <div className="dashboard-quick-stats mt-2">
                          <span className="badge bg-danger-subtle text-danger">{l('Errors 24u', 'Errors 24h')}: {dashboardOverview?.quickStats.systemErrors24h ?? 0}</span>
                          <span className="badge bg-info-subtle text-info">{l('Admin acties 24u', 'Admin actions 24h')}: {dashboardOverview?.quickStats.adminActions24h ?? 0}</span>
                        </div>
                      </div>}
                    </div>
                  </div>
                </div>

                <div className="card dashboard-panel mb-3">
                  <div className="card-header d-flex align-items-center justify-content-between">
                    <div>
                      <h5 className="mb-0 dashboard-section-title"><i className="ph-chart-line-up me-2" />{l('Trends laatste 7 dagen', 'Trends last 7 days')}</h5>
                      <small className="text-muted">{formatDashboardUpdatedAt(dashboardLastUpdated.overview)}</small>
                    </div>
                    <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => toggleDashboardSection('trends')}>
                      <i className={`ph-caret-${dashboardSectionOpen.trends ? 'up' : 'down'}`} />
                    </button>
                  </div>
                  {dashboardSectionOpen.trends && <div className="card-body">
                    <div className="row g-3">
                      {[
                        { key: 'activePlayers', label: l('Actieve spelers', 'Active players'), color: 'dashboard-trend-bar-primary' },
                        { key: 'registrations', label: l('Nieuwe spelers', 'New players'), color: 'dashboard-trend-bar-success' },
                        { key: 'adminActions', label: l('Admin acties', 'Admin actions'), color: 'dashboard-trend-bar-warning' },
                      ].map((trendMeta) => {
                        const data = dashboardOverview?.trends?.[trendMeta.key as keyof DashboardOverview['trends']] || []
                        const maxValue = Math.max(...data.map((item) => item.value), 1)
                        return (
                          <div key={trendMeta.key} className="col-lg-4">
                            <div className="dashboard-trend-card">
                              <div className="fw-semibold mb-2">{trendMeta.label}</div>
                              <div className="dashboard-trend-bars">
                                {data.map((point) => (
                                  <div key={`${trendMeta.key}-${point.date}`} className="dashboard-trend-point" title={`${point.date}: ${point.value}`}>
                                    <div className={`dashboard-trend-bar ${trendMeta.color}`} style={{ height: `${Math.max(10, (point.value / maxValue) * 70)}px` }} />
                                    <small>{point.date.slice(5)}</small>
                                  </div>
                                ))}
                              </div>
                            </div>
                          </div>
                        )
                      })}
                    </div>
                  </div>}
                </div>
              </div>

              <div className="col-xl-4">
                <div className="card dashboard-panel mb-3">
                  <div className="card-header d-flex align-items-center justify-content-between">
                    <div>
                      <h5 className="mb-0 dashboard-section-title"><i className="ph-activity me-2" />{l('Live activiteit', 'Live activity')}</h5>
                      <small className="text-muted">{formatDashboardUpdatedAt(dashboardLastUpdated.overview)}</small>
                    </div>
                    <div className="d-flex align-items-center gap-2">
                      <span className="badge bg-secondary">{dashboardOverview?.activityFeed.length || 0}</span>
                      <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => toggleDashboardSection('liveActivity')}>
                        <i className={`ph-caret-${dashboardSectionOpen.liveActivity ? 'up' : 'down'}`} />
                      </button>
                    </div>
                  </div>
                  {dashboardSectionOpen.liveActivity && <div className="card-body">
                    <div className="dashboard-feed-list">
                      {dashboardOverview?.activityFeed?.map((item) => (
                        <div key={item.id} className="dashboard-feed-item">
                          <div className="d-flex align-items-start justify-content-between gap-2">
                            <div>
                              <div className="fw-semibold">{item.title}</div>
                              <div className="small text-muted">{item.description}</div>
                            </div>
                            <span className={`badge ${item.type === 'system' ? 'bg-danger-subtle text-danger' : 'bg-info-subtle text-info'}`}>
                              {item.type}
                            </span>
                          </div>
                          <small className="text-muted">{new Date(item.createdAt).toLocaleString()}</small>
                        </div>
                      ))}
                      {!dashboardOverview && <div className="text-muted">{t.loading}</div>}
                    </div>
                  </div>}
                </div>

                <div className="card dashboard-panel">
                  <div className="card-header d-flex align-items-center justify-content-between">
                    <div>
                      <h5 className="mb-0 dashboard-section-title"><i className="ph-shield-warning me-2" />{l('Risicospelers', 'Risk players')}</h5>
                      <small className="text-muted">{formatDashboardUpdatedAt(dashboardLastUpdated.overview)}</small>
                    </div>
                    <div className="d-flex align-items-center gap-2">
                      <span className="badge bg-secondary">{dashboardOverview?.riskPlayers.length || 0}</span>
                      <button type="button" className="btn btn-outline-secondary btn-sm" onClick={() => toggleDashboardSection('riskPlayers')}>
                        <i className={`ph-caret-${dashboardSectionOpen.riskPlayers ? 'up' : 'down'}`} />
                      </button>
                    </div>
                  </div>
                  {dashboardSectionOpen.riskPlayers && <div className="card-body">
                    <div className="dashboard-risk-list">
                      {dashboardOverview?.riskPlayers?.map((player) => (
                        <button
                          key={player.id}
                          type="button"
                          className="dashboard-risk-item"
                          onClick={() => openPlayerDetails({
                            id: player.id,
                            username: player.username,
                            money: player.money,
                            rank: player.rank,
                            health: player.health,
                            currentCountry: player.currentCountry,
                            avatar: null,
                            isOnline: false,
                            createdAt: player.updatedAt,
                            updatedAt: player.updatedAt,
                          })}
                        >
                          <div className="d-flex align-items-center justify-content-between gap-2">
                            <div>
                              <div className="fw-semibold">{player.username}</div>
                              <div className="small text-muted">#{player.id} · {player.currentCountry} · €{player.money.toLocaleString()}</div>
                            </div>
                            <span className="badge bg-danger">{player.riskScore}</span>
                          </div>
                          <div className="dashboard-risk-meta small text-muted">
                            {l('Wanted', 'Wanted')}: {player.wantedLevel} · FBI: {player.fbiHeat} · {l('Gezondheid', 'Health')}: {player.health}%
                          </div>
                        </button>
                      ))}
                      {!dashboardOverview && <div className="text-muted">{t.loading}</div>}
                    </div>
                  </div>}
                </div>
              </div>
            </div>
          </>
        )}

        {activeTab === 'players' && (
          <>
            {/* Search */}
            <div className="mb-3">
              <div className="input-group">
                <span className="input-group-text"><i className="ph-magnifying-glass" /></span>
                <input
                  type="text"
                  className="form-control"
                  placeholder={t.searchByUsernameOrId}
                  value={playerSearch}
                  onChange={(e) => setPlayerSearch(e.target.value)}
                />
              </div>
            </div>

            <div className="card mb-3">
              <div className="card-body d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div>
                  <span className="fw-semibold">{l('Selectie', 'Selection')}: {selectedPlayerIds.length}</span>
                  <span className="text-muted ms-2">{l('op huidige pagina', 'on current page')}</span>
                </div>
                <div className="d-flex gap-2 flex-wrap">
                  <button className="btn btn-outline-secondary btn-sm" onClick={toggleSelectAllPlayersOnPage}>
                    <i className="ph-check-square-offset me-1" />{l('Selecteer pagina', 'Select page')}
                  </button>
                  <button className="btn btn-outline-warning btn-sm" disabled={!canManagePlayers || bulkActionLoading || selectedPlayerIds.length === 0} onClick={() => executeBulkPlayerAction('warn')}>
                    <i className="ph-warning me-1" />{l('Bulk waarschuwing', 'Bulk warning')}
                  </button>
                  <button className="btn btn-outline-success btn-sm" disabled={!canManagePlayers || bulkActionLoading || selectedPlayerIds.length === 0} onClick={() => executeBulkPlayerAction('add_money')}>
                    <i className="ph-currency-circle-dollar me-1" />{l('Bulk geld', 'Bulk money')}
                  </button>
                  <button className="btn btn-outline-danger btn-sm" disabled={!canManagePlayers || bulkActionLoading || selectedPlayerIds.length === 0} onClick={() => executeBulkPlayerAction('ban_temp')}>
                    <i className="ph-prohibit me-1" />{l('Bulk temp ban', 'Bulk temp ban')}
                  </button>
                </div>
              </div>
            </div>

            {/* Simple list */}
            <div className="card">
              <div className="card-header d-flex align-items-center">
                <h5 className="mb-0 flex-fill">{t.playersTitle}</h5>
                <span className="badge bg-secondary">{filteredPlayers.length}</span>
              </div>

              <div className="list-group list-group-borderless py-2">
                {filteredPlayers.length === 0 && (
                  <div className="list-group-item text-muted">
                    {l('Geen spelers gevonden.', 'No players found.')}
                  </div>
                )}
                {filteredPlayers.map(player => (
                  <div key={player.id} className="list-group-item hstack gap-3">
                    <div className="form-check m-0">
                      <input
                        className="form-check-input"
                        type="checkbox"
                        checked={selectedPlayerIds.includes(player.id)}
                        onChange={() => togglePlayerSelection(player.id)}
                        aria-label={`Select ${player.username}`}
                      />
                    </div>

                    {/* Avatar + health indicator */}
                    <div className="status-indicator-container flex-shrink-0">
                      {player.avatar ? (
                        <img
                          src={`http://localhost:3000/assets/images/avatars/${player.avatar}.png`}
                          className="w-40px h-40px rounded-pill object-fit-cover"
                          alt={player.username}
                          onError={(e) => {
                            const el = e.currentTarget as HTMLImageElement
                            el.style.display = 'none'
                            el.nextElementSibling?.classList.remove('d-none')
                          }}
                        />
                      ) : null}
                      <div
                        className={`w-40px h-40px rounded-pill bg-secondary d-flex align-items-center justify-content-center text-white fw-semibold${player.avatar ? ' d-none' : ''}`}
                        style={{ fontSize: '1rem' }}
                      >
                        {player.username.charAt(0).toUpperCase()}
                      </div>
                      <span
                        className={`status-indicator ${player.isOnline ? 'bg-success' : 'bg-secondary'}`}
                        title={player.isOnline ? l('Online', 'Online') : l('Offline', 'Offline')}
                      />
                    </div>

                    {/* Info */}
                    <div className="flex-fill">
                      <div className="fw-semibold">{player.username}</div>
                      <span className="text-muted">
                        {l('Rang', 'Rank')} {player.rank} &middot; {player.currentCountry} &middot; ${player.money.toLocaleString()} &middot; {player.health}%&nbsp;<i className="ph-heart text-danger" />
                      </span>
                    </div>

                    {/* Actions */}
                    <div className="align-self-center ms-3">
                      <div className="d-inline-flex gap-1">
                        <button
                          className="btn btn-outline-primary btn-sm"
                          onClick={() => openPlayerDetails(player)}
                          title={l('Openen', 'Open')}
                        >
                          <i className="ph-eye me-1" />{l('Open', 'Open')}
                        </button>
                        <button
                          className="btn btn-outline-danger btn-sm"
                          onClick={() => handleBanPlayer(player)}
                          title={t.ban}
                          disabled={!canManagePlayers}
                        >
                          <i className="ph-prohibit me-1" />{t.ban}
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Pagination */}
            <div className="d-flex justify-content-between align-items-center mt-3">
              <button
                className="btn btn-outline-secondary btn-sm"
                disabled={playersPage === 1}
                onClick={() => setPlayersPage(p => p - 1)}
              >
                <i className="ph-arrow-left me-1" />{t.previous}
              </button>
              <span className="text-muted">{tr(t.pageOf, { page: playersPage, total: playersTotalPages })}</span>
              <button
                className="btn btn-outline-secondary btn-sm"
                disabled={playersPage === playersTotalPages}
                onClick={() => setPlayersPage(p => p + 1)}
              >
                {t.next}<i className="ph-arrow-right ms-1" />
              </button>
            </div>

            {/* Ban Player Modal */}
            {banningPlayer && (
              <div className="modal-overlay" onClick={() => setBanningPlayer(null)}>
                <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
                  <h2>{t.banPlayerTitle}: {banningPlayer.username}</h2>
                  <div className="form-group">
                    <label>{t.banReason} *</label>
                    <textarea 
                      value={banReason}
                      onChange={(e) => setBanReason(e.target.value)}
                      placeholder={t.banReason}
                      rows={3}
                      style={{resize: 'vertical'}}
                    />
                  </div>
                  <div className="form-group">
                    <label>{t.banType}</label>
                    <div className="radio-group">
                      <label className="radio-label">
                        <input 
                          type="radio" 
                          name="banType" 
                          value="temporary"
                          checked={banType === 'temporary'}
                          onChange={() => setBanType('temporary')}
                        />
                        <span>{t.temporaryBan}</span>
                      </label>
                      <label className="radio-label">
                        <input 
                          type="radio" 
                          name="banType" 
                          value="permanent"
                          checked={banType === 'permanent'}
                          onChange={() => setBanType('permanent')}
                        />
                        <span>{t.permanentBan}</span>
                      </label>
                    </div>
                  </div>
                  {banType === 'temporary' && (
                    <div className="form-group">
                      <label>{t.durationHours}</label>
                      <input 
                        type="number" 
                        min="1"
                        value={banDuration}
                        onChange={(e) => setBanDuration(e.target.value)}
                      />
                      <small style={{color: 'var(--text-muted)', marginTop: '0.5rem', display: 'block'}}>
                        {l('Veelgebruikte duren: 24u (1 dag), 168u (1 week), 720u (30 dagen)', 'Common durations: 24h (1 day), 168h (1 week), 720h (30 days)')}
                      </small>
                    </div>
                  )}
                  <div className="modal-actions">
                    <button className="btn-small btn-danger" onClick={handleConfirmBan}>
                      {banType === 'permanent' ? t.permanentBanAction : tr(t.banForHours, { hours: banDuration })}
                    </button>
                    <button className="btn-small" onClick={() => setBanningPlayer(null)}>{t.cancel}</button>
                  </div>
                </div>
              </div>
            )}
          </>
        )}

        {activeTab === 'player-detail' && (
          <div className="player-detail-view">
            {playerDetailLoading && <div className="alert alert-info">{t.loading}</div>}

            {!playerDetailLoading && selectedPlayerOverview && (() => {
              const ov = selectedPlayerOverview
              const pl = ov.player
              const healthPct = Math.max(0, Math.min(100, pl.health))
              const healthColor = healthPct > 70 ? 'bg-success' : healthPct > 30 ? 'bg-warning' : 'bg-danger'
              const avatarUrl = selectedPlayerAvatar
                ? `http://localhost:3000/assets/images/avatars/${selectedPlayerAvatar}.png`
                : null

              return (
                <>
                  {/* ── Profile header card ── */}
                  <div className="card mb-3">
                    <div className="card-body">
                      <div className="d-flex align-items-center gap-3 flex-wrap">
                        {/* Avatar */}
                        <div className="status-indicator-container flex-shrink-0">
                          {avatarUrl ? (
                            <img
                              src={avatarUrl}
                              className="rounded-circle object-fit-cover"
                              style={{ width: 72, height: 72 }}
                              alt={pl.username}
                            />
                          ) : (
                            <div
                              className="rounded-circle bg-secondary d-flex align-items-center justify-content-center text-white fw-bold"
                              style={{ width: 72, height: 72, fontSize: '2rem' }}
                            >
                              {pl.username.charAt(0).toUpperCase()}
                            </div>
                          )}
                        </div>

                        {/* Name + badges */}
                        <div className="flex-fill">
                          <h4 className="mb-1 fw-bold">{pl.username}</h4>
                          <div className="d-flex gap-1 flex-wrap">
                            <span className="badge bg-primary">#{pl.id}</span>
                            <span className="badge bg-secondary">{l('Rang', 'Rank')} {pl.rank}</span>
                            <span className="badge bg-secondary">{pl.currentCountry}</span>
                            {pl.isVip && <span className="badge bg-warning text-dark"><i className="ph-crown me-1" />VIP</span>}
                            {pl.isBanned && <span className="badge bg-danger"><i className="ph-prohibit me-1" />{l('Gebanned', 'Banned')}</span>}
                            {pl.wantedLevel > 0 && <span className="badge bg-danger"><i className="ph-siren me-1" />{l('Wanted', 'Wanted')} {pl.wantedLevel}</span>}
                            {pl.email && <span className="badge bg-secondary"><i className="ph-envelope me-1" />{pl.email}</span>}
                          </div>
                          {/* Health bar */}
                          <div className="mt-2" style={{ maxWidth: 280 }}>
                            <div className="d-flex justify-content-between mb-1" style={{ fontSize: '0.75rem' }}>
                              <span className="text-muted"><i className="ph-heart me-1" />{l('Gezondheid', 'Health')}</span>
                              <span className="fw-semibold">{healthPct}%</span>
                            </div>
                            <div className="progress" style={{ height: 6 }}>
                              <div className={`progress-bar ${healthColor}`} style={{ width: `${healthPct}%` }} />
                            </div>
                          </div>
                        </div>

                        {/* Back button */}
                        <div className="ms-auto flex-shrink-0 player-detail-back-wrap">
                          <button className="btn btn-outline-secondary btn-sm" onClick={goBackToPlayers}>
                            <i className="ph-arrow-left me-1" />{l('Terug', 'Back')}
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* ── Metric tiles ── */}
                  <div className="row g-3 mb-3">
                    {[
                      { icon: 'ph-currency-eur', label: l('Geld', 'Money'), value: `€${pl.money.toLocaleString()}`, color: 'text-success' },
                      { icon: 'ph-trophy', label: l('XP', 'XP'), value: pl.xp.toLocaleString(), color: 'text-warning' },
                      { icon: 'ph-skull', label: l('Misdaden', 'Crimes'), value: `${ov.stats.crimes.success}/${ov.stats.crimes.total}`, color: 'text-danger' },
                      { icon: 'ph-briefcase', label: l('Jobs', 'Jobs'), value: ov.stats.jobs.total.toLocaleString(), color: 'text-info' },
                      { icon: 'ph-airplane', label: l('Vluchten', 'Flights'), value: ov.stats.flights.total.toLocaleString(), color: 'text-primary' },
                      { icon: 'ph-handcuffs', label: l('Jail', 'Jailed'), value: ov.stats.crimes.jailed.toLocaleString(), color: 'text-warning' },
                      { icon: 'ph-star', label: l('Reputatie', 'Reputation'), value: pl.reputation.toLocaleString(), color: 'text-warning' },
                      { icon: 'ph-crosshair', label: l('Kills', 'Kills'), value: pl.killCount.toLocaleString(), color: 'text-danger' },
                    ].map(({ icon, label, value, color }) => (
                      <div key={label} className="col-6 col-md-3">
                        <div className="card h-100">
                          <div className="card-body d-flex align-items-center gap-3 py-3">
                            <div className={`${color} flex-shrink-0`} style={{ fontSize: '1.75rem' }}>
                              <i className={icon} />
                            </div>
                            <div>
                              <div className="text-muted" style={{ fontSize: '0.75rem' }}>{label}</div>
                              <div className="fw-bold fs-6">{value}</div>
                            </div>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* ── Nav tabs ── */}
                  <ul className="nav nav-tabs mb-3">
                    {(['overview', 'manage', 'financial'] as const).map((tab) => (
                      <li key={tab} className="nav-item">
                        <button
                          className={`nav-link ${playerDetailTab === tab ? 'active' : ''}`}
                          onClick={() => setPlayerDetailTab(tab)}
                        >
                          {tab === 'overview' ? l('Overzicht', 'Overview')
                            : tab === 'manage' ? l('Beheer', 'Manage')
                            : l('Financieel', 'Financial')}
                        </button>
                      </li>
                    ))}
                  </ul>

                  {/* ══ OVERVIEW TAB ══ */}
                  {(playerDetailTab as string) === 'overview' && (
                    <>
                      {/* Player details */}
                      <div className="card mb-3">
                        <div className="card-header"><h5 className="mb-0"><i className="ph-user me-2" />{l('Spelergegevens', 'Player details')}</h5></div>
                        <div className="card-body">
                          <div className="row g-3">
                            {[
                              [l('ID', 'ID'), pl.id],
                              [l('Gebruikersnaam', 'Username'), pl.username],
                              [l('Land', 'Country'), pl.currentCountry],
                              [l('Rang', 'Rank'), pl.rank],
                              [l('XP', 'XP'), pl.xp.toLocaleString()],
                              [l('Geld', 'Money'), `€${pl.money.toLocaleString()}`],
                              [l('Gezondheid', 'Health'), `${pl.health}%`],
                              [l('Reputatie', 'Reputation'), pl.reputation],
                              [l('FBI Heat', 'FBI Heat'), pl.fbiHeat],
                              [l('Wanted level', 'Wanted level'), pl.wantedLevel],
                              [l('Kills', 'Kills'), pl.killCount],
                              [l('Hits', 'Hits'), pl.hitCount],
                              [l('Inventory slots', 'Inventory slots'), `${pl.inventory_slots_used}/${pl.max_inventory_slots}`],
                              [l('VIP', 'VIP'), pl.isVip ? (pl.vipExpiresAt ? `${l('Ja tot', 'Yes until')} ${new Date(pl.vipExpiresAt).toLocaleDateString()}` : l('Permanent', 'Permanent')) : l('Nee', 'No')],
                              [l('Gebanned', 'Banned'), pl.isBanned ? (pl.bannedUntil ? new Date(pl.bannedUntil).toLocaleString() : l('Permanent', 'Permanent')) : l('Nee', 'No')],
                              [l('Aangemaakt', 'Created'), new Date(pl.createdAt).toLocaleString()],
                            ].map(([label, value]) => (
                              <div key={String(label)} className="col-sm-6 col-md-4">
                                <div className="text-muted" style={{ fontSize: '0.75rem' }}>{label}</div>
                                <div className="fw-semibold">{String(value)}</div>
                              </div>
                            ))}
                          </div>
                        </div>
                      </div>

                      {/* Projections */}
                      <div className="card mb-3">
                        <div className="card-header"><h5 className="mb-0"><i className="ph-chart-line me-2" />{l('Prognoses (laatste 7 dagen)', 'Projections (last 7 days)')}</h5></div>
                        <div className="card-body">
                          <div className="row g-3">
                            {[
                              [l('Misdaden / dag', 'Crimes / day'), ov.projections.crimesPerDay],
                              [l('Jobs / dag', 'Jobs / day'), ov.projections.jobsPerDay],
                              [l('Reizen / dag', 'Travels / day'), ov.projections.travelsPerDay],
                              [l('Gem. daginkomen', 'Avg daily income'), `€${ov.projections.avgDailyIncome.toLocaleString()}`],
                              [l('Gem. XP / dag', 'Avg XP / day'), ov.projections.avgDailyXp.toLocaleString()],
                              [l('XP tot volgende rank', 'XP to next rank'), ov.projections.xpToNextRank.toLocaleString()],
                              [l('Dagen tot volgende rank', 'Days to next rank'), ov.projections.estimatedDaysToNextRank ?? '—'],
                            ].map(([label, value]) => (
                              <div key={String(label)} className="col-sm-6 col-md-4">
                                <div className="text-muted" style={{ fontSize: '0.75rem' }}>{label}</div>
                                <div className="fw-semibold">{String(value)}</div>
                              </div>
                            ))}
                          </div>
                        </div>
                      </div>

                      {/* Properties */}
                      <div className="card mb-3">
                        <div className="card-header"><h5 className="mb-0"><i className="ph-buildings me-2" />{l('Eigendommen', 'Properties')} <span className="badge bg-secondary ms-2">{ov.assets.properties.length}</span></h5></div>
                        {ov.assets.properties.length === 0
                          ? <div className="card-body text-muted">{l('Geen eigendommen.', 'No properties.')}</div>
                          : <div className="table-responsive">
                              <table className="table table-hover mb-0">
                                <thead><tr><th>ID</th><th>{l('Type', 'Type')}</th><th>{l('Land', 'Country')}</th><th>{l('Level', 'Level')}</th><th>{l('Prijs', 'Price')}</th></tr></thead>
                                <tbody>
                                  {ov.assets.properties.map((p: any) => (
                                    <tr key={p.id}><td>{p.propertyId}</td><td>{p.propertyType}</td><td>{p.countryId}</td><td>{p.upgradeLevel}</td><td>€{p.purchasePrice.toLocaleString()}</td></tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                        }
                      </div>

                      {/* Tools */}
                      <div className="card mb-3">
                        <div className="card-header"><h5 className="mb-0"><i className="ph-wrench me-2" />{l('Gereedschappen', 'Tools')} <span className="badge bg-secondary ms-2">{ov.assets.tools.length}</span></h5></div>
                        {ov.assets.tools.length === 0
                          ? <div className="card-body text-muted">{l('Geen gereedschappen.', 'No tools.')}</div>
                          : <div className="table-responsive">
                              <table className="table table-hover mb-0">
                                <thead><tr><th>{l('Tool', 'Tool')}</th><th>{l('Type', 'Type')}</th><th>{l('Aantal', 'Amount')}</th><th>{l('Duurzaamheid', 'Durability')}</th><th>{l('Locatie', 'Location')}</th></tr></thead>
                                <tbody>
                                  {ov.assets.tools.map((t: any) => (
                                    <tr key={t.id}><td>{t.tool?.name || t.toolId}</td><td>{t.tool?.type || '-'}</td><td>{t.quantity}</td><td>{t.durability}</td><td>{t.location}</td></tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                        }
                      </div>

                      {/* Ammo & weapons side by side */}
                      <div className="row g-3 mb-3">
                        <div className="col-lg-6">
                          <div className="card h-100">
                            <div className="card-header"><h5 className="mb-0"><i className="ph-bullets me-2" />{l('Ammo', 'Ammo')}</h5></div>
                            {ov.assets.ammo.length === 0
                              ? <div className="card-body text-muted">{l('Geen ammo.', 'No ammo.')}</div>
                              : <div className="table-responsive">
                                  <table className="table table-hover mb-0">
                                    <thead><tr><th>{l('Type', 'Type')}</th><th>{l('Aantal', 'Amount')}</th></tr></thead>
                                    <tbody>
                                      {ov.assets.ammo.map((a: any) => (
                                        <tr key={`${a.playerId}-${a.ammoType}`}><td>{a.ammoType}</td><td>{a.quantity}</td></tr>
                                      ))}
                                    </tbody>
                                  </table>
                                </div>
                            }
                          </div>
                        </div>
                        <div className="col-lg-6">
                          <div className="card h-100">
                            <div className="card-header"><h5 className="mb-0"><i className="ph-gun me-2" />{l('Wapens', 'Weapons')}</h5></div>
                            {ov.assets.weapons.length === 0
                              ? <div className="card-body text-muted">{l('Geen wapens.', 'No weapons.')}</div>
                              : <div className="table-responsive">
                                  <table className="table table-hover mb-0">
                                    <thead><tr><th>ID</th><th>{l('Aantal', 'Amount')}</th><th>{l('Conditie', 'Condition')}</th></tr></thead>
                                    <tbody>
                                      {ov.assets.weapons.map((w: any) => (
                                        <tr key={`${w.playerId}-${w.weaponId}`}><td>{w.weaponId}</td><td>{w.quantity}</td><td>{w.condition}</td></tr>
                                      ))}
                                    </tbody>
                                  </table>
                                </div>
                            }
                          </div>
                        </div>
                      </div>

                      {/* Recent actions */}
                      <div className="card mb-3">
                        <div className="card-header">
                          <h5 className="mb-0"><i className="ph-clock-counter-clockwise me-2" />{l('Recente handelingen', 'Recent actions')}</h5>
                        </div>
                        <div className="card-body pb-0 recent-actions-filters sticky-top">
                          <div className="row g-2 mb-3">
                            <div className="col-sm-6 col-md-3">
                              <select className="form-select form-select-sm" value={actionsDateRange} onChange={(e) => setActionsDateRange(e.target.value as DateRangeFilter)}>
                                <option value="24h">{l('Laatste 24 uur', 'Last 24 hours')}</option>
                                <option value="7d">{l('Laatste 7 dagen', 'Last 7 days')}</option>
                                <option value="30d">{l('Laatste 30 dagen', 'Last 30 days')}</option>
                                <option value="all">{l('Alles', 'All')}</option>
                              </select>
                            </div>
                            <div className="col-sm-6 col-md-3">
                              <select className="form-select form-select-sm" value={actionsTypeFilter} onChange={(e) => setActionsTypeFilter(e.target.value)}>
                                <option value="all">{l('Alle types', 'All types')}</option>
                                {activityTypeOptions.map((type) => <option key={type} value={type}>{type}</option>)}
                              </select>
                            </div>
                            <div className="col-sm-6 col-md-3">
                              <select className="form-select form-select-sm" value={actionsSort} onChange={(e) => setActionsSort(e.target.value as ActivitySort)}>
                                <option value="date_desc">{l('Nieuwste eerst', 'Newest first')}</option>
                                <option value="date_asc">{l('Oudste eerst', 'Oldest first')}</option>
                                <option value="type_asc">{l('Type A-Z', 'Type A-Z')}</option>
                                <option value="type_desc">{l('Type Z-A', 'Type Z-A')}</option>
                              </select>
                            </div>
                            <div className="col-sm-6 col-md-3">
                              <input className="form-control form-control-sm" placeholder={l('Zoek...', 'Search...')} value={actionsSearchInput} onChange={(e) => setActionsSearchInput(e.target.value)} />
                            </div>
                          </div>

                          <div className="row g-2 mb-3">
                            <div className="col-md-3">
                              <select className="form-select form-select-sm" value={recentActionsTimezone} onChange={(e) => setRecentActionsTimezone(e.target.value as ActivityTimezone)}>
                                <option value="local">{l('Tijdzone: lokaal', 'Timezone: local')}</option>
                                <option value="utc">{l('Tijdzone: UTC', 'Timezone: UTC')}</option>
                              </select>
                            </div>
                            <div className="col-md-3">
                              <select className="form-select form-select-sm" value={recentActionsAutoRefreshSeconds} onChange={(e) => setRecentActionsAutoRefreshSeconds(Number(e.target.value) as 0 | 15 | 30 | 60)}>
                                <option value={0}>{l('Auto-refresh: uit', 'Auto-refresh: off')}</option>
                                <option value={15}>{l('Auto-refresh: 15s', 'Auto-refresh: 15s')}</option>
                                <option value={30}>{l('Auto-refresh: 30s', 'Auto-refresh: 30s')}</option>
                                <option value={60}>{l('Auto-refresh: 60s', 'Auto-refresh: 60s')}</option>
                              </select>
                            </div>
                            <div className="col-md-6 d-flex gap-2 justify-content-md-end flex-wrap">
                              <button type="button" className="btn btn-sm btn-outline-primary" onClick={saveCurrentRecentView}>
                                <i className="ph-bookmark-simple me-1" />{l('Save view', 'Save view')}
                              </button>
                              <button type="button" className="btn btn-sm btn-outline-primary" onClick={exportRecentActivitiesCsv}>
                                <i className="ph-download-simple me-1" />CSV
                              </button>
                            </div>
                          </div>

                          {recentActionsSavedViews.length > 0 && (
                            <div className="d-flex flex-wrap gap-2 mb-3">
                              {recentActionsSavedViews.map((view) => (
                                <div key={view.id} className="badge bg-light text-dark border d-flex align-items-center gap-1">
                                  <button type="button" className="btn btn-link btn-sm p-0 text-decoration-none" onClick={() => applyRecentView(view)}>
                                    {view.name}
                                  </button>
                                  <button type="button" className="btn btn-link btn-sm p-0 text-danger" onClick={() => removeRecentView(view.id)}>
                                    <i className="ph-x" />
                                  </button>
                                </div>
                              ))}
                            </div>
                          )}

                          <div className="row g-2 mb-3">
                            <div className="col-md-4">
                              <div className="player-detail-kpi-card">
                                <div className="text-muted">{l('Totaal acties', 'Total actions')}</div>
                                <div className="fw-bold fs-5">{recentActivitiesTotal.toLocaleString()}</div>
                              </div>
                            </div>
                            <div className="col-md-4">
                              <div className="player-detail-kpi-card">
                                <div className="text-muted">{l('Totale opbrengst', 'Total reward')}</div>
                                <div className="fw-bold fs-5 text-success">€{recentActivitiesSummary.totalMoney.toLocaleString()}</div>
                              </div>
                            </div>
                            <div className="col-md-4">
                              <div className="player-detail-kpi-card">
                                <div className="text-muted">{l('Totale XP', 'Total XP')}</div>
                                <div className="fw-bold fs-5 text-info">{recentActivitiesSummary.totalXp.toLocaleString()}</div>
                              </div>
                            </div>
                          </div>

                          {recentActivitiesTrend.length > 0 && (
                            <div className="recent-actions-trend mb-3">
                              <div className="recent-actions-trend-bars">
                                {recentActivitiesTrend.map((point) => {
                                  const maxCount = Math.max(...recentActivitiesTrend.map((x) => x.count), 1)
                                  const height = Math.max(8, Math.round((point.count / maxCount) * 52))
                                  return (
                                    <div key={point.date} className="recent-actions-trend-item" title={`${point.date}: ${point.count}`}>
                                      <div className="recent-actions-trend-bar" style={{ height }} />
                                      <small>{point.date.slice(5)}</small>
                                    </div>
                                  )
                                })}
                              </div>
                            </div>
                          )}

                          <div className="d-flex justify-content-end mb-3">
                            <button
                              type="button"
                              className="btn btn-sm btn-outline-secondary"
                              onClick={() => {
                                setActionsDateRange('7d')
                                setActionsTypeFilter('all')
                                setActionsSort('date_desc')
                                setActionsSearchInput('')
                                setActionsPage(1)
                              }}
                            >
                              <i className="ph-arrow-counter-clockwise me-1" />{l('Reset filters', 'Reset filters')}
                            </button>
                          </div>
                        </div>
                        <div className="table-responsive">
                          <table className="table table-hover mb-0">
                            <thead>
                              <tr><th>{l('Type', 'Type')}</th><th>{l('Omschrijving', 'Description')}</th><th>{l('Jailtijd', 'Jail time')}</th><th>{l('Opbrengst', 'Reward')}</th><th>{l('XP', 'XP')}</th><th>{l('Moment', 'When')}</th></tr>
                            </thead>
                            <tbody>
                              {recentActivitiesLoading && (
                                <tr>
                                  <td colSpan={6} className="text-center text-muted py-4">{t.loading}</td>
                                </tr>
                              )}
                              {!recentActivitiesLoading && recentActivitiesError && (
                                <tr>
                                  <td colSpan={6} className="text-center text-danger py-4">{recentActivitiesError}</td>
                                </tr>
                              )}
                              {!recentActivitiesLoading && !recentActivitiesError && recentActivitiesViewRows.length === 0 && (
                                <tr>
                                  <td colSpan={6} className="text-center text-muted py-4">
                                    <div className="mb-2">{l('Geen resultaten gevonden voor deze filters.', 'No results found for these filters.')}</div>
                                    <button
                                      type="button"
                                      className="btn btn-sm btn-outline-secondary"
                                      onClick={() => {
                                        setActionsDateRange('7d')
                                        setActionsTypeFilter('all')
                                        setActionsSort('date_desc')
                                        setActionsSearchInput('')
                                        setActionsPage(1)
                                      }}
                                    >
                                      {l('Reset filters', 'Reset filters')}
                                    </button>
                                  </td>
                                </tr>
                              )}
                              {!recentActivitiesLoading && !recentActivitiesError && recentActivitiesViewRows.map(({ activity, moneyAmount, xpAmount, jailTime }) => (
                                <tr key={activity.id}>
                                  <td>
                                    <div className="d-flex align-items-center gap-2">
                                      <span className="badge bg-secondary">{activity.activityType}</span>
                                      <button
                                        type="button"
                                        className="btn btn-sm btn-outline-secondary py-0 px-1"
                                        title={l('Filter op dit type', 'Filter by this type')}
                                        onClick={() => {
                                          setActionsTypeFilter(activity.activityType)
                                          setActionsPage(1)
                                        }}
                                      >
                                        <i className="ph-funnel-simple" />
                                      </button>
                                    </div>
                                  </td>
                                  <td>
                                    <div>{activity.description}</div>
                                  </td>
                                  <td>{jailTime !== null ? <span className="fw-semibold text-danger">{jailTime} {l('min', 'min')}</span> : <span className="text-muted">—</span>}</td>
                                  <td>{moneyAmount !== null ? <span className="text-success fw-semibold">€{Number(moneyAmount).toLocaleString()}</span> : <span className="text-muted">—</span>}</td>
                                  <td>{xpAmount !== null ? Number(xpAmount).toLocaleString() : <span className="text-muted">—</span>}</td>
                                  <td className="text-muted" style={{ fontSize: '0.8rem', whiteSpace: 'nowrap' }}>{formatDateWithTimezone(activity.createdAt)}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                        <div className="card-footer d-flex justify-content-between align-items-center flex-wrap gap-2">
                          <small className="text-muted">
                            {tr(t.pageOf, { page: currentActionsPage, total: actionsTotalPages })} - {recentActivitiesTotal} {l('resultaten', 'results')}
                          </small>
                          <div className="btn-group btn-group-sm" role="group" aria-label="Recent actions pagination">
                            <button
                              type="button"
                              className="btn btn-outline-secondary"
                              onClick={() => setActionsPage((prev) => Math.max(1, prev - 1))}
                              disabled={currentActionsPage <= 1 || recentActivitiesLoading}
                            >
                              {t.previous}
                            </button>
                            {recentActivityPageNumbers.map((pageNumber) => (
                              <button
                                key={pageNumber}
                                type="button"
                                className={`btn ${pageNumber === currentActionsPage ? 'btn-primary' : 'btn-outline-secondary'}`}
                                onClick={() => setActionsPage(pageNumber)}
                                disabled={recentActivitiesLoading}
                              >
                                {pageNumber}
                              </button>
                            ))}
                            <button
                              type="button"
                              className="btn btn-outline-secondary"
                              onClick={() => setActionsPage((prev) => Math.min(actionsTotalPages, prev + 1))}
                              disabled={currentActionsPage >= actionsTotalPages || recentActivitiesLoading}
                            >
                              {t.next}
                            </button>
                          </div>
                        </div>
                      </div>
                    </>
                  )}

                  {/* ══ MANAGE TAB ══ */}
                  {(playerDetailTab as string) === 'manage' && (
                    <div className="card mb-3">
                      <div className="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <h5 className="mb-0"><i className="ph-sliders-horizontal me-2" />{l('Speler beheren', 'Manage player')}</h5>
                        <button
                          type="button"
                          className="btn btn-sm btn-danger"
                          onClick={handleManagePlayer}
                          disabled={isSavingPlayerManage || !canManagePlayers}
                        >
                          {isSavingPlayerManage
                            ? <><span className="spinner-border spinner-border-sm me-2" />{l('Bezig...', 'Processing...')}</>
                            : <><i className="ph-floppy-disk me-2" />{l('Opslaan alle wijzigingen', 'Save all changes')}</>}
                        </button>
                      </div>
                      <div className="card-body">
                        <div className="row g-3">
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Stel geld in', 'Set money')}</label>
                            <div className="input-group"><span className="input-group-text">€</span><input className="form-control" type="number" value={playerManageForm.setMoney} onChange={(e) => setPlayerManageForm({ ...playerManageForm, setMoney: e.target.value })} /></div>
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Voeg geld toe', 'Add money')}</label>
                            <div className="input-group"><span className="input-group-text">+€</span><input className="form-control" type="number" value={playerManageForm.addMoney} onChange={(e) => setPlayerManageForm({ ...playerManageForm, addMoney: e.target.value })} /></div>
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Stel rang in', 'Set rank')}</label>
                            <input className="form-control" type="number" value={playerManageForm.setRank} onChange={(e) => setPlayerManageForm({ ...playerManageForm, setRank: e.target.value })} />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Stel XP in', 'Set XP')}</label>
                            <input className="form-control" type="number" value={playerManageForm.setXp} onChange={(e) => setPlayerManageForm({ ...playerManageForm, setXp: e.target.value })} />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Voeg XP toe', 'Add XP')}</label>
                            <div className="input-group">
                              <span className="input-group-text">+</span>
                              <input className="form-control" type="number" value={playerManageForm.addXp} onChange={(e) => setPlayerManageForm({ ...playerManageForm, addXp: e.target.value })} />
                            </div>
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Gezondheid', 'Health')} (0–100)</label>
                            <input className="form-control" type="number" min={0} max={100} value={playerManageForm.setHealth} onChange={(e) => setPlayerManageForm({ ...playerManageForm, setHealth: e.target.value })} />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Land', 'Country')}</label>
                            <input className="form-control" value={playerManageForm.setCountry} onChange={(e) => setPlayerManageForm({ ...playerManageForm, setCountry: e.target.value })} />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('VIP dagen', 'VIP days')}</label>
                            <input className="form-control" type="number" min={1} value={playerManageForm.vipDays} onChange={(e) => setPlayerManageForm({ ...playerManageForm, vipDays: e.target.value })} />
                          </div>
                          <div className="col-md-4 d-flex align-items-end">
                            <div className="form-check mb-2">
                              <input className="form-check-input" type="checkbox" checked={playerManageForm.vipEnabled} onChange={(e) => setPlayerManageForm({ ...playerManageForm, vipEnabled: e.target.checked })} id="vipEnabled" />
                              <label className="form-check-label fw-semibold" htmlFor="vipEnabled">{l('VIP actief', 'VIP active')}</label>
                            </div>
                          </div>

                          <div className="col-12"><hr className="my-1" /><small className="text-muted">{l('Ammo & gereedschap', 'Ammo & tools')}</small></div>

                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Ammo type', 'Ammo type')}</label>
                            <input className="form-control" value={playerManageForm.ammoType} onChange={(e) => setPlayerManageForm({ ...playerManageForm, ammoType: e.target.value })} placeholder="9mm" />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Voeg kogels toe', 'Add bullets')}</label>
                            <input className="form-control" type="number" min={0} value={playerManageForm.ammoQuantity} onChange={(e) => setPlayerManageForm({ ...playerManageForm, ammoQuantity: e.target.value })} />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Tool ID', 'Tool ID')}</label>
                            <input className="form-control" value={playerManageForm.toolId} onChange={(e) => setPlayerManageForm({ ...playerManageForm, toolId: e.target.value })} placeholder="lockpick" />
                          </div>
                          <div className="col-md-4">
                            <label className="form-label fw-semibold">{l('Tool aantal', 'Tool amount')}</label>
                            <input className="form-control" type="number" min={1} value={playerManageForm.toolQuantity} onChange={(e) => setPlayerManageForm({ ...playerManageForm, toolQuantity: e.target.value })} />
                          </div>
                          <div className="col-12">
                            <label className="form-label fw-semibold">{l('Admin reden (audit)', 'Admin reason (audit)')}</label>
                            <textarea
                              className="form-control"
                              rows={2}
                              placeholder={l('Bij kritieke wijzigingen is een reden verplicht.', 'Reason is required for critical changes.')}
                              value={playerManageReason}
                              onChange={(e) => setPlayerManageReason(e.target.value)}
                            />
                            <small className="text-muted">{l('Wordt opgeslagen in audit logging.', 'Stored in audit logging.')}</small>
                          </div>
                        </div>

                        <div className="mt-4 d-flex flex-wrap gap-2 align-items-center">
                          <button className="btn btn-warning fw-bold" onClick={handleManagePlayer} disabled={isSavingPlayerManage || !canManagePlayers}>
                            {isSavingPlayerManage ? <><span className="spinner-border spinner-border-sm me-2" />{l('Bezig...', 'Processing...')}</> : <><i className="ph-floppy-disk me-2" />{l('Opslaan alle wijzigingen', 'Save all changes')}</>}
                          </button>
                          <small className="text-muted">{l('Slaat alle velden in dit beheerformulier op.', 'Saves all fields in this management form.')}</small>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* ══ FINANCIAL TAB ══ */}
                  {playerDetailTab === 'financial' && (
                    <>
                      {/* Date filter */}
                      <div className="card mb-3">
                        <div className="card-body d-flex gap-2 align-items-center flex-wrap">
                          <span className="text-muted me-1"><i className="ph-calendar me-1" />{l('Periode:', 'Period:')}</span>
                          {(['24h', '7d', '30d', 'all'] as const).map(r => (
                            <button key={r} className={`btn btn-sm ${financialDateRange === r ? 'btn-primary' : 'btn-outline-secondary'}`} onClick={() => setFinancialDateRange(r)}>
                              {r === 'all' ? l('Alles', 'All') : r}
                            </button>
                          ))}
                        </div>
                      </div>

                      {/* Financial metric tiles */}
                      <div className="row g-3 mb-3">
                        <div className="col-md-4">
                          <div className="card h-100">
                            <div className="card-body">
                              <div className="text-muted mb-1" style={{ fontSize: '0.75rem' }}><i className="ph-bank me-1" />{l('Bank saldo', 'Bank balance')}</div>
                              <div className="fw-bold fs-5">€{(ov.financial.bankAccount?.balance || 0).toLocaleString()}</div>
                              <div className="text-muted" style={{ fontSize: '0.75rem' }}>{l('Rente', 'Interest')}: {((ov.financial.bankAccount?.interestRate || 0) * 100).toFixed(2)}%</div>
                            </div>
                          </div>
                        </div>
                        <div className="col-md-4">
                          <div className="card h-100">
                            <div className="card-body">
                              <div className="text-muted mb-1" style={{ fontSize: '0.75rem' }}><i className="ph-dice-five me-1" />{l('Casino netto (speler)', 'Casino net (player)')}</div>
                              <div className={`fw-bold fs-5 ${ov.financial.casinoAsPlayerTotals.netResult >= 0 ? 'text-success' : 'text-danger'}`}>
                                €{ov.financial.casinoAsPlayerTotals.netResult.toLocaleString()}
                              </div>
                              <div className="text-muted" style={{ fontSize: '0.75rem' }}>{l('Ingezet', 'Bet')}: €{ov.financial.casinoAsPlayerTotals.totalBet.toLocaleString()}</div>
                            </div>
                          </div>
                        </div>
                        <div className="col-md-4">
                          <div className="card h-100">
                            <div className="card-body">
                              <div className="text-muted mb-1" style={{ fontSize: '0.75rem' }}><i className="ph-storefront me-1" />{l('Casino opbrengst (eigenaar)', 'Casino revenue (owner)')}</div>
                              <div className="fw-bold fs-5 text-success">€{ov.financial.casinoAsOwnerTotals.totalOwnerCut.toLocaleString()}</div>
                              <div className="text-muted" style={{ fontSize: '0.75rem' }}>{l('Volume', 'Volume')}: €{ov.financial.casinoAsOwnerTotals.totalBet.toLocaleString()}</div>
                            </div>
                          </div>
                        </div>
                      </div>

                      {/* Casino as player */}
                      <div className="card mb-3">
                        <div className="card-header d-flex align-items-center gap-2">
                          <h5 className="mb-0 flex-fill"><i className="ph-dice-five me-2" />{l('Casino transacties (als speler)', 'Casino transactions (as player)')}</h5>
                          <select className="form-select form-select-sm" style={{ maxWidth: 200 }} value={financialPlayerSort} onChange={(e) => setFinancialPlayerSort(e.target.value as any)}>
                            <option value="date_desc">{l('Nieuwste eerst', 'Newest first')}</option>
                            <option value="date_asc">{l('Oudste eerst', 'Oldest first')}</option>
                            <option value="bet_desc">{l('Inzet ↓', 'Bet ↓')}</option>
                            <option value="bet_asc">{l('Inzet ↑', 'Bet ↑')}</option>
                            <option value="result_desc">{l('Resultaat ↓', 'Result ↓')}</option>
                            <option value="result_asc">{l('Resultaat ↑', 'Result ↑')}</option>
                          </select>
                        </div>
                        {sortedCasinoAsPlayer.length === 0
                          ? <div className="card-body text-muted">{l('Geen transacties.', 'No transactions.')}</div>
                          : <div className="table-responsive">
                              <table className="table table-hover mb-0">
                                <thead><tr><th>{l('Moment', 'When')}</th><th>{l('Casino', 'Casino')}</th><th>{l('Spel', 'Game')}</th><th>{l('Inzet', 'Bet')}</th><th>{l('Uitbetaling', 'Payout')}</th><th>{l('Resultaat', 'Result')}</th></tr></thead>
                                <tbody>
                                  {sortedCasinoAsPlayer.map((e) => {
                                    const net = e.payout - e.betAmount
                                    return (
                                      <tr key={e.id}>
                                        <td className="text-muted" style={{ fontSize: '0.8rem', whiteSpace: 'nowrap' }}>{new Date(e.createdAt).toLocaleString()}</td>
                                        <td>{e.casinoId}</td>
                                        <td>{e.gameType}</td>
                                        <td>€{e.betAmount.toLocaleString()}</td>
                                        <td>€{e.payout.toLocaleString()}</td>
                                        <td className={net >= 0 ? 'text-success fw-semibold' : 'text-danger fw-semibold'}>€{net.toLocaleString()}</td>
                                      </tr>
                                    )
                                  })}
                                </tbody>
                              </table>
                            </div>
                        }
                      </div>

                      {/* Casino as owner */}
                      <div className="card mb-3">
                        <div className="card-header d-flex align-items-center gap-2">
                          <h5 className="mb-0 flex-fill"><i className="ph-storefront me-2" />{l('Casino transacties (als eigenaar)', 'Casino transactions (as owner)')}</h5>
                          <select className="form-select form-select-sm" style={{ maxWidth: 200 }} value={financialOwnerSort} onChange={(e) => setFinancialOwnerSort(e.target.value as any)}>
                            <option value="date_desc">{l('Nieuwste eerst', 'Newest first')}</option>
                            <option value="date_asc">{l('Oudste eerst', 'Oldest first')}</option>
                            <option value="cut_desc">{l('House cut ↓', 'House cut ↓')}</option>
                            <option value="cut_asc">{l('House cut ↑', 'House cut ↑')}</option>
                          </select>
                        </div>
                        {sortedCasinoAsOwner.length === 0
                          ? <div className="card-body text-muted">{l('Geen transacties.', 'No transactions.')}</div>
                          : <div className="table-responsive">
                              <table className="table table-hover mb-0">
                                <thead><tr><th>{l('Moment', 'When')}</th><th>{l('Speler ID', 'Player ID')}</th><th>{l('Casino', 'Casino')}</th><th>{l('Spel', 'Game')}</th><th>{l('House cut', 'House cut')}</th></tr></thead>
                                <tbody>
                                  {sortedCasinoAsOwner.map((e) => (
                                    <tr key={e.id}>
                                      <td className="text-muted" style={{ fontSize: '0.8rem', whiteSpace: 'nowrap' }}>{new Date(e.createdAt).toLocaleString()}</td>
                                      <td>{e.playerId}</td><td>{e.casinoId}</td><td>{e.gameType}</td>
                                      <td className="text-success fw-semibold">€{e.ownerCut.toLocaleString()}</td>
                                    </tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                        }
                      </div>

                      {/* Premium purchases */}
                      <div className="card mb-3">
                        <div className="card-header d-flex align-items-center gap-2">
                          <h5 className="mb-0 flex-fill"><i className="ph-crown me-2" />{l('Premium aankopen', 'Premium purchases')}</h5>
                          <select className="form-select form-select-sm" style={{ maxWidth: 200 }} value={financialPremiumSort} onChange={(e) => setFinancialPremiumSort(e.target.value as any)}>
                            <option value="date_desc">{l('Nieuwste eerst', 'Newest first')}</option>
                            <option value="date_asc">{l('Oudste eerst', 'Oldest first')}</option>
                            <option value="product_asc">{l('Product A-Z', 'Product A-Z')}</option>
                            <option value="product_desc">{l('Product Z-A', 'Product Z-A')}</option>
                          </select>
                        </div>
                        {sortedPremiumFulfillments.length === 0
                          ? <div className="card-body text-muted">{l('Geen aankopen.', 'No purchases.')}</div>
                          : <div className="table-responsive">
                              <table className="table table-hover mb-0">
                                <thead><tr><th>ID</th><th>{l('Product', 'Product')}</th><th>{l('Session', 'Session')}</th><th>{l('Moment', 'When')}</th></tr></thead>
                                <tbody>
                                  {sortedPremiumFulfillments.map((e) => (
                                    <tr key={e.id}>
                                      <td>{e.id}</td><td><span className="badge bg-warning text-dark">{e.productKey}</span></td>
                                      <td className="text-muted" style={{ fontSize: '0.75rem' }}>{e.stripeSessionId}</td>
                                      <td className="text-muted" style={{ fontSize: '0.8rem', whiteSpace: 'nowrap' }}>{new Date(e.fulfilledAt).toLocaleString()}</td>
                                    </tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                        }
                      </div>
                    </>
                  )}
                </>
              )
            })()}
          </div>
        )}

        {activeTab === 'vehicles' && (
          <>
            <h1>{t.vehiclesTitle}</h1>
            <div className="config-warning">
              {l('🚘 Beheer voertuigen in ', '🚘 Manage vehicles in ')}
              <strong>backend/content/vehicles.json</strong>
              {l(' zonder handmatig files te editen.', ' without manual file edits.')}
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{t.addVehicle}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('Categorie', 'Category')}</label>
                  <select
                    value={newVehicle.category}
                    onChange={(e) => setNewVehicle({ ...newVehicle, category: e.target.value as 'cars' | 'boats' })}
                  >
                    <option value="cars">{l('Auto\'s', 'Cars')}</option>
                    <option value="boats">{l('Boten', 'Boats')}</option>
                  </select>
                </div>
                <div className="form-group">
                  <label>{l('ID', 'ID')}</label>
                  <input value={newVehicle.id} onChange={(e) => setNewVehicle({ ...newVehicle, id: e.target.value })} placeholder="ferrari_f40" />
                </div>
                <div className="form-group">
                  <label>{l('Naam', 'Name')}</label>
                  <input value={newVehicle.name} onChange={(e) => setNewVehicle({ ...newVehicle, name: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Type', 'Type')}</label>
                  <input value={newVehicle.type} onChange={(e) => setNewVehicle({ ...newVehicle, type: e.target.value })} placeholder="speed" />
                </div>
                <div className="form-group">
                  <label>{l('Image nieuw (100%)', 'Image new (100%)')}</label>
                  <input value={newVehicle.imageNew} onChange={(e) => setNewVehicle({ ...newVehicle, imageNew: e.target.value })} placeholder="ferrari_f40_new.png" />
                </div>
                <div className="form-group">
                  <label>{l('Image vies (70-99%)', 'Image dirty (70-99%)')}</label>
                  <input value={newVehicle.imageDirty} onChange={(e) => setNewVehicle({ ...newVehicle, imageDirty: e.target.value })} placeholder="ferrari_f40_dirty.png" />
                </div>
                <div className="form-group">
                  <label>{l('Image defect (<70%)', 'Image damaged (<70%)')}</label>
                  <input value={newVehicle.imageDamaged} onChange={(e) => setNewVehicle({ ...newVehicle, imageDamaged: e.target.value })} placeholder="ferrari_f40_damaged.png" />
                </div>
                <div className="form-group">
                  <label>{l('Landen (komma-gescheiden)', 'Countries (comma-separated)')}</label>
                  <input value={newVehicle.availableInCountries} onChange={(e) => setNewVehicle({ ...newVehicle, availableInCountries: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Basiswaarde', 'Base value')}</label>
                  <input type="number" value={newVehicle.baseValue} onChange={(e) => setNewVehicle({ ...newVehicle, baseValue: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Brandstofcapaciteit', 'Fuel capacity')}</label>
                  <input type="number" value={newVehicle.fuelCapacity} onChange={(e) => setNewVehicle({ ...newVehicle, fuelCapacity: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Vereiste rang', 'Required rank')}</label>
                  <input type="number" value={newVehicle.requiredRank} onChange={(e) => setNewVehicle({ ...newVehicle, requiredRank: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Snelheid', 'Speed')}</label>
                  <input type="number" value={newVehicle.speed} onChange={(e) => setNewVehicle({ ...newVehicle, speed: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Pantser', 'Armor')}</label>
                  <input type="number" value={newVehicle.armor} onChange={(e) => setNewVehicle({ ...newVehicle, armor: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Lading', 'Cargo')}</label>
                  <input type="number" value={newVehicle.cargo} onChange={(e) => setNewVehicle({ ...newVehicle, cargo: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Stealth', 'Stealth')}</label>
                  <input type="number" value={newVehicle.stealth} onChange={(e) => setNewVehicle({ ...newVehicle, stealth: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Zeldzaamheid', 'Rarity')}</label>
                  <select value={newVehicle.rarity} onChange={(e) => setNewVehicle({ ...newVehicle, rarity: e.target.value })}>
                    <option value="common">{l('Gewoon', 'Common')}</option>
                    <option value="uncommon">{l('Ongewoon', 'Uncommon')}</option>
                    <option value="rare">{l('Zeldzaam', 'Rare')}</option>
                    <option value="epic">{l('Episch', 'Epic')}</option>
                    <option value="legendary">{l('Legendarisch', 'Legendary')}</option>
                  </select>
                </div>
              </div>

              <div className="form-group">
                <label>{l('Beschrijving', 'Description')}</label>
                <textarea
                  value={newVehicle.description}
                  onChange={(e) => setNewVehicle({ ...newVehicle, description: e.target.value })}
                  rows={3}
                  style={{ resize: 'vertical' }}
                />
              </div>

              <div className="form-group">
                <label>{l('Marktwaarde JSON', 'Market value JSON')}</label>
                <textarea
                  value={newVehicle.marketValueJson}
                  onChange={(e) => setNewVehicle({ ...newVehicle, marketValueJson: e.target.value })}
                  rows={5}
                  style={{ fontFamily: 'monospace', resize: 'vertical' }}
                />
              </div>

              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleAddVehicle} disabled={vehiclesLoading}>
                  {vehiclesLoading ? t.loading : t.addVehicle}
                </button>
                <button className="btn-small" onClick={loadVehicles} disabled={vehiclesLoading}>
                  {t.refresh}
                </button>
              </div>
            </div>

            <h2>{l('Auto\'s', 'Cars')} ({carDefinitions.length})</h2>
            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Naam', 'Name')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Nieuw', 'New')}</th>
                    <th>{l('Vies', 'Dirty')}</th>
                    <th>{l('Defect', 'Damaged')}</th>
                    <th>{l('Rang', 'Rank')}</th>
                    <th>{t.actions}</th>
                  </tr>
                </thead>
                <tbody>
                  {carDefinitions.map((vehicle) => (
                    <tr key={vehicle.id}>
                      <td>{vehicle.id}</td>
                      <td>{vehicle.name}</td>
                      <td>{vehicle.type}</td>
                      <td>{vehicle.imageNew || vehicle.image || '-'}</td>
                      <td>{vehicle.imageDirty || '-'}</td>
                      <td>{vehicle.imageDamaged || '-'}</td>
                      <td>{vehicle.requiredRank}</td>
                      <td>
                        <button className="btn-small btn-danger" onClick={() => handleDeleteVehicle('cars', vehicle.id)}>
                          {t.delete}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <h2>{l('Boten', 'Boats')} ({boatDefinitions.length})</h2>
            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Naam', 'Name')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Nieuw', 'New')}</th>
                    <th>{l('Vies', 'Dirty')}</th>
                    <th>{l('Defect', 'Damaged')}</th>
                    <th>{l('Rang', 'Rank')}</th>
                    <th>{t.actions}</th>
                  </tr>
                </thead>
                <tbody>
                  {boatDefinitions.map((vehicle) => (
                    <tr key={vehicle.id}>
                      <td>{vehicle.id}</td>
                      <td>{vehicle.name}</td>
                      <td>{vehicle.type}</td>
                      <td>{vehicle.imageNew || vehicle.image || '-'}</td>
                      <td>{vehicle.imageDirty || '-'}</td>
                      <td>{vehicle.imageDamaged || '-'}</td>
                      <td>{vehicle.requiredRank}</td>
                      <td>
                        <button className="btn-small btn-danger" onClick={() => handleDeleteVehicle('boats', vehicle.id)}>
                          {t.delete}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <h2>✈️ {l('Vliegtuigen', 'Aircraft')} ({aircraftList.length})</h2>
            <div className="config-warning">
              {l('Vliegtuigen worden opgeslagen in ', 'Aircraft are stored in ')}
              <strong>backend/content/aircraft.json</strong>.
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{t.addAircraft}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('ID', 'ID')}</label>
                  <input value={newAircraft.id} onChange={(e) => setNewAircraft({ ...newAircraft, id: e.target.value })} placeholder="cessna_172" />
                </div>
                <div className="form-group">
                  <label>{l('Naam', 'Name')}</label>
                  <input value={newAircraft.name} onChange={(e) => setNewAircraft({ ...newAircraft, name: e.target.value })} placeholder="Cessna 172" />
                </div>
                <div className="form-group">
                  <label>{l('Type', 'Type')}</label>
                  <input value={newAircraft.type} onChange={(e) => setNewAircraft({ ...newAircraft, type: e.target.value })} placeholder="light_aircraft" />
                </div>
                <div className="form-group">
                  <label>{l('Prijs', 'Price')}</label>
                  <input type="number" value={newAircraft.price} onChange={(e) => setNewAircraft({ ...newAircraft, price: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Min. rang', 'Min. rank')}</label>
                  <input type="number" value={newAircraft.minRank} onChange={(e) => setNewAircraft({ ...newAircraft, minRank: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Max. bereik (km)', 'Max. range (km)')}</label>
                  <input type="number" value={newAircraft.maxRange} onChange={(e) => setNewAircraft({ ...newAircraft, maxRange: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Brandstofcapaciteit', 'Fuel capacity')}</label>
                  <input type="number" value={newAircraft.fuelCapacity} onChange={(e) => setNewAircraft({ ...newAircraft, fuelCapacity: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Brandstofkosten / km', 'Fuel cost / km')}</label>
                  <input type="number" value={newAircraft.fuelCostPerKm} onChange={(e) => setNewAircraft({ ...newAircraft, fuelCostPerKm: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Reparatiekosten', 'Repair cost')}</label>
                  <input type="number" value={newAircraft.repairCost} onChange={(e) => setNewAircraft({ ...newAircraft, repairCost: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Snelheidsmultiplier', 'Speed multiplier')}</label>
                  <input type="number" step="0.1" value={newAircraft.speedMultiplier} onChange={(e) => setNewAircraft({ ...newAircraft, speedMultiplier: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Laadcapaciteit', 'Cargo capacity')}</label>
                  <input type="number" value={newAircraft.cargoCapacity} onChange={(e) => setNewAircraft({ ...newAircraft, cargoCapacity: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Image (optioneel)', 'Image (optional)')}</label>
                  <input value={newAircraft.image} onChange={(e) => setNewAircraft({ ...newAircraft, image: e.target.value })} placeholder="cessna_172.png" />
                </div>
              </div>
              <div className="form-group">
                <label>{l('Beschrijving', 'Description')}</label>
                <textarea
                  value={newAircraft.description}
                  onChange={(e) => setNewAircraft({ ...newAircraft, description: e.target.value })}
                  rows={2}
                  style={{ resize: 'vertical' }}
                />
              </div>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleAddAircraft} disabled={vehiclesLoading}>
                  {vehiclesLoading ? t.loading : t.addAircraft}
                </button>
              </div>
            </div>

            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Naam', 'Name')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Prijs', 'Price')}</th>
                    <th>{l('Min. rang', 'Min. rank')}</th>
                    <th>{l('Bereik', 'Range')}</th>
                    <th>{l('Snelheid x', 'Speed x')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {aircraftList.map((ac) => (
                    <tr key={ac.id}>
                      <td>{ac.id}</td>
                      <td>{ac.name}</td>
                      <td>{ac.type}</td>
                      <td>{ac.price?.toLocaleString()}</td>
                      <td>{ac.minRank}</td>
                      <td>{ac.maxRange} km</td>
                      <td>{ac.speedMultiplier}</td>
                      <td>
                        <button className="btn-small btn-danger" onClick={() => handleDeleteAircraft(ac.id)}>{t.delete}</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        )}

        {activeTab === 'tools' && (
          <>
            <h1>{t.toolsTitle}</h1>
            <div className="config-warning">
              {l('Gereedschappen worden opgeslagen in ', 'Tools are stored in ')}
              <strong>backend/data/tools.json</strong>.
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{t.addTool}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('ID', 'ID')}</label>
                  <input value={newTool.id} onChange={(e) => setNewTool({ ...newTool, id: e.target.value })} placeholder="lockpick" />
                </div>
                <div className="form-group">
                  <label>{l('Naam', 'Name')}</label>
                  <input value={newTool.name} onChange={(e) => setNewTool({ ...newTool, name: e.target.value })} placeholder="Lockpick" />
                </div>
                <div className="form-group">
                  <label>{l('Type', 'Type')}</label>
                  <input value={newTool.type} onChange={(e) => setNewTool({ ...newTool, type: e.target.value })} placeholder="lock_tools" />
                </div>
                <div className="form-group">
                  <label>{l('Aankoopbedrag', 'Base price')}</label>
                  <input type="number" value={newTool.basePrice} onChange={(e) => setNewTool({ ...newTool, basePrice: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Max. duurzaamheid', 'Max. durability')}</label>
                  <input type="number" value={newTool.maxDurability} onChange={(e) => setNewTool({ ...newTool, maxDurability: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Verlies kans (0-1)', 'Lose chance (0-1)')}</label>
                  <input type="number" step="0.01" min="0" max="1" value={newTool.loseChance} onChange={(e) => setNewTool({ ...newTool, loseChance: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Slijtage per gebruik', 'Wear per use')}</label>
                  <input type="number" value={newTool.wearPerUse} onChange={(e) => setNewTool({ ...newTool, wearPerUse: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Image URL (optioneel)', 'Image URL (optional)')}</label>
                  <input value={newTool.image} onChange={(e) => setNewTool({ ...newTool, image: e.target.value })} placeholder="lockpick.png" />
                </div>
                <div className="form-group" style={{ gridColumn: '1 / -1' }}>
                  <label>{l('Benodigd voor misdaden (komma-gescheiden IDs)', 'Required for crimes (comma-separated IDs)')}</label>
                  <input value={newTool.requiredFor} onChange={(e) => setNewTool({ ...newTool, requiredFor: e.target.value })} placeholder="car_theft,bank_robbery" />
                </div>
              </div>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleAddTool} disabled={toolsLoading}>
                  {toolsLoading ? t.loading : t.addTool}
                </button>
                <button className="btn-small" onClick={loadTools} disabled={toolsLoading}>{t.refresh}</button>
              </div>
            </div>

            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Naam', 'Name')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Aankoopbedrag', 'Base price')}</th>
                    <th>{l('Duurzaamheid', 'Durability')}</th>
                    <th>{l('Verlies%', 'Lose%')}</th>
                    <th>{l('Slijtage', 'Wear')}</th>
                    <th>{l('Afbeelding', 'Image')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {toolsList.map((tool) => (
                    <tr key={tool.id}>
                      <td>{tool.id}</td>
                      <td>
                        <input
                          type="text"
                          value={tool.name}
                          onChange={(e) => updateToolField(tool.id, 'name', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={tool.type || ''}
                          onChange={(e) => updateToolField(tool.id, 'type', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={tool.basePrice ?? 0}
                          onChange={(e) => updateToolField(tool.id, 'basePrice', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={tool.maxDurability ?? 100}
                          onChange={(e) => updateToolField(tool.id, 'maxDurability', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          step="0.01"
                          value={tool.loseChance ?? 0}
                          onChange={(e) => updateToolField(tool.id, 'loseChance', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={tool.wearPerUse ?? 0}
                          onChange={(e) => updateToolField(tool.id, 'wearPerUse', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={tool.image || ''}
                          onChange={(e) => updateToolField(tool.id, 'image', e.target.value)}
                        />
                      </td>
                      <td>
                        <button className="btn-small btn-success" onClick={() => handleSaveTool(tool)}>{t.save}</button>
                        {' '}
                        <button className="btn-small btn-danger" onClick={() => handleDeleteTool(tool.id)}>{t.delete}</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        )}

        {activeTab === 'crimes' && (
          <>
            <h1>{t.crimesTitle}</h1>
            <div className="config-warning">
              {l('Misdaden worden opgeslagen in ', 'Crimes are stored in ')}
              <strong>backend/content/crimes.json</strong>.
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{t.addCrime}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('ID', 'ID')}</label>
                  <input value={newCrime.id} onChange={(e) => setNewCrime({ ...newCrime, id: e.target.value })} placeholder="car_theft" />
                </div>
                <div className="form-group">
                  <label>{l('Naam', 'Name')}</label>
                  <input value={newCrime.name} onChange={(e) => setNewCrime({ ...newCrime, name: e.target.value })} placeholder="Car Theft" />
                </div>
                <div className="form-group">
                  <label>{l('Min. level', 'Min. level')}</label>
                  <input type="number" value={newCrime.minLevel} onChange={(e) => setNewCrime({ ...newCrime, minLevel: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Slaagkans (0–1)', 'Success chance (0–1)')}</label>
                  <input type="number" step="0.01" min="0" max="1" value={newCrime.baseSuccessChance} onChange={(e) => setNewCrime({ ...newCrime, baseSuccessChance: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Min. geld verdienste', 'Min. money reward')}</label>
                  <input type="number" value={newCrime.minReward} onChange={(e) => setNewCrime({ ...newCrime, minReward: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Max. geld verdienste', 'Max. money reward')}</label>
                  <input type="number" value={newCrime.maxReward} onChange={(e) => setNewCrime({ ...newCrime, maxReward: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Min. XP', 'Min. XP')}</label>
                  <input type="number" value={newCrime.minXpReward} onChange={(e) => setNewCrime({ ...newCrime, minXpReward: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Max. XP', 'Max. XP')}</label>
                  <input type="number" value={newCrime.maxXpReward} onChange={(e) => setNewCrime({ ...newCrime, maxXpReward: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Jail tijd (min)', 'Jail time (min)')}</label>
                  <input type="number" value={newCrime.jailTime} onChange={(e) => setNewCrime({ ...newCrime, jailTime: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Pech kans (0–1)', 'Breakdown chance (0–1)')}</label>
                  <input type="number" step="0.01" min="0" max="1" value={newCrime.breakdownChance} onChange={(e) => setNewCrime({ ...newCrime, breakdownChance: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Voertuig type vereist', 'Required vehicle type')}</label>
                  <select value={newCrime.requiredVehicleType} onChange={(e) => setNewCrime({ ...newCrime, requiredVehicleType: e.target.value, requiredVehicle: e.target.value !== 'none' })}>
                    <option value="none">{l('Geen', 'None')}</option>
                    <option value="car">{l('Auto', 'Car')}</option>
                    <option value="boat">{l('Boot', 'Boat')}</option>
                    <option value="aircraft">{l('Vliegtuig', 'Aircraft')}</option>
                  </select>
                </div>
                <div className="form-group" style={{ alignSelf: 'center' }}>
                  <label>
                    <input type="checkbox" checked={newCrime.isFederal} onChange={(e) => setNewCrime({ ...newCrime, isFederal: e.target.checked })} />{' '}
                    {l('Federale misdaad', 'Federal crime')}
                  </label>
                </div>
                <div className="form-group" style={{ gridColumn: '1 / -1' }}>
                  <label>{l('Beschrijving', 'Description')}</label>
                  <textarea
                    value={newCrime.description}
                    onChange={(e) => setNewCrime({ ...newCrime, description: e.target.value })}
                    rows={2}
                    style={{ resize: 'vertical' }}
                  />
                </div>
                <div className="form-group" style={{ gridColumn: '1 / -1' }}>
                  <label>{l('Benodigd gereedschap', 'Required tools')}</label>
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.5rem' }}>
                    {toolsList.map((tool) => (
                      <label key={tool.id} style={{ display: 'flex', alignItems: 'center', gap: '0.25rem' }}>
                        <input
                          type="checkbox"
                          checked={newCrime.requiredTools.includes(tool.id)}
                          onChange={(e) => {
                            const updated = e.target.checked
                              ? [...newCrime.requiredTools, tool.id]
                              : newCrime.requiredTools.filter((t) => t !== tool.id)
                            setNewCrime({ ...newCrime, requiredTools: updated })
                          }}
                        />
                        {tool.name}
                      </label>
                    ))}
                    {toolsList.length === 0 && <span style={{ color: 'var(--muted)' }}>{l('Laad eerst gereedschappen via het Gereedschappen-tabblad.', 'Load tools first via the Tools tab.')}</span>}
                  </div>
                </div>
              </div>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleAddCrime} disabled={crimesLoading}>
                  {crimesLoading ? t.loading : t.addCrime}
                </button>
                <button className="btn-small" onClick={loadCrimes} disabled={crimesLoading}>{t.refresh}</button>
              </div>
            </div>

            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Naam', 'Name')}</th>
                    <th>{l('Min. lvl', 'Min. lvl')}</th>
                    <th>{l('Slaagkans', 'Success chance')}</th>
                    <th>{l('Min geld', 'Min money')}</th>
                    <th>{l('Max geld', 'Max money')}</th>
                    <th>{l('Min XP', 'Min XP')}</th>
                    <th>{l('Max XP', 'Max XP')}</th>
                    <th>{l('Jail', 'Jail')}</th>
                    <th>{l('Voertuig', 'Vehicle')}</th>
                    <th>{l('Federaal', 'Federal')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {crimesList.map((crime) => (
                    <tr key={crime.id}>
                      <td>{crime.id}</td>
                      <td>
                        <input type="text" value={crime.name} onChange={(e) => updateCrimeField(crime.id, 'name', e.target.value)} />
                      </td>
                      <td>
                        <input type="number" value={crime.minLevel ?? 1} onChange={(e) => updateCrimeField(crime.id, 'minLevel', Number(e.target.value))} />
                      </td>
                      <td>
                        <input type="number" step="0.01" value={crime.baseSuccessChance ?? 0.5} onChange={(e) => updateCrimeField(crime.id, 'baseSuccessChance', Number(e.target.value))} />
                      </td>
                      <td>
                        <input type="number" value={crime.minReward ?? 0} onChange={(e) => updateCrimeField(crime.id, 'minReward', Number(e.target.value))} />
                      </td>
                      <td>
                        <input type="number" value={crime.maxReward ?? 0} onChange={(e) => updateCrimeField(crime.id, 'maxReward', Number(e.target.value))} />
                      </td>
                      <td>
                        <input type="number" value={crime.minXpReward ?? crime.xpReward ?? 0} onChange={(e) => updateCrimeField(crime.id, 'minXpReward', Number(e.target.value))} />
                      </td>
                      <td>
                        <input type="number" value={crime.maxXpReward ?? crime.xpReward ?? 0} onChange={(e) => updateCrimeField(crime.id, 'maxXpReward', Number(e.target.value))} />
                      </td>
                      <td>
                        <input type="number" value={crime.jailTime ?? 0} onChange={(e) => updateCrimeField(crime.id, 'jailTime', Number(e.target.value))} />
                      </td>
                      <td>
                        <select
                          value={crime.requiredVehicleType || 'none'}
                          onChange={(e) => {
                            updateCrimeField(crime.id, 'requiredVehicleType', e.target.value)
                            updateCrimeField(crime.id, 'requiredVehicle', e.target.value !== 'none')
                          }}
                        >
                          <option value="none">{l('Geen', 'None')}</option>
                          <option value="car">{l('Auto', 'Car')}</option>
                          <option value="boat">{l('Boot', 'Boat')}</option>
                          <option value="aircraft">{l('Vliegtuig', 'Aircraft')}</option>
                        </select>
                      </td>
                      <td>
                        <input
                          type="checkbox"
                          checked={crime.isFederal ?? false}
                          onChange={(e) => updateCrimeField(crime.id, 'isFederal', e.target.checked)}
                        />
                      </td>
                      <td>
                        <button className="btn-small btn-success" onClick={() => handleSaveCrime(crime)}>{t.save}</button>
                        {' '}
                        <button className="btn-small btn-danger" onClick={() => handleDeleteCrime(crime.id)}>{t.delete}</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        )}

        {activeTab === 'events' && (
          <>
            <h1>{l('Events', 'Events')}</h1>
            <div className="config-warning">
              {l('Beheer hier event templates, schema\'s en live events.', 'Manage event templates, schedules, and live events here.')}
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{l('Nieuw Event Template', 'New Event Template')}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>Key</label>
                  <input value={newEventTemplate.key} onChange={(e) => setNewEventTemplate({ ...newEventTemplate, key: e.target.value })} placeholder="vehicle_police_hunt" />
                </div>
                <div className="form-group">
                  <label>{l('Categorie', 'Category')}</label>
                  <input value={newEventTemplate.category} onChange={(e) => setNewEventTemplate({ ...newEventTemplate, category: e.target.value })} placeholder="vehicle" />
                </div>
                <div className="form-group">
                  <label>{l('Event type', 'Event type')}</label>
                  <input value={newEventTemplate.eventType} onChange={(e) => setNewEventTemplate({ ...newEventTemplate, eventType: e.target.value })} placeholder="boost" />
                </div>
                <div className="form-group">
                  <label>Icon</label>
                  <input value={newEventTemplate.icon ?? ''} onChange={(e) => setNewEventTemplate({ ...newEventTemplate, icon: e.target.value })} placeholder="bi-car-front" />
                </div>
                <div className="form-group">
                  <label>{l('Titel NL', 'Title NL')}</label>
                  <input value={newEventTemplate.titleNl} onChange={(e) => setNewEventTemplate({ ...newEventTemplate, titleNl: e.target.value })} />
                </div>
                <div className="form-group">
                  <label>{l('Titel EN', 'Title EN')}</label>
                  <input value={newEventTemplate.titleEn} onChange={(e) => setNewEventTemplate({ ...newEventTemplate, titleEn: e.target.value })} />
                </div>
              </div>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleCreateEventTemplate} disabled={eventsLoading}>{l('Template aanmaken', 'Create template')}</button>
                <button className="btn-small" onClick={loadEventAdminData} disabled={eventsLoading}>{t.refresh}</button>
              </div>
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{l('Nieuw Event Schema', 'New Event Schedule')}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('Template', 'Template')}</label>
                  <select
                    value={newEventSchedule.templateId}
                    onChange={(e) => setNewEventSchedule({ ...newEventSchedule, templateId: Number(e.target.value) })}
                  >
                    <option value={0}>{l('Selecteer template', 'Select template')}</option>
                    {eventTemplates.map((template) => (
                      <option key={template.id} value={template.id}>{template.id} - {template.key}</option>
                    ))}
                  </select>
                </div>
                <div className="form-group">
                  <label>{l('Schema type', 'Schedule type')}</label>
                  <input value={newEventSchedule.scheduleType} onChange={(e) => setNewEventSchedule({ ...newEventSchedule, scheduleType: e.target.value })} placeholder="interval" />
                </div>
                <div className="form-group">
                  <label>{l('Interval (min)', 'Interval (min)')}</label>
                  <input type="number" value={newEventSchedule.intervalMinutes ?? 0} onChange={(e) => setNewEventSchedule({ ...newEventSchedule, intervalMinutes: Number(e.target.value) })} />
                </div>
                <div className="form-group">
                  <label>{l('Duur (min)', 'Duration (min)')}</label>
                  <input type="number" value={newEventSchedule.durationMinutes ?? 0} onChange={(e) => setNewEventSchedule({ ...newEventSchedule, durationMinutes: Number(e.target.value) })} />
                </div>
              </div>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleCreateEventSchedule} disabled={eventsLoading}>{l('Schema aanmaken', 'Create schedule')}</button>
              </div>
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{l('Start Live Event', 'Start Live Event')}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('Template', 'Template')}</label>
                  <select
                    value={newLiveEvent.templateId}
                    onChange={(e) => setNewLiveEvent({ ...newLiveEvent, templateId: Number(e.target.value) })}
                  >
                    <option value={0}>{l('Selecteer template', 'Select template')}</option>
                    {eventTemplates.map((template) => (
                      <option key={template.id} value={template.id}>{template.id} - {template.key}</option>
                    ))}
                  </select>
                </div>
                <div className="form-group">
                  <label>Status</label>
                  <select
                    value={newLiveEvent.status ?? 'active'}
                    onChange={(e) => setNewLiveEvent({ ...newLiveEvent, status: e.target.value })}
                  >
                    <option value="active">active</option>
                    <option value="scheduled">scheduled</option>
                    <option value="completed">completed</option>
                  </select>
                </div>
                <div className="form-group">
                  <label>{l('Start (ISO datetime, optioneel)', 'Start (ISO datetime, optional)')}</label>
                  <input value={newLiveEvent.startedAt ?? ''} onChange={(e) => setNewLiveEvent({ ...newLiveEvent, startedAt: e.target.value || null })} placeholder="2026-04-04T12:00:00.000Z" />
                </div>
                <div className="form-group">
                  <label>{l('Einde (ISO datetime, optioneel)', 'End (ISO datetime, optional)')}</label>
                  <input value={newLiveEvent.endsAt ?? ''} onChange={(e) => setNewLiveEvent({ ...newLiveEvent, endsAt: e.target.value || null })} placeholder="2026-04-04T12:45:00.000Z" />
                </div>
              </div>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleCreateLiveEvent} disabled={eventsLoading}>{l('Live event starten', 'Start live event')}</button>
              </div>
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{l('Templates', 'Templates')} ({eventTemplates.length})</h3>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Key</th>
                    <th>{l('Categorie', 'Category')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Titel NL', 'Title NL')}</th>
                    <th>{l('Titel EN', 'Title EN')}</th>
                    <th>{l('Actief', 'Active')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {eventTemplates.map((template) => (
                    <tr key={template.id}>
                      <td>{template.id}</td>
                      <td>
                        <input
                          type="text"
                          value={template.key}
                          onChange={(e) => updateEventTemplateField(template.id, 'key', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={template.category}
                          onChange={(e) => updateEventTemplateField(template.id, 'category', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={template.eventType}
                          onChange={(e) => updateEventTemplateField(template.id, 'eventType', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={template.titleNl}
                          onChange={(e) => updateEventTemplateField(template.id, 'titleNl', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={template.titleEn}
                          onChange={(e) => updateEventTemplateField(template.id, 'titleEn', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="checkbox"
                          checked={template.isActive}
                          onChange={(e) => updateEventTemplateField(template.id, 'isActive', e.target.checked)}
                        />
                      </td>
                      <td>
                        <button className="btn-small btn-success" onClick={() => handleSaveEventTemplate(template)} disabled={savingEventTemplateId === template.id}>
                          {savingEventTemplateId === template.id ? t.loading : t.save}
                        </button>
                        {' '}
                        <button className={`btn-small ${template.isActive ? 'btn-danger' : 'btn-success'}`} onClick={() => handleToggleTemplateActive(template)} disabled={savingEventTemplateId === template.id}>
                          {template.isActive ? l('Uit', 'Disable') : l('Aan', 'Enable')}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{l('Schema\'s', 'Schedules')} ({eventSchedules.length})</h3>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>{l('Template ID', 'Template ID')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Interval', 'Interval')}</th>
                    <th>{l('Duur', 'Duration')}</th>
                    <th>{l('Cooldown', 'Cooldown')}</th>
                    <th>{l('Gewicht', 'Weight')}</th>
                    <th>{l('Actief', 'Enabled')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {eventSchedules.map((schedule) => (
                    <tr key={schedule.id}>
                      <td>{schedule.id}</td>
                      <td>{schedule.templateId}</td>
                      <td>
                        <input
                          type="text"
                          value={schedule.scheduleType}
                          onChange={(e) => updateEventScheduleField(schedule.id, 'scheduleType', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={schedule.intervalMinutes ?? 0}
                          onChange={(e) => updateEventScheduleField(schedule.id, 'intervalMinutes', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={schedule.durationMinutes ?? 0}
                          onChange={(e) => updateEventScheduleField(schedule.id, 'durationMinutes', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={schedule.cooldownMinutes ?? 0}
                          onChange={(e) => updateEventScheduleField(schedule.id, 'cooldownMinutes', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={schedule.weight ?? 0}
                          onChange={(e) => updateEventScheduleField(schedule.id, 'weight', Number(e.target.value))}
                        />
                      </td>
                      <td>
                        <input
                          type="checkbox"
                          checked={schedule.enabled}
                          onChange={(e) => updateEventScheduleField(schedule.id, 'enabled', e.target.checked)}
                        />
                      </td>
                      <td>
                        <button className="btn-small btn-success" onClick={() => handleSaveEventSchedule(schedule)} disabled={savingEventScheduleId === schedule.id}>
                          {savingEventScheduleId === schedule.id ? t.loading : t.save}
                        </button>
                        {' '}
                        <button className={`btn-small ${schedule.enabled ? 'btn-danger' : 'btn-success'}`} onClick={() => handleToggleScheduleEnabled(schedule)} disabled={savingEventScheduleId === schedule.id}>
                          {schedule.enabled ? l('Uit', 'Disable') : l('Aan', 'Enable')}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="table-container">
              <h3>{l('Live Events', 'Live Events')} ({liveEvents.length})</h3>
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>{l('Template', 'Template')}</th>
                    <th>Status</th>
                    <th>{l('Start', 'Start')}</th>
                    <th>{l('Einde', 'End')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {liveEvents.map((liveEvent) => (
                    <tr key={liveEvent.id}>
                      <td>{liveEvent.id}</td>
                      <td>{liveEvent.template?.key ?? liveEvent.templateId}</td>
                      <td>
                        <select
                          value={liveEvent.status}
                          onChange={(e) => updateLiveEventField(liveEvent.id, 'status', e.target.value)}
                        >
                          <option value="active">active</option>
                          <option value="scheduled">scheduled</option>
                          <option value="completed">completed</option>
                          <option value="cancelled">cancelled</option>
                        </select>
                      </td>
                      <td>
                        <input
                          type="text"
                          value={liveEvent.startedAt ?? ''}
                          onChange={(e) => updateLiveEventField(liveEvent.id, 'startedAt', e.target.value || null)}
                          placeholder="2026-04-04T12:00:00.000Z"
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={liveEvent.endsAt ?? ''}
                          onChange={(e) => updateLiveEventField(liveEvent.id, 'endsAt', e.target.value || null)}
                          placeholder="2026-04-04T12:45:00.000Z"
                        />
                      </td>
                      <td>
                        <button className="btn-small btn-success" onClick={() => handleSaveLiveEvent(liveEvent)} disabled={savingLiveEventId === liveEvent.id}>
                          {savingLiveEventId === liveEvent.id ? t.loading : t.save}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </>
        )}

        {activeTab === 'audit-logs' && (
          <>
            <h1>{t.auditLogsTitle}</h1>
            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Beheerder', 'Admin')}</th>
                    <th>{l('Actie', 'Action')}</th>
                    <th>{l('Doel', 'Target')}</th>
                    <th>{l('IP Adres', 'IP Address')}</th>
                    <th>{l('Tijdstip', 'Timestamp')}</th>
                  </tr>
                </thead>
                <tbody>
                  {auditLogs.map(log => (
                    <tr key={log.id}>
                      <td>{log.id}</td>
                      <td>{log.admin.username} ({log.admin.role})</td>
                      <td><span className="action-badge">{log.action}</span></td>
                      <td>{log.targetType ? `${log.targetType} #${log.targetId}` : '-'}</td>
                      <td>{log.ipAddress || '-'}</td>
                      <td>{new Date(log.createdAt).toLocaleString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              <div className="pagination">
                <button 
                  disabled={auditPage === 1} 
                  onClick={() => setAuditPage(p => p - 1)}
                >
                  {t.previous}
                </button>
                <span>{tr(t.pageOf, { page: auditPage, total: auditTotalPages })}</span>
                <button 
                  disabled={auditPage === auditTotalPages} 
                  onClick={() => setAuditPage(p => p + 1)}
                >
                  {t.next}
                </button>
              </div>
            </div>
          </>
        )}

        {activeTab === 'system-logs' && (
          <>
            <h1>{l('Systeem Logs', 'System Logs')}</h1>
            <div className="search-bar" style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 2fr auto', gap: 10, marginBottom: 12 }}>
              <select
                value={systemLogDateFilter}
                onChange={(e) => setSystemLogDateFilter(e.target.value as DateRangeFilter)}
                className="search-input"
              >
                <option value="24h">{l('Laatste 24 uur', 'Last 24 hours')}</option>
                <option value="7d">{l('Laatste 7 dagen', 'Last 7 days')}</option>
                <option value="30d">{l('Laatste 30 dagen', 'Last 30 days')}</option>
                <option value="all">{l('Alles', 'All time')}</option>
              </select>
              <select
                value={systemLogSourceFilter}
                onChange={(e) => setSystemLogSourceFilter(e.target.value)}
                className="search-input"
              >
                <option value="all">{l('Alle bronnen', 'All sources')}</option>
                {systemLogSources.map((source) => (
                  <option key={source} value={source}>{source}</option>
                ))}
              </select>
              <input
                type="text"
                className="search-input"
                placeholder={l('Zoek in melding of details...', 'Search in message or details...')}
                value={systemLogSearchFilter}
                onChange={(e) => setSystemLogSearchFilter(e.target.value)}
              />
              <button type="button" className="btn-small" onClick={loadSystemLogs}>
                {t.refresh}
              </button>
            </div>
            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('ID', 'ID')}</th>
                    <th>{l('Bron', 'Source')}</th>
                    <th>{l('Melding', 'Message')}</th>
                    <th>{l('Details', 'Details')}</th>
                    <th>{l('Tijdstip', 'Timestamp')}</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredSystemLogs.map((log) => {
                    const source = log.params?.source || '-'
                    const message = log.params?.message || '-'
                    const details = log.params?.details || '-'

                    return (
                      <tr key={log.id}>
                        <td>{log.id}</td>
                        <td>{source}</td>
                        <td style={{ maxWidth: 600, whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>{message}</td>
                        <td style={{ maxWidth: 520, whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>{details}</td>
                        <td>{new Date(log.createdAt).toLocaleString()}</td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
              <div className="pagination">
                <button
                  disabled={systemLogPage === 1}
                  onClick={() => setSystemLogPage((p) => p - 1)}
                >
                  {t.previous}
                </button>
                <span>{tr(t.pageOf, { page: systemLogPage, total: systemLogTotalPages })}</span>
                <button
                  disabled={systemLogPage === systemLogTotalPages}
                  onClick={() => setSystemLogPage((p) => p + 1)}
                >
                  {t.next}
                </button>
              </div>
            </div>
          </>
        )}

        {activeTab === 'admins' && (
          <>
            <h1>{l('Admin Beheer', 'Admin Management')}</h1>

            <div className="card p-3 mb-3" style={{ background: '#151a22', border: '1px solid rgba(255,255,255,.08)' }}>
              <h3 style={{ marginBottom: 12 }}>{l('Nieuwe admin aanmaken', 'Create new admin')}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: '2fr 2fr 1fr auto', gap: 10 }}>
                <input
                  type="text"
                  placeholder={l('Gebruikersnaam', 'Username')}
                  value={newAdminForm.username}
                  onChange={(e) => setNewAdminForm((prev) => ({ ...prev, username: e.target.value }))}
                />
                <input
                  type="password"
                  placeholder={l('Wachtwoord', 'Password')}
                  value={newAdminForm.password}
                  onChange={(e) => setNewAdminForm((prev) => ({ ...prev, password: e.target.value }))}
                />
                <select
                  value={newAdminForm.role}
                  onChange={(e) =>
                    setNewAdminForm((prev) => ({
                      ...prev,
                      role: e.target.value as 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER',
                    }))
                  }
                >
                  <option value="VIEWER">VIEWER</option>
                  <option value="MODERATOR">MODERATOR</option>
                  <option value="SUPER_ADMIN">SUPER_ADMIN</option>
                </select>
                <button className="btn-small btn-success" onClick={handleCreateAdmin} disabled={isCreatingAdmin}>
                  {isCreatingAdmin ? t.creating : l('Aanmaken', 'Create')}
                </button>
              </div>
            </div>

            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>{l('Gebruikersnaam', 'Username')}</th>
                    <th>{l('Rol', 'Role')}</th>
                    <th>{l('Actief', 'Active')}</th>
                    <th>{l('Laatste login', 'Last login')}</th>
                    <th>{l('Acties', 'Actions')}</th>
                  </tr>
                </thead>
                <tbody>
                  {admins.map((admin) => (
                    <tr key={admin.id}>
                      <td>{admin.id}</td>
                      <td>{admin.username}</td>
                      <td>
                        <select
                          value={admin.role}
                          onChange={(e) =>
                            handleUpdateAdmin(admin, {
                              role: e.target.value as 'SUPER_ADMIN' | 'MODERATOR' | 'VIEWER',
                            })
                          }
                          disabled={savingAdminId === admin.id}
                        >
                          <option value="VIEWER">VIEWER</option>
                          <option value="MODERATOR">MODERATOR</option>
                          <option value="SUPER_ADMIN">SUPER_ADMIN</option>
                        </select>
                      </td>
                      <td>{admin.isActive ? t.yes : t.no}</td>
                      <td>{admin.lastLoginAt ? new Date(admin.lastLoginAt).toLocaleString() : '-'}</td>
                      <td>
                        <button
                          className={`btn-small ${admin.isActive ? 'btn-danger' : 'btn-success'}`}
                          disabled={savingAdminId === admin.id}
                          onClick={() => handleUpdateAdmin(admin, { isActive: !admin.isActive })}
                        >
                          {admin.isActive ? l('Deactiveer', 'Deactivate') : l('Activeer', 'Activate')}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>

              {adminsLoading && <p style={{ padding: 12 }}>{t.loading}</p>}
            </div>
          </>
        )}

        {activeTab === 'config' && (
          <>
            <h1>{t.configEditorTitle}</h1>
            <div className="config-warning">
              ⚠️ <strong>{t.warning}:</strong> {t.configRestartWarning}
            </div>
            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3 style={{ marginBottom: '0.5rem' }}>{t.prostitutionBalanceTitle}</h3>
              <p className="text-muted" style={{ marginBottom: '0.75rem' }}>{t.prostitutionBalanceDescription}</p>
              <div className="d-flex gap-2 align-items-center flex-wrap">
                <select
                  className="form-select"
                  style={{ maxWidth: 260 }}
                  value={selectedProstitutionBalanceProfile}
                  onChange={(e) => applyProstitutionBalanceProfile(e.target.value as ProstitutionBalanceProfile)}
                >
                  {PROSTITUTION_BALANCE_PROFILES.map((profile) => (
                    <option key={profile} value={profile}>{profile}</option>
                  ))}
                </select>
                <button
                  className="btn btn-sm btn-primary"
                  type="button"
                  onClick={() => applyProstitutionBalanceProfile(selectedProstitutionBalanceProfile)}
                >
                  {t.prostitutionBalanceApply}
                </button>
                <span className="badge bg-light text-body border">{PROSTITUTION_BALANCE_PROFILE_KEY}</span>
              </div>
            </div>
            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3 style={{ marginBottom: '0.5rem' }}>{t.vipHousingBonusTitle}</h3>
              <p className="text-muted" style={{ marginBottom: '0.75rem' }}>{t.vipHousingBonusDescription}</p>
              <div className="d-flex gap-2 align-items-center flex-wrap">
                <label className="fw-semibold" style={{ whiteSpace: 'nowrap' }}>
                  {t.vipHousingBonusLabel}:
                </label>
                <input
                  type="number"
                  min="0"
                  step="1"
                  className="form-control"
                  style={{ maxWidth: 120 }}
                  value={vipHousingBonusInput}
                  onChange={(e) => setVipHousingBonusInput(e.target.value)}
                />
                <span className="text-muted small">{t.vipHousingBonusHint}</span>
                <button
                  className="btn btn-sm btn-success"
                  type="button"
                  onClick={handleSaveVipHousingBonus}
                >
                  {t.vipHousingBonusSave}
                </button>
                <span className="badge bg-light text-body border">{VIP_HOUSING_BONUS_KEY}</span>
              </div>
              <p className="text-muted small mt-2">
                {t.vipHousingBonusCurrentValue}: <strong>{editingConfig[VIP_HOUSING_BONUS_KEY] ?? VIP_HOUSING_BONUS_DEFAULT}</strong>
              </p>
            </div>
            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3 style={{ marginBottom: '0.5rem' }}>{t.prostitutionHousingRentTitle}</h3>
              <p className="text-muted" style={{ marginBottom: '0.75rem' }}>{t.prostitutionHousingRentDescription}</p>
              <div className="d-flex gap-2 align-items-center flex-wrap">
                <label className="fw-semibold" style={{ whiteSpace: 'nowrap' }}>
                  {t.prostitutionHousingRentStandardLabel}:
                </label>
                <input
                  type="number"
                  min="0"
                  step="1"
                  className="form-control"
                  style={{ maxWidth: 120 }}
                  value={housingRentStandardInput}
                  onChange={(e) => setHousingRentStandardInput(e.target.value)}
                />
                <span className="badge bg-light text-body border">{HOUSING_RENT_STANDARD_KEY}</span>
              </div>
              <div className="d-flex gap-2 align-items-center flex-wrap mt-2">
                <label className="fw-semibold" style={{ whiteSpace: 'nowrap' }}>
                  {t.prostitutionHousingRentVipLabel}:
                </label>
                <input
                  type="number"
                  min="0"
                  step="1"
                  className="form-control"
                  style={{ maxWidth: 120 }}
                  value={housingRentVipInput}
                  onChange={(e) => setHousingRentVipInput(e.target.value)}
                />
                <span className="badge bg-light text-body border">{HOUSING_RENT_VIP_KEY}</span>
              </div>
              <div className="mt-2">
                <button
                  className="btn btn-sm btn-success"
                  type="button"
                  onClick={handleSaveHousingRent}
                >
                  {t.prostitutionHousingRentSave}
                </button>
              </div>
            </div>
            <div className="search-bar">
              <input 
                type="text" 
                placeholder={t.searchConfigKeys}
                value={configSearch}
                onChange={(e) => setConfigSearch(e.target.value)}
                className="search-input"
              />
            </div>
            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th style={{width: '30%'}}>{l('Sleutel', 'Key')}</th>
                    <th style={{width: '70%'}}>{l('Waarde', 'Value')}</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredConfig.map(([key]) => (
                    <tr key={key}>
                      <td><strong>{key}</strong></td>
                      <td>
                        <input 
                          type="text"
                          value={editingConfig[key] || ''}
                          onChange={(e) => setEditingConfig({...editingConfig, [key]: e.target.value})}
                          className="config-input"
                        />
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleSaveConfig}>
                  {t.saveChanges}
                </button>
                <button className="btn-small" onClick={loadConfig}>
                  {t.reset}
                </button>
              </div>
            </div>
          </>
        )}

        {activeTab === 'premium-offers' && (
          <>
            <h1>{t.premiumOffersTitle}</h1>
            <div className="config-warning">
              {l('💡 Pas hier live prijzen en aantallen aan voor Mollie one-time aankopen. Geen backend wijziging nodig.', '💡 Manage live prices and quantities for Mollie one-time purchases here. No backend change needed.')}
            </div>

            <div className="table-container" style={{ marginBottom: '1rem' }}>
              <h3>{l('Nieuwe aanbieding aanmaken', 'Create new offer')}</h3>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(5, minmax(120px, 1fr))', gap: '0.75rem' }}>
                <div className="form-group">
                  <label>{l('Sleutel', 'Key')}</label>
                  <input
                    type="text"
                    value={newPremiumOffer.key}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, key: e.target.value })}
                    placeholder="money_xl"
                  />
                </div>
                <div className="form-group">
                  <label>{l('NL titel', 'NL title')}</label>
                  <input
                    type="text"
                    value={newPremiumOffer.titleNl}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, titleNl: e.target.value })}
                  />
                </div>
                <div className="form-group">
                  <label>{l('EN titel', 'EN title')}</label>
                  <input
                    type="text"
                    value={newPremiumOffer.titleEn}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, titleEn: e.target.value })}
                  />
                </div>
                <div className="form-group">
                  <label>{l('Afbeelding URL', 'Image URL')}</label>
                  <input
                    type="text"
                    value={newPremiumOffer.imageUrl ?? ''}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, imageUrl: e.target.value })}
                    placeholder="https://.../offer.png"
                  />
                </div>
                <div className="form-group">
                  <label>{l('Prijs (cent)', 'Price (cents)')}</label>
                  <input
                    type="number"
                    min="1"
                    value={newPremiumOffer.priceEurCents}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, priceEurCents: parseInt(e.target.value || '0', 10) })}
                  />
                </div>
                <div className="form-group">
                  <label>{l('Type', 'Type')}</label>
                  <select
                    value={newPremiumOffer.rewardType}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, rewardType: e.target.value as 'money' | 'ammo' })}
                  >
                    <option value="money">{l('geld', 'money')}</option>
                    <option value="ammo">{l('munitie', 'ammo')}</option>
                  </select>
                </div>
                <div className="form-group">
                  <label>{l('Money hoeveelheid', 'Money amount')}</label>
                  <input
                    type="number"
                    min="0"
                    value={newPremiumOffer.moneyAmount ?? 0}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, moneyAmount: parseInt(e.target.value || '0', 10) })}
                  />
                </div>
                <div className="form-group">
                  <label>{l('Ammo type', 'Ammo type')}</label>
                  <input
                    type="text"
                    value={newPremiumOffer.ammoType ?? ''}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, ammoType: e.target.value })}
                    placeholder="9mm"
                  />
                </div>
                <div className="form-group">
                  <label>{l('Ammo aantal', 'Ammo qty')}</label>
                  <input
                    type="number"
                    min="0"
                    value={newPremiumOffer.ammoQuantity ?? 0}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, ammoQuantity: parseInt(e.target.value || '0', 10) })}
                  />
                </div>
                <div className="form-group">
                  <label>{l('Sortering', 'Sort')}</label>
                  <input
                    type="number"
                    min="0"
                    value={newPremiumOffer.sortOrder}
                    onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, sortOrder: parseInt(e.target.value || '0', 10) })}
                  />
                </div>
                <div className="form-group" style={{ alignSelf: 'end' }}>
                  <label>
                    <input
                      type="checkbox"
                      checked={newPremiumOffer.isActive}
                      onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, isActive: e.target.checked })}
                    />{' '}
                    {l('Actief', 'Active')}
                  </label>
                </div>
                <div className="form-group" style={{ alignSelf: 'end' }}>
                  <label>
                    <input
                      type="checkbox"
                      checked={newPremiumOffer.showPopupOnOpen}
                      onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, showPopupOnOpen: e.target.checked })}
                    />{' '}
                    {l('Popup bij game-open', 'Popup on game open')}
                  </label>
                </div>
                <div className="form-group" style={{ alignSelf: 'end' }}>
                  <label>
                    <input
                      type="checkbox"
                      checked={newPremiumOffer.notifyAllPlayers}
                      onChange={(e) => setNewPremiumOffer({ ...newPremiumOffer, notifyAllPlayers: e.target.checked })}
                    />{' '}
                    {l('Push naar alle spelers', 'Push to all players')}
                  </label>
                </div>
              </div>

              <div className="config-actions">
                <button className="btn-small btn-success" onClick={handleCreatePremiumOffer}>
                  {l('Nieuwe aanbieding toevoegen', 'Add new offer')}
                </button>
                <button
                  className="btn-small"
                  onClick={() =>
                    openPreview({
                      key: newPremiumOffer.key || 'preview_offer',
                      titleNl: newPremiumOffer.titleNl || 'Voorbeeld aanbieding',
                      titleEn: newPremiumOffer.titleEn || 'Preview offer',
                      imageUrl: newPremiumOffer.imageUrl,
                      priceEurCents: newPremiumOffer.priceEurCents,
                      rewardType: newPremiumOffer.rewardType,
                      moneyAmount: newPremiumOffer.moneyAmount,
                      ammoType: newPremiumOffer.ammoType,
                      ammoQuantity: newPremiumOffer.ammoQuantity,
                    })
                  }
                >
                  {l('Preview popup', 'Preview popup')}
                </button>
              </div>
            </div>

            <div className="config-actions" style={{ marginBottom: '1rem', display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
              <button className="btn-small" onClick={loadPremiumOffers} disabled={premiumOffersLoading}>
                {premiumOffersLoading ? t.loading : t.refresh}
              </button>
              <button
                className="btn-small"
                style={filterPopupOnly ? { background: 'var(--success)', color: 'white' } : {}}
                onClick={() => setFilterPopupOnly(!filterPopupOnly)}
              >
                {filterPopupOnly ? l('✓ Popup ON filter actief', '✓ Popup ON filter active') : l('Filter: alleen Popup ON', 'Filter: only Popup ON')}
              </button>
            </div>

            <div className="table-container">
              <table className="data-table">
                <thead>
                  <tr>
                    <th>{l('Sleutel', 'Key')}</th>
                    <th>{l('NL titel', 'NL title')}</th>
                    <th>{l('EN titel', 'EN title')}</th>
                    <th>{l('Afbeelding', 'Image')}</th>
                    <th>{l('Prijs (cent)', 'Price (cents)')}</th>
                    <th>{l('Type', 'Type')}</th>
                    <th>{l('Money hoeveelheid', 'Money amount')}</th>
                    <th>{l('Ammo type', 'Ammo type')}</th>
                    <th>{l('Ammo aantal', 'Ammo qty')}</th>
                    <th>{l('Actief', 'Active')}</th>
                    <th>{l('Popup', 'Popup')}</th>
                    <th>{l('Sortering', 'Sort')}</th>
                    <th>{l('Actie', 'Action')}</th>
                  </tr>
                </thead>
                <tbody>
                  {(filterPopupOnly ? premiumOffers.filter((o) => o.showPopupOnOpen) : premiumOffers).map((offer) => (
                    <tr key={offer.id}>
                      <td>
                        <strong>{offer.key}</strong>
                        {offer.showPopupOnOpen && (
                          <>
                            {' '}
                            <span className="action-badge">{l('Popup AAN', 'Popup ON')}</span>
                          </>
                        )}
                      </td>
                      <td>
                        <input
                          type="text"
                          value={offer.titleNl}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'titleNl', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={offer.titleEn}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'titleEn', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={offer.imageUrl ?? ''}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'imageUrl', e.target.value)}
                          placeholder="https://..."
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          min="1"
                          value={offer.priceEurCents}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'priceEurCents', parseInt(e.target.value || '0', 10))}
                        />
                      </td>
                      <td>
                        <select
                          value={offer.rewardType}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'rewardType', e.target.value as 'money' | 'ammo')}
                        >
                          <option value="money">{l('geld', 'money')}</option>
                          <option value="ammo">{l('munitie', 'ammo')}</option>
                        </select>
                      </td>
                      <td>
                        <input
                          type="number"
                          min="0"
                          value={offer.moneyAmount ?? 0}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'moneyAmount', parseInt(e.target.value || '0', 10))}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={offer.ammoType ?? ''}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'ammoType', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          min="0"
                          value={offer.ammoQuantity ?? 0}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'ammoQuantity', parseInt(e.target.value || '0', 10))}
                        />
                      </td>
                      <td>
                        <input
                          type="checkbox"
                          checked={offer.isActive}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'isActive', e.target.checked)}
                        />
                      </td>
                      <td>
                        <input
                          type="checkbox"
                          checked={offer.showPopupOnOpen}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'showPopupOnOpen', e.target.checked)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          min="0"
                          value={offer.sortOrder}
                          onChange={(e) => updatePremiumOfferField(offer.id, 'sortOrder', parseInt(e.target.value || '0', 10))}
                        />
                      </td>
                      <td>
                        <button className="btn-small btn-success" onClick={() => handleSavePremiumOffer(offer)}>
                          {t.save}
                        </button>
                        {' '}
                        <button className="btn-small" onClick={() => openPreview(offer)}>
                          {l('Preview', 'Preview')}
                        </button>
                        {' '}
                        <button className="btn-small btn-danger" onClick={() => handleDeletePremiumOffer(offer)}>
                          {t.delete}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {previewOffer && (
              <div className="modal-overlay" onClick={() => setPreviewOffer(null)}>
                <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
                  <h2>{previewOffer.titleNl || previewOffer.titleEn}</h2>
                  {previewOffer.imageUrl && (
                    <div style={{ marginBottom: '1rem' }}>
                      <img
                        src={previewOffer.imageUrl}
                        alt={previewOffer.titleEn || previewOffer.key}
                        style={{ width: '100%', maxHeight: 220, objectFit: 'cover', borderRadius: 8 }}
                      />
                    </div>
                  )}
                  <p><strong>{l('Prijs', 'Price')}:</strong> €{(previewOffer.priceEurCents / 100).toFixed(2)}</p>
                  <p>
                    <strong>{l('Beloning', 'Reward')}:</strong>{' '}
                    {previewOffer.rewardType === 'money'
                      ? `+€${previewOffer.moneyAmount ?? 0}`
                      : `${previewOffer.ammoType ?? '-'} x${previewOffer.ammoQuantity ?? 0}`}
                  </p>
                  <div className="modal-actions">
                    <button className="btn-small" onClick={() => setPreviewOffer(null)}>{t.close}</button>
                  </div>
                </div>
              </div>
            )}
          </>
        )}

        {activeTab === 'npcs' && (
          <>
            <h1>{t.npcManagementTitle}</h1>
            <div className="npc-header">
              <button className="btn-small btn-success" onClick={() => setCreatingNPC(true)}>
                + {t.createNpc}
              </button>
              <button className="btn-small" onClick={loadNPCs} disabled={npcLoading}>
                {npcLoading ? t.loading : `🔄 ${t.refresh}`}
              </button>
            </div>
            
            {npcs.length === 0 && !npcLoading && (
              <div style={{padding: '2rem', textAlign: 'center', color: 'var(--text-muted)'}}>
                {t.noNpcsFound}
              </div>
            )}

            {npcs.length > 0 && (
              <div className="table-container">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>{l('ID', 'ID')}</th>
                      <th>{l('Gebruikersnaam', 'Username')}</th>
                      <th>{l('Activiteitsniveau', 'Activity level')}</th>
                      <th>{l('Totaal misdaden', 'Total crimes')}</th>
                      <th>{l('Succesratio', 'Success rate')}</th>
                      <th>{l('Arrestaties', 'Arrests')}</th>
                      <th>{l('Geld verdiend', 'Money earned')}</th>
                      <th>{l('Rang', 'Rank')}</th>
                      <th>{l('Misdaden/uur', 'Crimes/hour')}</th>
                      <th>{t.actions}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {npcs.map(npc => (
                      <tr key={npc.id}>
                        <td>{npc.id}</td>
                        <td>{npc.username}</td>
                        <td>
                          <span className={`activity-badge activity-${npc.activityLevel.toLowerCase()}`}>
                            {npc.activityLevel}
                          </span>
                        </td>
                        <td>{npc.stats.totalCrimes}</td>
                        <td>
                          {npc.stats.totalCrimes > 0 
                            ? `${((npc.stats.successfulCrimes / npc.stats.totalCrimes) * 100).toFixed(1)}%`
                            : l('N.v.t.', 'N/A')
                          }
                        </td>
                        <td>{npc.stats.arrests}</td>
                        <td>${npc.stats.totalMoneyEarned.toLocaleString()}</td>
                        <td>{npc.npcPlayer.rank}</td>
                        <td>{npc.stats.crimesPerHour.toFixed(2)}</td>
                        <td>
                          <button className="btn-small btn-primary" onClick={() => handleViewNPCDetails(npc)}>
                            {t.details}
                          </button>
                          {' '}
                          <button className="btn-small" onClick={() => handleSimulateNPC(npc)} disabled={npcLoading}>
                            {t.simulate}
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}

            {/* Create NPC Modal */}
            {creatingNPC && (
              <div className="modal-overlay" onClick={() => setCreatingNPC(false)}>
                <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
                  <h2>{t.createNpcTitle}</h2>
                  <div className="form-group">
                    <label>{l('Gebruikersnaam', 'Username')} *</label>
                    <input 
                      type="text" 
                      value={newNPCUsername}
                      onChange={(e) => setNewNPCUsername(e.target.value)}
                      placeholder={l('Voer NPC gebruikersnaam in...', 'Enter NPC username...')}
                      disabled={npcLoading}
                    />
                  </div>
                  <div className="form-group">
                    <label>{t.activityLevel}</label>
                    <select 
                      value={newNPCActivityLevel}
                      onChange={(e) => setNewNPCActivityLevel(e.target.value)}
                      disabled={npcLoading}
                    >
                      <option value="MATIG">{l('MATIG (1-2 misdaden/uur)', 'MODERATE (1-2 crimes/hour)')}</option>
                      <option value="GEMIDDELD">{l('GEMIDDELD (3-5 misdaden/uur)', 'AVERAGE (3-5 crimes/hour)')}</option>
                      <option value="CONTINU">{l('CONTINU (10-20 misdaden/uur)', 'CONTINUOUS (10-20 crimes/hour)')}</option>
                    </select>
                  </div>
                  <div className="modal-actions">
                    <button className="btn-small btn-success" onClick={handleCreateNPC} disabled={npcLoading}>
                      {npcLoading ? t.creating : t.createNpc}
                    </button>
                    <button className="btn-small" onClick={() => setCreatingNPC(false)} disabled={npcLoading}>
                      {t.cancel}
                    </button>
                  </div>
                </div>
              </div>
            )}

            {/* Simulate NPC Modal */}
            {simulatingNPC && (
              <div className="modal-overlay" onClick={() => setSimulatingNPC(null)}>
                <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
                  <h2>{t.simulateNpcTitle}</h2>
                  <p>{l('Simuleer activiteit voor:', 'Simulate activity for:')} <strong>{simulatingNPC.username}</strong></p>
                  <div className="form-group">
                    <label>{t.hoursToSimulate} *</label>
                    <input 
                      type="number" 
                      min="0.1"
                      max="24"
                      step="0.5"
                      value={simulateHours}
                      onChange={(e) => setSimulateHours(e.target.value)}
                      placeholder={l('Voer uren in (max 24)...', 'Enter hours (max 24)...')}
                      disabled={npcLoading}
                    />
                    <small style={{color: 'var(--text-muted)', marginTop: '0.5rem', display: 'block'}}>
                      {l('Voer een waarde in tussen 0.1 en 24 uur', 'Enter a value between 0.1 and 24 hours')}
                    </small>
                  </div>
                  <div className="modal-actions">
                    <button className="btn-small btn-success" onClick={handleConfirmSimulate} disabled={npcLoading}>
                      {npcLoading ? t.loading : t.startSimulation}
                    </button>
                    <button className="btn-small" onClick={() => setSimulatingNPC(null)} disabled={npcLoading}>
                      {t.cancel}
                    </button>
                  </div>
                </div>
              </div>
            )}

            {/* NPC Details Modal */}
            {selectedNPC && (
              <div className="modal-overlay" onClick={() => setSelectedNPC(null)}>
                <div className="admin-modal admin-modal-large" onClick={(e) => e.stopPropagation()}>
                  <h2>{t.npcDetails}: {selectedNPC.username}</h2>
                  <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem'}}>
                    <div className="stat-card">
                      <h4>{t.playerInfo}</h4>
                      <p><strong>{l('Geld', 'Money')}:</strong> ${selectedNPC.npcPlayer.money.toLocaleString()}</p>
                      <p><strong>{l('Rang', 'Rank')}:</strong> {selectedNPC.npcPlayer.rank}</p>
                      <p><strong>{l('Gezondheid', 'Health')}:</strong> {selectedNPC.npcPlayer.health}%</p>
                      <p><strong>{l('Land', 'Country')}:</strong> {selectedNPC.npcPlayer.currentCountry}</p>
                      <p><strong>{l('Activiteit', 'Activity')}:</strong> {selectedNPC.activityLevel}</p>
                    </div>
                    <div className="stat-card">
                      <h4>{t.crimeStats}</h4>
                      <p><strong>{l('Totaal misdaden', 'Total crimes')}:</strong> {selectedNPC.stats.totalCrimes}</p>
                      <p><strong>{l('Gelukt', 'Successful')}:</strong> {selectedNPC.stats.successfulCrimes}</p>
                      <p><strong>{l('Mislukt', 'Failed')}:</strong> {selectedNPC.stats.failedCrimes}</p>
                      <p><strong>{l('Succesratio', 'Success rate')}:</strong> {selectedNPC.stats.totalCrimes > 0 ? `${((selectedNPC.stats.successfulCrimes / selectedNPC.stats.totalCrimes) * 100).toFixed(1)}%` : l('N.v.t.', 'N/A')}</p>
                      <p><strong>{l('Arrestaties', 'Arrests')}:</strong> {selectedNPC.stats.arrests}</p>
                    </div>
                    <div className="stat-card">
                      <h4>{t.jobStats}</h4>
                      <p><strong>{l('Totaal jobs', 'Total jobs')}:</strong> {selectedNPC.stats.totalJobs}</p>
                      <p><strong>{l('Jobs/uur', 'Jobs/hour')}:</strong> {selectedNPC.stats.jobsPerHour.toFixed(2)}</p>
                    </div>
                    <div className="stat-card">
                      <h4>{t.earningsPerformance}</h4>
                      <p><strong>{l('Geld verdiend', 'Money earned')}:</strong> ${selectedNPC.stats.totalMoneyEarned.toLocaleString()}</p>
                      <p><strong>{l('XP verdiend', 'XP earned')}:</strong> {selectedNPC.stats.totalXpEarned.toLocaleString()}</p>
                      <p><strong>{l('Geld/uur', 'Money/hour')}:</strong> ${selectedNPC.stats.moneyPerHour.toFixed(2)}</p>
                      <p><strong>{l('XP/uur', 'XP/hour')}:</strong> {selectedNPC.stats.xpPerHour.toFixed(2)}</p>
                    </div>
                    <div className="stat-card">
                      <h4>{t.otherStats}</h4>
                      <p><strong>{l('Misdaden/uur', 'Crimes/hour')}:</strong> {selectedNPC.stats.crimesPerHour.toFixed(2)}</p>
                      <p><strong>{l('Totale jailtijd', 'Total jail time')}:</strong> {selectedNPC.stats.totalJailTime} min</p>
                      <p><strong>{l('Aangemaakt', 'Created')}:</strong> {new Date(selectedNPC.createdAt).toLocaleString()}</p>
                    </div>
                  </div>
                  <div className="modal-actions">
                    <button className="btn-small" onClick={() => setSelectedNPC(null)}>
                      {t.close}
                    </button>
                  </div>
                </div>
              </div>
            )}
          </>
        )}
            </main>
          </div>
        </div>
      </div>
    </>
  )
}

export default App
