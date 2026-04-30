import type { SupportedPlayerLanguage } from '../config/supportedLanguages';

/** BCP-47 style locale for number formatting in achievement inbox / activity lines */
export const ACHIEVEMENT_NUMBER_LOCALE: Record<SupportedPlayerLanguage, string> = {
  en: 'en-US',
  nl: 'nl-NL',
  de: 'de-DE',
  fr: 'fr-FR',
  es: 'es-ES',
  it: 'it-IT',
  pl: 'pl-PL',
  pt: 'pt-PT',
};

type InboxPhrases = {
  header: (title: string) => string;
  rewardHeading: string;
  lineMoney: (amount: string) => string;
  lineXp: (amount: string) => string;
  lineReputation: (amount: string) => string;
  badgeLine: (icon: string, title: string) => string;
};

const INBOX: Record<SupportedPlayerLanguage, InboxPhrases> = {
  en: {
    header: (title) => `🏆 Achievement Unlocked: ${title}`,
    rewardHeading: 'Reward:',
    lineMoney: (amount) => `• Money: €${amount}`,
    lineXp: (amount) => `• XP: ${amount}`,
    lineReputation: (amount) => `• Reputation: +${amount}`,
    badgeLine: (icon, title) => `🎖 Badge: ${icon} ${title}`,
  },
  nl: {
    header: (title) => `🏆 Prestatie vrijgespeeld: ${title}`,
    rewardHeading: 'Beloning:',
    lineMoney: (amount) => `• Geld: €${amount}`,
    lineXp: (amount) => `• XP: ${amount}`,
    lineReputation: (amount) => `• Reputatie: +${amount}`,
    badgeLine: (icon, title) => `🎖 Badge: ${icon} ${title}`,
  },
  de: {
    header: (title) => `🏆 Erfolg freigeschaltet: ${title}`,
    rewardHeading: 'Belohnung:',
    lineMoney: (amount) => `• Geld: €${amount}`,
    lineXp: (amount) => `• EP: ${amount}`,
    lineReputation: (amount) => `• Ruf: +${amount}`,
    badgeLine: (icon, title) => `🎖 Abzeichen: ${icon} ${title}`,
  },
  fr: {
    header: (title) => `🏆 Succès débloqué : ${title}`,
    rewardHeading: 'Récompense :',
    lineMoney: (amount) => `• Argent : €${amount}`,
    lineXp: (amount) => `• XP : ${amount}`,
    lineReputation: (amount) => `• Réputation : +${amount}`,
    badgeLine: (icon, title) => `🎖 Insigne : ${icon} ${title}`,
  },
  es: {
    header: (title) => `🏆 Logro desbloqueado: ${title}`,
    rewardHeading: 'Recompensa:',
    lineMoney: (amount) => `• Dinero: €${amount}`,
    lineXp: (amount) => `• XP: ${amount}`,
    lineReputation: (amount) => `• Reputación: +${amount}`,
    badgeLine: (icon, title) => `🎖 Insignia: ${icon} ${title}`,
  },
  it: {
    header: (title) => `🏆 Obiettivo sbloccato: ${title}`,
    rewardHeading: 'Ricompensa:',
    lineMoney: (amount) => `• Denaro: €${amount}`,
    lineXp: (amount) => `• XP: ${amount}`,
    lineReputation: (amount) => `• Reputazione: +${amount}`,
    badgeLine: (icon, title) => `🎖 Distintivo: ${icon} ${title}`,
  },
  pl: {
    header: (title) => `🏆 Osiągnięcie odblokowane: ${title}`,
    rewardHeading: 'Nagroda:',
    lineMoney: (amount) => `• Pieniądze: €${amount}`,
    lineXp: (amount) => `• PD: ${amount}`,
    lineReputation: (amount) => `• Reputacja: +${amount}`,
    badgeLine: (icon, title) => `🎖 Odznaka: ${icon} ${title}`,
  },
  pt: {
    header: (title) => `🏆 Conquista desbloqueada: ${title}`,
    rewardHeading: 'Recompensa:',
    lineMoney: (amount) => `• Dinheiro: €${amount}`,
    lineXp: (amount) => `• XP: ${amount}`,
    lineReputation: (amount) => `• Reputação: +${amount}`,
    badgeLine: (icon, title) => `🎖 Emblema: ${icon} ${title}`,
  },
};

const ACTIVITY: Record<SupportedPlayerLanguage, (title: string) => string> = {
  en: (title) => `Achievement unlocked: ${title}`,
  nl: (title) => `Prestatie vrijgespeeld: ${title}`,
  de: (title) => `Erfolg freigeschaltet: ${title}`,
  fr: (title) => `Succès débloqué : ${title}`,
  es: (title) => `Logro desbloqueado: ${title}`,
  it: (title) => `Obiettivo sbloccato: ${title}`,
  pl: (title) => `Osiągnięcie odblokowane: ${title}`,
  pt: (title) => `Conquista desbloqueada: ${title}`,
};

export function formatAchievementInboxMessage(
  language: SupportedPlayerLanguage,
  input: {
    title: string;
    description: string;
    icon: string;
    rewardMoney: number;
    rewardXp: number;
    rewardReputation: number;
    category: string;
    achievementId: string;
  }
): string {
  const locale = ACHIEVEMENT_NUMBER_LOCALE[language] ?? 'en-US';
  const p = INBOX[language] ?? INBOX.en;
  const { title, description, icon, rewardMoney, rewardXp, rewardReputation, category, achievementId } = input;

  const m = rewardMoney.toLocaleString(locale);
  const x = rewardXp.toLocaleString(locale);
  const r = rewardReputation.toLocaleString(locale);

  const lines = [
    p.header(title),
    '',
    description,
    '',
    p.rewardHeading,
    p.lineMoney(m),
    p.lineXp(x),
    p.lineReputation(r),
    '',
    p.badgeLine(icon, title),
    `[[achievement:${category}/${achievementId}]]`,
  ];

  return lines.join('\n');
}

export function getAchievementUnlockedActivityLogMessage(
  language: SupportedPlayerLanguage,
  displayTitle: string
): string {
  return (ACTIVITY[language] ?? ACTIVITY.en)(displayTitle);
}
