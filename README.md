# eggshells

App für Menschen in Beziehung mit PTBS/BPD-Partner:innen. Wissen, Skills, Selbstfürsorge.

## Stack
Cloudflare Pages + D1 (SQLite), Vanilla JS Frontend – gleiches Muster wie gym-tracker, putzplan, health-metrics-tracker. PIN-Schutz über signiertes Auth-Cookie (analog zu darlehen_violeta).

## Status
- ✅ Wissen & Mustererkennung: Datenmodell, 59 Muster über alle Kategorien (Migration `0009` füllt vormals dünne Kategorien auf, `0010` ergänzt PTBS-Kernsymptome, `0012` ergänzt Eiszeit-Zyklus, Instanz ohne Gesetzbuch, Gefühl validieren ≠ Realität verbiegen, Beratungsresistenz, Überbringer wird zum Feind, Nur zuhören statt lösen), API, Frontend-Liste mit Aufklapp-Details. Sortierung seit `0012` in Zehnerschritten, damit verwandte Karten nebeneinander eingefügt werden können
- ✅ Skills: erprobte Sätze & Werkzeuge nach Eskalationsstufe (Früh / Mitte / Spät / Danach), 22 Karten (Migrationen `0007`/`0008`/`0012`/`0014`/`0015`, darunter "Übersetzen in beide Richtungen" in der Stufe Danach, u.a. Gelbe und Rote Karte, Validieren + Grenze in einem Satz, Erst Angst spiegeln dann Fakten; Stufe "Danach" mit Nachsorge für sich selbst, Wiederannäherung ohne Druck, Nachbesprechung als Ritual, eigener Anteil, Abschließen ohne Entschuldigung, Timing für Lösungsgespräche), optionales Hinweisfeld `callout` (z.B. "Was ist Rot?"), API `/api/skills`, eigener Tab mit sichtbaren Beispielsätzen und aufklappbarem "wann hilft's / wann nicht"
- ✅ Log: Formular (Zeitpunkt, Notiz, Stimmung vorher/nachher, Musterzuordnung) + Liste + Löschen
- ✅ Selbstfürsorge: Formular (Datum, Aktion per Preset oder frei, Notiz) + Liste + Löschen
- ✅ Krisenmodus: Schritte + Kontakte, im "Bearbeiten"-Modus selbst befüllbar (Inhalte bewusst nicht Teil der Seed-Daten)
- ✅ PIN-Schutz für die ganze App (Cookie-basiert, `APP_PIN` + `COOKIE_SECRET` als Cloudflare-Secrets). Fehlversuche begrenzt: 5 pro IP in 15 Minuten, 20 insgesamt pro Stunde (Tabelle `auth_attempts`, Migration `0016`). Fehlt `COOKIE_SECRET`, wird niemand eingelassen. Empfehlung: PIN mit mindestens 6 Ziffern
- ✅ Offline: Krisenplan und Skills werden auf dem Gerät zwischengespeichert und sind ohne Verbindung sichtbar (auch ohne PIN, weil offline nichts geprüft werden kann). Log-Einträge werden bewusst nicht lokal gespeichert
- ✅ Speichern: Formulare werden erst geleert, wenn der Server den Eintrag bestätigt hat; Fehler erscheinen als Hinweis, Doppeltipps erzeugen keine doppelten Einträge. Löschen mit 5 Sekunden "Rückgängig"
- ✅ Log-Entwurf: ein angefangener Log-Eintrag bleibt auf dem Gerät gespeichert (App geschlossen, Akku leer, Seite neu geladen), bis er gespeichert oder mit "Verwerfen" gelöscht wird. Ein Log-Eintrag wird mit seinen Mustern in einem Schritt gespeichert (ganz oder gar nicht)
- ✅ Updates: der Service Worker holt die Oberfläche zuerst aus dem Netz und fällt nur offline (oder nach 4 Sekunden ohne Antwort) auf den gespeicherten Stand zurück. Neue Deployments kommen damit ohne Neuinstallation an
- ✅ Anmeldung: `functions/api/_middleware.js` prüft das Auth-Cookie zentral für alle `/api/`-Routen (außer `/api/auth`), fängt Serverfehler als JSON ab und setzt `Cache-Control: no-store`. Neue Endpunkte sind damit automatisch geschützt
- ✅ Theorie: 32 Karten in zwei Kapiteln, Beziehungswissenschaft (Gary Chapman, Die fünf Sprachen der Liebe: Einführung, je eine Karte pro Sprache, das Währungsproblem; John Gottman: vier Reiter und Gegenmittel, Flooding, Reparaturversuche, Nachbesprechung eines Streits, sanfter Einstieg, Zuwendungsangebote, 5:1, lösbare vs. dauerhafte Probleme, Einfluss annehmen) und Kommunikation (Paul Watzlawick: fünf Axiome, Doppelbindung; Marshall Rosenberg: GFK), je mit Kernaussage, Alltag, Übertragung auf BPD/PTBS-Dynamik und immer sichtbaren Grenzen. `theory`/`theory_patterns`/`theory_skills` (Migration `0013`), API `/api/theory` (optional `?section=`, `?author=`); Muster-/Skill-Karten zeigen "Theorie: …" mit Sprung zur Karte
- ✅ Werkzeug "Unsere Sprachen" (unter Chapman im Theorie-Bereich): Rangfolge der fünf Sprachen für Ich und Partner:in per Auf/Ab-Buttons, Notiz pro Sprache, automatische Übersetzungshilfe (Ideen für die Top-2 von Partner:in, Hinweis bei unterschiedlicher Hauptsprache). Tabelle `love_language_profile` (Migration `0015`), API `/api/love-languages` (GET, PUT)
- ✅ Log: optionales Feld "Welche Sprache hat hier gefehlt?" (Spalte `entries.missing_languages`), Zusammenfassung "Am häufigsten gefehlt" über der Liste
- ✅ Navigation: fünf Hauptpunkte (Verstehen, Skills, Log, Fürsorge, Krise); "Verstehen" bündelt Wissen, Theorie, Forschung und Quiz mit einem Umschalter
- ✅ Quiz (unter "Verstehen"): Runden mit 10 Fragen, automatisch aus allen geladenen Karten erzeugt (Muster erkennen, "Hilft das oder eher nicht?", Skill-Phase, Skill zu einem Beispielsatz, Theorie-Konzept zu einer Alltagsszene, Autor:in, Evidenzgrad und Kernaussage einer Quelle). Filter nach Bereich, Auflösung mit Erklärung und Sprung zur Karte, "Falsche nochmal". Falsch beantwortete Fragen merkt sich das Gerät und stellt sie bevorzugt wieder. Neue Karten landen ohne Zutun im Quiz
- ✅ Forschung: 7 Karten (Programme, Modelle, PTBS-spezifisch, Literatur, Anlaufstellen) mit Evidenz-Badge, Relevanz und Pflichtfeld Einschränkungen, `research`/`research_patterns`/`research_skills` (Migration `0011`), API `/api/research`, Tab mit Kategorie-Filter; Muster-/Skill-Karten zeigen "Belegt durch: …" mit Sprung zur Quelle

