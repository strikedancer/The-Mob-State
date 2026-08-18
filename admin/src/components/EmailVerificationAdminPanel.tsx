import { useEffect, useState } from 'react'
import { adminService } from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'

type Props = {
  locale: AdminLanguage
}

const tr = (locale: AdminLanguage, nl: string, en: string) => getAdminTr(locale, nl, en)

export function EmailVerificationAdminPanel({ locale }: Props) {
  const [required, setRequired] = useState(true)
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    try {
      setLoading(true)
      setError(null)
      const next = await adminService.getEmailVerificationGate()
      setRequired(next.required)
    } catch (err) {
      setError(
        tr(
          locale,
          'Instelling laden mislukt.',
          'Failed to load setting.',
        ),
      )
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void load()
  }, [])

  const save = async (nextRequired: boolean) => {
    try {
      setSaving(true)
      setError(null)
      setMessage(null)
      const updated = await adminService.updateEmailVerificationGate(nextRequired)
      setRequired(updated.required)
      setMessage(
        updated.required
          ? tr(
              locale,
              'E-mailverificatie staat weer AAN. Nieuwe accounts krijgen een mail; ongeverifieerde spelers kunnen niet inloggen tot ze de link gebruiken.',
              'Email verification is ON again. New accounts get a mail; unverified players cannot log in until they use the link.',
            )
          : tr(
              locale,
              'E-mailverificatie staat tijdelijk UIT. Spelers kunnen inloggen en registreren zonder mail.',
              'Email verification is temporarily OFF. Players can log in and register without mail.',
            ),
      )
    } catch (err) {
      setError(tr(locale, 'Opslaan mislukt.', 'Failed to save.'))
      console.error(err)
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="table-container" style={{ marginBottom: '1rem' }}>
      <div className="d-flex align-items-start justify-content-between gap-3 flex-wrap mb-2">
        <div>
          <h3 className="h5 mb-1">
            {tr(locale, 'E-mailverificatie bij login', 'Email verification on login')}
          </h3>
          <p className="text-muted small mb-0">
            {tr(
              locale,
              'Zet dit tijdelijk uit als Gmail/Spamhaus mail blokkeert. Accounts blijven ongeverifieerd in de database. Als je het weer aanzet, is de mail-gate terug: registratie stuurt weer een mail, login eist verificatie.',
              'Turn this off temporarily if Gmail/Spamhaus blocks mail. Accounts stay unverified in the database. Turning it back on restores the mail gate: registration sends mail again, login requires verification.',
            )}
          </p>
        </div>
        <span className={`badge ${required ? 'bg-success' : 'bg-warning text-dark'}`}>
          {required
            ? tr(locale, 'Live: verificatie AAN', 'Live: verification ON')
            : tr(locale, 'Live: verificatie UIT', 'Live: verification OFF')}
        </span>
      </div>

      {loading && <div className="text-muted">{tr(locale, 'Laden…', 'Loading…')}</div>}
      {error && <div className="alert alert-danger mb-2">{error}</div>}
      {message && <div className="alert alert-success mb-2">{message}</div>}

      <div className="form-check form-switch">
        <input
          className="form-check-input"
          type="checkbox"
          id="email-verification-required"
          checked={required}
          disabled={loading || saving}
          onChange={(e) => void save(e.target.checked)}
        />
        <label className="form-check-label" htmlFor="email-verification-required">
          {tr(locale, 'Verificatie verplicht (mail sturen)', 'Verification required (send mail)')}
        </label>
      </div>
    </div>
  )
}
