import type { SupportedPlayerLanguage } from '../config/supportedLanguages';

export type JobIntelPayload =
  | { type: 'territory_contest'; regionName: string; contestStatus: string }
  | { type: 'territory_hotspot'; regionName: string; valueTier: number }
  | { type: 'live_event'; eventTitle: string }
  | { type: 'hitlist_chatter'; targetName: string; bounty: number }
  | { type: 'police_whisper'; regionName: string };

type IntelFormatter = (payload: JobIntelPayload) => string;

const INTEL_INBOX: Record<SupportedPlayerLanguage, Record<JobIntelPayload['type'], IntelFormatter>> = {
  en: {
    territory_contest: (p) =>
      `🕵️ Street intel — Territory tip\nHeard on the job: ${(p as Extract<JobIntelPayload, { type: 'territory_contest' }>).regionName} is contested (${(p as Extract<JobIntelPayload, { type: 'territory_contest' }>).contestStatus}). Worth a look on the map.`,
    territory_hotspot: (p) => {
      const payload = p as Extract<JobIntelPayload, { type: 'territory_hotspot' }>;
      return `🕵️ Street intel — Hot region\nDrivers mention heavy traffic around ${payload.regionName} (tier ${payload.valueTier}). Crews may be sniffing around.`;
    },
    live_event: (p) =>
      `🕵️ Street intel — Event chatter\nSomeone at work mentioned "${(p as Extract<JobIntelPayload, { type: 'live_event' }>).eventTitle}" — extra points on the board right now.`,
    hitlist_chatter: (p) => {
      const payload = p as Extract<JobIntelPayload, { type: 'hitlist_chatter' }>;
      return `🕵️ Street intel — Contract whisper\nBar talk: ${payload.targetName} has a €${payload.bounty.toLocaleString('en-US')} contract on the wire.`;
    },
    police_whisper: (p) =>
      `🕵️ Street intel — Patrol pattern\nUniforms circling ${(p as Extract<JobIntelPayload, { type: 'police_whisper' }>).regionName} tonight. Keep your head down if you're running hot.`,
  },
  nl: {
    territory_contest: (p) =>
      `🕵️ Straatintel — Territoriumtip\nOpgepikt tijdens werk: ${(p as Extract<JobIntelPayload, { type: 'territory_contest' }>).regionName} is omstreden (${(p as Extract<JobIntelPayload, { type: 'territory_contest' }>).contestStatus}). Check de kaart.`,
    territory_hotspot: (p) => {
      const payload = p as Extract<JobIntelPayload, { type: 'territory_hotspot' }>;
      return `🕵️ Straatintel — Hot gebied\nChauffeurs fluisteren over drukte rond ${payload.regionName} (tier ${payload.valueTier}). Crews snuffelen mee.`;
    },
    live_event: (p) =>
      `🕵️ Straatintel — Event-roddel\nIemand op werk noemde "${(p as Extract<JobIntelPayload, { type: 'live_event' }>).eventTitle}" — nu extra punten te pakken.`,
    hitlist_chatter: (p) => {
      const payload = p as Extract<JobIntelPayload, { type: 'hitlist_chatter' }>;
      return `🕵️ Straatintel — Contractfluister\nKroegpraat: er ligt €${payload.bounty.toLocaleString('nl-NL')} op ${payload.targetName}.`;
    },
    police_whisper: (p) =>
      `🕵️ Straatintel — Patrouille\nUniformen cirkelen rond ${(p as Extract<JobIntelPayload, { type: 'police_whisper' }>).regionName} vanavond. Lager profiel houden als je heat hebt.`,
  },
  de: {
    territory_contest: (p) => INTEL_INBOX.en.territory_contest(p),
    territory_hotspot: (p) => INTEL_INBOX.en.territory_hotspot(p),
    live_event: (p) => INTEL_INBOX.en.live_event(p),
    hitlist_chatter: (p) => INTEL_INBOX.en.hitlist_chatter(p),
    police_whisper: (p) => INTEL_INBOX.en.police_whisper(p),
  },
  fr: {
    territory_contest: (p) => INTEL_INBOX.en.territory_contest(p),
    territory_hotspot: (p) => INTEL_INBOX.en.territory_hotspot(p),
    live_event: (p) => INTEL_INBOX.en.live_event(p),
    hitlist_chatter: (p) => INTEL_INBOX.en.hitlist_chatter(p),
    police_whisper: (p) => INTEL_INBOX.en.police_whisper(p),
  },
  es: {
    territory_contest: (p) => INTEL_INBOX.en.territory_contest(p),
    territory_hotspot: (p) => INTEL_INBOX.en.territory_hotspot(p),
    live_event: (p) => INTEL_INBOX.en.live_event(p),
    hitlist_chatter: (p) => INTEL_INBOX.en.hitlist_chatter(p),
    police_whisper: (p) => INTEL_INBOX.en.police_whisper(p),
  },
  it: {
    territory_contest: (p) => INTEL_INBOX.en.territory_contest(p),
    territory_hotspot: (p) => INTEL_INBOX.en.territory_hotspot(p),
    live_event: (p) => INTEL_INBOX.en.live_event(p),
    hitlist_chatter: (p) => INTEL_INBOX.en.hitlist_chatter(p),
    police_whisper: (p) => INTEL_INBOX.en.police_whisper(p),
  },
  pl: {
    territory_contest: (p) => INTEL_INBOX.en.territory_contest(p),
    territory_hotspot: (p) => INTEL_INBOX.en.territory_hotspot(p),
    live_event: (p) => INTEL_INBOX.en.live_event(p),
    hitlist_chatter: (p) => INTEL_INBOX.en.hitlist_chatter(p),
    police_whisper: (p) => INTEL_INBOX.en.police_whisper(p),
  },
  pt: {
    territory_contest: (p) => INTEL_INBOX.en.territory_contest(p),
    territory_hotspot: (p) => INTEL_INBOX.en.territory_hotspot(p),
    live_event: (p) => INTEL_INBOX.en.live_event(p),
    hitlist_chatter: (p) => INTEL_INBOX.en.hitlist_chatter(p),
    police_whisper: (p) => INTEL_INBOX.en.police_whisper(p),
  },
};

export function formatJobIntelInboxMessage(
  language: SupportedPlayerLanguage,
  payload: JobIntelPayload,
): string {
  const bundle = INTEL_INBOX[language] ?? INTEL_INBOX.en;
  return bundle[payload.type](payload);
}