- ✅ Design: warme, ruhige Farbwelt (Sand, Salbei, Nebelblau, Pfirsich), Milchglas-Karten über einer Hintergrund-Landschaft mit langsam treibenden Farbflächen und Hügeln, hervorgehobene Karten mit wanderndem Farbverlauf, schwebende Navigation, eigener Dunkelmodus (Abenddämmerung). Schrift Outfit, selbst gehostet in `src/fonts/` (SIL Open Font License, `src/fonts/OFL.txt`), damit sie auch offline da ist. Alle Bewegungen ruhen bei "Bewegung reduzieren" in den Systemeinstellungen
- ✅ Kopfbild: gemalte Ostsee-Dünenlandschaft (`src/img/ostsee-tag.webp`, 104 KB, im Offline-Cache) oben auf jeder Seite, schwebt ganz langsam heran; im Dunkelmodus automatisch die Nacht-Version mit Mond und Leuchtturm (`src/img/ostsee-nacht.webp`). Auf dem Wasser blitzen pixelkleine Lichtpunkte auf, vor allem in der Sonnen- bzw. Mondbahn (SVG über dem Bild, gleiche Bühne `.hero-stage` im Format 2000:750, damit sie bei jeder Bildschirmbreite auf dem Wasser sitzen)
- ✅ Ostsee-Dünen oben auf jeder Seite: gezeichnete Szene (Vektorgrafik in `index.html`, Klasse `dune-hero`) mit Düne, Strandhafer, Dünenzaun, Meer, Sonne bzw. Mond und Möwen. Strandhafer wiegt sich, Wellen ziehen, Wasser glitzert; im Dunkelmodus Abendstimmung. Erzeugt mit einem kleinen Python-Skript, die Farben kommen aus CSS-Variablen (`--sky-top`, `--dune-back` …)
- ✅ Monitor-Ansicht: ab 1000 px Navigation als Seitenleiste links, Karten in zwei Spalten (ab 1600 px drei), Log und Fürsorge mit Formular links und Einträgen rechts, Quiz als ruhige mittelbreite Spalte; ab 640 px etwas breitere Handy-Ansicht

