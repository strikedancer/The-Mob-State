import { useEffect, useMemo, useState } from 'react'
import { adminService, type AdminTerritoryOverview } from '../services/adminService'

type Props = {
  locale: 'nl' | 'en'
}

type TerritoryProgressionTuningForm = {
  hqRegionCapPerLevel: string
  hqRegionCapBonusCap: string
  hqContestCapPerLevel: string
  hqContestCapBonusCap: string
  hqActionPointBonusPerLevel: string
  hqActionPointBonusCap: string
  crewMissionActionPointBonusPerLevel: string
  crewMissionActionPointBonusCap: string
  weaponStorageDefenseBonusPerLevel: string
  ammoStorageDefenseBonusPerLevel: string
  carStorageRaidBonusPerLevel: string
  boatStorageSupplyBonusPerLevel: string
  drugStorageSabotageBonusPerLevel: string
  buildingActionBonusCap: string
  actionUnlockHqLevelPatrol: string
  actionUnlockHqLevelIntelScan: string
  actionUnlockHqLevelSabotage: string
  actionUnlockHqLevelSupplyRun: string
  actionUnlockHqLevelRaid: string
  actionUnlockHqLevelDefense: string
}

const tr = (locale: 'nl' | 'en', nl: string, en: string) => (locale === 'nl' ? nl : en)

const formatDate = (value: string | null, locale: 'nl' | 'en') => {
  if (!value) return '-'
  const parsed = new Date(value)
  if (Number.isNaN(parsed.getTime())) return value
  return parsed.toLocaleString(locale === 'nl' ? 'nl-NL' : 'en-GB')
}

