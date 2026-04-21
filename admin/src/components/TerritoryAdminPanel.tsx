import { useEffect, useMemo, useState } from 'react'
import { adminService, type AdminTerritoryOverview } from '../services/adminService'

type Props = {
  locale: 'nl' | 'en'
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

  const loadOverview = async () => {
    try {
      setLoading(true)
      const nextOverview = await adminService.getTerritoryOverview()
      setOverview(nextOverview)

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