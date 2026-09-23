# Hinweise für Claude

## Git-Workflow
- Änderungen direkt auf `main` committen und pushen, keine Feature-Branches und keine Pull Requests.
- Cloudflare Pages ist mit GitHub verbunden: jeder Push auf `main` wird automatisch live deployt.
- Datenbank-Migrationen (`migrations/*.sql`) laufen NICHT automatisch mit. Nach einer neuen Migration dem Nutzer den SQL-Text für die D1-Konsole im Cloudflare-Dashboard (bzw. den `wrangler d1 execute`-Befehl) geben.
- Wenn `app.js`/`style.css`/`index.html` geändert werden, `CACHE_NAME` in `src/sw.js` hochzählen, sonst sehen installierte PWAs die Änderung nicht.
