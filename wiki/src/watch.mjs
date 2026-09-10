import { spawn } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const argv = process.argv.slice(2);
const skipInitial = argv.includes('--skip-initial');
const args = Object.fromEntries(
  argv.reduce((acc, cur, i, arr) => {
    if (cur.startsWith('--') && cur !== '--skip-initial') acc.push([cur.slice(2), arr[i + 1]]);
    return acc;
  }, [])
);

const SRC = path.resolve(args.src || __dirname);
const CONTENT = path.resolve(args.content || path.join(SRC, '..', '..', 'backend', 'content'));
const OUT = path.resolve(args.out || path.join(SRC, '..', 'dist'));
const BUILD = path.join(SRC, 'build.mjs');
const L10N = args.l10n ? path.resolve(args.l10n) : '';
const HELP_INDEX = args['help-index'] ? path.resolve(args['help-index']) : '';
const DEBOUNCE_MS = 1500;
const WATCH_EXT = new Set(['.json', '.mjs', '.js', '.css', '.dart', '.arb']);

function runBuild(outDir) {
  return new Promise((resolve, reject) => {
    const cmd = [BUILD, '--content', CONTENT, '--out', outDir];
    if (L10N) cmd.push('--l10n', L10N);
    if (HELP_INDEX) cmd.push('--help-index', HELP_INDEX);
    const child = spawn(process.execPath, cmd, {
      stdio: 'inherit',
    });
    child.on('error', reject);
    child.on('exit', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`almanac build exited ${code}`));
    });
  });
}

function swapDir(staging, dest) {
  const prev = `${dest}.prev`;
  fs.rmSync(prev, { recursive: true, force: true });
  if (fs.existsSync(dest)) fs.renameSync(dest, prev);
  try {
    fs.renameSync(staging, dest);
  } catch (err) {
    if (fs.existsSync(prev) && !fs.existsSync(dest)) fs.renameSync(prev, dest);
    throw err;
  }
  fs.rmSync(prev, { recursive: true, force: true });
}

let building = false;
let queued = false;

async function rebuild(reason) {
  if (building) {
    queued = true;
    return;
  }
  building = true;
  const staging = `${OUT}.next`;
  try {
    fs.rmSync(staging, { recursive: true, force: true });
    console.log(`wiki: rebuilding (${reason})`);
    await runBuild(staging);
    swapDir(staging, OUT);
    console.log(`wiki: almanac ready → ${OUT}`);
  } catch (err) {
    fs.rmSync(staging, { recursive: true, force: true });
    console.error(`wiki: rebuild failed: ${err.message || err}`);
  } finally {
    building = false;
    if (queued) {
      queued = false;
      await rebuild('queued change');
    }
  }
}

function shouldWatch(filePath) {
  return WATCH_EXT.has(path.extname(filePath).toLowerCase());
}

function watchTree(dir, label) {
  if (!fs.existsSync(dir)) {
    console.warn(`wiki: skip watch, missing ${label} ${dir}`);
    return;
  }
  let timer = null;
  fs.watch(dir, { recursive: true }, (_event, filename) => {
    if (filename && !shouldWatch(filename)) return;
    clearTimeout(timer);
    timer = setTimeout(() => {
      rebuild(`${label} ${filename || 'changed'}`).catch((err) => {
        console.error(err);
      });
    }, DEBOUNCE_MS);
  });
  console.log(`wiki: watching ${label} ${dir}`);
}

if (!fs.existsSync(BUILD)) {
  console.error(`wiki: missing generator ${BUILD}`);
  process.exit(1);
}

if (!skipInitial) {
  await rebuild('startup');
}

watchTree(CONTENT, 'content');
watchTree(SRC, 'templates');
if (L10N) watchTree(L10N, 'help-l10n');
if (HELP_INDEX) watchTree(path.dirname(HELP_INDEX), 'help-index');

await new Promise(() => {});
