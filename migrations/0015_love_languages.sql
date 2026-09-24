-- Die fünf Sprachen der Liebe (Gary Chapman): Theorie-Karten, ein Skill,
-- das Profil-Werkzeug "Unsere Sprachen" und im Log das Feld "Welche Sprache
-- hat gefehlt?". Inhalte eigenständig formuliert, keine Zitate aus dem Buch.
-- (Ursprünglich als 0007 geplant, 0007 ist bereits belegt - daher 0015.)
--
-- Als EIN Block ausführen: theory wird neu aufgebaut, weil die CHECK-Regel
-- auf author nur drei Autoren zuließ. Die Regel entfällt dabei ganz, damit
-- künftige Autoren keinen Umbau mehr brauchen. IDs bleiben erhalten, die
-- Verknüpfungen werden gesichert und wieder eingespielt.

-- 1. theory neu aufbauen (ohne CHECK auf author)
CREATE TABLE theory_patterns_backup AS SELECT theory_id, pattern_id FROM theory_patterns;
CREATE TABLE theory_skills_backup AS SELECT theory_id, skill_id FROM theory_skills;
DELETE FROM theory_patterns;
DELETE FROM theory_skills;

CREATE TABLE theory_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  section TEXT NOT NULL CHECK (section IN ('beziehungswissenschaft', 'kommunikation')),
  author TEXT NOT NULL,
  title TEXT NOT NULL,
  core TEXT NOT NULL,
  everyday TEXT NOT NULL,
  in_context TEXT NOT NULL,
  limits TEXT NOT NULL,
  reference TEXT,
  sort_order INTEGER DEFAULT 0
);

INSERT INTO theory_new (id, slug, section, author, title, core, everyday, in_context, limits, reference, sort_order)
SELECT id, slug, section, author, title, core, everyday, in_context, limits, reference, sort_order FROM theory;

DROP TABLE theory;
ALTER TABLE theory_new RENAME TO theory;

INSERT INTO theory_patterns (theory_id, pattern_id) SELECT theory_id, pattern_id FROM theory_patterns_backup;
INSERT INTO theory_skills (theory_id, skill_id) SELECT theory_id, skill_id FROM theory_skills_backup;
DROP TABLE theory_patterns_backup;
DROP TABLE theory_skills_backup;

-- 2. Profil "Unsere Sprachen"
CREATE TABLE love_language_profile (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  person TEXT NOT NULL CHECK (person IN ('ich', 'partner')),
  language TEXT NOT NULL CHECK (language IN ('worte', 'zeit', 'geschenke', 'hilfe', 'koerper')),
  rank INTEGER NOT NULL CHECK (rank BETWEEN 1 AND 5),
  note TEXT,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (person, language)
);

-- 3. Log: welche Sprache hat gefehlt (JSON-Array der Sprach-IDs)
ALTER TABLE entries ADD COLUMN missing_languages TEXT;

-- 4. Skill
INSERT INTO skills (slug, title, stage, description, example_phrases, works_when, fails_when, callout, sort_order) VALUES
('uebersetzen-beide-richtungen', 'Übersetzen in beide Richtungen', 'danach',
 'Du übersetzt deine Liebesbeweise in die Sprache der anderen Person und benennst deine eigene Sprache, ohne dich zu rechtfertigen. So wird sichtbar, was ohnehin schon da ist.',
 '["Ich mach heute die Küche, damit du Ruhe hast.", "Wenn ich dir den Rücken freihalte, ist das meine Art zu sagen, dass ich dich liebe.", "Was würde dir heute guttun?"]',
 'In ruhigen Phasen und als Alltagsgewohnheit, nicht erst als Reparatur nach einem Streit.',
 'Mitten im Konflikt als Argument, etwa "Ich hab doch so viel für dich getan". Dann wirkt es wie Aufrechnen und lädt zum Gegenrechnen ein.',
 NULL, 60);

