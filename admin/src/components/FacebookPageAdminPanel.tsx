import { useEffect, useState } from 'react'
import type { FormEvent } from 'react'
import { adminService } from '../services/adminService'
import type { AdminLanguage } from '../i18n/translations'
import { getAdminTr } from '../i18n/inlineMessages'

type Props = {
  locale: AdminLanguage
}

const tr = (locale: AdminLanguage, nl: string, en: string) => getAdminTr(locale, nl, en)

export function FacebookPageAdminPanel({ locale }: Props) {
  const [loginEnabled, setLoginEnabled] = useState(false)
  const [pageEnabled, setPageEnabled] = useState(false)
  const [loading, setLoading] = useState(false)
  const [publishing, setPublishing] = useState(false)
  const [message, setMessage] = useState('')
  const [link, setLink] = useState('https://themobstate.com/')
  const [status, setStatus] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    try {
      setLoading(true)
      setError(null)
      const next = await adminService.getFacebookStatus()
      setLoginEnabled(next.loginEnabled)
      setPageEnabled(next.pageEnabled)
    } catch (err) {
      setError(
        tr(locale, 'Facebook-status laden mislukt.', 'Failed to load Facebook status.'),
      )
      console.error(err)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void load()
  }, [])

  const publish = async (event: FormEvent) => {
    event.preventDefault()
    try {
      setPublishing(true)
      setError(null)
      setStatus(null)
      const result = await adminService.publishFacebookPost({
        message,
        link,
      })
      setStatus(
        tr(
          locale,
          `Bericht geplaatst${result.postId ? ` (${result.postId})` : ''}.`,
          `Post published${result.postId ? ` (${result.postId})` : ''}.`,
        ),
      )
      setMessage('')
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : tr(locale, 'Plaatsen mislukt.', 'Failed to publish.'),
      )
      console.error(err)
    } finally {
      setPublishing(false)
    }
  }

  return (
    <div className="table-container" style={{ marginBottom: '1rem' }}>
      <div className="d-flex align-items-start justify-content-between gap-3 flex-wrap mb-2">
        <div>
          <h3 className="h5 mb-1">{tr(locale, 'Facebook-pagina', 'Facebook page')}</h3>
          <p className="text-muted small mb-0">
            {tr(
              locale,
              'Plaats een bericht op de Facebook-pagina. Speler-login via Facebook staat aan zodra App ID en Secret in .env.plesk staan. Zonder Page-token blijft deze box uit.',
              'Publish a post to the Facebook page. Player Facebook login turns on once App ID and Secret are in .env.plesk. Without a Page token this box stays off.',
            )}
          </p>
        </div>
        <div className="d-flex gap-2 flex-wrap">
          <span className={`badge ${loginEnabled ? 'bg-success' : 'bg-secondary'}`}>
            {loginEnabled
              ? tr(locale, 'Login: AAN', 'Login: ON')
              : tr(locale, 'Login: UIT', 'Login: OFF')}
          </span>
          <span className={`badge ${pageEnabled ? 'bg-success' : 'bg-secondary'}`}>
            {pageEnabled
              ? tr(locale, 'Pagina: AAN', 'Page: ON')
              : tr(locale, 'Pagina: UIT', 'Page: OFF')}
          </span>
        </div>
      </div>

      {loading && <div className="text-muted">{tr(locale, 'Laden…', 'Loading…')}</div>}
      {error && <div className="alert alert-danger mb-2">{error}</div>}
      {status && <div className="alert alert-success mb-2">{status}</div>}

      <form onSubmit={(event) => void publish(event)}>
        <div className="mb-2">
          <label className="form-label" htmlFor="facebook-page-message">
            {tr(locale, 'Bericht', 'Message')}
          </label>
          <textarea
            id="facebook-page-message"
            className="form-control"
            rows={5}
            maxLength={5000}
            value={message}
            disabled={loading || publishing || !pageEnabled}
            onChange={(e) => setMessage(e.target.value)}
            placeholder={tr(
              locale,
              'The Mob State is live. Bouw je imperium op themobstate.com',
              'The Mob State is live. Build your empire at themobstate.com',
            )}
          />
        </div>
        <div className="mb-3">
          <label className="form-label" htmlFor="facebook-page-link">
            {tr(locale, 'Link (optioneel)', 'Link (optional)')}
          </label>
          <input
            id="facebook-page-link"
            className="form-control"
            type="url"
            value={link}
            disabled={loading || publishing || !pageEnabled}
            onChange={(e) => setLink(e.target.value)}
          />
        </div>
        <button
          type="submit"
          className="btn btn-primary"
          disabled={loading || publishing || !pageEnabled || message.trim().length < 1}
        >
          {publishing
            ? tr(locale, 'Plaatsen…', 'Publishing…')
            : tr(locale, 'Plaats op Facebook', 'Publish to Facebook')}
        </button>
      </form>
    </div>
  )
}
