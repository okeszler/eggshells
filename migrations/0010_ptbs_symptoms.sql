-- Ergänzt die Kategorie "Trauma-Wissenschaft" um zentrale PTBS-Symptombereiche,
-- die bisher fehlten: Intrusionen als sensorisches Wiedererleben (anders als
-- die bereits vorhandenen "emotionalen Flashbacks", die ohne Bild auskommen),
-- Vermeidung, Übererregung, Schlaf, Trigger-Ketten, Jahrestage und negative
-- Grundannahmen. Allgemein bekannte, öffentlich dokumentierte PTBS-Symptomatik
-- (u.a. DSM-5-Symptomcluster), eigenständig formuliert für die Partner:innen-
-- Perspektive dieser App, keine Übernahme fremder Originaltexte.
INSERT INTO patterns (slug, category, title, summary, recognize, helps, avoid, sort_order) VALUES

('intrusionen-flashbacks', 'Trauma-Wissenschaft', 'Intrusionen: wenn eine Erinnerung sich wie jetzt anfühlt',
 'Anders als eine normale Erinnerung wird ein Trauma-Fragment plötzlich und ungewollt als Bild, Geruch, Geräusch oder Körperempfindung erlebt - nicht als "ich erinnere mich", sondern als "es passiert gerade".',
 'Plötzliches Erstarren oder Zusammenzucken, oft ausgelöst durch einen an sich harmlosen Reiz wie einen Geruch, Tonfall oder eine Berührung, gefolgt von Verwirrung oder Rückzug.',
 'Ruhig und ohne Berührung ansprechen, die Gegenwart benennen, etwa "wir sind hier, im Wohnzimmer, heute". Zeit geben, bis die Person wieder ganz da ist.',
 'Fragen, was genau passiert ist, während die Intrusion noch läuft - das kann die Erinnerung eher vertiefen als auflösen.', 47),

('vermeidungsverhalten', 'Trauma-Wissenschaft', 'Vermeidungsverhalten: ein Symptom, kein Desinteresse',
 'Orte, Themen, Menschen oder sogar Filme, die an das Trauma erinnern, werden aktiv umgangen - das kostet oft mehr Energie, als es von außen aussieht.',
 'Bestimmte Themen werden konsequent gewechselt, bestimmte Orte oder Situationen ohne große Erklärung gemieden.',
 'Die Vermeidung respektieren, ohne sie zu hinterfragen. Selbst keinen Druck aufbauen, "da jetzt durchzumüssen".',
 'Konfrontation als Mutprobe verstehen, etwa "stell dich dem doch einfach" - Vermeidung ist ein Schutzmechanismus, kein Mangel an Willenskraft.', 48),

('uebererregung', 'Trauma-Wissenschaft', 'Übererregung: der Körper bleibt auf Wache',
 'Das Nervensystem bleibt dauerhaft in erhöhter Alarmbereitschaft - mit stärkerem Schreckreflex, Reizbarkeit und Schwierigkeiten beim Einschlafen.',
 'Auffälliges Zusammenzucken bei plötzlichen Geräuschen, ständiges Prüfen von Türen oder Fenstern, Reizbarkeit ohne erkennbaren Auslöser.',
 'Als körperlichen Zustand verstehen, nicht als schlechte Laune. Vorhersehbarkeit im Alltag schaffen: ankündigen statt überraschen.',
 'Überraschungen als liebevolle Geste einsetzen, etwa eine Party oder plötzlichen Besuch - bei Übererregung wirken sie oft gegenteilig.', 49),

('albtraeume-schlaf', 'Trauma-Wissenschaft', 'Albträume und gestörter Schlaf',
 'Trauma-Inhalte tauchen häufig nachts wieder auf, manchmal als direkte Wiederholung, manchmal verschlüsselt - mit entsprechenden Auswirkungen auf Schlafqualität und Tagesform.',
 'Unruhiger Schlaf, plötzliches Aufwachen, Vermeidung des Einschlafens, Erschöpfung trotz ausreichender Schlafzeit.',
 'Nach dem Aufwachen kurz Orientierung geben (Ort, Zeit, "du bist sicher"), ohne sofort nach Inhalten zu fragen.',
 'Den Albtraum sofort im Detail besprechen wollen - direkt nach dem Aufwachen ist oft der falsche Moment dafür.', 50),

('trigger-ketten', 'Trauma-Wissenschaft', 'Wie ein Trigger eine ganze Kette auslöst',
 'Ein einzelner, oft kleiner Reiz kann eine Kette aus Körperreaktion, Gedanken und Verhalten in Gang setzen, die von außen unverhältnismäßig zum Auslöser wirkt.',
 'Eine kleine Situation, etwa ein Wort, ein Geruch oder eine Geste, löst eine Reaktion aus, deren Ausmaß in keinem Verhältnis zum unmittelbaren Anlass steht.',
 'Den Trigger benennen, wenn er erkannt ist, statt ihn zu verstecken oder wegzudiskutieren. Nach der akuten Reaktion gemeinsam schauen, was ihn ausgemacht hat.',
 'Trigger dauerhaft aus dem gemeinsamen Leben verbannen wollen - das schränkt oft mehr ein, als es hilft, und ist selten vollständig möglich.', 51),

('jahrestage', 'Trauma-Wissenschaft', 'Jahrestage und wiederkehrende Daten',
 'Der Körper kann sich an ein Datum erinnern, auch wenn der Kopf es nicht bewusst verknüpft - Belastung häuft sich oft um denselben Kalendertag oder dieselbe Jahreszeit.',
 'Auffällige Stimmungseinbrüche oder Anspannung um ein bestimmtes Datum, ohne dass ein aktueller Auslöser erkennbar ist.',
 'Relevante Daten im Blick behalten und in dieser Zeit bewusst weniger Termine und Anforderungen einplanen.',
 'Die Verbindung zwischen Datum und Stimmung als Zufall abtun oder als übertrieben werten.', 52),

('negative-grundannahmen', 'Trauma-Wissenschaft', 'Negative Grundannahmen über sich und die Welt',
 'Trauma kann dauerhafte Überzeugungen hinterlassen wie "die Welt ist gefährlich" oder "ich bin schuld" - unabhängig von der aktuellen, objektiven Sicherheit.',
 'Wiederkehrende Sätze wie "mir passiert sowieso immer was Schlimmes" oder starke Selbstvorwürfe für Dinge außerhalb der eigenen Kontrolle.',
 'Der Überzeugung nicht mit Fakten widersprechen wollen, etwa "das stimmt doch nicht", sondern das Gefühl dahinter anerkennen.',
 'Die Grundannahme als aktuelle Meinung über die Beziehung nehmen - oft ist sie älter als die Beziehung selbst.', 53);
