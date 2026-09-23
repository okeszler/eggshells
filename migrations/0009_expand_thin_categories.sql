-- Füllt vier Kategorien auf, die bisher nur eine einzige Karte hatten
-- (Borderline, Beziehungszyklus, Abwehrmechanismus, Kommunikation), damit
-- der Wissen-Tab nicht mehr so unausgewogen wirkt. Allgemein bekannte,
-- öffentlich dokumentierte Konzepte, eigenständig formuliert, keine
-- Übernahme fremder Originaltexte.
INSERT INTO patterns (slug, category, title, summary, recognize, helps, avoid, sort_order) VALUES

('angst-vor-verlassenwerden', 'Borderline', 'Die Angst vor dem Verlassenwerden',
 'Ein zentrales Symptom: reale oder auch nur befürchtete Distanz kann Panik oder Wut auslösen, unabhängig davon, wie stabil die Beziehung objektiv ist.',
 'Starke Reaktionen auf kleine Anzeichen von Distanz - später kommen, kurz nicht antworten. Teils auch bewusstes oder unbewusstes Testen, ob du bleibst.',
 'Verlässlichkeit über kleine, wiederholbare Signale zeigen, etwa Bescheid geben, wenn du später kommst. Nicht auf jeden Test reagieren müssen.',
 'Sich durch Drohungen wie "dann geh ich halt" ständig zur Beruhigung erpressen lassen - das verstärkt das Muster auf Dauer.', 34),

('identitaetsdiffusion', 'Borderline', 'Diffuses Selbstbild',
 'Interessen, Meinungen oder sogar Lebensziele können sich auffällig je nach Umfeld oder Beziehungsphase verschieben - ein unsicherer, wenig stabiler Kern des Selbstbilds.',
 'Vorlieben oder sogar Berufswünsche ändern sich auffällig oft, teils angepasst an die jeweils wichtigste Bezugsperson.',
 'Die eigene, stabile Identität als Ruhepunkt behalten, ohne die andere Person auf eine Version festlegen zu wollen.',
 'Die Wechsel als bewusste Unehrlichkeit werten - meistens ist es kein Spiel, sondern echte innere Unsicherheit.', 35),

('impulsive-handlungen', 'Borderline', 'Impulsive Handlungen in Belastungsmomenten',
 'Impulsive Handlungen - etwa Geld ausgeben, riskantes Fahren oder Substanzkonsum - können ein Versuch sein, unerträgliche innere Anspannung schnell zu regulieren.',
 'Plötzliche, untypische Handlungen kurz nach einer emotionalen Belastungsspitze, oft ohne erkennbare Vorüberlegung.',
 'Nach einer akuten Belastung fragen, was gerade wirklich helfen würde, statt die Handlung im Nachhinein zu bewerten.',
 'Die Handlung sofort moralisch bewerten - das erhöht meist nur die Scham, die oft schon vorher da war.', 36),

('chronisches-leeregefuehl', 'Borderline', 'Chronisches Leeregefühl',
 'Ein tiefes, andauerndes Gefühl der Leere, das unabhängig von äußeren Umständen bestehen bleibt, auch wenn objektiv alles in Ordnung ist.',
 'Aussagen wie "ich fühl einfach nichts" oder ein ständiges Suchen nach Ablenkung und Stimulation.',
 'Das Gefühl als eigenständiges Symptom ernst nehmen, nicht als Undankbarkeit gegenüber dem, was gerade da ist.',
 'Versuchen, die Leere mit der eigenen Anwesenheit oder Leistung zu füllen - das überfordert auf Dauer beide Seiten.', 37),

('wiederannaeherung-nach-eskalation', 'Beziehungszyklus', 'Die intensive Wiederannäherung nach der Eskalation',
 'Nach einem großen Streit folgt oft eine besonders liebevolle, intensive Phase - fast wie ein Neuanfang. Das kann sich als wiederkehrendes Muster festigen.',
 'Auf jede größere Eskalation folgt eine auffällig intensive Versöhnungsphase mit viel Nähe und Zuwendung.',
 'Die Versöhnung annehmen, ohne die vorherige Eskalation zu vergessen oder kleinzureden.',
 'Die intensive Nähe als Beweis nehmen, dass der Streit "nichts bedeutet hat" und deshalb nicht mehr angesprochen werden muss.', 38),

('testverhalten', 'Beziehungszyklus', 'Testverhalten',
 'Innerhalb des Zyklus kann es zu Provokationen kommen, die - bewusst oder unbewusst - prüfen sollen, ob die andere Person trotzdem bleibt.',
 'Provokationen, die inhaltlich wenig Sinn ergeben, aber eine klare Reaktion herausfordern: Bleiben oder Gehen.',
 'Erkennen, worum es eigentlich geht - Sicherheit -, ohne jeden Test inhaltlich mitzuspielen.',
 'Jeden Test unbedingt "bestehen" wollen - das verstärkt das Muster oft nur weiter.', 39),