-- 5. Theorie-Karten
INSERT INTO theory (slug, section, author, title, core, everyday, in_context, limits, reference, sort_order) VALUES

('chapman-einfuehrung', 'beziehungswissenschaft', 'Chapman', 'Einführung: Die fünf Sprachen der Liebe',
 'Menschen zeigen Zuneigung auf unterschiedliche Weise und erkennen sie auch unterschiedlich. Wer in einer anderen Sprache liebt als das Gegenüber, kann viel geben, ohne dass es als Liebe ankommt. Der Paarberater Gary Chapman unterscheidet fünf solcher Sprachen.',
 'Eine Person repariert seit Wochen alles im Haus und wundert sich, dass sich die andere trotzdem vernachlässigt fühlt. Die hätte sich vor allem einen Abend zu zweit gewünscht.',
 'Das Modell gibt ein einfaches, nicht wertendes Vokabular für eine häufige Enttäuschung: "Ich gebe doch so viel." In angespannten Beziehungen hilft es, Zuwendung gezielter zu zeigen. Grenzen und Behandlung ersetzt es nicht. Das Werkzeug "Unsere Sprachen" weiter unten macht es konkret.',
 'Populäres Modell mit schwacher wissenschaftlicher Grundlage. Eine Übersichtsarbeit (Impett, Park & Muise, 2024, Current Directions in Psychological Science) fand kaum Belege dafür, dass es genau fünf Sprachen gibt oder dass passende Sprachen die Zufriedenheit vorhersagen. Eher sind alle Formen für die meisten Menschen wichtig, und entscheidend ist, auf die Bedürfnisse des anderen einzugehen. In der App: gemeinsames Vokabular, kein Diagnoseinstrument.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 10),

('sprache-worte', 'beziehungswissenschaft', 'Chapman', 'Worte der Wertschätzung',
 'Zuneigung zeigt sich in ausgesprochener Anerkennung: Lob, Dank, ein ehrliches Kompliment, ein gesagtes "Ich hab dich gern".',
 '"Danke, dass du heute an den Termin gedacht hast, das hat mir echt geholfen."',
 'Wer diese Sprache spricht, reagiert oft auch besonders stark auf abwertende Worte. Kritik und Verachtung (siehe die vier Reiter) treffen dann doppelt. Umgekehrt kann ein ehrlicher Satz der Wertschätzung auch in schwierigen Phasen stabilisieren.',
 'Schwach belegtes, populäres Modell (siehe Einführung): nützlich als gemeinsames Vokabular, kein Diagnoseinstrument.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 20),

('sprache-zeit', 'beziehungswissenschaft', 'Chapman', 'Zweisamkeit',
 'Ungeteilte Aufmerksamkeit: gemeinsame Zeit, in der nichts anderes nebenbei läuft, kein Handy, kein halbes Zuhören.',
 'Ein Spaziergang, bei dem beide wirklich miteinander reden, statt nebeneinander Nachrichten zu lesen.',
 'Bei ausgeprägter Angst vor dem Verlassenwerden kann fehlende Aufmerksamkeit schnell wie Rückzug wirken. Kurze, verlässliche Zeitfenster sind dann oft wertvoller als seltene lange.',
 'Schwach belegtes, populäres Modell (siehe Einführung): nützlich als gemeinsames Vokabular, kein Diagnoseinstrument.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 30),

('sprache-geschenke', 'beziehungswissenschaft', 'Chapman', 'Geschenke',
 'Kleine, sichtbare Zeichen, dass man an den anderen gedacht hat. Es geht nicht um den Wert, sondern um die Aufmerksamkeit dahinter.',
 'Auf dem Heimweg die Lieblingsschokolade mitnehmen, weil das Gegenüber einen harten Tag erwähnt hat.',
 'In angespannten Phasen kann ein Geschenk auch als Versuch gelesen werden, einen Konflikt zuzudecken. Als kleine Geste im Alltag wirkt es meist besser als als Wiedergutmachung nach einem Streit.',
 'Schwach belegtes, populäres Modell (siehe Einführung): nützlich als gemeinsames Vokabular, kein Diagnoseinstrument. Die Sprache wird oft als materialistisch missverstanden; gemeint sind Zeichen von Aufmerksamkeit.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 40),

('sprache-hilfe', 'beziehungswissenschaft', 'Chapman', 'Hilfsbereitschaft',
 'Zuneigung durch Taten: Dinge für den anderen erledigen, Last abnehmen, den Rücken freihalten.',
 'Die Steuererklärung übernehmen, weil das Gegenüber gerade keinen Kopf dafür hat.',
 'Taten werden leicht übersehen, wenn die andere Person eine andere Sprache spricht. Ungefragte Hilfe kann außerdem als Kritik ankommen, so als hieße sie "Du schaffst das nicht". Kurz zu sagen, was man tut und warum, macht die Absicht sichtbar.',
 'Schwach belegtes, populäres Modell (siehe Einführung): nützlich als gemeinsames Vokabular, kein Diagnoseinstrument.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 50),

('sprache-koerper', 'beziehungswissenschaft', 'Chapman', 'Zärtlichkeit und Körperkontakt',
 'Zuneigung über Berührung: eine Umarmung, Hand halten, Nähe auf dem Sofa, eine Hand auf der Schulter.',
 'Eine kurze Umarmung zur Begrüßung, bevor irgendetwas anderes besprochen wird.',
 'Bei PTBS kann Berührung in angespannten Momenten erschrecken oder überfordern, auch wenn sie sonst sehr willkommen ist. Vorher kurz fragen, ob Nähe gerade passt, und ein Nein nicht persönlich nehmen.',
 'Schwach belegtes, populäres Modell (siehe Einführung): nützlich als gemeinsames Vokabular, kein Diagnoseinstrument. Gerade Körperkontakt hängt stark vom momentanen Zustand ab; eine Rangfolge sagt nichts über den einzelnen Moment.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 60),

('waehrungsproblem', 'beziehungswissenschaft', 'Chapman', 'Das Währungsproblem',
 'Zwei Menschen können beide viel geben und sich trotzdem beide ungeliebt fühlen, wenn ihre Währungen nicht übereinstimmen.',
 'Eine Person liebt über Taten: Haushalt, Organisation, Probleme lösen. Die andere braucht Worte und Aufmerksamkeit. Die Taten kommen als Pflicht an, die Bitte um Worte als Nörgeln.',
 'In angespannten Beziehungen kippt das schnell: Ein neues Organisationssystem wird nicht als Fürsorge gelesen, sondern als "Du hältst mich für unfähig". Hier hilft, die eigene Tat in Worte zu übersetzen und das Gefühl der anderen Person zu validieren, ohne ihre Deutung zu übernehmen. Siehe auch das Muster "Nur zuhören statt lösen".',
 'Populäres Modell mit schwacher wissenschaftlicher Grundlage. Eine Übersichtsarbeit (Impett, Park & Muise, 2024, Current Directions in Psychological Science) fand kaum Belege dafür, dass es genau fünf Sprachen gibt oder dass passende Sprachen die Zufriedenheit vorhersagen. Eher sind alle Formen für die meisten Menschen wichtig, und entscheidend ist, auf die Bedürfnisse des anderen einzugehen. In der App: gemeinsames Vokabular, kein Diagnoseinstrument.',
 'Gary Chapman: Die fünf Sprachen der Liebe', 70);

-- 6. Verknüpfungen
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'sprache-zeit' AND p.slug = 'angst-vor-verlassenwerden';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'sprache-koerper' AND p.slug = 'uebererregung';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'waehrungsproblem' AND p.slug = 'zuhoeren-statt-loesen';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'chapman-einfuehrung' AND s.slug = 'uebersetzen-beide-richtungen';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'waehrungsproblem' AND s.slug = 'validieren-und-grenze-ein-satz';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'waehrungsproblem' AND s.slug = 'uebersetzen-beide-richtungen';
