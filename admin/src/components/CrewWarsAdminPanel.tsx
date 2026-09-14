import { useEffect, useMemo, useState } from 'react'
import {
  adminService,
  type AdminCrewWarOverview,
  type CrewWarRuntimeConfigView,
} from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'
import {
  AdminPageIntro,
  RuntimeField,
  RuntimeKpi,
  RuntimeKpiGrid,
  RuntimeToolbar,
  isInvalidAmount,
  runtimeValueFor,
  type FieldKind,
} from './adminChrome'

type Props = {
  locale: AdminLanguage
}

const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en)

const WAR_RUNTIME_FIELDS: Array<{
  key: string
  kind: FieldKind
  labelNl: string
  labelEn: string
  helpNl: string
  helpEn: string
}> = [
  {
    key: 'CREW_WAR_MIN_MEMBERS',
    kind: 'int',
    labelNl: 'Minimum leden',
    labelEn: 'Minimum members',
    helpNl: 'Beide crews moeten dit aantal leden hebben om een oorlog te starten. 1–20. Nu 1 zolang er weinig spelers zijn; later kun je dit weer op 3 zetten.',
    helpEn: 'Both crews need this many members to start a war. 1–20. Use 1 while the player count is low; raise it to 3 later.',
  },
  {
    key: 'CREW_WAR_PREPARATION_MINUTES',
    kind: 'minutes',
    labelNl: 'Voorbereiding',
    labelEn: 'Preparation',
    helpNl: 'Minuten tussen declareren en de eerste aanvallen. 1–180.',
    helpEn: 'Minutes between declare and the first attacks. 1–180.',
  },
  {
    key: 'CREW_WAR_ACTIVE_HOURS',
    kind: 'hours',
    labelNl: 'Actieve duur',
    labelEn: 'Active duration',
    helpNl: 'Uren dat de war actief is (inclusief lockdown). 1–72.',
    helpEn: 'Hours the war stays active (including lockdown). 1–72.',
  },
  {
    key: 'CREW_WAR_LOCKDOWN_MINUTES',
    kind: 'minutes',
    labelNl: 'Lockdown',
    labelEn: 'Lockdown',
    helpNl: 'Laatste minuten zonder nieuwe aanvallen. 1–180, korter dan de actieve duur.',
    helpEn: 'Final minutes without new attacks. 1–180, shorter than the active duration.',
  },
  {
    key: 'CREW_WAR_COOLDOWN_HOURS',
    kind: 'hours',
    labelNl: 'Cooldown na war',
    labelEn: 'Cooldown after war',
    helpNl: 'Uren voordat dezelfde crews weer kunnen vechten. 0–72.',
    helpEn: 'Hours before the same crews can fight again. 0–72.',
  },
]

function valuesFromView(view: CrewWarRuntimeConfigView) {
  return Object.fromEntries(
    WAR_RUNTIME_FIELDS.map((field) => [field.key, runtimeValueFor(view, field.key)]),
  )
}

