const MAX = 500;
const lines: string[] = [];

export function logLine(source: string, message: string, data?: unknown): void {
  const ts = new Date().toISOString();
  const extra = data !== undefined ? ` ${JSON.stringify(data)}` : "";
  const line = `[${ts}] [${source}] ${message}${extra}`;
  console.log(line);
  lines.push(line);
  if (lines.length > MAX) {
    lines.splice(0, lines.length - MAX);
  }
}

export function getRecentLogs(): string[] {
  return [...lines];
}