## Nächste Schritte
- Log mit Skills verknüpfen: pro Eintrag festhalten, welcher Skill eingesetzt wurde und ob er gewirkt hat, damit sich zeigt, was in der Praxis wirklich funktioniert
- Eigene Skills in der App anlegen/bearbeiten (analog zum Bearbeiten-Modus im Krisen-Tab), statt nur über Migrationen
- Im Krisen-Tab auf die Stufe "Spät" (physischer Ausstieg) verlinken
- HPE Oberösterreich prüfen: Angebot für Angehörige/Partner:innen dort noch nicht verifiziert (siehe Forschungskarte "HPE Österreich")
- Partner-spezifische Studien ergänzen, sobald gefunden (aktuelle Evidenz ist überwiegend an gemischten Angehörigengruppen/Eltern erhoben)

## Quellen (Theorie-Bereich)
- John M. Gottman & Nan Silver: *Die 7 Geheimnisse der glücklichen Ehe*
- Gottman Institute: Übung zur Nachbesprechung eines Streits (*Aftermath of a Fight or Regrettable Incident*)
- Paul Watzlawick, Janet H. Beavin & Don D. Jackson: *Menschliche Kommunikation*
- Paul Watzlawick: *Anleitung zum Unglücklichsein*
- Gregory Bateson, Don D. Jackson, Jay Haley & John Weakland (1956): *Toward a Theory of Schizophrenia*
- Marshall B. Rosenberg: *Gewaltfreie Kommunikation*
- Gary Chapman: *Die fünf Sprachen der Liebe* (populär, wissenschaftlich schwach belegt: siehe Emily A. Impett, Haeyoung Gideon Park & Amy Muise (2024): *Popular Psychology Through a Scientific Lens: Evaluating Love Languages From a Relationship Science Perspective*, Current Directions in Psychological Science)

Alle Inhalte sind in eigenen Worten zusammengefasst, ohne wörtliche Zitate.

## Setup

```bash
npm install
wrangler login
wrangler d1 create eggshells-db
# database_id aus der Ausgabe in wrangler.toml eintragen
npm run db:init
npm run db:seed
# danach alle übrigen Migrationen einspielen (wrangler merkt sich, was schon gelaufen ist):
wrangler d1 migrations apply eggshells-db --remote
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
- **Code-Änderungen:** Cloudflare Pages ist mit GitHub verbunden, jeder Push auf `main` wird automatisch deployt.
- **Schema-Änderungen:** neue Datei `migrations/00XX_beschreibung.sql` anlegen (fortlaufende Nummer) und auf `main` pushen. Die GitHub Action `.github/workflows/migrations.yml` spielt sie automatisch ein (`wrangler d1 migrations apply`); welche Migrationen schon gelaufen sind, steht in der Tabelle `d1_migrations`. Bereits eingespielte Migrationsdateien nie nachträglich ändern, sondern immer eine neue anlegen. Der Code-Deploy läuft parallel; eine Migration sollte deshalb so gebaut sein, dass der alte Code damit noch funktioniert (Spalten hinzufügen statt umbenennen)
- **Einrichtung der Migrations-Action (einmalig):**
  1. `scripts/bootstrap-d1-migrations.sql` in der D1-Konsole ausführen. Das trägt die früher von Hand eingespielten Migrationen `0001`–`0016` als erledigt ein
  2. Cloudflare-API-Token mit Berechtigung "D1: Edit" anlegen (My Profile → API Tokens → Create Token → Custom token)
  3. Im GitHub-Repo unter Settings → Secrets and variables → Actions die Secrets `CLOUDFLARE_API_TOKEN` und `CLOUDFLARE_ACCOUNT_ID` anlegen
  4. Unter Actions → "D1-Migrationen" → "Run workflow" einmal von Hand starten. Erwartete Ausgabe: "No migrations to apply"
