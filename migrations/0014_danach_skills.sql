-- Baut die Eskalationsstufe "danach" aus (bisher nur "Timing für
-- Lösungsgespräche"): Nachsorge für sich selbst, Wiederannäherung ohne
-- Druck, Nachbesprechung als Ritual, eigener Anteil, Abschließen ohne
-- Entschuldigung. Die Reihenfolge folgt dem typischen Ablauf nach einer
-- Eskalation. Inhalte eigenständig formuliert.

UPDATE skills SET sort_order = 50 WHERE slug = 'timing-loesungsgespraeche';

INSERT INTO skills (slug, title, stage, description, example_phrases, works_when, fails_when, callout, sort_order) VALUES

('nachsorge-fuer-mich', 'Erst Nachsorge für dich selbst', 'danach',
 'Nach einer Eskalation kümmerst du dich zuerst um dich: den Körper runterfahren (Bewegung, Wasser, frische Luft), mit einer vertrauten Person sprechen, kurz ins Log schreiben, was passiert ist. Analyse und Klärung kommen später.',
 '["Ich geh jetzt erst mal eine Runde, dann schau ich weiter.", "Ich muss das kurz loswerden, hast du fünf Minuten?", "Heute Abend kläre ich nichts mehr. Morgen ist auch noch ein Tag."]',
 'Direkt nach dem Höhepunkt, wenn dein eigenes Nervensystem noch auf Alarm steht. Wer selbst wieder reguliert ist, trifft bessere Entscheidungen über den nächsten Schritt.',
 'Wenn aus der Nachsorge ein Grübeln im Kreis wird, in dem der Streit innerlich immer wieder durchgespielt wird. Oder wenn das Gespräch mit Dritten vor allem Bestätigung gegen die andere Person sucht.',
 'Deine Erholung musst du dir nicht erst verdienen. Sie ist die Voraussetzung dafür, dass du wieder klar denken kannst, und kein Verrat an der Beziehung.', 10),

('wiederannaeherung-ohne-druck', 'Wiederannäherung ohne Druck', 'danach',
 'Wenn sich die Lage beruhigt hat, sendest du ein kleines, freundliches Signal, das Kontakt anbietet, ohne ein Gespräch einzufordern. Die andere Person entscheidet selbst, wann sie darauf eingeht.',
 '["Ich bin da, wenn du reden magst. Kein Druck.", "Magst du einen Tee?", "Ich hab dich gern, auch wenn es gerade schwierig war."]',
 'Wenn beide wieder halbwegs reguliert sind. Ein kleines Signal ohne Bedingung zeigt, dass die Beziehung den Streit überstanden hat, ohne dass jemand nachgeben muss.',
 'Wenn das Signal eigentlich eine versteckte Forderung ist, etwa "Können wir jetzt endlich reden?". Oder wenn die andere Person noch im Nachhall steckt und jeder Kontakt als Druck ankommt. Dann den Abstand respektieren und es später noch einmal versuchen.',
 NULL, 20),

('nachbesprechung-ritual', 'Die Nachbesprechung als festes Ritual', 'danach',
 'In einer ruhigen Phase sprecht ihr einen Streit nach einem Ablauf nach, den ihr vorher gemeinsam vereinbart habt: Jede Person schildert ihre Gefühle und ihre Sicht, ohne die andere zu widerlegen, dann was sie getriggert hat, ihren eigenen Anteil und was sie nächstes Mal anders machen möchte. Wer zuhört, fasst nur zusammen.',
 '["Magst du den Streit von Dienstag mit mir nachbesprechen, so wie wir es ausgemacht haben?", "Ich erzähl dir, wie es mir ging. Du musst nichts richtigstellen, nur zuhören.", "Was ich mitnehme: Nächstes Mal sag ich früher, dass ich eine Pause brauche."]',
 'Mit deutlichem Abstand zum Streit, wenn beide ruhig sind und dem Gespräch zugestimmt haben. Weil beide denselben Ablauf durchlaufen, ist es ein gemeinsames Ritual und keine Anklage.',
 'Wenn es zu früh kommt, als Überfall erlebt wird oder in eine neue Runde "Wer hat angefangen?" kippt. Dann abbrechen und auf später verschieben.',
 'Nur mit Zustimmung beider und nur in einer ruhigen Phase. Den Ablauf am besten in einer guten Zeit vereinbaren, nicht erst nach dem nächsten Streit vorschlagen.', 30),

('eigener-anteil', 'Den eigenen Anteil benennen', 'danach',
 'Du benennst konkret, was du selbst zur Eskalation beigetragen hast, ohne dich kleinzumachen und ohne ein "aber" anzuhängen. Das nimmt Druck aus der Schuldfrage und zeigt, dass du Verantwortung für dein eigenes Verhalten übernimmst.',
 '["Ich bin lauter geworden als nötig. Das tut mir leid.", "Ich hab dir nicht richtig zugehört, weil ich schon meine Antwort im Kopf hatte.", "Mein Satz war sarkastisch, und das war nicht fair."]',
 'Wenn der Anteil konkret und echt ist. Oft fällt es dann auch der anderen Person leichter, über ihren Anteil zu sprechen, ohne dass du das einforderst.',
 'Wenn aus dem eigenen Anteil die ganze Schuld wird, nur um Frieden herzustellen. Oder wenn er als Tauschgeschäft gemeint ist, nach dem Motto "Ich hab mich entschuldigt, jetzt bist du dran".',
 'Den eigenen Anteil übernehmen heißt nicht, die ganze Schuld zu übernehmen. Für Abwertung oder Grenzüberschreitungen der anderen Person bist du nicht verantwortlich.', 40),

('ohne-entschuldigung-abschliessen', 'Abschließen, auch ohne Entschuldigung', 'danach',
 'Nicht jeder Streit endet mit einer Entschuldigung oder einer gemeinsamen Sicht. Du schließt den Vorfall für dich ab: Du hältst fest, was passiert ist, wo für dich eine Grenze war und was du daraus mitnimmst, unabhängig davon, ob die andere Person das je anerkennt.',
 '["Wir sehen das unterschiedlich, und das ist für heute okay.", "Ich brauche nicht, dass du mir recht gibst. Für mich ist das Thema erledigt.", "Ich merk mir: Bei dem Ton gehe ich nächstes Mal früher raus."]',
 'Wenn eine Entschuldigung ausbleibt, der Vorfall ganz anders erinnert wird oder die andere Person einfach zur Tagesordnung übergeht. Es gibt dir die Kontrolle über deinen eigenen Abschluss zurück.',
 'Wenn "abschließen" heißt, sich wiederholende Grenzverletzungen stillschweigend hinzunehmen. Wiederkehrende Rote-Karte-Situationen gehören ins Log und gegebenenfalls in die eigene Therapie, nicht nur in den inneren Abschluss.',
 NULL, 45);

-- Verknüpfungen zu Forschung und Theorie
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'rolle-partner-nicht-therapeut' AND s.slug = 'nachsorge-fuer-mich';

INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'flooding' AND s.slug = 'nachsorge-fuer-mich';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'reparaturversuche' AND s.slug = 'wiederannaeherung-ohne-druck';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'zuwendungsangebote' AND s.slug = 'wiederannaeherung-ohne-druck';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'nachbesprechung-streit' AND s.slug = 'nachbesprechung-ritual';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'axiom-interpunktion' AND s.slug = 'nachbesprechung-ritual';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'gegenmittel-reiter' AND s.slug = 'eigener-anteil';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'loesbare-dauerhafte-probleme' AND s.slug = 'ohne-entschuldigung-abschliessen';
