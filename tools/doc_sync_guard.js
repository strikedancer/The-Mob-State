#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');

function run(cmd) {
  return execSync(cmd, {
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
    maxBuffer: 50 * 1024 * 1024,
  }).trim();
}

function isInsideGitRepo() {
  try {
    return run('git rev-parse --is-inside-work-tree') === 'true';
  } catch (_) {
    return false;
  }
}

function hasGitHead() {
  try {
    run('git rev-parse --verify HEAD');
    return true;
  } catch (_) {
    return false;
  }
}

function normalize(p) {
  return p.replace(/\\/g, '/').replace(/^\.\//, '');
}

function getChangedFiles(mode) {
  let cmd;
  if (mode === 'staged') {
    cmd = 'git diff --cached --name-only --diff-filter=ACMR';
  } else {
    cmd = hasGitHead()
      ? 'git diff --name-only --diff-filter=ACMR HEAD'
      : 'git diff --cached --name-only --diff-filter=ACMR';
  }
  const output = run(cmd);
  if (!output) return [];
  return output.split(/\r?\n/).map(normalize).filter(Boolean);
}

function isGameplayFile(file) {
  if (file.startsWith('client/lib/')) return true;
  if (file.startsWith('backend/src/')) return true;
  if (file.startsWith('admin/src/')) return true;
  return false;
}

function isProtocolFile(file) {
  return file.startsWith('docs/module-protocols/') && file.toLowerCase().endsWith('.md');
}

function isManualFile(file) {
  const lower = file.toLowerCase();
  if (!lower.endsWith('.md')) return false;
  if (lower.startsWith('docs/module-protocols/')) return false;

  if (lower === 'gameplay.md') return true;
  if (lower.startsWith('docs/')) return true;
  if (lower.includes('guide')) return true;
  if (lower.includes('handleiding')) return true;
  if (lower.includes('readme')) return true;

  return false;
}

function main() {
  if (!isInsideGitRepo()) {
    console.log('[doc-sync] Skipped: not running inside a git work tree.');
    return;
  }

  const modeArg = process.argv.includes('--all') ? 'all' : 'staged';
  const files = getChangedFiles(modeArg);

  if (files.length === 0) {
    console.log('[doc-sync] No changed files to validate.');
    return;
  }

  const gameplayFiles = files.filter(isGameplayFile);
  if (gameplayFiles.length === 0) {
    console.log('[doc-sync] No gameplay code changes detected.');
    return;
  }

  const protocolFiles = files.filter(isProtocolFile);
  const manualFiles = files.filter(isManualFile);

  const missingProtocol = protocolFiles.length === 0;
  const missingManual = manualFiles.length === 0;

  if (!missingProtocol && !missingManual) {
    console.log('[doc-sync] OK: gameplay changes include protocol and handleiding/manual updates.');
    return;
  }

  console.error('\n[doc-sync] Validation failed. Gameplay code changed without required docs updates.\n');
  console.error('Changed gameplay files:');
  gameplayFiles.forEach((f) => console.error(`  - ${f}`));

  if (missingProtocol) {
    console.error('\nMissing protocol update:');
    console.error('  - Update at least one file in docs/module-protocols/*.md');
  }

  if (missingManual) {
    console.error('\nMissing handleiding/manual update:');
    console.error('  - Update a gameplay-facing markdown file such as:');
    console.error('    * GAMEPLAY.md');
    console.error('    * docs/**/*.md (excluding docs/module-protocols)');
    console.error('    * *GUIDE*.md / *HANDLEIDING*.md / README*.md');
  }

  console.error('\nIf no docs change is truly required, set DOC_SYNC_BYPASS=1 for this run.');
  process.exit(1);
}

if (process.env.DOC_SYNC_BYPASS === '1') {
  console.log('[doc-sync] Bypassed via DOC_SYNC_BYPASS=1');
  process.exit(0);
}

try {
  main();
} catch (err) {
  console.error('[doc-sync] Guard failed to execute:', err.message || err);
  process.exit(2);
}
