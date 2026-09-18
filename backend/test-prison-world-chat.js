'use strict';

function formatJailDurationNl(minutesRaw) {
  const minutes = Math.max(1, Math.round(Number(minutesRaw) || 0));
  const hours = Math.floor(minutes / 60);
  const rest = minutes % 60;
  if (hours <= 0) {
    return minutes === 1 ? '1 minuut' : `${minutes} minuten`;
  }
  const hourPart = hours === 1 ? '1 uur' : `${hours} uur`;
  if (rest === 0) return hourPart;
  const minPart = rest === 1 ? '1 minuut' : `${rest} minuten`;
  return `${hourPart} en ${minPart}`;
}

function buildJailAnnouncement(username, authority, jailTimeMinutes) {
  const name = String(username || 'Speler').replace(/[\r\n\t]+/g, ' ').trim().slice(0, 32) || 'Speler';
  const duration =
    jailTimeMinutes != null && jailTimeMinutes > 0
      ? ` voor ${formatJailDurationNl(jailTimeMinutes)}`
      : '';
  const key = String(authority || '').toLowerCase();
  if (key.includes('black_money') || key.includes('zwart')) {
    return `${name} is opgepakt wegens zwart geld${duration}.`;
  }
  if (key.includes('fbi')) return `${name} is opgepakt door de FBI${duration}.`;
  if (key.includes('border') || key.includes('grens')) {
    return `${name} is opgepakt door de grenspolitie${duration}.`;
  }
  return `${name} is opgepakt door de politie${duration}.`;
}

function assertEqual(actual, expected, label) {
  if (actual !== expected) {
    throw new Error(`${label}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
}

assertEqual(formatJailDurationNl(1), '1 minuut', 'one minute');
assertEqual(formatJailDurationNl(45), '45 minuten', 'minutes only');
assertEqual(formatJailDurationNl(60), '1 uur', 'exact hour');
assertEqual(formatJailDurationNl(90), '1 uur en 30 minuten', 'hour and minutes');
assertEqual(formatJailDurationNl(125), '2 uur en 5 minuten', 'two hours');
assertEqual(
  buildJailAnnouncement('Rico', 'Police', 45),
  'Rico is opgepakt door de politie voor 45 minuten.',
  'police line',
);
assertEqual(
  buildJailAnnouncement('Rico', 'FBI', 90),
  'Rico is opgepakt door de FBI voor 1 uur en 30 minuten.',
  'fbi line',
);
assertEqual(
  buildJailAnnouncement('Rico', 'black_money', 30),
  'Rico is opgepakt wegens zwart geld voor 30 minuten.',
  'black money line',
);

console.log('test-prison-world-chat: ok');
