import { useEffect, useState } from 'react'
import {
  adminService,
  type DrugRuntimeConfigView,
} from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'

type Props = {
  locale: AdminLanguage
}

const KEYS: Array<{ key: string; labelNl: string; labelEn: string; hintNl: string; hintEn: string }> = [
  {
    key: 'DRUG_WHOLESALE_MIN_GRAMS',
    labelNl: 'Minimale groothandel (gram)',
    labelEn: 'Wholesale minimum (grams)',
    hintNl: 'Default 250',
    hintEn: 'Default 250',
  },
  {
    key: 'DRUG_WHOLESALE_SPREAD_BPS',
    labelNl: 'B2B-spread (bps onder dest street)',
    labelEn: 'B2B spread (bps under dest street)',
    hintNl: '1500 = 15%',
    hintEn: '1500 = 15%',
  },
  {
    key: 'DRUG_WHOLESALE_VOLUME_BONUS_BPS_PER_KG',
    labelNl: 'Volumebonus per kg (bps)',
    labelEn: 'Volume bonus per kg (bps)',
    hintNl: '200 = 2% per kg',
    hintEn: '200 = 2% per kg',
  },
  {
    key: 'DRUG_WHOLESALE_VOLUME_BONUS_CAP_BPS',
    labelNl: 'Volumebonus cap (bps)',
    labelEn: 'Volume bonus cap (bps)',
    hintNl: '600 = 6%',
    hintEn: '600 = 6%',
  },
  {
    key: 'DRUG_WHOLESALE_SCARCITY_WINDOW_H',
    labelNl: 'Scarcity-venster (uur)',
    labelEn: 'Scarcity window (hours)',
    hintNl: 'Recente wholesale-grams in dest',
    hintEn: 'Recent wholesale grams in dest',
  },
  {
    key: 'DRUG_WHOLESALE_SCARCITY_CAP_BPS',
    labelNl: 'Scarcity cap (bps)',
    labelEn: 'Scarcity cap (bps)',
    hintNl: '1000 = 10%',
    hintEn: '1000 = 10%',
  },
  {
    key: 'DRUG_WHOLESALE_FBI_HEAT_PER_KG',
    labelNl: 'FBI-heat per kg bij aankomst',
    labelEn: 'FBI heat per kg on arrival',
    hintNl: 'Alleen bij succesvolle payout',
    hintEn: 'Successful payout only',
  },
  {
    key: 'DRUG_WHOLESALE_DRUG_HEAT',
    labelNl: 'Drug-heat bij verzenden',
    labelEn: 'Drug heat on send',
    hintNl: 'Incl. bestaande smokkel +2',
    hintEn: 'Includes existing smuggle +2',
  },
  {
    key: 'DRUG_WHOLESALE_CREW_RUNNER_BPS',
    labelNl: 'Crew-export loper-cut (bps)',
    labelEn: 'Crew export runner cut (bps)',
    hintNl: '500 = 5% van payout naar de loper',
    hintEn: '500 = 5% of payout to the runner',
  },
  {
    key: 'DRUG_HEAT_CASH_COOL_COST_PER_POINT',
    labelNl: 'Cash-cool kosten per heat-punt',
    labelEn: 'Cash-cool cost per heat point',
    hintNl: 'Euro',
    hintEn: 'Euro',
  },
  {
    key: 'DRUG_HEAT_CASH_COOL_POINTS',
    labelNl: 'Cash-cool punten per actie',
    labelEn: 'Cash-cool points per action',
    hintNl: 'Default 25',
    hintEn: 'Default 25',
  },
  {
    key: 'DRUG_HEAT_LOW_PROFILE_HOURS',
    labelNl: 'Low-profile duur (uur)',
    labelEn: 'Low-profile duration (hours)',
    hintNl: 'Default 4',
    hintEn: 'Default 4',
  },
  {
    key: 'DRUG_HEAT_LOW_PROFILE_COOLDOWN_HOURS',
    labelNl: 'Low-profile cooldown (uur)',
    labelEn: 'Low-profile cooldown (hours)',
    hintNl: 'Default 8',
    hintEn: 'Default 8',
  },
  {
    key: 'DRUG_RAID_DOWNTIME_HOURS',
    labelNl: 'Raid downtime (uur)',
    labelEn: 'Raid downtime (hours)',
    hintNl: 'Default 4',
    hintEn: 'Default 4',
  },
  {
    key: 'DRUG_RAID_CASH_FINE_PERCENT',
    labelNl: 'Raid cash-boete %',
    labelEn: 'Raid cash fine %',
    hintNl: 'Default 35',
    hintEn: 'Default 35',
  },
  {
    key: 'DRUG_DARKWEB_AUTOSALE_FEE_PERCENT',
    labelNl: 'Darkweb auto-sale fee %',
    labelEn: 'Darkweb auto-sale fee %',
    hintNl: 'Default 12',
    hintEn: 'Default 12',
  },
  {
    key: 'DRUG_DARKWEB_AUTOSALE_HEAT',
    labelNl: 'Darkweb auto-sale heat',
    labelEn: 'Darkweb auto-sale heat',
    hintNl: 'Default 4',
    hintEn: 'Default 4',
  },
  {
    key: 'DRUG_DARKWEB_AUTOSALE_SHARE_PERCENT',
    labelNl: 'Darkweb auto-sale share %',
    labelEn: 'Darkweb auto-sale share %',
    hintNl: 'Default 10',
    hintEn: 'Default 10',
  },
  {
    key: 'DRUG_NIGHTCLUB_OWN_PROD_BONUS_PERCENT',
    labelNl: 'Nightclub eigen-productie bonus %',
    labelEn: 'Nightclub own-production bonus %',
    hintNl: 'Default 8',
    hintEn: 'Default 8',
  },
]

const tr = (locale: AdminLanguage, nl: string, en: string) => getAdminTr(locale, nl, en)

function valueFor(view: DrugRuntimeConfigView | null, key: string): string {
  if (!view) return ''
  const raw = view.values[key] ?? view.defaults[key] ?? ''
  return String(raw)
}

export function DrugsAdminPanel({ locale }: Props) {
  const [view, setView] = useState<DrugRuntimeConfigView | null>(null)
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [values, setValues] = useState<Record<string, string>>({})
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    try {
      setLoading(true)
      setError(null)
      const next = await adminService.getDrugRuntimeConfig()
      setView(next)
      const nextValues: Record<string, string> = {}
      for (const row of KEYS) {
        nextValues[row.key] = valueFor(next, row.key)
      }
      setValues(nextValues)
    } catch (err) {
      setError(
        tr(locale, 'Drugs runtime-config laden mislukt.', 'Failed to load drugs runtime config.'),
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
      const updated = await adminService.updateDrugRuntimeConfig(values)
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
      <h1 className="h3 mb-1">{tr(locale, 'Drugs', 'Drugs')}</h1>
      <p className="text-muted mb-3">
        {tr(
          locale,
          'Runtime-keys voor groothandel-export, heat, raids, darkweb en nightclub-bonus. Police-pressure en Clearing House-gate niet hier flippen.',
          'Runtime keys for wholesale export, heat, raids, darkweb and nightclub bonus. Do not flip police pressure or Clearing House here.',
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
