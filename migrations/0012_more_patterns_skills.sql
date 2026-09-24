-- Weitere Muster und Skills, eine vierte Eskalationsstufe "danach" (Nachsorge
-- und Reparatur nach der Eskalation) und ein optionales Hinweisfeld "callout"
-- auf Skill-Karten (z.B. "Was ist Rot?"). Inhalte eigenständig und generisch
-- formuliert, ohne persönliche Details.
--
-- Als EIN Block ausführen: Die skills-Tabelle wird neu aufgebaut, weil SQLite
-- eine CHECK-Regel nicht nachträglich ändern kann. Die IDs bleiben dabei
-- erhalten, die Verknüpfungen in research_skills werden gesichert und wieder
-- eingespielt.

-- 1. Sortierung mit Lücken, damit neue Karten direkt neben verwandte passen
UPDATE patterns SET sort_order = sort_order * 10;
UPDATE skills SET sort_order = sort_order * 10;

-- 2. skills neu aufbauen: Stufe 'danach' + Spalte callout
CREATE TABLE research_skills_backup AS SELECT research_id, skill_id FROM research_skills;
DELETE FROM research_skills;

CREATE TABLE skills_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  stage TEXT NOT NULL CHECK (stage IN ('frueh', 'mitte', 'spaet', 'danach')),  -- Eskalationsstufe
  description TEXT NOT NULL,       -- was es ist
  example_phrases TEXT NOT NULL,   -- JSON-Array mit konkreten Sätzen
  works_when TEXT NOT NULL,        -- wann es funktioniert
  fails_when TEXT NOT NULL,        -- wann es nicht funktioniert / Risiken
  callout TEXT,                    -- optionaler, immer sichtbarer Hinweis auf der Karte
  sort_order INTEGER DEFAULT 0
);

INSERT INTO skills_new (id, slug, title, stage, description, example_phrases, works_when, fails_when, sort_order)
SELECT id, slug, title, stage, description, example_phrases, works_when, fails_when, sort_order FROM skills;

DROP TABLE skills;
ALTER TABLE skills_new RENAME TO skills;

INSERT INTO research_skills (research_id, skill_id) SELECT research_id, skill_id FROM research_skills_backup;
DROP TABLE research_skills_backup;

-- 3. Neue Muster
INSERT INTO patterns (slug, category, title, summary, recognize, helps, avoid, sort_order) VALUES

('eiszeit-zyklus', 'Beziehungszyklus', 'Der Eiszeit-Zyklus',
 'Ein oft kleiner Auslöser, an den sich später kaum jemand erinnert, setzt einen mehrtägigen und erstaunlich vorhersehbaren Ablauf in Gang: Verletztheit, wachsende Distanz, Abwertung, Eiszeit, offene Aggression oder Trennungsdrohung, Rückzieher, dann Ruhe.',
 'Der Anlass steht in keinem Verhältnis zur Dauer der Verstimmung. Annäherungsversuche in der Mitte des Zyklus prallen ab oder verschärfen die Lage. Der Ablauf wiederholt sich in ähnlichen Abständen und mit ähnlichen Stationen.',
 'Für dich selbst erkennen und benennen, in welcher Phase ihr gerade seid. Die Energie nicht in Reparaturversuche mitten im Zyklus stecken, sondern ins eigene Fundament: Schlaf, Kontakte, Routinen. Dir bewusst machen, dass auch diese Phase endet.',
 'Den Zyklus mit noch mehr Freundlichkeit abkürzen wollen, und jede Phase, besonders die Trennungsdrohung, als endgültig lesen.', 45),

('instanz-ohne-gesetzbuch', 'Kommunikation', 'Instanz ohne Gesetzbuch',
 'Dein Verhalten wird laufend bewertet, aber die Maßstäbe entstehen spontan und rückwirkend. Dadurch kann jede Handlung im Nachhinein zum Beweis gegen dich werden. Eng verwandt mit dem Double-Bind.',
 'Dasselbe Verhalten wird einmal kritisiert, weil es fehlt, und ein anderes Mal, weil es falsch ausgeführt wurde, etwa "Du machst das nie" und kurz darauf "Du machst das viel zu langsam".',
 'Akzeptieren, dass es kein "Richtig" im Sinne des Gegenübers gibt, das du treffen könntest. Daraus die Freiheit ableiten, nach deinen eigenen Werten zu handeln.',
 'Die Regeln erraten wollen und dich vorauseilend anpassen. Das Regelwerk ändert sich schneller, als du es lernen kannst.', 25),

