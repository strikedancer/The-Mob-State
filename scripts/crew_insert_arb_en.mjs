import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, '..');
const arbPath = path.join(root, 'client', 'lib', 'l10n', 'app_en.arb');
let t = fs.readFileSync(arbPath, 'utf8');
const a = fs.readFileSync(path.join(__dirname, '_crew_ui_en_arb_fragment.txt'), 'utf8');
const b = fs.readFileSync(path.join(__dirname, '_crew_tr_en_arb.txt'), 'utf8');
const extra = `  "crewUiHqUpgradeSideBuildingsMessage": "Upgrade all side buildings to at least level {level} first.\\n\\nMissing:\\n{missing}",
  "@crewUiHqUpgradeSideBuildingsMessage": {
    "placeholders": {
      "level": {"type": "String"},
      "missing": {"type": "String"}
    }
  },
`;
const insert = `${a.trimEnd()}\n${extra}${b.trimEnd()}\n`;
const needle = '  "premiumUiLoadError":';
const i = t.indexOf(needle);
if (i < 0) throw new Error('needle not found');
t = t.slice(0, i) + insert + t.slice(i);
fs.writeFileSync(arbPath, t, 'utf8');
console.log('Inserted crew keys into app_en.arb');