export function TerritoryAdminPanel({ locale }: Props) {
  const [overview, setOverview] = useState<AdminTerritoryOverview | null>(null)
  const [loading, setLoading] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [selectedRegionKey, setSelectedRegionKey] = useState('')
  const [selectedCrewId, setSelectedCrewId] = useState('')
  const [selectedContestId, setSelectedContestId] = useState('')
  const [seasonKey, setSeasonKey] = useState('')
  const [seasonStartsAt, setSeasonStartsAt] = useState('')
  const [seasonEndsAt, setSeasonEndsAt] = useState('')
  const [progressionTuning, setProgressionTuning] = useState<TerritoryProgressionTuningForm>({
    hqRegionCapPerLevel: '0.2',
    hqRegionCapBonusCap: '3',
    hqContestCapPerLevel: '0.1',
    hqContestCapBonusCap: '2',
    hqActionPointBonusPerLevel: '0.12',
    hqActionPointBonusCap: '2',
    crewMissionActionPointBonusPerLevel: '0.1',
    crewMissionActionPointBonusCap: '2',
    weaponStorageDefenseBonusPerLevel: '0.18',
    ammoStorageDefenseBonusPerLevel: '0.16',
    carStorageRaidBonusPerLevel: '0.15',
    boatStorageSupplyBonusPerLevel: '0.15',
    drugStorageSabotageBonusPerLevel: '0.15',
    buildingActionBonusCap: '3',
    actionUnlockHqLevelPatrol: '0',
    actionUnlockHqLevelIntelScan: '2',
    actionUnlockHqLevelSabotage: '6',
    actionUnlockHqLevelSupplyRun: '2',
    actionUnlockHqLevelRaid: '8',
    actionUnlockHqLevelDefense: '4',
  })

  const loadOverview = async () => {
    try {
      setLoading(true)
      const nextOverview = await adminService.getTerritoryOverview()
      setOverview(nextOverview)
      setProgressionTuning({
        hqRegionCapPerLevel: String(nextOverview.config.hqRegionCapPerLevel ?? 0.2),
        hqRegionCapBonusCap: String(nextOverview.config.hqRegionCapBonusCap ?? 3),
        hqContestCapPerLevel: String(nextOverview.config.hqContestCapPerLevel ?? 0.1),
        hqContestCapBonusCap: String(nextOverview.config.hqContestCapBonusCap ?? 2),
        hqActionPointBonusPerLevel: String(nextOverview.config.hqActionPointBonusPerLevel ?? 0.12),
        hqActionPointBonusCap: String(nextOverview.config.hqActionPointBonusCap ?? 2),
        crewMissionActionPointBonusPerLevel: String(nextOverview.config.crewMissionActionPointBonusPerLevel ?? 0.1),
        crewMissionActionPointBonusCap: String(nextOverview.config.crewMissionActionPointBonusCap ?? 2),
        weaponStorageDefenseBonusPerLevel: String(nextOverview.config.weaponStorageDefenseBonusPerLevel ?? 0.18),
        ammoStorageDefenseBonusPerLevel: String(nextOverview.config.ammoStorageDefenseBonusPerLevel ?? 0.16),
        carStorageRaidBonusPerLevel: String(nextOverview.config.carStorageRaidBonusPerLevel ?? 0.15),
        boatStorageSupplyBonusPerLevel: String(nextOverview.config.boatStorageSupplyBonusPerLevel ?? 0.15),
        drugStorageSabotageBonusPerLevel: String(nextOverview.config.drugStorageSabotageBonusPerLevel ?? 0.15),
        buildingActionBonusCap: String(nextOverview.config.buildingActionBonusCap ?? 3),
        actionUnlockHqLevelPatrol: String(nextOverview.config.actionUnlockHqLevelPatrol ?? 0),
        actionUnlockHqLevelIntelScan: String(nextOverview.config.actionUnlockHqLevelIntelScan ?? 2),
        actionUnlockHqLevelSabotage: String(nextOverview.config.actionUnlockHqLevelSabotage ?? 6),
        actionUnlockHqLevelSupplyRun: String(nextOverview.config.actionUnlockHqLevelSupplyRun ?? 2),
        actionUnlockHqLevelRaid: String(nextOverview.config.actionUnlockHqLevelRaid ?? 8),
        actionUnlockHqLevelDefense: String(nextOverview.config.actionUnlockHqLevelDefense ?? 4),
      })

      if (!selectedRegionKey && nextOverview.regions.length > 0) {
        setSelectedRegionKey(nextOverview.regions[0].regionKey)
      }
      if (!selectedContestId && nextOverview.contests.length > 0) {
        const unresolvedContest = nextOverview.contests.find((contest) => !['resolved', 'cancelled'].includes(contest.status))
        setSelectedContestId(String(unresolvedContest?.id ?? nextOverview.contests[0].id))
      }
      if (!seasonKey && nextOverview.activeSeason?.seasonKey) {
        setSeasonKey(nextOverview.activeSeason.seasonKey)
      }
    } catch (error) {
      window.alert(`${tr(locale, 'Territory-overzicht laden mislukt', 'Failed to load territory overview')}: ${(error as Error).message}`)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void loadOverview()
  }, [])

  const selectedRegion = useMemo(
    () => overview?.regions.find((region) => region.regionKey === selectedRegionKey) ?? null,
    [overview, selectedRegionKey],
  )

  const selectableContests = useMemo(
    () => overview?.contests.filter((contest) => !['resolved', 'cancelled'].includes(contest.status)) ?? [],
    [overview],
  )

  const handleAssignRegion = async () => {
    if (!selectedRegionKey) {
      window.alert(tr(locale, 'Kies eerst een regio.', 'Select a region first.'))
      return
    }

    try {
      setSubmitting(true)
      await adminService.territoryAssignRegion(selectedRegionKey, selectedCrewId ? Number(selectedCrewId) : null)
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'Regio toewijzen mislukt', 'Failed to assign region')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  const handleResetRegion = async () => {
    if (!selectedRegionKey) {
      window.alert(tr(locale, 'Kies eerst een regio.', 'Select a region first.'))
      return
    }
    if (!window.confirm(tr(locale, `Reset regio ${selectedRegionKey}?`, `Reset region ${selectedRegionKey}?`))) {
      return
    }

    try {
      setSubmitting(true)
      await adminService.territoryResetRegion(selectedRegionKey)
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'Regio resetten mislukt', 'Failed to reset region')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  const handleResolveContest = async () => {
    const contestId = Number(selectedContestId)
    if (!contestId) {
      window.alert(tr(locale, 'Kies eerst een contest.', 'Select a contest first.'))
      return
    }

    try {
      setSubmitting(true)
      await adminService.territoryResolveContest(contestId)
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'Contest resolven mislukt', 'Failed to resolve contest')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  const handleStartSeason = async () => {
    if (!seasonKey.trim() || !seasonStartsAt || !seasonEndsAt) {
      window.alert(tr(locale, 'Vul season key, start en eindtijd in.', 'Provide season key, start and end time.'))
      return
    }

    try {
      setSubmitting(true)
      await adminService.territoryStartSeason({
        seasonKey: seasonKey.trim(),
        startsAt: new Date(seasonStartsAt).toISOString(),
        endsAt: new Date(seasonEndsAt).toISOString(),
      })
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'Seizoen starten mislukt', 'Failed to start season')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  const handleCloseSeason = async () => {
    const resolvedSeasonKey = overview?.activeSeason?.seasonKey ?? seasonKey
    if (!resolvedSeasonKey) {
      window.alert(tr(locale, 'Geen seizoen geselecteerd om te sluiten.', 'No season selected to close.'))
      return
    }

    try {
      setSubmitting(true)
      await adminService.territoryCloseSeason(resolvedSeasonKey)
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'Seizoen sluiten mislukt', 'Failed to close season')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  const handleSaveProgressionTuning = async () => {
    const numericEntries = Object.entries(progressionTuning).map(([key, value]) => ({
      key,
      value: Number.parseFloat(value),
    }))
    if (numericEntries.some((entry) => !Number.isFinite(entry.value) || entry.value < 0)) {
      window.alert(tr(locale, 'Vul alleen geldige positieve getallen in.', 'Use valid non-negative numbers only.'))
      return
    }

    const payload: Record<string, string> = {
      TERRITORY_HQ_REGION_CAP_PER_LEVEL: progressionTuning.hqRegionCapPerLevel,
      TERRITORY_HQ_REGION_CAP_BONUS_CAP: progressionTuning.hqRegionCapBonusCap,
      TERRITORY_HQ_CONTEST_CAP_PER_LEVEL: progressionTuning.hqContestCapPerLevel,
      TERRITORY_HQ_CONTEST_CAP_BONUS_CAP: progressionTuning.hqContestCapBonusCap,
      TERRITORY_HQ_ACTION_POINT_BONUS_PER_LEVEL: progressionTuning.hqActionPointBonusPerLevel,
      TERRITORY_HQ_ACTION_POINT_BONUS_CAP: progressionTuning.hqActionPointBonusCap,
      TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_PER_LEVEL: progressionTuning.crewMissionActionPointBonusPerLevel,
      TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_CAP: progressionTuning.crewMissionActionPointBonusCap,
      TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL: progressionTuning.weaponStorageDefenseBonusPerLevel,
      TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL: progressionTuning.ammoStorageDefenseBonusPerLevel,
      TERRITORY_CAR_STORAGE_RAID_BONUS_PER_LEVEL: progressionTuning.carStorageRaidBonusPerLevel,
      TERRITORY_BOAT_STORAGE_SUPPLY_BONUS_PER_LEVEL: progressionTuning.boatStorageSupplyBonusPerLevel,
      TERRITORY_DRUG_STORAGE_SABOTAGE_BONUS_PER_LEVEL: progressionTuning.drugStorageSabotageBonusPerLevel,
      TERRITORY_BUILDING_ACTION_BONUS_CAP: progressionTuning.buildingActionBonusCap,
      TERRITORY_ACTION_UNLOCK_HQ_LEVEL_PATROL: progressionTuning.actionUnlockHqLevelPatrol,
      TERRITORY_ACTION_UNLOCK_HQ_LEVEL_INTEL_SCAN: progressionTuning.actionUnlockHqLevelIntelScan,
      TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SABOTAGE: progressionTuning.actionUnlockHqLevelSabotage,
      TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SUPPLY_RUN: progressionTuning.actionUnlockHqLevelSupplyRun,
      TERRITORY_ACTION_UNLOCK_HQ_LEVEL_RAID: progressionTuning.actionUnlockHqLevelRaid,
      TERRITORY_ACTION_UNLOCK_HQ_LEVEL_DEFENSE: progressionTuning.actionUnlockHqLevelDefense,
    }

    try {
      setSubmitting(true)
      await adminService.updateConfig(payload)
      await loadOverview()
      window.alert(tr(locale, 'Territory progression tuning opgeslagen.', 'Territory progression tuning saved.'))
    } catch (error) {
      window.alert(`${tr(locale, 'Opslaan mislukt', 'Save failed')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="d-flex flex-column gap-3">
      <div className="d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
          <h1 className="mb-1">Territory</h1>
          <div className="config-warning mb-0">{tr(locale, 'Beheer Territory live: regio-eigendom, contests en seizoenen.', 'Manage Territory live: region ownership, contests, and seasons.')}</div>
        </div>
        <button type="button" className="btn btn-outline-secondary" onClick={() => void loadOverview()} disabled={loading || submitting}>
          <i className="ph-arrow-clockwise me-1" />{tr(locale, 'Ververs', 'Refresh')}
        </button>
      </div>

      <div className="row g-3">
        <div className="col-md-3"><div className="card h-100"><div className="card-body"><div className="text-muted small">{tr(locale, 'Landen actief', 'Active countries')}</div><div className="fw-bold fs-4">{overview?.summary.enabledCountries ?? 0}</div></div></div></div>
        <div className="col-md-3"><div className="card h-100"><div className="card-body"><div className="text-muted small">{tr(locale, 'Regio’s actief', 'Active regions')}</div><div className="fw-bold fs-4">{overview?.summary.enabledRegions ?? 0}</div></div></div></div>
        <div className="col-md-3"><div className="card h-100"><div className="card-body"><div className="text-muted small">{tr(locale, 'Actieve contests', 'Active contests')}</div><div className="fw-bold fs-4">{overview?.summary.activeContests ?? 0}</div></div></div></div>
        <div className="col-md-3"><div className="card h-100"><div className="card-body"><div className="text-muted small">{tr(locale, 'Gecontroleerde regio’s', 'Controlled regions')}</div><div className="fw-bold fs-4">{overview?.summary.controlledRegions ?? 0}</div></div></div></div>
      </div>

      <div className="card">
        <div className="card-header"><h5 className="mb-0">{tr(locale, 'Progression tuning', 'Progression tuning')}</h5></div>
        <div className="card-body">
          <div className="small text-muted mb-3">
            {tr(
              locale,
              'Koppel Territory-groei aan HQ, crew missielevel en bijgebouwen. Alle waarden zijn runtime en direct live.',
              'Couple Territory growth to HQ, crew mission level and side buildings. All values are runtime and apply live.',
            )}
          </div>
          <div className="row g-3">
            {[
              ['hqRegionCapPerLevel', 'HQ region cap +/level', 'HQ region cap +/level'],
              ['hqRegionCapBonusCap', 'HQ region cap bonus max', 'HQ region cap bonus cap'],
              ['hqContestCapPerLevel', 'HQ contest cap +/level', 'HQ contest cap +/level'],
              ['hqContestCapBonusCap', 'HQ contest cap bonus max', 'HQ contest cap bonus cap'],
              ['hqActionPointBonusPerLevel', 'HQ actiepunten +/level', 'HQ action points +/level'],
              ['hqActionPointBonusCap', 'HQ actiebonus max', 'HQ action bonus cap'],
              ['crewMissionActionPointBonusPerLevel', 'Crew missie +/level', 'Crew mission +/level'],
              ['crewMissionActionPointBonusCap', 'Crew missiebonus max', 'Crew mission bonus cap'],
              ['weaponStorageDefenseBonusPerLevel', 'Wapenopslag defense +/level', 'Weapon storage defense +/level'],
              ['ammoStorageDefenseBonusPerLevel', 'Munitieopslag defense +/level', 'Ammo storage defense +/level'],
              ['carStorageRaidBonusPerLevel', 'Auto-opslag raid +/level', 'Car storage raid +/level'],
              ['boatStorageSupplyBonusPerLevel', 'Bootopslag supply +/level', 'Boat storage supply +/level'],
              ['drugStorageSabotageBonusPerLevel', 'Drugsopslag sabotage +/level', 'Drug storage sabotage +/level'],
              ['buildingActionBonusCap', 'Bijgebouw bonus max', 'Building bonus cap'],
              ['actionUnlockHqLevelPatrol', 'Unlock patrol vanaf HQ', 'Unlock patrol from HQ'],
              ['actionUnlockHqLevelIntelScan', 'Unlock intel vanaf HQ', 'Unlock intel from HQ'],
              ['actionUnlockHqLevelSabotage', 'Unlock sabotage vanaf HQ', 'Unlock sabotage from HQ'],
              ['actionUnlockHqLevelSupplyRun', 'Unlock supply vanaf HQ', 'Unlock supply from HQ'],
              ['actionUnlockHqLevelRaid', 'Unlock raid vanaf HQ', 'Unlock raid from HQ'],
              ['actionUnlockHqLevelDefense', 'Unlock defense vanaf HQ', 'Unlock defense from HQ'],
            ].map(([key, nlLabel, enLabel]) => (
              <div className="col-md-6 col-xl-3" key={key}>
                <label className="form-label fw-semibold">{tr(locale, nlLabel, enLabel)}</label>
                <input
                  className="form-control"
                  value={progressionTuning[key as keyof TerritoryProgressionTuningForm]}
                  onChange={(event) => {
                    const value = event.target.value
                    const fieldKey = key as keyof TerritoryProgressionTuningForm
                    setProgressionTuning((current) => ({
                      ...current,
                      [fieldKey]: value,
                    }))
                  }}
                />
              </div>
            ))}
          </div>
          <div className="d-flex justify-content-end mt-3">
            <button
              type="button"
              className="btn btn-primary"
              disabled={loading || submitting}
              onClick={() => void handleSaveProgressionTuning()}
            >
              {tr(locale, 'Opslaan en live toepassen', 'Save and apply live')}
            </button>
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-header"><h5 className="mb-0">{tr(locale, 'Territory telemetry (24u)', 'Territory telemetry (24h)')}</h5></div>
        <div className="card-body d-flex flex-column gap-3">
          <div className="row g-3">
            <div className="col-md-3"><div className="border rounded p-2"><div className="small text-muted">{tr(locale, 'Cash/min', 'Cash/min')}</div><div className="fw-bold">{overview?.telemetry?.rewardPerMinute.cashPerMinute ?? 0}</div></div></div>
            <div className="col-md-3"><div className="border rounded p-2"><div className="small text-muted">{tr(locale, 'Rewards/min', 'Rewards/min')}</div><div className="fw-bold">{overview?.telemetry?.rewardPerMinute.rewardsPerMinute ?? 0}</div></div></div>
            <div className="col-md-3"><div className="border rounded p-2"><div className="small text-muted">{tr(locale, 'Totaal cash', 'Total cash')}</div><div className="fw-bold">{overview?.telemetry?.rewardPerMinute.totalCash ?? 0}</div></div></div>
            <div className="col-md-3"><div className="border rounded p-2"><div className="small text-muted">{tr(locale, 'Totaal rewards', 'Total rewards')}</div><div className="fw-bold">{overview?.telemetry?.rewardPerMinute.totalRewards ?? 0}</div></div></div>
          </div>

          <div className="row g-3">
            <div className="col-xl-6">
              <h6 className="mb-2">{tr(locale, 'Winrate per HQ-band', 'Winrate by HQ band')}</h6>
              <div className="table-responsive">
                <table className="table table-sm mb-0">
                  <thead><tr><th>{tr(locale, 'HQ band', 'HQ band')}</th><th>{tr(locale, 'Contests', 'Contests')}</th><th>{tr(locale, 'Wins', 'Wins')}</th><th>{tr(locale, 'Winrate', 'Winrate')}</th></tr></thead>
                  <tbody>
                    {(overview?.telemetry?.contestWinrateByHqBand ?? []).map((entry) => (
                      <tr key={entry.hqBand}>
                        <td>{entry.hqBand}</td><td>{entry.contests}</td><td>{entry.wins}</td><td>{entry.winratePercent}%</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
            <div className="col-xl-6">
              <h6 className="mb-2">{tr(locale, 'Region growth per crew-size', 'Region growth per crew-size')}</h6>
              <div className="table-responsive">
                <table className="table table-sm mb-0">
                  <thead><tr><th>{tr(locale, 'Crew size', 'Crew size')}</th><th>{tr(locale, 'Crews', 'Crews')}</th><th>{tr(locale, 'Captures', 'Captures')}</th><th>{tr(locale, 'Gemiddeld', 'Average')}</th></tr></thead>
                  <tbody>
                    {(overview?.telemetry?.regionGrowthByCrewSize ?? []).map((entry) => (
                      <tr key={entry.crewSizeBand}>
                        <td>{entry.crewSizeBand}</td><td>{entry.crews}</td><td>{entry.totalRegionsCaptured}</td><td>{entry.avgRegionsCaptured}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <div className="row g-3">
            <div className="col-xl-6">
              <h6 className="mb-2">{tr(locale, 'Bonus usage: HQ tier', 'Bonus usage: HQ tier')}</h6>
              <div className="table-responsive">
                <table className="table table-sm mb-0">
                  <thead><tr><th>{tr(locale, 'HQ band', 'HQ band')}</th><th>{tr(locale, 'Acties', 'Actions')}</th><th>{tr(locale, 'Bonus totaal', 'Bonus total')}</th><th>{tr(locale, 'Gem./actie', 'Avg/action')}</th></tr></thead>
                  <tbody>
                    {(overview?.telemetry?.bonusUsageByTier?.hqBand ?? []).map((entry) => (
                      <tr key={entry.hqBand}>
                        <td>{entry.hqBand}</td><td>{entry.actions}</td><td>{entry.totalBonusPoints}</td><td>{entry.avgBonusPoints}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
            <div className="col-xl-6">
              <h6 className="mb-2">{tr(locale, 'Bonus usage: building tier', 'Bonus usage: building tier')}</h6>
              <div className="table-responsive">
                <table className="table table-sm mb-0">
                  <thead><tr><th>{tr(locale, 'Building tier', 'Building tier')}</th><th>{tr(locale, 'Acties', 'Actions')}</th><th>{tr(locale, 'Bonus totaal', 'Bonus total')}</th><th>{tr(locale, 'Gem./actie', 'Avg/action')}</th></tr></thead>
                  <tbody>
                    {(overview?.telemetry?.bonusUsageByTier?.buildingTier ?? []).map((entry) => (
                      <tr key={entry.buildingTier}>
                        <td>{entry.buildingTier}</td><td>{entry.actions}</td><td>{entry.totalBonusPoints}</td><td>{entry.avgBonusPoints}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="row g-3">
        <div className="col-xl-4">
          <div className="card h-100">
            <div className="card-header"><h5 className="mb-0">{tr(locale, 'Regio moderation', 'Region moderation')}</h5></div>
            <div className="card-body d-flex flex-column gap-3">
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'Regio', 'Region')}</label>
                <select className="form-select" value={selectedRegionKey} onChange={(event) => setSelectedRegionKey(event.target.value)}>
                  <option value="">{tr(locale, 'Kies regio', 'Select region')}</option>
                  {(overview?.regions ?? []).map((region) => (
                    <option key={region.regionKey} value={region.regionKey}>{region.countryCode.toUpperCase()} · {region.nameNl}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'Owner crew', 'Owner crew')}</label>
                <select className="form-select" value={selectedCrewId} onChange={(event) => setSelectedCrewId(event.target.value)}>
                  <option value="">{tr(locale, 'Neutraal / geen owner', 'Neutral / no owner')}</option>
                  {(overview?.crews ?? []).map((crew) => (
                    <option key={crew.id} value={crew.id}>{crew.name} #{crew.id}</option>
                  ))}
                </select>
              </div>
              {selectedRegion && (
                <div className="small text-muted border rounded p-2 bg-light-subtle">
                  <div><strong>{tr(locale, 'Huidige owner', 'Current owner')}:</strong> {selectedRegion.ownerCrewName ?? tr(locale, 'Neutraal', 'Neutral')}</div>
                  <div><strong>SVG ID:</strong> {selectedRegion.svgElementId}</div>
                  <div><strong>{tr(locale, 'Stability', 'Stability')}:</strong> {selectedRegion.stability}</div>
                  <div><strong>{tr(locale, 'Actieve contest', 'Active contest')}:</strong> {selectedRegion.activeContestStatus ?? '-'}</div>
                </div>
              )}
              <div className="d-flex gap-2 flex-wrap">
                <button type="button" className="btn btn-primary" onClick={() => void handleAssignRegion()} disabled={submitting || loading}>{tr(locale, 'Toewijzen', 'Assign')}</button>
                <button type="button" className="btn btn-outline-danger" onClick={() => void handleResetRegion()} disabled={submitting || loading}>{tr(locale, 'Reset regio', 'Reset region')}</button>
              </div>
            </div>
          </div>
        </div>

        <div className="col-xl-4">
          <div className="card h-100">
            <div className="card-header"><h5 className="mb-0">{tr(locale, 'Contest moderation', 'Contest moderation')}</h5></div>
            <div className="card-body d-flex flex-column gap-3">
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'Open contest', 'Open contest')}</label>
                <select className="form-select" value={selectedContestId} onChange={(event) => setSelectedContestId(event.target.value)}>
                  <option value="">{tr(locale, 'Kies contest', 'Select contest')}</option>
                  {selectableContests.map((contest) => (
                    <option key={contest.id} value={contest.id}>#{contest.id} · {contest.regionNameNl} · {contest.status}</option>
                  ))}
                </select>
              </div>
              <div className="small text-muted border rounded p-2 bg-light-subtle">
                <div><strong>{tr(locale, 'Prep', 'Prep')}:</strong> {overview?.config.contestPrepMinutes ?? 0}m</div>
                <div><strong>{tr(locale, 'Actief', 'Active')}:</strong> {overview?.config.contestActiveMinutes ?? 0}m</div>
                <div><strong>{tr(locale, 'Lockdown', 'Lockdown')}:</strong> {overview?.config.contestLockdownMinutes ?? 0}m</div>
                <div><strong>{tr(locale, 'Capture threshold', 'Capture threshold')}:</strong> {overview?.config.captureThresholdPercent ?? 0}%</div>
              </div>
              <button type="button" className="btn btn-outline-primary" onClick={() => void handleResolveContest()} disabled={submitting || loading || selectableContests.length === 0}>{tr(locale, 'Resolve geselecteerde contest', 'Resolve selected contest')}</button>
            </div>
          </div>
        </div>

        <div className="col-xl-4">
          <div className="card h-100">
            <div className="card-header"><h5 className="mb-0">{tr(locale, 'Season control', 'Season control')}</h5></div>
            <div className="card-body d-flex flex-column gap-3">
              <div><label className="form-label fw-semibold">Season key</label><input className="form-control" value={seasonKey} onChange={(event) => setSeasonKey(event.target.value)} placeholder="2026-05" /></div>
              <div><label className="form-label fw-semibold">{tr(locale, 'Starttijd', 'Start time')}</label><input className="form-control" type="datetime-local" value={seasonStartsAt} onChange={(event) => setSeasonStartsAt(event.target.value)} /></div>
              <div><label className="form-label fw-semibold">{tr(locale, 'Eindtijd', 'End time')}</label><input className="form-control" type="datetime-local" value={seasonEndsAt} onChange={(event) => setSeasonEndsAt(event.target.value)} /></div>
              <div className="d-flex gap-2 flex-wrap">
                <button type="button" className="btn btn-success" onClick={() => void handleStartSeason()} disabled={submitting || loading}>{tr(locale, 'Start seizoen', 'Start season')}</button>
                <button type="button" className="btn btn-outline-danger" onClick={() => void handleCloseSeason()} disabled={submitting || loading || !overview?.activeSeason}>{tr(locale, 'Sluit actief seizoen', 'Close active season')}</button>
              </div>
              <div className="small text-muted border rounded p-2 bg-light-subtle">
                <div><strong>{tr(locale, 'Actief seizoen', 'Active season')}:</strong> {overview?.activeSeason?.seasonKey ?? '-'}</div>
                <div><strong>{tr(locale, 'Loopt van', 'Runs from')}:</strong> {formatDate(overview?.activeSeason?.startsAt ?? null, locale)}</div>
                <div><strong>{tr(locale, 'Tot', 'Until')}:</strong> {formatDate(overview?.activeSeason?.endsAt ?? null, locale)}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="row g-3">
        <div className="col-xl-7">
          <div className="card h-100">
            <div className="card-header"><h5 className="mb-0">{tr(locale, 'Recente contests', 'Recent contests')}</h5></div>
            <div className="table-responsive">
              <table className="table table-hover mb-0 align-middle">
                <thead>
                  <tr><th>#</th><th>{tr(locale, 'Regio', 'Region')}</th><th>{tr(locale, 'Status', 'Status')}</th><th>{tr(locale, 'Aanvaller', 'Attacker')}</th><th>{tr(locale, 'Verdediger', 'Defender')}</th><th>{tr(locale, 'Start', 'Start')}</th></tr>
                </thead>
                <tbody>
                  {(overview?.contests ?? []).map((contest) => (
                    <tr key={contest.id}>
                      <td>#{contest.id}</td>
                      <td>{contest.countryCode.toUpperCase()} · {contest.regionNameNl}</td>
                      <td><span className="badge bg-secondary-subtle text-dark">{contest.status}</span></td>
                      <td>{contest.attackerCrewName ?? `#${contest.attackerCrewId}`}</td>
                      <td>{contest.defenderCrewName ?? tr(locale, 'Neutraal', 'Neutral')}</td>
                      <td>{formatDate(contest.startedAt, locale)}</td>
                    </tr>
                  ))}
                  {!loading && (overview?.contests.length ?? 0) === 0 && <tr><td colSpan={6} className="text-center text-muted py-4">{tr(locale, 'Nog geen contests.', 'No contests yet.')}</td></tr>}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div className="col-xl-5">
          <div className="card h-100">
            <div className="card-header"><h5 className="mb-0">{tr(locale, 'Territory leaderboard', 'Territory leaderboard')}</h5></div>
            <div className="table-responsive">
              <table className="table table-sm table-hover mb-0">
                <thead><tr><th>#</th><th>{tr(locale, 'Crew', 'Crew')}</th><th>{tr(locale, 'Regio’s', 'Regions')}</th></tr></thead>
                <tbody>
                  {(overview?.leaderboard ?? []).map((entry, index) => (
                    <tr key={entry.crewId}><td>{index + 1}</td><td>{entry.crewName}</td><td>{entry.regionsOwned}</td></tr>
                  ))}
                  {!loading && (overview?.leaderboard.length ?? 0) === 0 && <tr><td colSpan={3} className="text-center text-muted py-4">{tr(locale, 'Nog geen owners.', 'No owners yet.')}</td></tr>}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