export function CrewWarsAdminPanel({ locale }: Props) {
  const [overview, setOverview] = useState<AdminCrewWarOverview | null>(null)
  const [runtimeView, setRuntimeView] = useState<CrewWarRuntimeConfigView | null>(null)
  const [runtimeValues, setRuntimeValues] = useState<Record<string, string>>({})
  const [loading, setLoading] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [savingRuntime, setSavingRuntime] = useState(false)
  const [runtimeMessage, setRuntimeMessage] = useState<string | null>(null)
  const [runtimeError, setRuntimeError] = useState<string | null>(null)
  const [form, setForm] = useState({
    attackerCrewId: '',
    defenderCrewId: '',
    warType: 'kill_war' as 'kill_war' | 'economy_war' | 'territory_war' | 'total_war',
    startsInMinutes: '15',
  })

  const loadOverview = async () => {
    try {
      setLoading(true)
      const [response, config] = await Promise.all([
        adminService.getCrewWarsOverview(),
        adminService.getCrewWarRuntimeConfig(),
      ])
      setOverview(response)
      setRuntimeView(config)
      setRuntimeValues(valuesFromView(config))
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

  const dirtyCount = useMemo(() => {
    if (!runtimeView) return 0
    return WAR_RUNTIME_FIELDS.filter(
      (field) => (runtimeValues[field.key] ?? '') !== runtimeValueFor(runtimeView, field.key),
    ).length
  }, [runtimeValues, runtimeView])

  const saveRuntime = async () => {
    if (WAR_RUNTIME_FIELDS.some((field) => isInvalidAmount(runtimeValues[field.key] ?? ''))) {
      setRuntimeError(tr(locale, 'Corrigeer ongeldige waarden voor je opslaat.', 'Fix invalid values before saving.'))
      return
    }
    try {
      setSavingRuntime(true)
      setRuntimeError(null)
      setRuntimeMessage(null)
      const updated = await adminService.updateCrewWarRuntimeConfig(runtimeValues)
      setRuntimeView(updated)
      setRuntimeValues(valuesFromView(updated))
      setRuntimeMessage(tr(locale, 'Crew War-instellingen opgeslagen. Gelden meteen voor nieuwe oorlogen.', 'Crew War settings saved. They apply immediately to new wars.'))
    } catch (error) {
      setRuntimeError(tr(locale, 'Opslaan mislukt (check de bereiken).', 'Save failed (check the ranges).'))
      console.error(error)
    } finally {
      setSavingRuntime(false)
    }
  }

  return (
    <div className="d-flex flex-column gap-3">
      <AdminPageIntro
        kicker={tr(locale, 'Crew · oorlogen', 'Crew · wars')}
        description={tr(
          locale,
          'Declareer oorlogen, volg seizoensstanden en moderatie. Wijzigingen zijn live.',
          'Declare wars, track season standings and moderation. Changes apply live.',
        )}
      />
      <RuntimeKpiGrid>
        <RuntimeKpi
          label={tr(locale, 'Actief seizoen', 'Active season')}
          value={overview?.season.seasonKey || '-'}
          hint={overview?.season.status || undefined}
        />
        <RuntimeKpi
          label={tr(locale, 'Open wars', 'Open wars')}
          value={String(overview?.activeWars.length || 0)}
        />
        <RuntimeKpi
          label={tr(locale, 'Min. leden', 'Min. members')}
          value={runtimeValueFor(runtimeView, 'CREW_WAR_MIN_MEMBERS') || '-'}
          hint={tr(locale, 'Live drempel om te declareren', 'Live declare threshold')}
        />
        <RuntimeKpi
          label={tr(locale, 'Geblokkeerde acties', 'Blocked actions')}
          value={String(overview?.flaggedActions || 0)}
        />
      </RuntimeKpiGrid>
      {runtimeError && <div className="alert alert-danger">{runtimeError}</div>}
      {runtimeMessage && <div className="alert alert-success">{runtimeMessage}</div>}
      <RuntimeToolbar
        locale={locale}
        loading={loading}
        saving={savingRuntime}
        dirtyCount={dirtyCount}
        disabled={!runtimeView}
        onRefresh={() => void loadOverview()}
        onDiscard={() => runtimeView && setRuntimeValues(valuesFromView(runtimeView))}
        onSave={() => void saveRuntime()}
      />
      <div className="card">
        <div className="card-header d-flex align-items-start gap-3">
          <i className="ph-flag runtime-section-icon fs-4" />
          <div>
            <h2 className="h5 mb-1">{tr(locale, 'War-instellingen', 'War settings')}</h2>
            <p className="text-muted small mb-0">
              {tr(
                locale,
                'Geldt voor nieuwe oorlogen in de War Room. Leden-minimum 1 is bedoeld voor een kleine startpopulatie.',
                'Applies to new wars in the War Room. A member minimum of 1 is for a small launch population.',
              )}
            </p>
          </div>
        </div>
        <div className="card-body">
          <div className="row g-3">
            {WAR_RUNTIME_FIELDS.map((field) => (
              <div className="col-md-6 col-xl-4" key={field.key}>
                <RuntimeField
                  locale={locale}
                  label={tr(locale, field.labelNl, field.labelEn)}
                  help={tr(locale, field.helpNl, field.helpEn)}
                  fieldKey={field.key}
                  kind={field.kind}
                  value={runtimeValues[field.key] ?? ''}
                  saved={runtimeValueFor(runtimeView, field.key)}
                  fallback={runtimeView?.defaults[field.key] ?? ''}
                  disabled={savingRuntime || loading || !runtimeView}
                  onChange={(next) =>
                    setRuntimeValues((current) => ({ ...current, [field.key]: next }))
                  }
                  onReset={() =>
                    setRuntimeValues((current) => ({
                      ...current,
                      [field.key]: runtimeView?.defaults[field.key] ?? '',
                    }))
                  }
                />
              </div>
            ))}
          </div>
        </div>
      </div>
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
                <input className="form-control" type="number" min={1} max={180} value={form.startsInMinutes} onChange={(e) => setForm((current) => ({ ...current, startsInMinutes: e.target.value }))} />
              </div>
              <button type="button" className="btn btn-danger" onClick={handleDeclare} disabled={submitting || loading}>
                {submitting ? tr(locale, 'Bezig...', 'Working...') : tr(locale, 'Declareer oorlog', 'Declare war')}
              </button>
            </div>
          </div>
        </div>

        <div className="col-lg-8">
          <div className="card">
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