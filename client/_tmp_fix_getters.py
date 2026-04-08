import re
from pathlib import Path
root = Path(r'c:/xampp/htdocs/mafia_game')
svc = (root/'backend/src/services/achievementService.ts').read_text(encoding='utf-8')
screen_path = root/'client/lib/screens/achievements_screen.dart'
screen = screen_path.read_text(encoding='utf-8')

pattern = re.compile(r"\n\s*([a-z0-9_]+):\s*\{\s*\n\s*id:\s*'([^']+)',\s*\n\s*title:\s*'([^']*)',\s*\n\s*description:\s*'([^']*)',", re.M)
ids = [m.group(2) for m in pattern.finditer(svc) if m.group(1)==m.group(2)]

lines_title = ["  String _localizedAchievementTitle(Achievement achievement) {", "    final t = AppLocalizations.of(context)!;", "", "    switch (achievement.id) {"]
for aid in ids:
    lines_title.append(f"      case '{aid}':")
    lines_title.append(f"        return t.achievementTitle_{aid};")
lines_title += ["      default:", "        return achievement.title;", "    }", "  }"]

lines_desc = ["  String _localizedAchievementDescription(Achievement achievement) {", "    final t = AppLocalizations.of(context)!;", "", "    switch (achievement.id) {"]
for aid in ids:
    lines_desc.append(f"      case '{aid}':")
    lines_desc.append(f"        return t.achievementDescription_{aid};")
lines_desc += ["      default:", "        return achievement.description;", "    }", "  }"]

replacement = '\n'.join(lines_title) + '\n\n' + '\n'.join(lines_desc)
screen_new = re.sub(
    r"\s*String _localizedAchievementTitle\(Achievement achievement\) \{.*?\n\s*String _localizedAchievementDescription\(Achievement achievement\) \{.*?\n\s*\}\n",
    '\n' + replacement + '\n',
    screen,
    flags=re.S
)
screen_path.write_text(screen_new, encoding='utf-8')
print(f'Updated localization getter calls for {len(ids)} achievements.')
