-- Eigenständig formulierte Wissenskarten zu DBT-Grundlagen und einzelnen Skills,
-- als Ergänzung zu den bestehenden Beziehungsmustern. Inhaltlich orientiert an
-- allgemein bekannten DBT-Konzepten (Bohus/Wolf u.a.), aber komplett neu
-- formuliert für die Partner:innen-Perspektive dieser App (keine Übernahme
-- urheberrechtlich geschützter Originaltexte).
INSERT INTO patterns (slug, category, title, summary, recognize, helps, avoid, sort_order) VALUES

('was-ist-ein-skill', 'DBT-Basics', 'Was ist ein "Skill"?',
 'Ein Skill ist eine konkrete, erlernbare Handlung, um mit starken Gefühlen umzugehen – kein Charakterzug und keine Garantie.',
 'Deine Partnerin/dein Partner spricht in der Therapie von „Skills", „Skillskette" oder „Skills anwenden" – das sind bewusst eingeübte Bewältigungsschritte, keine Zauberformel.',
 'Als Info nehmen, nicht als Erwartungshaltung. Skills brauchen Übung und funktionieren nicht in jeder Situation gleich gut.',
 '„Wende doch deinen Skill an" als Vorwurf in der Hitze des Streits – das wirkt bevormundend und verstärkt oft eher die Anspannung.', 7),

('biosoziale-theorie', 'DBT-Basics', 'Warum Gefühle so schnell hochkochen',
 'Die biosoziale Theorie erklärt intensive Gefühlsausbrüche als Zusammenspiel aus hoher emotionaler Empfindlichkeit und einem Umfeld, das Gefühle früher oft nicht ernst genommen hat.',
 'Reaktionen wirken unverhältnismäßig zum Anlass und kommen sehr schnell, sehr intensiv und klingen langsam wieder ab.',
 'Die Reaktion als Ausdruck echter innerer Überflutung verstehen, nicht als Absicht dir zu schaden. Das nimmt nichts von deinem eigenen Recht auf Grenzen.',
 'Die Erklärung als Entschuldigung für jedes Verhalten nehmen – Verstehen ist etwas anderes als alles hinnehmen.', 8),

('emotionales-netz', 'DBT-Basics', 'Wenn ein kleiner Auslöser eine riesige Reaktion bringt',
 'Eine aktuelle Situation kann alte, ähnliche Erfahrungen "mit auslösen" – die Reaktion gilt dann nicht nur dem Moment, sondern auch dem, was er unbewusst erinnert.',
 'Die Reaktion fühlt sich für dich völlig überzogen an, während sie für die andere Person absolut real und riesig ist.',
 'Nicht um die "richtige Reaktionsgröße" streiten. Fragen, was der Moment gerade auslöst, statt nur den Auslöser selbst zu bewerten.',
 'Erklären wollen, dass die Reaktion "nicht zur Situation passt" – das wird als Nicht-Ernstnehmen erlebt.', 9),

('radikale-akzeptanz', 'Skill: Stresstoleranz', 'Radikale Akzeptanz',
 'Eine schwierige Realität so anzunehmen, wie sie gerade ist – ohne sie gutzuheißen – reduziert oft das zusätzliche Leiden am Kämpfen gegen das, was ohnehin schon da ist.',
 'Du merkst es an Gedanken wie "das darf nicht wahr sein", "das ist nicht fair" oder endlosem Grübeln über das "Warum", das nichts mehr verändert.',
 'Bewusst anerkennen: "Das ist gerade die Situation." Das schafft Raum, um zu handeln, statt nur gegen die Realität anzukämpfen.',
 'Akzeptanz mit Resignation oder Zustimmung verwechseln – akzeptieren heißt nicht, alles gutzuheißen oder eigene Grenzen aufzugeben.', 10),

('stop-skill', 'Skill: Stresstoleranz', 'STOP – kurz innehalten in Hochspannung',
 'Eine einfache Vier-Schritte-Pause für den Moment maximaler Anspannung: kurz stoppen, einen Schritt zurücktreten, wahrnehmen was passiert, dann bewusst weitermachen.',
 'Der Puls steigt, Gedanken werden eng, die erste Reaktion wäre impulsiv – das ist der Moment, in dem STOP am meisten bringt.',
 'Buchstäblich innehalten (auch körperlich), einmal tief durchatmen, kurz beobachten, was gerade in dir und um dich passiert, dann erst reagieren.',
 'STOP als Vermeidung nutzen, um Themen dauerhaft nicht anzusprechen – es ist eine Pause, kein Ausweichen.', 11),

('fuenf-sinne-beruhigung', 'Skill: Stresstoleranz', 'Sich beruhigen über die 5 Sinne',
 'Gezielt einen oder mehrere Sinne ansprechen (Sehen, Hören, Riechen, Schmecken, Fühlen), um die eigene Anspannung körperlich herunterzufahren.',
 'Du merkst körperliche Anspannung – flacher Atem, enger Brustkorb, Grübelschleifen – und brauchst schnell etwas, das nicht nur im Kopf stattfindet.',
 'Konkret ausprobieren: kaltes Wasser über die Hände, ein starkes Aroma riechen, Musik bewusst hören, etwas Strukturiertes anschauen. Was wirkt, ist individuell.',
 'Erwarten, dass ein Sinnesreiz das zugrunde liegende Problem löst – er beruhigt das Nervensystem, ersetzt aber kein Gespräch danach.', 12),

('validierung-partner', 'Skill: Kommunikation', 'Validierung: Verstehen zeigen, ohne zuzustimmen',
 'Validierung heißt, der anderen Person zu zeigen, dass ihr Erleben nachvollziehbar ist – unabhängig davon, ob du ihre Einschätzung der Situation teilst.',
 'Ein Gespräch eskaliert oft weiter, wenn zuerst die Fakten richtiggestellt statt das Gefühl anerkannt wird.',
 'Das Gefühl benennen, bevor du inhaltlich widersprichst: "Ich merke, das hat dich wirklich verletzt." Das beruhigt oft, bevor überhaupt über Fakten gesprochen wird.',
 'Validierung mit Zustimmung verwechseln – du kannst ein Gefühl anerkennen und trotzdem anderer Meinung über die Situation bleiben.', 13),

('grenzen-nein-sagen', 'Skill: Kommunikation', 'Grenzen setzen und Nein sagen',
 'Eine Bitte abzulehnen oder eine eigene Grenze zu benennen ist eine erlernbare Fertigkeit – dafür braucht es weder Rechtfertigung noch Härte.',
 'Du merkst Grenzüberschreitung oft erst an eigener Erschöpfung oder Groll, weil das Nein-Sagen im Moment schwerfällt.',
 'Kurz und klar bleiben: die Grenze benennen, kurz begründen (falls sinnvoll), keine Endlos-Rechtfertigung. Der richtige Zeitpunkt und Ton sind wichtiger als die perfekte Formulierung.',
 'Ausufernd rechtfertigen oder aus Angst vor Streit ganz auf die eigene Grenze verzichten – beides führt langfristig zu mehr Erschöpfung.', 14);
