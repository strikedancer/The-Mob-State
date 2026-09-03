import { useEffect, useState } from 'react'
import {
  adminService,
  type CountryPoliceRuntimeConfigView,
} from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'

type Props = {
  locale: AdminLanguage
}

function tr(locale: AdminLanguage, nl: string, en: string): string {
  return locale === 'nl' ? nl : en
}

function valueFor(view: CountryPoliceRuntimeConfigView | null, key: string): string {
  if (!view) return ''
  const raw = view.values[key] ?? view.defaults[key] ?? ''
  return String(raw)
}

export function CountryPoliceAdminPanel({ locale }: Props) {
  const [view, setView] = useState<CountryPoliceRuntimeConfigView | null>(null)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    const next = await adminService.getCountryPoliceRuntimeConfig()
    setView(next)
  }

  useEffect(() => {
    void load().catch((err) => setError(String(err)))
  }, [])

  const enabled = valueFor(view, 'COUNTRY_POLICE_PRESSURE_ENABLED') === '1'

  const toggleEnabled = async () => {
    setSaving(true)
    setError(null)
    try {
      const updated = await adminService.updateCountryPoliceRuntimeConfig({
        COUNTRY_POLICE_PRESSURE_ENABLED: enabled ? '0' : '1',
      })
      setView(updated)
    } catch (err) {
      setError(String(err))
    } finally {
      setSaving(false)
    }
  }

  return (
    <section>
      <h1 className="h3 mb-1">
        {tr(locale, 'Landelijke politie', 'Country police')}
      </h1>
      <p className="text-muted mb-3">
        {tr(
          locale,
          'Runtime-flag, niet de code-default. Uit = bestaande crime/arrest-math. Aan = landelijke druk op succes- en arrestkans.',
          'Runtime flag, not the code default. Off = current crime/arrest math. On = country pressure on success and arrest chance.',
        )}
      </p>
      {error && <div className="alert alert-danger">{error}</div>}
      <div className="card mb-3">
        <div className="card-body d-flex align-items-center justify-content-between gap-3">
          <div>
            <div className="fw-semibold">
              {tr(locale, 'Druk actief', 'Pressure enabled')}
            </div>
            <div className="small text-muted">COUNTRY_POLICE_PRESSURE_ENABLED</div>
          </div>
          <button
            type="button"
            className={`btn ${enabled ? 'btn-success' : 'btn-outline-secondary'}`}
            disabled={saving || !view}
            onClick={() => void toggleEnabled()}
          >
            {enabled
              ? tr(locale, 'Aan', 'On')
              : tr(locale, 'Uit', 'Off')}
          </button>
        </div>
      </div>
      <p className="small text-muted mb-0">
        {tr(
          locale,
          'QA: dashboard-strip, crimes-strip, travel-badges en disrupt. Code-default blijft 0.',
          'QA: dashboard strip, crimes strip, travel badges, and disrupt. Code default stays 0.',
        )}
      </p>
    </section>
  )
}
