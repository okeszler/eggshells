# Leave the eggshells

App für Menschen in Beziehung mit PTBS/BPD-Partner:innen. Wissen, Skills, Selbstfürsorge.

## Stack
Cloudflare Pages + D1 (SQLite), Vanilla JS Frontend – gleiches Muster wie gym-tracker, putzplan, health-metrics-tracker. PIN-Schutz über signiertes Auth-Cookie (analog zu darlehen_violeta).

## Status
- ✅ Wissen & Mustererkennung: Datenmodell, Seed-Daten (6 Muster), API, Frontend-Liste mit Aufklapp-Details
- ✅ Log: Formular (Zeitpunkt, Notiz, Stimmung vorher/nachher, Musterzuordnung) + Liste + Löschen
- ✅ Selbstfürsorge: Formular (Datum, Aktion per Preset oder frei, Notiz) + Liste + Löschen
- ✅ Krisenmodus: Schritte + Kontakte, im "Bearbeiten"-Modus selbst befüllbar (Inhalte bewusst nicht Teil der Seed-Daten)
- ✅ PIN-Schutz für die ganze App (Cookie-basiert, `APP_PIN` + `COOKIE_SECRET` als Cloudflare-Secrets)

## Setup

```bash
npm install
wrangler login
wrangler d1 create eggshells-db
# database_id aus der Ausgabe in wrangler.toml eintragen
npm run db:init
npm run db:seed
wrangler pages secret put APP_PIN --project-name=eggshells
wrangler pages secret put COOKIE_SECRET --project-name=eggshells
npm run deploy
```

Danach im Cloudflare-Dashboard einmalig: **Workers & Pages → eggshells → Settings → Functions → D1 database bindings** →
Binding `DB` auf `eggshells-db` setzen, dann erneut `npm run deploy`.

## Lokal entwickeln

```bash
npm run dev
```

## Laufende Wartung
- **Code-Änderungen:** `npm run deploy` erneut ausführen. URL bleibt gleich.
- **Schema-Änderungen:** neue Migration in `migrations/` anlegen, mit `wrangler d1 execute eggshells-db --remote --file=migrations/000X_....sql` einspielen.