('gefuehl-validieren-nicht-realitaet', 'Kommunikation', 'Gefühl validieren heißt nicht, die Realität zu verbiegen',
 'Der Wunsch nach Bestätigung richtet sich oft nicht nur auf das Gefühl ("Ich verstehe, dass dich das trifft"), sondern auf die Deutung der Situation ("Du hast recht, ich habe dich schlecht behandelt").',
 'Die Anerkennung des Gefühls reicht nicht aus. Beruhigung tritt erst ein, wenn du der Deutung zustimmst.',
 'Das Gefühl ehrlich anerkennen und die Deutung stehen lassen, ohne ihr zuzustimmen. Klar trennen zwischen "Ich sehe, wie es dir geht" und "Ich stimme deiner Version zu".',
 'Einer verzerrten Deutung zustimmen, um Ruhe zu haben. Kurzfristig hilft das, langfristig untergräbt es deine eigene Wahrnehmung.', 27),

('beratungsresistenz-partner', 'Abwehrmechanismus', 'Beratungsresistenz gegenüber dem Partner',
 'Vorschläge werden abgelehnt, nicht wegen ihres Inhalts, sondern wegen des Absenders. Ein Rat vom Partner oder von der Partnerin wird als Korrektur oder Bevormundung erlebt.',
 'Auch in ruhigen Phasen werden Lösungsvorschläge zurückgewiesen. Ähnliche Ideen werden von Dritten, etwa der Therapeutin oder Freund:innen, eher angenommen.',
 'Die Tür offen halten, statt Lösungen zu liefern. Veränderung dort erwarten, wo sie möglich ist, zum Beispiel in der eigenen Therapie der Person, und nicht über deine Vorschläge.',
 'Immer bessere Argumente suchen oder dich als Problemlöser für das Innenleben der anderen Person verstehen.', 55),

('ueberbringer-wird-zum-feind', 'Abwehrmechanismus', 'Der Überbringer wird zum Feind',
 'Wer eine unangenehme Information weitergibt, bekommt die Reaktion ab, die eigentlich der Information selbst gilt. Der Ärger landet beim Boten statt bei der Nachricht.',
 'Auf eine sachliche Mitteilung folgt kein Eingehen auf den Inhalt, sondern ein Angriff auf dich als Person, etwa "Warum schickst du mir so etwas? Was bist du für ein Mensch?"',
 'Inhalt und Reaktion auseinanderhalten. Den Angriff nicht inhaltlich verteidigen. Die sachliche Nachricht einmal geben, danach eine klare Grenze ziehen.',
 'Dich dafür rechtfertigen, dass du die Nachricht überbracht hast, oder wichtige Informationen aus Angst vor der Reaktion zurückhalten.', 425),

('zuhoeren-statt-loesen', 'Emotionsregulation', 'Nur zuhören statt lösen',
 'Im emotionalen Hoch ist die Fähigkeit zu planen und abzuwägen eingeschränkt. Lösungsvorschläge fühlen sich dann wie eine zusätzliche Anforderung an, nicht wie Hilfe.',
 'Gespräche über Maßnahmen führen zu Rückzug, und es wird ausdrücklich eingefordert, "nur zuzuhören".',
 'Im akuten Moment zuhören, ohne eine Lösung anzubieten. Maßnahmen erst mit deutlichem zeitlichem Abstand ansprechen, idealerweise wenn das Signal dafür von der anderen Person kommt.',
 'Lösungen auf dem Höhepunkt oder direkt danach einbringen.', 335);

-- 4. Neue Skills
INSERT INTO skills (slug, title, stage, description, example_phrases, works_when, fails_when, callout, sort_order) VALUES

('gelbe-karte', 'Die Gelbe Karte', 'frueh',
 'Ein kurzes, vorher vereinbartes Warnsignal für den Moment, in dem der Ton giftig wird, aber noch keine Abwertung der Person passiert: Sarkasmus, spürbare Reizbarkeit, erstes Kippen in Richtung Abwertung. Das kann ein einzelnes Wort sein oder im Chat ein Gelbe-Karte-Sticker.',
 '["Gelb.", "Das geht gerade Richtung Rot.", "Stopp, das wird gerade giftig."]',
 'Solange bei beiden noch Kapazität zur Reflexion da ist, und solange Gelb selten und ernst gemeint bleibt.',
 'Wenn Gelb inflationär wird. Dann verschiebt sich die Grenze schleichend nach oben, und Rot verliert seine Klarheit.',
 'Gelb ist keine weichere Version von Rot. Gelb heißt: Der Ton kippt, eine Umkehr ist noch möglich. Sobald die Person selbst abgewertet wird, gilt Rot.', 15),

