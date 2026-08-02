import { useEffect, useMemo, useState } from 'react'
import {
  adminService,
  type CrewMissionRuntimeConfigView,
} from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'

type Props = {
  locale: AdminLanguage
}

const CLEARING_HOUSE_KEY = 'CREW_MISSION_CLEARING_HOUSE_MIN_MISSION_LEVEL'
const PHASE2_ON_LEVEL = 3

const OTHER_KEYS: Array<{ key: string; labelNl: string; labelEn: string; hintNl: string; hintEn: string }> = [
  {
    key: 'CREW_MISSION_T1_CREDITS_PER_MINUTE',
    labelNl: 'T1 credits / minuut',
    labelEn: 'T1 credits / minute',
    hintNl: '1–20',
    hintEn: '1–20',
  },
  {
    key: 'CREW_MISSION_T2_CREDITS_PER_MINUTE',
    labelNl: 'T2 credits / minuut',
    labelEn: 'T2 credits / minute',
    hintNl: '1–20',
    hintEn: '1–20',
  },
  {
    key: 'CREW_MISSION_T3_CREDITS_PER_MINUTE',
    labelNl: 'T3 credits / minuut',
    labelEn: 'T3 credits / minute',
    hintNl: '1–20',
    hintEn: '1–20',
  },
  {
    key: 'CREW_MISSION_REPEAT_WINDOW_MINUTES',
    labelNl: 'Repeat-venster (min)',
    labelEn: 'Repeat window (min)',
    hintNl: '15–360',
    hintEn: '15–360',
  },
  {
    key: 'CREW_MISSION_REPEAT_2_MULTIPLIER',
    labelNl: 'Repeat ×2 multiplier',
    labelEn: 'Repeat ×2 multiplier',
    hintNl: '0.5–1',
    hintEn: '0.5–1',
  },
  {
    key: 'CREW_MISSION_REPEAT_3_MULTIPLIER',
    labelNl: 'Repeat ×3 multiplier',
    labelEn: 'Repeat ×3 multiplier',
    hintNl: '0.5–1',
    hintEn: '0.5–1',
  },
  {
    key: 'CREW_MISSION_REPEAT_4_MULTIPLIER',
    labelNl: 'Repeat ×4+ multiplier',
    labelEn: 'Repeat ×4+ multiplier',
    hintNl: '0.5–1',
    hintEn: '0.5–1',
  },
  {
    key: 'CREW_MISSION_CREW_LEVEL_BASE_XP',
    labelNl: 'Crew level basis-XP',
    labelEn: 'Crew level base XP',
    hintNl: '100–20000',
    hintEn: '100–20000',
  },
  {
    key: 'CREW_MISSION_CREW_LEVEL_STEP_XP',
    labelNl: 'Crew level stap-XP',
    labelEn: 'Crew level step XP',
    hintNl: '10–5000',
    hintEn: '10–5000',
  },
  {
    key: 'CREW_MISSION_CREW_LEVEL_CASH_BONUS_PER_LEVEL_PCT',
    labelNl: 'Cashbonus % per level',
    labelEn: 'Cash bonus % per level',
    hintNl: '0–10',
    hintEn: '0–10',
  },
  {
    key: 'CREW_MISSION_CREW_LEVEL_CASH_BONUS_CAP_PCT',
    labelNl: 'Cashbonus cap %',
    labelEn: 'Cash bonus cap %',
    hintNl: '0–100',
    hintEn: '0–100',
  },
]

const tr = (locale: AdminLanguage, nl: string, en: string) => getAdminTr(locale, nl, en)

function valueFor(view: CrewMissionRuntimeConfigView | null, key: string): string {
  if (!view) return ''
  const raw = view.values[key] ?? view.defaults[key] ?? ''
  return String(raw)
}

