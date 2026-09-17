-- Baut die bisher nur mit einer Karte (Affektprojektion) besetzte Kategorie
-- "Emotionsregulation" aus. Allgemein bekannte, öffentlich dokumentierte
-- Konzepte (primäre/sekundäre Emotionen, emotionale Ansteckung, Affekt-
-- labilität als BPD-Symptom, "Gefühlswellen"/Urge Surfing, physiologischer
-- Nachhall starker Gefühle) — eigenständig formuliert.
INSERT INTO patterns (slug, category, title, summary, recognize, helps, avoid, sort_order) VALUES

('sekundaere-emotionen', 'Emotionsregulation', 'Sekundäre Emotionen: Gefühle über Gefühle',
 'Oft kommt zu einem ersten, direkten Gefühl (z. B. Angst) ein zweites, reaktives Gefühl dazu (z. B. Wut über die eigene Angst) – nach außen sichtbar wird meist nur das zweite.',
 'Eine Reaktion wirkt heftiger als der ursprüngliche Auslöser – oft steckt darunter Scham, Angst oder Traurigkeit, die als Wut oder Rückzug nach außen tritt.',
 'Fragen (für dich selbst wie im Gespräch), welches Gefühl wohl "darunter" liegt, statt nur auf das sichtbare Gefühl zu reagieren.',
 'Nur das sekundäre Gefühl (z. B. die Wut) ansprechen und bewerten – das trifft selten den eigentlichen Kern.', 29),

('emotionale-ansteckung', 'Emotionsregulation', 'Emotionale Ansteckung',
 'Starke Gefühle springen leicht auf nahestehende Personen über – Anspannung erzeugt Anspannung, auch ohne ein Wort.',
 'Du merkst, wie deine eigene Stimmung kippt, kurz nachdem die andere Person angespannt oder aufgewühlt wirkt.',
 'Dir bewusst machen, dass die Anspannung "übergesprungen" ist. Kurz bei dir selbst nachspüren, was wirklich deins ist und was übernommen wurde.',
 'Automatisch mit eskalieren, weil sich die Anspannung "richtig" anfühlt – ein bewusster Moment Distanz unterbricht die Ansteckung.', 30),

('affektlabilitaet', 'Emotionsregulation', 'Affektlabilität: schnelle Stimmungswechsel',
 'Bei erhöhter emotionaler Empfindlichkeit können Stimmungen deutlich schneller und intensiver wechseln als bei den meisten Menschen – das ist ein Symptom, keine Unberechenbarkeit mit Absicht.',
 'Ein Stimmungsumschwung innerhalb von Minuten, oft ohne erkennbaren äußeren Anlass, der für Außenstehende schwer nachvollziehbar wirkt.',
 'Nicht bei jedem Wechsel nach der "logischen" Ursache suchen. Präsent bleiben, ohne die eigene Stimmung zwanghaft daran anzupassen.',
 '"Jetzt war doch gerade noch alles gut" als Vorwurf bringen – das erhöht oft nur den Druck.', 31),

('gefuehle-aushalten', 'Emotionsregulation', 'Gefühle aushalten, ohne sofort zu handeln',
 'Ein starkes Gefühl steigt, erreicht einen Höhepunkt und klingt danach von selbst wieder ab – wie eine Welle. Es muss nicht sofort durch eine Handlung "erledigt" werden.',
 'Der Drang, JETZT etwas zu tun (anrufen, klären, weggehen), fühlt sich dringender an, als die Situation eigentlich ist.',
 'Die Welle bewusst "mitreiten" – ein paar Minuten abwarten, bevor gehandelt wird. Die Intensität nimmt fast immer von selbst ab.',
 'Jeden Handlungsimpuls sofort ausleben (oder krampfhaft unterdrücken) – beides verstärkt eher die nächste Welle.', 32),

('nachhall-starker-gefuehle', 'Emotionsregulation', 'Der Nachhall starker Gefühle',
 'Der Körper braucht nach einer intensiven emotionalen Reaktion Zeit, um sich zu beruhigen – auch wenn nach außen schon wieder Ruhe wirkt, ist das System oft noch nachschwingend aktiviert.',
 'Kurz nach einem heftigen Moment wirkt eine an sich kleine, neue Reizung schon wieder überproportional groß.',
 'Nach einem intensiven Moment bewusst Pufferzeit einplanen, bevor das nächste Thema angegangen wird.',
 'Direkt nach einer Eskalation zum nächsten wichtigen Gespräch übergehen – das System ist oft noch nicht wirklich "unten".', 33);
