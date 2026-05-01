#!/usr/bin/env node
/**
 * One-off / maintenance: parse client/lib/data/help_content.dart HelpTopic blocks
 * and emit help_topics_extracted.json with nl/en strings for ARB import.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const dartPath = path.join(root, 'client', 'lib', 'data', 'help_content.dart');
const outPath = path.join(__dirname, '_help_topics_extracted.json');

function unescapeDartString(s) {
  return s.replace(/\\'/g, "'").replace(/\\n/g, '\n');
}

function extractQuotedStringsInBrackets(block, fieldName, nextFieldPattern) {
  const startRe = new RegExp(`${fieldName}:\\s*\\[`, 'm');
  const startM = block.match(startRe);
  if (!startM) throw new Error(`No ${fieldName} in block`);
  const start = startM.index + startM[0].length;
  const rest = block.slice(start);
  const nextM = rest.match(nextFieldPattern);
  if (!nextM) throw new Error(`No terminator after ${fieldName}`);
  const inner = rest.slice(0, nextM.index);
  const items = [];
  const re = /'((?:\\'|[^'])*)'/gs;
  let m;
  while ((m = re.exec(inner))) {
    items.push(unescapeDartString(m[1]));
  }
  return items;
}

function extractMultilineQuoted(block, fieldName) {
  const re = new RegExp(`${fieldName}:\\s*\\n\\s*'((?:\\\\'|[^'])*)'`, 'm');
  const m = block.match(re);
  if (m) return unescapeDartString(m[1]);
  const re2 = new RegExp(`${fieldName}:\\s*'((?:\\\\'|[^'])*)'`, 'm');
  const m2 = block.match(re2);
  if (m2) return unescapeDartString(m2[1]);
  throw new Error(`No ${fieldName}`);
}

function extractSimpleQuoted(block, fieldName) {
  const re = new RegExp(`${fieldName}:\\s*'((?:\\\\'|[^'])*)'`, 'm');
  const m = block.match(re);
  if (!m) throw new Error(`No ${fieldName}`);
  return unescapeDartString(m[1]);
}

function splitTopics(text) {
  const listMarker = 'const List<HelpTopic> helpTopics = [';
  const listStart = text.indexOf(listMarker);
  if (listStart === -1) {
    throw new Error(`Expected ${listMarker} in ${dartPath}`);
  }
  const scanFrom = listStart + listMarker.length;
  const topics = [];
  let pos = scanFrom;
  while (true) {
    const i = text.indexOf('HelpTopic(', pos);
    if (i === -1) break;
    const depthStart = text.indexOf('(', i);
    let depth = 0;
    let j = depthStart;
    let inString = false;
    let stringQuote = null;
    let escape = false;
    for (; j < text.length; j++) {
      const c = text[j];
      if (inString) {
        if (escape) {
          escape = false;
          continue;
        }
        if (c === '\\') {
          escape = true;
          continue;
        }
        if (c === stringQuote) {
          inString = false;
          stringQuote = null;
        }
        continue;
      }
      if (c === "'" || c === '"') {
        inString = true;
        stringQuote = c;
        continue;
      }
      if (c === '(') depth++;
      else if (c === ')') {
        depth--;
        if (depth === 0) {
          j++;
          break;
        }
      }
    }
    topics.push(text.slice(i, j));
    pos = j;
  }
  return topics;
}

const text = fs.readFileSync(dartPath, 'utf8');
const blocks = splitTopics(text);
const out = [];

for (const block of blocks) {
  const id = extractSimpleQuoted(block, 'id');
  const categoryNl = extractSimpleQuoted(block, 'categoryNl');
  const categoryEn = extractSimpleQuoted(block, 'categoryEn');
  const titleNl = extractSimpleQuoted(block, 'titleNl');
  const titleEn = extractSimpleQuoted(block, 'titleEn');
  const summaryNl = extractMultilineQuoted(block, 'summaryNl');
  const summaryEn = extractMultilineQuoted(block, 'summaryEn');
  const howNl = extractQuotedStringsInBrackets(block, 'howNl', /\]\s*,\s*howEn\s*:/);
  const howEn = extractQuotedStringsInBrackets(block, 'howEn', /\]\s*,\s*tipsNl\s*:/);
  const tipsNl = extractQuotedStringsInBrackets(block, 'tipsNl', /\]\s*,\s*tipsEn\s*:/);
  const tipsEn = extractQuotedStringsInBrackets(block, 'tipsEn', /\]\s*,\s*protocolPath\s*:/);
  const protocolPath = extractSimpleQuoted(block, 'protocolPath');
  const iconM = block.match(/icon:\s*(Icons\.\w+)/);
  if (!iconM) throw new Error(`No icon: Icons.* for ${id}`);
  const icon = iconM[1];
  out.push({
    id,
    icon,
    categoryNl,
    categoryEn,
    titleNl,
    titleEn,
    summaryNl,
    summaryEn,
    howNl,
    howEn,
    tipsNl,
    tipsEn,
    protocolPath,
  });
}

fs.writeFileSync(outPath, JSON.stringify(out, null, 2), 'utf8');
console.log(`Wrote ${out.length} topics to ${path.relative(root, outPath)}`);