export function CrewMissionsAdminPanel({ locale }: Props) {
  const [view, setView] = useState<CrewMissionRuntimeConfigView | null>(null)
  const [loading, setLoading] = useState(false)
  const [savingGate, setSavingGate] = useState(false)
  const [savingOther, setSavingOther] = useState(false)
  const [gateEnabled, setGateEnabled] = useState(false)
  const [gateLevel, setGateLevel] = useState(String(PHASE2_ON_LEVEL))
  const [otherValues, setOtherValues] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    try {
      setLoading(true)
      setError(null)
      const next = await adminService.getCrewMissionRuntimeConfig()
      setView(next)
      const current = Number(valueFor(next, CLEARING_HOUSE_KEY) || 0)
      setGateEnabled(current > 0)
      setGateLevel(String(current > 0 ? current : PHASE2_ON_LEVEL))
      const nextOther: Record<string, string> = {}
      for (const row of OTHER_KEYS) {
        nextOther[row.key] = valueFor(next, row.key)
      }
      setOtherValues(nextOther)
    } catch (err) {
      setError(
        tr(
          locale,
          'Crew mission runtime-config laden mislukt.',
          'Failed to load crew mission runtime config.',
        ),
      )
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const liveLevel = useMemo(() => Number(valueFor(view, CLEARING_HOUSE_KEY) || 0), [view])
  const liveEnabled = liveLevel > 0

  const saveGate = async () => {
    const level = gateEnabled ? Number.parseInt(gateLevel, 10) : 0
    if (gateEnabled && (!Number.isFinite(level) || level < 1 || level > 50)) {
      setError(
        tr(
          locale,
          'Missieniveau moet tussen 1 en 50 liggen als de gate aan staat.',
          'Mission level must be between 1 and 50 when the gate is on.',
        ),
      )
      return
    }

    try {
      setSavingGate(true)
      setError(null)
      setMessage(null)
      const updated = await adminService.updateCrewMissionRuntimeConfig({
        [CLEARING_HOUSE_KEY]: gateEnabled ? level : 0,
      })
      setView(updated)
      const nextLevel = Number(valueFor(updated, CLEARING_HOUSE_KEY) || 0)
      setGateEnabled(nextLevel > 0)
      setGateLevel(String(nextLevel > 0 ? nextLevel : PHASE2_ON_LEVEL))
      setMessage(
        nextLevel > 0
          ? tr(
              locale,
              `Clearing House gate AAN (min. missieniveau ${nextLevel}).`,
              `Clearing House gate ON (min. mission level ${nextLevel}).`,
            )
          : tr(locale, 'Clearing House gate UIT.', 'Clearing House gate OFF.'),
      )
    } catch (err) {
      setError(
        tr(
          locale,
          'Opslaan van Clearing House gate mislukt.',
          'Failed to save Clearing House gate.',
        ),
      )
      console.error(err)
    } finally {
      setSavingGate(false)
    }
  }

  const saveOther = async () => {
    try {
      setSavingOther(true)
      setError(null)
      setMessage(null)
      const updated = await adminService.updateCrewMissionRuntimeConfig(otherValues)
      setView(updated)
      setMessage(
        tr(locale, 'Crew mission pacing opgeslagen.', 'Crew mission pacing saved.'),
      )
    } catch (err) {
      setError(
        tr(
          locale,
          'Opslaan van pacing-instellingen mislukt (check bereiken).',
          'Failed to save pacing settings (check ranges).',
        ),
      )
      console.error(err)
    } finally {
      setSavingOther(false)
    }
  }

  return (
    <div className="d-flex flex-column gap-3">
      <div className="d-flex align-items-center justify-content-between gap-2 flex-wrap">
        <div>
          <h1 className="h3 mb-1">{tr(locale, 'Crew Missions', 'Crew Missions')}</h1>
          <div className="text-muted">
            {tr(
              locale,
              'Runtime gates en pacing. Wijzigingen gelden direct zonder deploy.',
              'Runtime gates and pacing. Changes apply live without a deploy.',
            )}
          </div>
        </div>
        <button
          type="button"
          className="btn btn-outline-secondary btn-sm"
          onClick={() => void load()}
          disabled={loading}
        >
          <i className="ph-arrows-clockwise me-1" />
          {tr(locale, 'Ververs', 'Refresh')}
        </button>
      </div>

      {loading && <div className="text-muted">{tr(locale, 'Laden…', 'Loading…')}</div>}
      {error && <div className="alert alert-danger mb-0">{error}</div>}
      {message && <div className="alert alert-success mb-0">{message}</div>}

      <div className="border rounded p-3">
        <div className="d-flex align-items-start justify-content-between gap-3 flex-wrap mb-3">
          <div>
            <div className="fw-semibold">
              {tr(locale, 'Clearing House Phase-2 gate', 'Clearing House Phase-2 gate')}
            </div>
            <div className="text-muted small">
              {tr(
                locale,
                'Extra lock op Clearing House Kluisrun: crew.missionLevel moet ≥ dit niveau zijn. Tier-3 HQ/leden-eisen blijven altijd gelden. Aanbevolen: 3 na genoeg T2/T3/Blackout telemetry.',
                'Extra lock on Clearing House Vault Run: crew.missionLevel must be ≥ this level. Tier-3 HQ/member requirements still always apply. Recommended: 3 after enough T2/T3/Blackout telemetry.',
              )}
            </div>
          </div>
          <span className={`badge ${liveEnabled ? 'bg-warning text-dark' : 'bg-secondary'}`}>
            {liveEnabled
              ? tr(locale, `Live: AAN (≥${liveLevel})`, `Live: ON (≥${liveLevel})`)
              : tr(locale, 'Live: UIT', 'Live: OFF')}
          </span>
        </div>

        <div className="form-check form-switch mb-3">
          <input
            className="form-check-input"
            type="checkbox"
            id="clearing-house-gate"
            checked={gateEnabled}
            onChange={(e) => {
              setGateEnabled(e.target.checked)
              if (e.target.checked && (!gateLevel || gateLevel === '0')) {
                setGateLevel(String(PHASE2_ON_LEVEL))
              }
            }}
          />
          <label className="form-check-label" htmlFor="clearing-house-gate">
            {tr(
              locale,
              'Gate inschakelen (min. missieniveau)',
              'Enable gate (min. mission level)',
            )}
          </label>
        </div>

        <div className="row g-3 align-items-end">
          <div className="col-12 col-md-4">
            <label className="form-label">
              {tr(locale, 'Minimum missieniveau', 'Minimum mission level')}
            </label>
            <input
              type="number"
              min={1}
              max={50}
              className="form-control"
              disabled={!gateEnabled}
              value={gateLevel}
              onChange={(e) => setGateLevel(e.target.value)}
            />
            <div className="form-text">
              {tr(
                locale,
                `Standaard Phase-2 waarde: ${PHASE2_ON_LEVEL}. 0 = uit.`,
                `Default Phase-2 value: ${PHASE2_ON_LEVEL}. 0 = off.`,
              )}
            </div>
          </div>
          <div className="col-12 col-md-auto">
            <button
              type="button"
              className="btn btn-primary"
              disabled={savingGate || loading}
              onClick={() => void saveGate()}
            >
              {savingGate
                ? tr(locale, 'Opslaan…', 'Saving…')
                : tr(locale, 'Gate opslaan', 'Save gate')}
            </button>
          </div>
          <div className="col-12 col-md-auto">
            <button
              type="button"
              className="btn btn-outline-secondary"
              disabled={savingGate || loading}
              onClick={() => {
                setGateEnabled(false)
                setGateLevel(String(PHASE2_ON_LEVEL))
              }}
            >
              {tr(locale, 'Zet UI op UIT', 'Set UI to OFF')}
            </button>
          </div>
        </div>
      </div>

      <div className="border rounded p-3">
        <div className="fw-semibold mb-1">
          {tr(locale, 'Pacing & rewards (runtime)', 'Pacing & rewards (runtime)')}
        </div>
        <div className="text-muted small mb-3">
          {tr(
            locale,
            'Credits/min, repeat diminishing en crew-level cashbonus. Alleen wijzigen na telemetry-check.',
            'Credits/min, repeat diminishing and crew-level cash bonus. Change only after a telemetry check.',
          )}
        </div>
        <div className="row g-3">
          {OTHER_KEYS.map((row) => (
            <div className="col-12 col-md-6 col-xl-4" key={row.key}>
              <label className="form-label">
                {tr(locale, row.labelNl, row.labelEn)}
              </label>
              <input
                className="form-control"
                value={otherValues[row.key] ?? ''}
                onChange={(e) =>
                  setOtherValues((prev) => ({ ...prev, [row.key]: e.target.value }))
                }
              />
              <div className="form-text">{tr(locale, row.hintNl, row.hintEn)}</div>
            </div>
          ))}
        </div>
        <div className="mt-3">
          <button
            type="button"
            className="btn btn-outline-primary"
            disabled={savingOther || loading}
            onClick={() => void saveOther()}
          >
            {savingOther
              ? tr(locale, 'Opslaan…', 'Saving…')
              : tr(locale, 'Pacing opslaan', 'Save pacing')}
          </button>
        </div>
      </div>
    </div>
  )
}
