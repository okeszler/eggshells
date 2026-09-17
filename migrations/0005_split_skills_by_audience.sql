-- Trennt die bisherige "Skill: ..."-Kategorie danach, wer die Fertigkeit
-- tatsächlich anwendet: die 5 bestehenden Karten sind alle für die
-- Partner:innen-Seite formuliert (Selbstregulation, Kommunikation) und
-- werden entsprechend umbenannt. Neu dazu kommt "Skill für Betroffene":
-- keine Anleitung für den Partner/die Partnerin, sondern Hintergrundwissen,
-- was die betroffene Person in ihrer eigenen Therapie übt und wie man das
-- unterstützend begleitet, ohne es zu übernehmen oder zu bewerten.

UPDATE patterns SET category = 'Skill für Partner' WHERE slug IN (
  'radikale-akzeptanz', 'stop-skill', 'fuenf-sinne-beruhigung',
  'validierung-partner', 'grenzen-nein-sagen'
);

INSERT INTO patterns (slug, category, title, summary, recognize, helps, avoid, sort_order) VALUES

('wise-mind', 'Skill für Betroffene', 'Wise Mind: zwischen Gefühl und Verstand',
 'Ein zentrales DBT-Konzept: Entscheidungen weder rein aus dem Gefühl (Emotion Mind) noch rein aus dem Kopf (Reasonable Mind) treffen, sondern aus einem integrierenden "weisen" Zustand dazwischen.',
 'Wenn deine Partnerin/dein Partner in der Therapie von "Wise Mind" spricht oder bewusst innehält, bevor sie/er reagiert, übt sie/er genau das.',
 'Geduld für diese bewusste Pause haben, statt auf eine sofortige Reaktion zu drängen. Eine kurze Pause ist Teil der Übung, keine Vermeidung.',
 'Die Pause als Ignorieren oder als Spielchen werten und ungeduldig nachhaken.', 25),

('skill-kette', 'Skill für Betroffene', 'Skill-Kette: mehrere Fertigkeiten hintereinander',
 'In Hochspannung reicht oft ein einzelner Skill nicht aus – in der Therapie wird geübt, mehrere Fertigkeiten nacheinander zu kombinieren, bis die Anspannung sinkt.',
 'Deine Partnerin/dein Partner probiert nacheinander mehrere Dinge aus (z. B. erst rausgehen, dann Musik, dann anrufen), bevor es besser wird – das ist geplant, kein Zeichen von "nichts hilft".',
 'Das Ausprobieren mehrerer Schritte mittragen, ohne nach dem ersten erfolglosen Versuch schon zu resignieren ("bringt eh nichts").',
 'Frühzeitig eingreifen oder für die Person entscheiden, welcher Skill jetzt "richtig" wäre – das unterläuft die eigene Übung.', 26),

('persoenlicher-sicherheitsplan', 'Skill für Betroffene', 'Persönlicher Sicherheitsplan',
 'Viele Menschen in Behandlung erarbeiten sich einen eigenen, meist schriftlichen Plan mit persönlichen Frühwarnzeichen, hilfreichen Schritten und Kontakten für den Ernstfall.',
 'Ein solcher Plan ist zutiefst persönlich und oft therapeutisch erarbeitet – er gehört der betroffenen Person, nicht euch als Paar gemeinsam.',
 'Fragen, ob und wie du eine Rolle in diesem Plan spielen sollst, statt es anzunehmen. Den Plan respektieren, auch wenn du ihn nicht im Detail kennst.',
 'Den Plan ungefragt "verbessern" wollen oder eigene Vorstellungen von der "richtigen" Krisenbewältigung überstülpen.', 27),

('rueckblick-analyse', 'Skill für Betroffene', 'Warum ein Vorfall im Nachhinein noch einmal besprochen wird',
 'In Therapien wird oft im Nachhinein Schritt für Schritt analysiert, wie eine schwierige Situation entstanden ist – nicht um Schuld zu verteilen, sondern um das Muster zu verstehen.',
 'Deine Partnerin/dein Partner will einen bereits abgeschlossenen Streit noch einmal detailliert "aufrollen" – das kann Teil der therapeutischen Aufarbeitung sein, nicht neu entfachter Streit.',
 'Bereit sein, sachlich beim Nachvollziehen des Ablaufs zu helfen, wenn danach gefragt wird – ohne es als erneuten Vorwurf zu erleben.',
 'Die Rückschau automatisch als Angriff werten und defensiv reagieren – das erschwert die eigentliche Analyse.', 28);
