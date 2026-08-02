import { useEffect, useState } from 'react'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'
import { adminService } from '../services/adminService'

type Props = { locale: AdminLanguage }

type VenueRow = {
  venueId: number
  playerId: number
  ownerUsername: string
  country: string
  isOpen: boolean
  crowdSize: number
  crowdVibe: string
  sales24hCount: number
  sales24hRevenue: number
  thefts24hCount: number
  thefts24hLoss: number
  activeEvents: number
}

const tr = (locale: AdminLanguage, nl: string, en: string) => getAdminTr(locale, nl, en)

export function NightclubAdminPanel({ locale }: Props) {
  const [rows, setRows] = useState<VenueRow[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [generatedAt, setGeneratedAt] = useState('')

  const load = async () => {
    setLoading(true)
    setError('')
    try {
      const data = await adminService.getNightclubOverview()
      setRows(Array.isArray(data.venues) ? data.venues : [])
      setGeneratedAt(data.generatedAt ?? '')
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Failed to load')
      setRows([])
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void load()
  }, [])

  return (
    <div className="card border-0 shadow-sm">
      <div className="card-header d-flex justify-content-between align-items-center">
        <strong>{tr(locale, 'Nightclub overzicht', 'Nightclub overview')}</strong>
        <button className="btn btn-sm btn-outline-primary" onClick={() => void load()} disabled={loading}>
          {tr(locale, 'Vernieuwen', 'Refresh')}
        </button>
      </div>
      <div className="card-body">
        <p className="text-muted small mb-3">
          {tr(
            locale,
            'Read-only telemetry: crowd, 24u sales/thefts en actieve events. Geen Ops Lab-duplicaat.',
            'Read-only telemetry: crowd, 24h sales/thefts and active events. Not a player Ops Lab duplicate.',
          )}
          {generatedAt ? ` · ${generatedAt}` : ''}
        </p>
        {error ? <div className="alert alert-danger py-2">{error}</div> : null}
        {loading ? <div className="text-muted">{tr(locale, 'Laden…', 'Loading…')}</div> : null}
        {!loading && rows.length === 0 ? (
          <div className="text-muted">{tr(locale, 'Geen clubs gevonden', 'No clubs found')}</div>
        ) : null}
        {rows.length > 0 ? (
          <div className="table-responsive">
            <table className="table table-sm align-middle">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>{tr(locale, 'Eigenaar', 'Owner')}</th>
                  <th>{tr(locale, 'Land', 'Country')}</th>
                  <th>{tr(locale, 'Open', 'Open')}</th>
                  <th>{tr(locale, 'Crowd', 'Crowd')}</th>
                  <th>{tr(locale, 'Sales 24u', 'Sales 24h')}</th>
                  <th>{tr(locale, 'Thefts 24u', 'Thefts 24h')}</th>
                  <th>{tr(locale, 'Events', 'Events')}</th>
                </tr>
              </thead>
              <tbody>
                {rows.map((row) => (
                  <tr key={row.venueId}>
                    <td>{row.venueId}</td>
                    <td>
                      {row.ownerUsername} <span className="text-muted">#{row.playerId}</span>
                    </td>
                    <td>{row.country}</td>
                    <td>{row.isOpen ? '✓' : '–'}</td>
                    <td>
                      {row.crowdSize} <span className="text-muted">({row.crowdVibe})</span>
                    </td>
                    <td>
                      {row.sales24hCount} / €{row.sales24hRevenue}
                    </td>
                    <td>
                      {row.thefts24hCount} / €{row.thefts24hLoss}
                    </td>
                    <td>{row.activeEvents}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : null}
      </div>
    </div>
  )
}
