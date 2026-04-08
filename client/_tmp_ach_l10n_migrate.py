import re, json
from pathlib import Path

root = Path(r'c:/xampp/htdocs/mafia_game')
svc = (root/'backend/src/services/achievementService.ts').read_text(encoding='utf-8')

pattern = re.compile(r"\n\s*([a-z0-9_]+):\s*\{\s*\n\s*id:\s*'([^']+)',\s*\n\s*title:\s*'([^']*)',\s*\n\s*description:\s*'([^']*)',", re.M)
entries = []
for m in pattern.finditer(svc):
    key, idv, title, desc = m.groups()
    if key == idv:
        entries.append((idv, title, desc))

screen = (root/'client/lib/screens/achievements_screen.dart').read_text(encoding='utf-8')

def parse_map(var_name):
    m = re.search(rf"{var_name}\s*=\s*\{{(.*?)\n\s*\}};", screen, re.S)
    out = {}
    if not m:
        return out
    body = m.group(1)
    for k,v in re.findall(r"'([^']+)'\s*:\s*'((?:\\'|[^'])*)'", body):
        out[k] = v.replace("\\'", "'")
    return out

nl_titles = parse_map('_achievementTitleNl')
nl_descs = parse_map('_achievementDescriptionNl')

for arb_name in ['app_en.arb', 'app_nl.arb']:
    p = root/'client/lib/l10n'/arb_name
    data = json.loads(p.read_text(encoding='utf-8'))
    for aid, title, desc in entries:
        tkey = f'achievementTitle_{aid}'
        dkey = f'achievementDescription_{aid}'
        if arb_name == 'app_en.arb':
            data[tkey] = title
            data[dkey] = desc
        else:
            data[tkey] = nl_titles.get(aid, title)
            data[dkey] = nl_descs.get(aid, desc)
    p.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# generate switch methods for localized getters usage

def getter_name(prefix, aid):
    parts = aid.split('_')
    return prefix + ''.join([parts[0]] + [p.capitalize() for p in parts[1:]])

lines_title = ["  String _localizedAchievementTitle(Achievement achievement) {", "    final t = AppLocalizations.of(context)!;", "", "    switch (achievement.id) {"]
for aid, _, _ in entries:
    lines_title.append(f"      case '{aid}':")
    lines_title.append(f"        return t.{getter_name('achievementTitle', aid)};")
lines_title += ["      default:", "        return achievement.title;", "    }", "  }"]

lines_desc = ["  String _localizedAchievementDescription(Achievement achievement) {", "    final t = AppLocalizations.of(context)!;", "", "    switch (achievement.id) {"]
for aid, _, _ in entries:
    lines_desc.append(f"      case '{aid}':")
    lines_desc.append(f"        return t.{getter_name('achievementDescription', aid)};")
lines_desc += ["      default:", "        return achievement.description;", "    }", "  }"]

combined = '\n'.join(lines_title) + '\n\n' + '\n'.join(lines_desc)

screen_new = re.sub(
    r"\s*String _localizedAchievementTitle\(Achievement achievement\) \{.*?\n\s*String _localizedAchievementDescription\(Achievement achievement\) \{.*?\n\s*\}\n",
    '\n' + combined + '\n',
    screen,
    flags=re.S
)

# remove old static nl maps if present
screen_new = re.sub(r"\n\s*static const Map<String, String> _achievementTitleNl = \{.*?\n\s*\};\n", "\n", screen_new, flags=re.S)
screen_new = re.sub(r"\n\s*static const Map<String, String> _achievementDescriptionNl = \{.*?\n\s*\};\n", "\n", screen_new, flags=re.S)

(root/'client/lib/screens/achievements_screen.dart').write_text(screen_new, encoding='utf-8')
print(f'Updated ARB keys for {len(entries)} achievements and rewired screen localization.')
