# eggshells

App für Menschen in Beziehung mit PTBS/BPD-Partner:innen. Wissen, Skills, Selbstfürsorge.

## Stack
Cloudflare Pages + D1 (SQLite), Vanilla JS Frontend – gleiches Muster wie gym-tracker, putzplan, health-metrics-tracker. PIN-Schutz über signiertes Auth-Cookie (analog zu darlehen_violeta).

## Status
- ✅ Wissen & Mustererkennung: Datenmodell, 53 Muster über alle Kategorien (Migration `0009` füllt vormals dünne Kategorien auf, `0010` ergänzt PTBS-Kernsymptome: Intrusionen, Vermeidung, Übererregung, Schlaf, Trigger-Ketten, Jahrestage, negative Grundannahmen), API, Frontend-Liste mit Aufklapp-Details
- ✅ Skills: erprobte Sätze & Werkzeuge nach Eskalationsstufe (Früh / Mitte / Spät), 11 Karten (Migrationen `0007`/`0008`), API `/api/skills`, eigener Tab mit sichtbaren Beispielsätzen und aufklappbarem "wann hilft's / wann nicht"
- ✅ Log: Formular (Zeitpunkt, Notiz, Stimmung vorher/nachher, Musterzuordnung) + Liste + Löschen
- ✅ Selbstfürsorge: Formular (Datum, Aktion per Preset oder frei, Notiz) + Liste + Löschen
- ✅ Krisenmodus: Schritte + Kontakte, im "Bearbeiten"-Modus selbst befüllbar (Inhalte bewusst nicht Teil der Seed-Daten)
- ✅ PIN-Schutz für die ganze App (Cookie-basiert, `APP_PIN` + `COOKIE_SECRET` als Cloudflare-Secrets)
- ✅ Forschung: 7 Karten (Programme, Modelle, PTBS-spezifisch, Literatur, Anlaufstellen) mit Evidenz-Badge, Relevanz und Pflichtfeld Einschränkungen, `research`/`research_patterns`/`research_skills` (Migration `0011`), API `/api/research`, Tab mit Kategorie-Filter; Muster-/Skill-Karten zeigen "Belegt durch: …" mit Sprung zur Quelle

## Nächste Schritte
- Log mit Skills verknüpfen: pro Eintrag festhalten, welcher Skill eingesetzt wurde und ob er gewirkt hat, damit sich zeigt, was in der Praxis wirklich funktioniert
- Eigene Skills in der App anlegen/bearbeiten (analog zum Bearbeiten-Modus im Krisen-Tab), statt nur über Migrationen
- Im Krisen-Tab auf die Stufe "Spät" (physischer Ausstieg) verlinken
- HPE Oberösterreich prüfen: Angebot für Angehörige/Partner:innen dort noch nicht verifiziert (siehe Forschungskarte "HPE Österreich")
- Partner-spezifische Studien ergänzen, sobald gefunden (aktuelle Evidenz ist überwiegend an gemischten Angehörigengruppen/Eltern erhoben)

## Setup

```bash
npm install
wrangler login
wrangler d1 create eggshells-db
# database_id aus der Ausgabe in wrangler.toml eintragen
npm run db:init
npm run db:seed
# danach die übrigen Migrationen der Reihe nach einspielen (0003 … 0011), z.B.:
wrangler d1 execute eggshells-db --remote --file=migrations/0011_research.sql
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
