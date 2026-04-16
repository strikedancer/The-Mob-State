# Git Workflow – The Mob State

## Iets aanpassen en naar GitHub pushen

Standaard blokkeert deze repository directe pushes naar `main` en `master` via de repo-local `pre-push` hook. De normale route is dus: feature branch maken, committen, pushen naar die branch en daarna een pull request openen.

```bash
# 1. Maak een werkbranch
git checkout -b fix/mijn-wijziging

# 2. Bekijk wat je hebt aangepast
git status

# 3. Voeg alles toe
git add .

# 4. Commit met omschrijving
git commit -m "Beschrijf wat je hebt aangepast"

# 5. Push je branch naar GitHub
git push -u origin HEAD
```

## Nooduitzondering

Alleen als een directe push naar `main` of `master` echt bewust nodig is, kun je de lokale blokkade eenmalig overriden:

```bash
ALLOW_MAIN_PUSH=1 git push origin main
```

Dat voorkomt niet de GitHub-ruleset zelf, maar zorgt wel dat deze repo lokaal niet meer per ongeluk direct naar `main` pusht.

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
git checkout -b mijn-branch → git add . → git commit -m "..." → git push -u origin HEAD
```

Als commit geweigerd wordt: eerst het bijpassende protocol bijwerken, dan opnieuw `git add .` en committen.
Als push geweigerd wordt: controleer of je per ongeluk naar `main` of `master` pusht.
