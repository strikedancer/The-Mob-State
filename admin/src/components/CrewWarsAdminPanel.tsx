import { useEffect, useState } from 'react'
import { adminService, type AdminCrewWarOverview } from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'

type Props = {
  locale: AdminLanguage
}

const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en)

export function CrewWarsAdminPanel({ locale }: Props) {
  const [overview, setOverview] = useState<AdminCrewWarOverview | null>(null)
  const [loading, setLoading] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [form, setForm] = useState({
    attackerCrewId: '',
    defenderCrewId: '',
    warType: 'kill_war' as 'kill_war' | 'economy_war' | 'territory_war' | 'total_war',
    startsInMinutes: '15',
  })

  const loadOverview = async () => {
    try {
      setLoading(true)
      const response = await adminService.getCrewWarsOverview()
      setOverview(response)
    } catch (error) {
      window.alert(`${tr(locale, 'Crew-oorlogen laden mislukt', 'Failed to load crew wars')}: ${(error as Error).message}`)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void loadOverview()
  }, [])

  const handleDeclare = async () => {
    const attackerCrewId = Number(form.attackerCrewId)
    const defenderCrewId = Number(form.defenderCrewId)
    const startsInMinutes = Number(form.startsInMinutes)

    if (!attackerCrewId || !defenderCrewId || attackerCrewId === defenderCrewId) {
      window.alert(tr(locale, 'Kies twee verschillende crews.', 'Choose two different crews.'))
      return
    }

    try {
      setSubmitting(true)
      await adminService.declareCrewWar({
        attackerCrewId,
        defenderCrewId,
        warType: form.warType,
        startsInMinutes,
      })
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'Oorlog declareren mislukt', 'Failed to declare war')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  const handleStatusAction = async (warId: number, action: 'start_now' | 'enter_lockdown' | 'resolve' | 'archive' | 'cancel') => {
    try {
      setSubmitting(true)
      await adminService.updateCrewWarStatus(warId, action)
      await loadOverview()
    } catch (error) {
      window.alert(`${tr(locale, 'War status wijzigen mislukt', 'Failed to update war status')}: ${(error as Error).message}`)
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="d-flex flex-column gap-3">
      <div className="row g-3">
        <div className="col-lg-4">
          <div className="card h-100">
            <div className="card-header d-flex justify-content-between align-items-center">
              <h5 className="mb-0">{tr(locale, 'Oorlog declareren', 'Declare war')}</h5>
              <button type="button" className="btn btn-sm btn-outline-secondary" onClick={() => void loadOverview()} disabled={loading || submitting}>
                <i className="ph-arrow-clockwise me-1" />{tr(locale, 'Ververs', 'Refresh')}
              </button>
            </div>
            <div className="card-body d-flex flex-column gap-3">
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'Aanvallende crew', 'Attacking crew')}</label>
                <select className="form-select" value={form.attackerCrewId} onChange={(e) => setForm((current) => ({ ...current, attackerCrewId: e.target.value }))}>
                  <option value="">{tr(locale, 'Kies crew', 'Select crew')}</option>
                  {(overview?.crews || []).map((crew) => (
                    <option key={crew.id} value={crew.id}>{crew.name} #{crew.id}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'Verdedigende crew', 'Defending crew')}</label>
                <select className="form-select" value={form.defenderCrewId} onChange={(e) => setForm((current) => ({ ...current, defenderCrewId: e.target.value }))}>
                  <option value="">{tr(locale, 'Kies crew', 'Select crew')}</option>
                  {(overview?.crews || []).map((crew) => (
                    <option key={crew.id} value={crew.id}>{crew.name} #{crew.id}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'War type', 'War type')}</label>
                <select className="form-select" value={form.warType} onChange={(e) => setForm((current) => ({ ...current, warType: e.target.value as typeof current.warType }))}>
                  <option value="kill_war">Kill War</option>
                  <option value="economy_war">Economy War</option>
                  <option value="territory_war">Territory War</option>
                  <option value="total_war">Total War</option>
                </select>
              </div>
              <div>
                <label className="form-label fw-semibold">{tr(locale, 'Start over minuten', 'Start in minutes')}</label>
                <input className="form-control" type="number" min={1} max={60} value={form.startsInMinutes} onChange={(e) => setForm((current) => ({ ...current, startsInMinutes: e.target.value }))} />
              </div>
              <button type="button" className="btn btn-danger" onClick={handleDeclare} disabled={submitting || loading}>
                {submitting ? tr(locale, 'Bezig...', 'Working...') : tr(locale, 'Declareer oorlog', 'Declare war')}
              </button>
            </div>
          </div>
        </div>

        <div className="col-lg-8">
          <div className="row g-3">
            <div className="col-md-4">
              <div className="card h-100">
                <div className="card-body">
                  <div className="text-muted small">{tr(locale, 'Actief seizoen', 'Active season')}</div>
                  <div className="fw-bold fs-5">{overview?.season.seasonKey || '-'}</div>
                  <div className="small text-muted mt-1">{overview?.season.status || '-'}</div>
                </div>
              </div>
            </div>
            <div className="col-md-4">
              <div className="card h-100">
                <div className="card-body">
                  <div className="text-muted small">{tr(locale, 'Open wars', 'Open wars')}</div>
                  <div className="fw-bold fs-5">{overview?.activeWars.length || 0}</div>
                </div>
              </div>
            </div>
            <div className="col-md-4">
              <div className="card h-100">
                <div className="card-body">
                  <div className="text-muted small">{tr(locale, 'Geblokkeerde acties', 'Blocked actions')}</div>
                  <div className="fw-bold fs-5">{overview?.flaggedActions || 0}</div>
                </div>
              </div>
            </div>
          </div>

          <div className="card mt-3">
            <div className="card-header">
              <h5 className="mb-0">{tr(locale, 'Seizoensleaderboard', 'Season leaderboard')}</h5>
            </div>
            <div className="table-responsive">
              <table className="table table-hover mb-0">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>{tr(locale, 'Crew', 'Crew')}</th>
                    <th>{tr(locale, 'Punten', 'Points')}</th>
                    <th>{tr(locale, 'Kills', 'Kills')}</th>
                    <th>{tr(locale, 'Loot', 'Loot')}</th>
                  </tr>
                </thead>
                <tbody>
                  {(overview?.seasonLeaderboard || []).map((entry) => (
                    <tr key={entry.crewId}>
                      <td>{entry.rank}</td>
                      <td>{entry.crew?.name || `#${entry.crewId}`}</td>
                      <td>{entry.totalPoints}</td>
                      <td>{entry.totalKills}</td>
                      <td>€{entry.totalLoot.toLocaleString()}</td>
                    </tr>
                  ))}
                  {!loading && (overview?.seasonLeaderboard.length || 0) === 0 && (
                    <tr><td colSpan={5} className="text-center text-muted py-4">{tr(locale, 'Nog geen seizoensdata.', 'No season data yet.')}</td></tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <div className="card">
        <div className="card-header">
          <h5 className="mb-0">{tr(locale, 'Actieve wars', 'Active wars')}</h5>
        </div>
        <div className="card-body d-flex flex-column gap-3">
          {(overview?.activeWars || []).map((war) => (
            <div key={war.id} className="border rounded p-3">
              <div className="d-flex flex-wrap justify-content-between gap-2 align-items-start">
                <div>
                  <div className="fw-semibold">#{war.id} · {war.attackerCrew?.name || `#${war.attackerCrewId}`} vs {war.defenderCrew?.name || `#${war.defenderCrewId}`}</div>
                  <div className="text-muted small">{war.warType} · {war.status} · {new Date(war.activeFrom).toLocaleString()}</div>
                </div>
                <div className="d-flex gap-2 flex-wrap">
                  <button type="button" className="btn btn-sm btn-outline-success" onClick={() => void handleStatusAction(war.id, 'start_now')} disabled={submitting}>{tr(locale, 'Start nu', 'Start now')}</button>
                  <button type="button" className="btn btn-sm btn-outline-warning" onClick={() => void handleStatusAction(war.id, 'enter_lockdown')} disabled={submitting}>{tr(locale, 'Lockdown', 'Lockdown')}</button>
                  <button type="button" className="btn btn-sm btn-outline-primary" onClick={() => void handleStatusAction(war.id, 'resolve')} disabled={submitting}>{tr(locale, 'Resolve', 'Resolve')}</button>
                  <button type="button" className="btn btn-sm btn-outline-secondary" onClick={() => void handleStatusAction(war.id, 'archive')} disabled={submitting}>{tr(locale, 'Archiveer', 'Archive')}</button>
                  <button type="button" className="btn btn-sm btn-outline-danger" onClick={() => void handleStatusAction(war.id, 'cancel')} disabled={submitting}>{tr(locale, 'Annuleer', 'Cancel')}</button>
                </div>
              </div>
              <div className="table-responsive mt-3">
                <table className="table table-sm mb-0">
                  <thead>
                    <tr>
                      <th>{tr(locale, 'Crew', 'Crew')}</th>
                      <th>{tr(locale, 'Punten', 'Points')}</th>
                      <th>{tr(locale, 'Kills', 'Kills')}</th>
                      <th>{tr(locale, 'Deaths', 'Deaths')}</th>
                      <th>{tr(locale, 'Loot', 'Loot')}</th>
                      <th>{tr(locale, 'Gebieden', 'Territories')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {war.standings.map((standing) => (
                      <tr key={`${war.id}-${standing.crewId}`}>
                        <td>{standing.crew?.name || `#${standing.crewId}`}</td>
                        <td>{standing.totalPoints}</td>
                        <td>{standing.totalKills}</td>
                        <td>{standing.totalDeaths}</td>
                        <td>€{standing.totalLoot.toLocaleString()}</td>
                        <td>{standing.territoriesHeld}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          ))}

          {!loading && (overview?.activeWars.length || 0) === 0 && (
            <div className="text-muted text-center py-4">{tr(locale, 'Geen actieve wars.', 'No active wars.')}</div>
          )}
        </div>
      </div>
    </div>
  )
}