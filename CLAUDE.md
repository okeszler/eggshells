# Hinweise für Claude

## Git-Workflow
- Änderungen direkt auf `main` committen und pushen, keine Feature-Branches und keine Pull Requests.
- Cloudflare Pages ist mit GitHub verbunden: jeder Push auf `main` wird automatisch live deployt.
- Datenbank-Migrationen (`migrations/*.sql`) spielt die GitHub Action `.github/workflows/migrations.yml` bei jedem Push auf `main` automatisch ein (Einrichtung siehe README, "Laufende Wartung"). Solange der Nutzer nicht bestätigt hat, dass die Action eingerichtet ist und läuft, zusätzlich den SQL-Text für die D1-Konsole geben (auf dem Handy in Blöcken im Chat, dort gibt es kein "Copy raw file").
- Bereits eingespielte Migrationsdateien nie ändern, immer eine neue mit der nächsten Nummer anlegen. Migrationen so bauen, dass der gerade laufende Code damit weiter funktioniert, weil Code-Deploy und Migration parallel laufen.
- Neue API-Endpunkte brauchen keine eigene Anmeldeprüfung: `functions/api/_middleware.js` schützt alle `/api/`-Routen außer `/api/auth`.
- Wenn `app.js`/`style.css`/`index.html` geändert werden, `CACHE_NAME` in `src/sw.js` hochzählen, sonst sehen installierte PWAs die Änderung nicht.
