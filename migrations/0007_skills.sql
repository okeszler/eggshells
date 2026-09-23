-- Skills: erprobte, konkrete Werkzeuge für den Moment, sortiert nach Eskalationsstufe.
-- Im Unterschied zu den Wissenskarten (patterns) geht es hier nicht um Hintergrund,
-- sondern um das, was man in der Situation tatsächlich sagt oder tut.
CREATE TABLE skills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  stage TEXT NOT NULL CHECK (stage IN ('frueh', 'mitte', 'spaet')),  -- Eskalationsstufe
  description TEXT NOT NULL,       -- was es ist
  example_phrases TEXT NOT NULL,   -- JSON-Array mit konkreten Sätzen
  works_when TEXT NOT NULL,        -- wann es funktioniert
  fails_when TEXT NOT NULL,        -- wann es nicht funktioniert / Risiken
  sort_order INTEGER DEFAULT 0
);

INSERT INTO skills (slug, title, stage, description, example_phrases, works_when, fails_when, sort_order) VALUES

('reframe-frage', 'Die Reframe-Frage', 'frueh',
 'Sobald du merkst, dass ein Gespräch in Richtung Streit kippt, stellst du eine ehrliche Frage, die den Autopiloten unterbricht. Sie lädt beide ein, kurz von außen auf die Situation zu schauen, und macht deutlich, dass ein Streit das eigentliche Problem nicht lösen wird.',
 '["Willst du gerade streiten?", "Ich glaube, ein Streit bringt uns hier nicht weiter. Was brauchst du eigentlich gerade?", "Merkst du auch, dass wir gerade Richtung Streit rutschen?"]',
 'Wenn der Moment früh erkannt wird und bei beiden noch genug Kopf für Reflexion da ist, also bevor die Emotion das Denken übernommen hat. Die Frage muss wirklich offen gemeint sein, nicht rhetorisch.',
 'Wenn der Trigger schon zu tief sitzt: Dann wird die Frage als Vorwurf, Spott oder Belehrung gehört und kann den Streit sogar anheizen. Dann direkt zur nächsten Stufe wechseln statt die Frage zu wiederholen.', 1),

('meta-benennung', 'Die Form benennen, nicht den Inhalt', 'mitte',
 'Statt auf den Inhalt eines Angriffs einzusteigen und ihn Punkt für Punkt zu widerlegen, benennst du ruhig, was gerade passiert: die Abwertung, den Vorwurf, den Ton. Du steigst aus der Sachebene aus und bleibst trotzdem präsent.',
 '["Da ist sie wieder, die Abwertung.", "Das nehme ich nicht an.", "Ich will dein Gift gerade nicht.", "Über den Inhalt rede ich gern, aber nicht in diesem Ton."]',
 'Wenn der Streit schon läuft, aber noch nicht eskaliert ist. Es funktioniert, weil du keine neuen Argumente lieferst, an denen man sich festbeißen kann. Es gibt keine neue Angriffsfläche.',
 'Kann als "ich durchschau dich" oder als Überlegenheit ankommen und damit zusätzliche Scham oder Wut auslösen. Deshalb kurz, ruhig und ohne Triumph sagen, und nicht mit Analyse nachlegen. Wenn es sichtbar schlimmer wird: nächste Stufe.', 2),

('physischer-ausstieg', 'Der physische Ausstieg', 'spaet',
 'Du verlässt die Situation aktiv: anderes Zimmer, raus aus der Wohnung, eine Runde um den Block. Das ist eine Pause für beide Nervensysteme und keine Entscheidung über die Beziehung. Am besten kurz ansagen, dass du gehst und wann du wiederkommst.',
 '["Ich gehe jetzt kurz raus. Ich komme in einer halben Stunde wieder.", "Ich brauche eine Pause, sonst wird es schlimmer. Wir reden später weiter.", "Ich gehe nicht weg von dir, ich gehe nur aus dieser Situation raus."]',
 'Immer, als letzte Stufe, wenn Worte nichts mehr erreichen. Räumlicher Abstand senkt die Erregung zuverlässiger als jeder Satz. Die Ansage mit Rückkehrzeit nimmt der anderen Person die Angst vor dem Verlassenwerden.',
 'Wenn der Ausstieg ohne Ansage passiert oder als Strafe eingesetzt wird (Türknallen, tagelanges Schweigen), wird er als Verlassen erlebt. Und wenn "später reden" nie passiert, verliert das Versprechen seine Wirkung.', 3);
