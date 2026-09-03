import { useEffect, useState } from 'react'
import {
  adminService,
  type CasinoRuntimeConfigView,
} from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'

type Props = {
  locale: AdminLanguage
}

const KEYS: Array<{ key: string; labelNl: string; labelEn: string; hintNl: string; hintEn: string }> = [
  {
    key: 'CASINO_FLOOR_MAX_BET_1',
    labelNl: 'Max inzet verdieping 1 (public)',
    labelEn: 'Max bet floor 1 (public)',
    hintNl: 'Euro',
    hintEn: 'Euro',
  },
  {
    key: 'CASINO_FLOOR_MAX_BET_2',
    labelNl: 'Max inzet verdieping 2 (VIP)',
    labelEn: 'Max bet floor 2 (VIP)',
    hintNl: 'Euro',
    hintEn: 'Euro',
  },
  {
    key: 'CASINO_FLOOR_MAX_BET_3',
    labelNl: 'Max inzet verdieping 3 (private)',
    labelEn: 'Max bet floor 3 (private)',
    hintNl: 'Euro',
    hintEn: 'Euro',
  },
  {
    key: 'CASINO_RAKE_BPS_1',
    labelNl: 'Rake verdieping 1 (bps)',
    labelEn: 'Rake floor 1 (bps)',
    hintNl: '200 = 2%',
    hintEn: '200 = 2%',
  },
  {
    key: 'CASINO_RAKE_BPS_2',
    labelNl: 'Rake verdieping 2 (bps)',
    labelEn: 'Rake floor 2 (bps)',
    hintNl: '350 = 3,5%',
    hintEn: '350 = 3.5%',
  },
  {
    key: 'CASINO_RAKE_BPS_3',
    labelNl: 'Rake verdieping 3 (bps)',
    labelEn: 'Rake floor 3 (bps)',
    hintNl: '500 = 5%',
    hintEn: '500 = 5%',
  },
  {
    key: 'CASINO_FLOOR_UPGRADE_2',
    labelNl: 'Upgradekosten naar VIP',
    labelEn: 'Upgrade cost to VIP',
    hintNl: 'Euro (speler-cash)',
    hintEn: 'Euro (player cash)',
  },
  {
    key: 'CASINO_FLOOR_UPGRADE_3',
    labelNl: 'Upgradekosten naar private',
    labelEn: 'Upgrade cost to private',
    hintNl: 'Euro (speler-cash)',
    hintEn: 'Euro (player cash)',
  },
  {
    key: 'CASINO_RAID_DRAIN_PCT',
    labelNl: 'Ledger-raid drain %',
    labelEn: 'Ledger raid drain %',
    hintNl: 'Basis % van bankroll',
    hintEn: 'Base % of bankroll',
  },
  {
    key: 'CASINO_SECURITY_DRAIN_REDUCTION_BPS',
    labelNl: 'Security-schaal (bps)',
    labelEn: 'Security scale (bps)',
    hintNl: '10000 = 100% staff-defense',
    hintEn: '10000 = 100% staff defense',
  },
]

const tr = (locale: AdminLanguage, nl: string, en: string) => getAdminTr(locale, nl, en)

function valueFor(view: CasinoRuntimeConfigView | null, key: string): string {
  if (!view) return ''
  const raw = view.values[key] ?? view.defaults[key] ?? ''
  return String(raw)
}

export function CasinoAdminPanel({ locale }: Props) {
  const [view, setView] = useState<CasinoRuntimeConfigView | null>(null)
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [values, setValues] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    try {
      setLoading(true)
      setError(null)
      const next = await adminService.getCasinoRuntimeConfig()
      setView(next)
      const nextValues: Record<string, string> = {}
      for (const row of KEYS) {
        nextValues[row.key] = valueFor(next, row.key)
      }
      setValues(nextValues)
    } catch (err) {
      setError(
        tr(locale, 'Casino runtime-config laden mislukt.', 'Failed to load casino runtime config.'),
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

  const save = async () => {
    setSaving(true)
    setError(null)
    setMessage(null)
    try {
      const updated = await adminService.updateCasinoRuntimeConfig(values)
      setView(updated)
      setMessage(tr(locale, 'Opgeslagen.', 'Saved.'))
    } catch (err) {
      setError(tr(locale, 'Opslaan mislukt.', 'Save failed.'))
      console.error(err)
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <h1 className="h3 mb-1">{tr(locale, 'Casino', 'Casino')}</h1>
      <p className="text-muted mb-3">
        {tr(
          locale,
          'Runtime-keys voor verdiepingen, rake, upgradekosten en ledger-raid. Geen code-defaults flippen.',
          'Runtime keys for floors, rake, upgrade prices and ledger raid. Do not flip code defaults.',
        )}
      </p>
      {error && <div className="alert alert-danger">{error}</div>}
      {message && <div className="alert alert-success">{message}</div>}
      {loading && <p className="text-muted">{tr(locale, 'Laden…', 'Loading…')}</p>}
      <div className="row g-3">
        {KEYS.map((row) => (
          <div className="col-md-6" key={row.key}>
            <label className="form-label fw-semibold">
              {tr(locale, row.labelNl, row.labelEn)}
            </label>
            <input
              className="form-control"
              value={values[row.key] ?? ''}
              onChange={(event) =>
                setValues((prev) => ({ ...prev, [row.key]: event.target.value }))
              }
              disabled={!view || saving}
            />
            <div className="form-text">
              {row.key} · {tr(locale, row.hintNl, row.hintEn)}
            </div>
          </div>
        ))}
      </div>
      <div className="mt-3">
        <button
          type="button"
          className="btn btn-primary"
          disabled={!view || saving}
          onClick={() => void save()}
        >
          {saving ? tr(locale, 'Opslaan…', 'Saving…') : tr(locale, 'Opslaan', 'Save')}
        </button>
      </div>
    </section>
  )
}