('eskalationsspirale', 'Beziehungszyklus', 'Die Eskalationsspirale',
 'Ein kleiner Auslöser kann innerhalb weniger Sätze zu einem großen Streit anwachsen, weil jede Reaktion die nächste befeuert.',
 'Ein Thema, das eigentlich klein war, wird von Satz zu Satz größer, beide Seiten schaukeln sich gegenseitig hoch.',
 'Früh aussteigen, bevor die Spirale Fahrt aufnimmt - zum Beispiel mit einer Reframe-Frage (siehe Skills-Tab).',
 'Um das letzte Wort kämpfen wollen - das treibt die Spirale meist nur weiter an statt sie zu stoppen.', 40),

('verleugnung', 'Abwehrmechanismus', 'Verleugnung',
 'Ereignisse werden im Nachhinein anders dargestellt oder komplett abgestritten - meist kein bewusstes Lügen, sondern ein Schutz vor unerträglicher Realität.',
 'Ein Vorfall wird nachträglich völlig anders erzählt oder abgestritten, auch wenn er eindeutig stattgefunden hat.',
 'Nicht in eine Beweisdiskussion einsteigen. Bei Bedarf sachlich Fakten festhalten, ohne sie als Waffe einzusetzen.',
 'Die Verleugnung als bewusste Lüge werten - oft steckt dahinter Scham, die als noch unerträglicher erlebt wird.', 41),

('projektive-identifikation', 'Abwehrmechanismus', 'Projektive Identifikation',
 'Eigene, unerträgliche Gefühle können unbewusst in der anderen Person ausgelöst werden - du fühlst plötzlich das, was eigentlich die andere Person gerade innerlich spürt.',
 'Du fühlst dich plötzlich genauso wütend, hilflos oder schuldig, wie es vermutlich bei der anderen Person gerade innerlich aussieht.',
 'Kurz innehalten und fragen, ob das eigene Gefühl wirklich deins ist oder gerade übernommen wurde.',
 'Das übernommene Gefühl ungefiltert zurückspielen - das verstärkt die Dynamik meist nur zusätzlich.', 42),

('intellektualisierung', 'Abwehrmechanismus', 'Intellektualisierung',
 'Ein eigentlich emotionales Thema wird plötzlich sachlich-abstrakt verhandelt, um das dahinterliegende Gefühl nicht spüren zu müssen.',
 'Ein Streit wird plötzlich sachlich-theoretisch geführt, etwa mit Sätzen wie "psychologisch betrachtet ist das ja...".',
 'Sanft zurück zum Gefühl führen, etwa mit "Was fühlst du dabei gerade?", ohne die Analyse abzuwerten.',
 'In die Theoriediskussion mit einsteigen - das bestätigt die Vermeidung nur, statt sie aufzulösen.', 43),

('du-botschaften', 'Kommunikation', 'Pauschale Du-Botschaften',
 'Verallgemeinernde Vorwürfe mit "immer" oder "nie" statt einer konkreten Situationsbeschreibung machen es schwer, auf den eigentlichen Punkt einzugehen.',
 'Sätze mit "immer", "nie" oder "typisch du" statt einer konkreten, benennbaren Situation.',
 'Nach der konkreten Situation fragen, etwa "Was genau meinst du, heute Morgen?", ohne die Pauschalisierung zu übernehmen.',
 'Mit einer Gegen-Pauschalisierung antworten, etwa "du machst das doch auch immer" - das eskaliert nur weiter.', 44),

('schweigen-als-kommunikation', 'Kommunikation', 'Schweigen als Kommunikationsform',
 'Vollständiger Rückzug aus dem Gespräch, teils über Stunden oder Tage, ohne inhaltliche Reaktion auf Fragen oder Gesprächsversuche.',
 'Auf Fragen oder Gesprächsversuche folgt komplettes Schweigen, das sich lange hinziehen kann.',
 'Raum lassen, ohne aufzugeben - kurz signalisieren, dass du ansprechbar bleibst, ohne zu drängen.',
 'Das Schweigen mit noch mehr Reden durchbrechen wollen - das erhöht meist nur den Druck auf beiden Seiten.', 45),

('vorwurf-als-frage', 'Kommunikation', 'Der als Frage verpackte Vorwurf',
 'Eine Frage, die keine echte Antwort erwartet, sondern eine Bewertung transportiert - etwa "warum bist du eigentlich so egoistisch?".',
 'Fragen, auf die es eigentlich keine gute Antwort gibt, weil die Bewertung schon in der Frage steckt.',
 'Die eigentliche Aussage dahinter benennen, statt inhaltlich auf die Frage einzugehen: "Das klingt für mich nach einem Vorwurf. Worum geht es dir?"',
 'Die Frage wörtlich beantworten und sich rechtfertigen - das bestätigt den Vorwurf oft implizit.', 46);
