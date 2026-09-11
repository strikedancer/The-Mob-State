import { useEffect, useState } from "react";
import { adminService } from "../services/adminService";
import type { AdminLanguage } from "../i18n/translations";
import { getAdminTr } from "../i18n/inlineMessages";
import { EventChipGrantCard } from "./EventChipGrantCard";
import { AdminPageIntro } from "./adminChrome";

type Props = {
  locale: AdminLanguage;
  canManage: boolean;
  isSuperAdmin: boolean;
};

const TRIGGERABLE = [
  { id: "expiredEvents", nl: "Verlopen events", en: "Expired events" },
  { id: "updateLeaderboards", nl: "Leaderboards bijwerken", en: "Update leaderboards" },
  { id: "resetWeeklyLeaderboard", nl: "Weekleaderboard reset", en: "Reset weekly leaderboard" },
  { id: "cleanupRivalries", nl: "Rivalries opruimen", en: "Cleanup rivalries" },
] as const;

export function OpsAdminPanel({ locale, canManage, isSuperAdmin }: Props) {
  const l = (nl: string, en: string) => getAdminTr(locale, nl, en);
  const [status, setStatus] = useState<{
    lastExecutions?: Record<string, unknown>;
    jobs?: Record<string, string>;
  } | null>(null);
  const [loading, setLoading] = useState(true);
  const [busyJob, setBusyJob] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      setStatus(await adminService.getCronStatus());
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : l("Cron-status laden mislukt.", "Failed to load cron status."),
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void load();
  }, []);

  const trigger = async (jobName: string) => {
    if (!canManage) return;
    if (
      !window.confirm(
        l(
          `Cron "${jobName}" nu handmatig starten?`,
          `Run cron "${jobName}" now?`,
        ),
      )
    ) {
      return;
    }
    setBusyJob(jobName);
    setError(null);
    try {
      await adminService.triggerCron(jobName);
      await load();
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : l("Trigger mislukt.", "Trigger failed."),
      );
    } finally {
      setBusyJob(null);
    }
  };

  return (
    <>
      <AdminPageIntro
        kicker={l("Operaties · lab", "Operations · lab")}
        description={l(
          "Enterprise-controles: cron, event-chips en live serverjobs. Acties worden geaudit.",
          "Enterprise controls: cron, event chips and live server jobs. Actions are audited.",
        )}
      />
      {error && <div className="alert alert-danger">{error}</div>}

      <div className="ops-grid">
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h5 className="mb-0">{l("Cron-jobs", "Cron jobs")}</h5>
            <button
              type="button"
              className="btn btn-sm btn-outline-secondary"
              onClick={() => void load()}
              disabled={loading}
            >
              {l("Vernieuwen", "Refresh")}
            </button>
          </div>
          <div className="card-body">
            {loading && !status ? (
              <p className="text-muted mb-0">{l("Laden…", "Loading…")}</p>
            ) : (
              <div className="table-container">
                <table className="data-table">
                  <thead>
                    <tr>
                      <th>Job</th>
                      <th>{l("Schema", "Schedule")}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {Object.entries(status?.jobs ?? {}).map(([name, schedule]) => (
                      <tr key={name}>
                        <td>{name}</td>
                        <td>{schedule}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
            {canManage && (
              <div className="d-flex flex-wrap gap-2 mt-3">
                {TRIGGERABLE.map((job) => (
                  <button
                    key={job.id}
                    type="button"
                    className="btn btn-primary btn-sm"
                    disabled={busyJob === job.id}
                    onClick={() => void trigger(job.id)}
                  >
                    {busyJob === job.id
                      ? l("Bezig…", "Working…")
                      : l(job.nl, job.en)}
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>

        {isSuperAdmin && <EventChipGrantCard locale={locale} />}
      </div>
    </>
  );
}
