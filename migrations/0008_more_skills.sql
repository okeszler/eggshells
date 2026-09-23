-- Erweitert den Skills-Tab um weitere erprobte Werkzeuge pro Eskalationsstufe.
-- Bisher gab es nur je eine Karte pro Stufe (0007) - das reicht nicht, um in
-- unterschiedlichen Situationen eine passende Option zu haben. Eigenständig
-- formuliert, keine Übernahme fremder Originaltexte.
INSERT INTO skills (slug, title, stage, description, example_phrases, works_when, fails_when, sort_order) VALUES

('beduerfnis-benennen', 'Das eigene Bedürfnis direkt benennen', 'frueh',
 'Statt in eine Klage oder einen Vorwurf zu rutschen, sagst du konkret, was du gerade brauchst. Das lenkt weg vom Gegeneinander und hin zu einer lösbaren Bitte.',
 '["Ich brauche gerade 10 Minuten Ruhe, bevor wir weiterreden.", "Mir ist wichtig, dass wir das heute noch klären, aber nicht jetzt in der Tür.", "Ich merke, ich werde ungeduldig. Lass uns kurz durchatmen."]',
 'Ganz am Anfang, solange die eigene Frustration noch benennbar ist und nicht schon in Vorwürfe gekippt ist. Eine konkrete Bitte lässt sich leichter annehmen als eine diffuse Anspannung.',
 'Sobald die Emotion schon zu hoch ist, wirkt das Benennen eines Bedürfnisses schnell wie eine Ausrede oder Ablenkung vom eigentlichen Thema.', 4),

('zeitlupe-anfrage', 'Um Zeitlupe bitten', 'frueh',
 'Du bittest offen darum, das Gespräch zu verlangsamen: ein Punkt nach dem anderen, statt mehrerer Themen gleichzeitig. Das nimmt Tempo aus einer Situation, die gerade Fahrt aufnimmt.',
 '["Können wir das langsamer machen? Ein Punkt nach dem anderen.", "Ich verlier grad den Faden, lass uns nochmal von vorne anfangen, aber langsamer.", "Lass uns kurz Luft holen, bevor wir weiterreden."]',
 'Wenn noch ein Gespräch möglich ist, aber Tempo und Lautstärke schon steigen. Funktioniert, weil es das Gespräch nicht abbricht, nur entschleunigt.',
 'Wenn die andere Person schon in starker Erregung ist, kann die Bitte um Verlangsamung wie Bevormundung ankommen.', 5),

('stimmungsbruch-humor', 'Bewusster Stimmungsbruch mit Leichtigkeit', 'frueh',
 'Eine wohldosierte, liebevolle Bemerkung unterbricht den beginnenden Automatismus, bevor er Fahrt aufnimmt. Funktioniert nur, wenn genug Vertrauen und Leichtigkeit in der Beziehung vorhanden ist.',
 '["Okay, ich hol grad Wasser, bevor das hier Level Weltkrieg erreicht.", "Moment, ich muss kurz meinen Kampfmodus ausschalten.", "Sollen wir das nochmal von vorn versuchen, diesmal mit weniger Drama?"]',
 'Ganz frueh, bei Partner:innen, die auf Humor in angespannten Momenten grundsätzlich gut reagieren. Nie erzwingen, nur einsetzen, wenn es sich stimmig anfühlt.',
 'Kann als Nicht-ernst-nehmen ankommen, besonders wenn das Thema für die andere Person schon schwer ist oder die Anspannung schon zu hoch ist.', 6),