('angst-spiegeln-dann-fakten', 'Erst die Angst spiegeln, dann die Fakten', 'frueh',
 'Bei einer Sorge, die sachlich unbegründet ist, erkennst du zuerst das Gefühl an und nennst danach einmal ruhig die Fakten. Ohne sie zu wiederholen und ohne Einsicht einzufordern.',
 '["Ich sehe, dass dich das wirklich beunruhigt.", "Klar, dass dich das nervös macht. Ich sag dir einmal kurz, wie es tatsächlich aussieht.", "Du musst mir das jetzt nicht glauben. Ich wollte es dir nur einmal sagen."]',
 'Bei Sorgen und Ängsten, solange der Trigger noch nicht voll aktiv ist. Die Anerkennung senkt die Anspannung so weit, dass die Fakten überhaupt ankommen können.',
 'Wenn sofort Einsicht eingefordert wird, etwa "Gib zu, dass du überreagierst", oder wenn die Fakten mehrmals wiederholt werden. Dann wird aus der Beruhigung ein Rechthaben.',
 NULL, 45),

('validieren-und-grenze-ein-satz', 'Validieren und Grenze in einem Satz', 'mitte',
 'Du erkennst das Gefühl an und setzt die Grenze im selben Satz, statt zwischen Verständnis und Grenze hin und her zu wechseln. Beides gilt gleichzeitig.',
 '["Ich sehe, dass dich das aufwühlt, aber so rede ich nicht mit dir.", "Ich verstehe, dass du erschöpft bist. Beschimpfen lasse ich mich trotzdem nicht.", "Dein Ärger ist verständlich, und trotzdem ist hier für mich eine Grenze."]',
 'Die andere Person erlebt sich weniger invalidiert, während die Grenze klar bleibt. Das unterbricht den Kreislauf aus Invalidierung und Eskalation.',
 'Wenn die Validierung wie eine Floskel klingt oder die Grenze im Nachsatz weich wird, etwa mit "aber eigentlich ist es eh okay".',
 NULL, 25),

('rote-karte', 'Die Rote Karte', 'spaet',
 'Bei Abwertung der Person zeigst oder schickst du kommentarlos Rot, im Chat etwa als Rote-Karte-Sticker. Danach folgt eine feste, vorher klare Konsequenz: den Chat für eine vereinbarte Zeit stummschalten, das Gespräch beenden oder den Raum verlassen.',
 '["Rot.", "Rot. Ich bin jetzt raus, wir reden morgen weiter."]',
 'Weil es keine inhaltliche Angriffsfläche bietet und weil jedes Mal eine reale Konsequenz folgt.',
 'Wenn keine Konsequenz folgt, wird die Karte zur leeren Geste. Und wenn unklar ist, was als Rot zählt, wird jede Karte selbst zum neuen Streitthema.',
 'Was ist Rot? Ein Angriff auf deinen Wert oder Charakter statt auf ein Verhalten, zum Beispiel "Was bist du nur für ein Mensch?". Kritik an etwas Konkretem, das du getan hast, ist kein Rot, auch wenn sie hart klingt. Dafür gibt es Gelb.', 35),

('timing-loesungsgespraeche', 'Timing für Lösungsgespräche', 'danach',
 'Maßnahmen und Sachthemen werden weder mitten im Konflikt noch direkt danach besprochen, sondern mit deutlichem Abstand. Für Sachentscheidungen, etwa rund um ein größeres gemeinsames Projekt, helfen kurze, feste Nur-Fakten-Termine, getrennt von Gesprächen über die Beziehung.',
 '["Wenn du magst, schauen wir uns das morgen in Ruhe an.", "15 Minuten, eine Frage, eine Entscheidung. Mehr nehmen wir uns heute nicht vor.", "Das Thema ist mir wichtig, aber nicht jetzt. Sag mir, wann es für dich passt."]',
 'Wenn beide ruhig sind und die Initiative zumindest teilweise von der anderen Person kommt.',
 'Wenn das Sachthema selbst schon ein Beziehungsthema ist. Dann kann es entlastender sein, Kleinigkeiten allein zu entscheiden, statt sie zum Gespräch zu machen.',
 NULL, 10);

-- 5. Verknüpfungen zur Forschung
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'transaktionsmodell' AND p.slug = 'gefuehl-validieren-nicht-realitaet';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'validierung-und-grenzen' AND p.slug = 'gefuehl-validieren-nicht-realitaet';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'rolle-partner-nicht-therapeut' AND p.slug = 'beratungsresistenz-partner';

INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'validierung-und-grenzen' AND s.slug = 'validieren-und-grenze-ein-satz';
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'transaktionsmodell' AND s.slug = 'validieren-und-grenze-ein-satz';
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'transaktionsmodell' AND s.slug = 'angst-spiegeln-dann-fakten';
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'stop-walking-on-eggshells' AND s.slug = 'rote-karte';
