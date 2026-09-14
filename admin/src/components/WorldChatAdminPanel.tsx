import { useEffect, useState } from "react";
import {
  adminService,
  type GlobalChatAdminOverview,
} from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";
import { AdminPageIntro } from "./adminChrome";

type Props = {
  locale: AdminLanguage;
};

const tr = (locale: AdminLanguage, nl: string, en: string) =>
  getAdminTr(locale, nl, en);

export function WorldChatAdminPanel({ locale }: Props) {
  const [view, setView] = useState<GlobalChatAdminOverview | null>(null);
  const [blocklist, setBlocklist] = useState("");
  const [mutePlayerId, setMutePlayerId] = useState("");
  const [muteMinutes, setMuteMinutes] = useState("60");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const next = await adminService.getGlobalChatOverview();
      setView(next);
      setBlocklist(next.extraBlocklist ?? "");
    } catch (err) {
      console.error(err);
      setError(
        tr(locale, "Wereldchat laden mislukt.", "Failed to load world chat."),
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const saveBlocklist = async () => {
    setSaving(true);
    setError(null);
    setMessage(null);
    try {
      const next = await adminService.updateGlobalChatSettings({
        extraBlocklist: blocklist,
      });
      setView(next);
      setMessage(tr(locale, "Filterlijst opgeslagen.", "Filter list saved."));
    } catch (err) {
      console.error(err);
      setError(tr(locale, "Opslaan mislukt.", "Save failed."));
    } finally {
      setSaving(false);
    }
  };

  const toggleEnabled = async () => {
    if (!view) return;
    setSaving(true);
    setError(null);
    try {
      const next = await adminService.updateGlobalChatSettings({
        enabled: !view.enabled,
      });
      setView(next);
    } catch (err) {
      console.error(err);
      setError(tr(locale, "Schakelen mislukt.", "Toggle failed."));
    } finally {
      setSaving(false);
    }
  };

  return (
    <section>
      <AdminPageIntro
        kicker={tr(locale, "Sociaal · wereldchat", "Social · world chat")}
        description={tr(
          locale,
          "Open lobby voor alle spelers. Discord-brug staat in de server-env (webhook + bot), niet hier.",
          "Public lobby for every player. The Discord bridge is server env (webhook + bot), not here.",
        )}
      />
      {error ? <p className="error-text">{error}</p> : null}
      {message ? <p className="ok-text">{message}</p> : null}
      {loading && !view ? <p>{tr(locale, "Laden…", "Loading…")}</p> : null}
      {view ? (
        <>
          <div className="runtime-card" style={{ marginBottom: 16 }}>
            <p>
              {tr(locale, "Status", "Status")}:{" "}
              <strong>
                {view.enabled
                  ? tr(locale, "aan", "on")
                  : tr(locale, "uit", "off")}
              </strong>
              {" · "}
              Discord out: {view.discord.outbound ? "on" : "off"}
              {" · "}
              Discord in: {view.discord.inbound ? "on" : "off"}
            </p>
            <button type="button" disabled={saving} onClick={() => void toggleEnabled()}>
              {view.enabled
                ? tr(locale, "Chat uitzetten", "Turn chat off")
                : tr(locale, "Chat aanzetten", "Turn chat on")}
            </button>
            <button type="button" onClick={() => void load()} style={{ marginLeft: 8 }}>
              {tr(locale, "Vernieuwen", "Refresh")}
            </button>
          </div>

          <div className="runtime-card" style={{ marginBottom: 16 }}>
            <h3>{tr(locale, "Extra scheldwoorden", "Extra blocked words")}</h3>
            <p>
              {tr(
                locale,
                "Eén woord per regel. Extra bovenop de ingebouwde lijst (NL/EN/DE/FR/ES/IT/PL/PT).",
                "One word per line. Added on top of the built-in list (NL/EN/DE/FR/ES/IT/PL/PT).",
              )}
            </p>
            <textarea
              rows={6}
              value={blocklist}
              onChange={(event) => setBlocklist(event.target.value)}
              style={{ width: "100%" }}
            />
            <button type="button" disabled={saving} onClick={() => void saveBlocklist()}>
              {tr(locale, "Lijst opslaan", "Save list")}
            </button>
          </div>

          <div className="runtime-card" style={{ marginBottom: 16 }}>
            <h3>{tr(locale, "Mute", "Mute")}</h3>
            <input
              placeholder={tr(locale, "Speler-ID", "Player ID")}
              value={mutePlayerId}
              onChange={(event) => setMutePlayerId(event.target.value)}
            />
            <input
              placeholder="min"
              value={muteMinutes}
              onChange={(event) => setMuteMinutes(event.target.value)}
              style={{ width: 80, marginLeft: 8 }}
            />
            <button
              type="button"
              disabled={saving}
              style={{ marginLeft: 8 }}
              onClick={async () => {
                const playerId = Number(mutePlayerId);
                const minutes = Number(muteMinutes);
                if (!Number.isFinite(playerId) || playerId <= 0) return;
                setSaving(true);
                try {
                  await adminService.muteGlobalChatPlayer({ playerId, minutes });
                  setMutePlayerId("");
                  await load();
                } catch (err) {
                  console.error(err);
                  setError(tr(locale, "Mute mislukt.", "Mute failed."));
                } finally {
                  setSaving(false);
                }
              }}
            >
              {tr(locale, "Muten", "Mute")}
            </button>
            <ul>
              {view.mutes.map((mute) => (
                <li key={mute.playerId}>
                  {mute.username} (#{mute.playerId})
                  {mute.mutedUntil
                    ? ` → ${new Date(mute.mutedUntil).toLocaleString()}`
                    : ""}
                  <button
                    type="button"
                    style={{ marginLeft: 8 }}
                    onClick={async () => {
                      await adminService.unmuteGlobalChatPlayer(mute.playerId);
                      await load();
                    }}
                  >
                    {tr(locale, "Unmute", "Unmute")}
                  </button>
                </li>
              ))}
            </ul>
          </div>

          <div className="runtime-card">
            <h3>{tr(locale, "Recente berichten", "Recent messages")}</h3>
            {view.reports.length > 0 ? (
              <p>
                {tr(locale, "Meldingen", "Reports")}: {view.reports.length}
              </p>
            ) : null}
            <table className="data-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>{tr(locale, "Speler", "Player")}</th>
                  <th>{tr(locale, "Bron", "Source")}</th>
                  <th>{tr(locale, "Bericht", "Message")}</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {view.messages.map((row) => (
                  <tr key={row.id}>
                    <td>{row.id}</td>
                    <td>
                      {row.displayName}
                      {row.playerId ? ` (#${row.playerId})` : ""}
                    </td>
                    <td>{row.source}</td>
                    <td>{row.message}</td>
                    <td>
                      <button
                        type="button"
                        onClick={async () => {
                          await adminService.deleteGlobalChatMessage(row.id);
                          await load();
                        }}
                      >
                        {tr(locale, "Wissen", "Delete")}
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      ) : null}
    </section>
  );
}
