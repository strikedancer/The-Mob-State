# Git Workflow – The Mob State

## Iets aanpassen en naar GitHub pushen

```bash
# 1. Bekijk wat je hebt aangepast
git status

# 2. Voeg alles toe
git add .

# 3. Commit met omschrijving
git commit -m "Beschrijf wat je hebt aangepast"

# 4. Push naar GitHub
git push
```

## Als je gameplay code aanpast

Gameplay bestanden zijn alles in `client/lib/`, `backend/src/` of `admin/src/`.

Bij stap 3 blokkeert de pre-commit hook de commit totdat je ook een doc hebt bijgewerkt:
- Pas het bijpassende protocol aan in `docs/module-protocols/*.md`  
- én/of pas `GAMEPLAY.md` of een ander handleiding-bestand aan

Daarna opnieuw `git add .` en dan werkt de commit wel.

## Welk protocol hoort bij welk onderdeel?

| Onderdeel             | Protocol bestand                              |
|-----------------------|-----------------------------------------------|
| Prostitutie           | docs/module-protocols/prostitution.md         |
| Eigendommen           | docs/module-protocols/properties.md           |
| Algemeen / meerdere   | docs/module-protocols/PROTOCOL_MASTER.md      |

## Kortste versie om te onthouden

```
git add . → git commit -m "..." → git push
```

Als commit geweigerd wordt: eerst het bijpassende protocol bijwerken, dan opnieuw `git add .` en committen.
