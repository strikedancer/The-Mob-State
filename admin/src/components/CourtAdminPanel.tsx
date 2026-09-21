import { useState } from "react";
import { adminService } from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";
import { AdminPageIntro } from "./adminChrome";

type Props = {
  locale: AdminLanguage;
  isSuperAdmin: boolean;
};

const CONFIRM_PHRASE = "WIPE_ALL_RECORDS";

const PROMO_PREVIEW_NL =
  "Ieders strafblad is zojuist gewist. Iedereen start opnieuw met een schoon blad.\n\nHoud het nu bij via Rechtbank. Hoe eerder je regels wegkoopt, hoe beter het lukt — weinig regels maakt wissen een stuk makkelijker.";

export function CourtAdminPanel({ locale, isSuperAdmin }: Props) {
  const l = (nl: string, en: string) => getAdminTr(locale, nl, en);
  const [confirmText, setConfirmText] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [lastResult, setLastResult] = useState<{
    playersCleared: number;
    recordsCleared: number;
    announcementId: number | null;
  } | null>(null);

  const canRun =
    isSuperAdmin && confirmText.trim() === CONFIRM_PHRASE && !busy;

  const runAmnesty = async () => {
    if (!canRun) return;
    if (
      !window.confirm(
        l(
          "Dit wist het zichtbare strafblad van ALLE spelers en plaatst een wereldchat-promo met afbeelding. Doorgaan?",
          "This wipes the visible criminal record for ALL players and posts a world-chat promo with image. Continue?",
        ),
      )
    ) {
      return;
    }

    setBusy(true);
    setError(null);
    setMessage(null);
    try {
      const result = await adminService.runCourtRecordAmnesty();
      setLastResult({
        playersCleared: result.playersCleared,
        recordsCleared: result.recordsCleared,
        announcementId: result.announcementId,
      });
      setMessage(
        l(
          `Amnesty gedaan: ${result.playersCleared} spelers, ${result.recordsCleared} records. Wereldchat-promo geplaatst.`,
          `Amnesty done: ${result.playersCleared} players, ${result.recordsCleared} records. World-chat promo posted.`,
        ),
      );
      setConfirmText("");
    } catch (err) {
      console.error(err);
      setError(
        err instanceof Error
          ? err.message
          : l("Amnesty mislukt.", "Amnesty failed."),
      );
    } finally {
      setBusy(false);
    }
  };

  return (
    <section>
      <AdminPageIntro
        kicker={l("Rechtbank · amnesty", "Court · amnesty")}
        description={l(
          "Super-admin tools voor het strafblad. Amnesty wist zichtbare veroordelingen voor iedereen en plaatst dezelfde promo in wereldchat (met afbeelding; Discord volgt via de chat-brug).",
          "Super-admin tools for criminal records. Amnesty clears visible convictions for everyone and posts the same promo in world chat (with image; Discord follows via the chat bridge).",
        )}
      />

      {error ? <p className="error-text">{error}</p> : null}
      {message ? <p className="ok-text">{message}</p> : null}

      {!isSuperAdmin ? (
        <div className="runtime-card">
          <p>
            {l(
              "Alleen SUPER_ADMIN mag de globale strafblad-amnesty starten.",
              "Only SUPER_ADMIN can run the global criminal-record amnesty.",
            )}
          </p>
        </div>
      ) : (
        <div className="runtime-card" style={{ marginBottom: 16 }}>
          <h3>
            {l(
              "Alle strafbladen wissen (amnesty)",
              "Wipe all criminal records (amnesty)",
            )}
          </h3>
          <p>
            {l(
              "Schrijft voor elke speler een trial.record_expunged-marker (source: amnesty). Nieuwe veroordelingen daarna tellen weer normaal. Spelers komen niet vrij uit de cel.",
              "Writes a trial.record_expunged marker per player (source: amnesty). New convictions after that count normally. Players are not released from jail.",
            )}
          </p>

          <div
            className="runtime-card"
            style={{ marginTop: 12, marginBottom: 12, opacity: 0.95 }}
          >
            <h4>{l("Promo-voorbeeld", "Promo preview")}</h4>
            <p>
              <strong>Rechtbank</strong>
            </p>
            <pre
              style={{
                whiteSpace: "pre-wrap",
                fontFamily: "inherit",
                margin: 0,
              }}
            >
              {PROMO_PREVIEW_NL}
            </pre>
            <p style={{ marginTop: 8, fontSize: 13 }}>
              {l("Afbeelding", "Image")}:{" "}
              <code>promo/court_record_wipe.png</code>
            </p>
          </div>

          <label style={{ display: "block", marginBottom: 8 }}>
            {l(
              `Typ ter bevestiging exact: ${CONFIRM_PHRASE}`,
              `Type exactly to confirm: ${CONFIRM_PHRASE}`,
            )}
          </label>
          <input
            type="text"
            value={confirmText}
            onChange={(event) => setConfirmText(event.target.value)}
            placeholder={CONFIRM_PHRASE}
            style={{ width: "min(100%, 320px)", marginRight: 8 }}
            autoComplete="off"
            spellCheck={false}
          />
          <button
            type="button"
            className="btn btn-danger"
            disabled={!canRun}
            onClick={() => void runAmnesty()}
          >
            {busy
              ? l("Bezig…", "Working…")
              : l("Strafbladen wissen + promo", "Wipe records + promo")}
          </button>

          {lastResult ? (
            <p style={{ marginTop: 12 }}>
              {l("Laatste run", "Last run")}:{" "}
              {lastResult.playersCleared}{" "}
              {l("spelers", "players")} · {lastResult.recordsCleared}{" "}
              {l("records", "records")}
              {lastResult.announcementId != null
                ? ` · chat #${lastResult.announcementId}`
                : ""}
            </p>
          ) : null}
        </div>
      )}
    </section>
  );
}