('bedarfsfrage-statt-rechtfertigung', 'Nach dem eigentlichen Bedürfnis fragen', 'mitte',
 'Statt dich gegen einen Vorwurf zu rechtfertigen, fragst du danach, was die andere Person gerade wirklich braucht. Das verschiebt das Gespräch vom Angriff zum Kern.',
 '["Was bräuchtest du gerade von mir?", "Was würde dir jetzt helfen?", "Ich hör, dass du sauer bist. Was ist der eigentliche Punkt?"]',
 'Mitten im Streit, wenn die andere Person noch ansprechbar ist. Es funktioniert, weil du nicht auf der Vorwurfsebene bleibst, sondern eine Ebene tiefer gehst.',
 'Kann wie Ablenkung oder Verhör wirken, wenn die andere Person gerade nur gehört werden, nicht analysiert werden will.', 7),

('kaputte-schallplatte', 'Die kaputte Schallplatte', 'mitte',
 'Du wiederholst ruhig denselben kurzen, neutralen Satz, statt auf jedes neue Argument einzugehen. Das nimmt Streitpunkten den Boden, ohne dass du dich rechtfertigen musst.',
 '["Ich hör dich. Ich bleib trotzdem dabei.", "Das sehe ich anders, aber ich will jetzt nicht weiter diskutieren.", "Ich versteh, dass du das so siehst. Ich bleib bei meiner Grenze."]',
 'Wenn Gegenargumente die Lage nur verschärfen. Es funktioniert, weil du keine neue Angriffsfläche mehr lieferst und trotzdem präsent bleibst.',
 'Wenn es zu mechanisch oder kalt klingt, wirkt es wie Mauern statt wie eine Grenze. Ton und Tempo entscheiden hier viel.', 8),

('kurze-pause-im-raum', 'Eine kurze Pause ansagen, ohne zu gehen', 'mitte',
 'Du bittest um einen kurzen Moment Stille, bleibst dabei aber im Raum. Anders als der physische Ausstieg (Stufe Spät) ist das eine Mikropause, kein Verlassen der Situation.',
 '["Können wir 5 Minuten schweigen? Ich brauch das grad.", "Ich muss kurz durchatmen, bevor ich was Falsches sage.", "Gib mir kurz einen Moment, ich bin gleich wieder da."]',
 'Wenn die Anspannung steigt, aber ein voller Ausstieg noch nicht nötig ist. Präsenz bleibt erhalten, nur das Tempo wird rausgenommen.',
 'Wenn die Pause ignoriert oder als Vorwand fürs Nicht-zu-Ende-Reden genutzt wird, verliert sie ihren Wert.', 9),

('vereinbartes-codewort', 'Ein gemeinsames Codewort', 'spaet',
 'In einem ruhigen Moment vereinbart ihr ein neutrales Wort, das jede:r sagen kann, um Stopp zu signalisieren, ohne dass es als Angriff gelesen wird. Wichtig: das Wort wird VOR der nächsten Krise festgelegt, nicht erst mittendrin erfunden.',
 '["Ananas.", "Ich sag jetzt unser Wort: Pause.", "Timeout."]',
 'Wenn es vorher gemeinsam vereinbart wurde und beide wissen, dass es respektiert wird, egal wie der Streit gerade läuft.',
 'Wenn es nie vorher festgelegt wurde oder eine Seite es benutzt, um jedem unangenehmen Thema dauerhaft auszuweichen.', 10),

('notfallkontakt', 'Einen Notfallkontakt als Rückhalt haben', 'spaet',
 'Eine Person außerhalb der Beziehung, die du in einem eskalierten Moment kurz anrufen oder anschreiben kannst, nicht um sie gegen die andere Person auszuspielen, sondern um selbst runterzukommen.',
 '["Ich ruf kurz jemanden an, bin gleich wieder da.", "Ich schreib grad kurz mit jemandem, das hilft mir runterzukommen.", "Ich brauch grad eine andere Stimme von aussen."]',
 'Wenn eine verlässliche Person dafür wirklich verfügbar ist und der Kontakt der eigenen Regulation dient, nicht dem Sammeln von Verbündeten.',
 'Wenn er genutzt wird, um über die andere Person herzuziehen, oder zum Ersatz dafür wird, das Thema je direkt anzusprechen.', 11);
