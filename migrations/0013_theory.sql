-- Theorie-Bereich: Konzepte von John Gottman (Beziehungswissenschaft) sowie
-- Paul Watzlawick und Marshall Rosenberg (Kommunikation), jeweils kurz in
-- eigenen Worten erklärt und auf eine Beziehung mit BPD/PTBS-Dynamik
-- übertragen. Keine wörtlichen Zitate oder längeren Paraphrasen aus den
-- Büchern. Pflichtfeld "limits" für Grenzen und Evidenzlage.
-- (Ursprünglich als 0006 geplant, 0006 ist bereits belegt - daher 0013.)

CREATE TABLE theory (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  section TEXT NOT NULL CHECK (section IN ('beziehungswissenschaft', 'kommunikation')),
  author TEXT NOT NULL CHECK (author IN ('Gottman', 'Watzlawick', 'Rosenberg')),
  title TEXT NOT NULL,
  core TEXT NOT NULL,         -- Kernaussage, 1-3 Sätze
  everyday TEXT NOT NULL,     -- wie es im Alltag aussieht
  in_context TEXT NOT NULL,   -- Übertragung auf BPD/PTBS-Dynamik
  limits TEXT NOT NULL,       -- Pflichtfeld: Grenzen, Evidenzlage
  reference TEXT,             -- Buchtitel/Quelle
  sort_order INTEGER DEFAULT 0
);

CREATE TABLE theory_patterns (
  theory_id INTEGER NOT NULL REFERENCES theory(id) ON DELETE CASCADE,
  pattern_id INTEGER NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  PRIMARY KEY (theory_id, pattern_id)
);

CREATE TABLE theory_skills (
  theory_id INTEGER NOT NULL REFERENCES theory(id) ON DELETE CASCADE,
  skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (theory_id, skill_id)
);

INSERT INTO theory (slug, section, author, title, core, everyday, in_context, limits, reference, sort_order) VALUES

('gottman-einfuehrung', 'beziehungswissenschaft', 'Gottman', 'Einführung: John Gottman',
 'Der Psychologe John Gottman hat über Jahrzehnte Paare im Streit und im Alltag beobachtet, unter anderem in einem eigens eingerichteten Labor. Aus wiederkehrenden Interaktionsmustern konnte er mit hoher Trefferquote vorhersagen, welche Paare sich trennen.',
 'Viel vorhersagen lässt nicht, ob ein Paar streitet, sondern wie: welcher Ton am Anfang steht, ob Reparaturversuche ankommen und wie viel Wohlwollen im Alltag da ist.',
 'Die Konzepte geben eine Sprache für Dinge, die sich sonst diffus anfühlen. In einer Beziehung mit BPD/PTBS-Dynamik sind sie vor allem ein Werkzeug zur eigenen Orientierung, kein Maßstab, an dem die andere Person gemessen wird.',
 'Die Forschung stammt überwiegend von Paaren ohne schwere psychische Erkrankung. Viele Zahlen, etwa zur Vorhersagegenauigkeit, kommen aus Gottmans eigenen Studien und wurden nur teilweise unabhängig bestätigt. Die Methoden setzen voraus, dass sich beide zumindest zeitweise selbst regulieren können.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 10),

('vier-reiter', 'beziehungswissenschaft', 'Gottman', 'Die vier apokalyptischen Reiter',
 'Vier Verhaltensweisen im Streit sagen eine Trennung besonders stark voraus: Kritik (Angriff auf die Person statt Beschwerde über ein Verhalten), Verachtung (Spott, Sarkasmus, Herabsetzung), Rechtfertigung (jede eigene Beteiligung abwehren) und Mauern (emotionaler Rückzug). Verachtung gilt als stärkster Einzelfaktor.',
 'Aus "Der Müll ist noch nicht draußen" wird "Du bist einfach rücksichtslos" (Kritik), dann folgt ein Augenrollen (Verachtung), die Antwort "Ich hatte eben keine Zeit" (Rechtfertigung) und schließlich Schweigen vor dem Handy (Mauern).',
 'Oft verteilen sich die Reiter ungleich: Eine Person zeigt vor allem Kritik und Verachtung, die andere mauert, um sich zu schützen. Beide Anteile halten den Kreislauf am Laufen, auch wenn sie sich sehr unterschiedlich anfühlen. Gelbe und Rote Karte setzen genau hier an.',
 'Die Reiter wurden an Paaren ohne schwere Persönlichkeitsstörung beschrieben. Mauern kann bei starker Überflutung auch Selbstschutz sein und ist dann nicht gleichzusetzen mit Desinteresse.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 20),

('gegenmittel-reiter', 'beziehungswissenschaft', 'Gottman', 'Gegenmittel zu den vier Reitern',
 'Zu jedem Reiter gibt es ein Gegenstück: eine Beschwerde als Ich-Botschaft statt Kritik, eine Kultur der Wertschätzung statt Verachtung, den eigenen Anteil übernehmen statt sich zu rechtfertigen, und körperliche Selbstberuhigung statt Mauern.',
 '"Ich ärgere mich, dass der Müll noch drin ist. Kannst du ihn heute noch rausbringen?" statt "Du bist rücksichtslos". Oder: "Stimmt, das habe ich vergessen" statt einer langen Begründung.',
 'Du kannst nur deine eigenen Gegenmittel anwenden. Das verändert die Dynamik oft trotzdem, weil ein Teil des Kreislaufs wegfällt. Wenn die andere Seite gerade nicht erreichbar ist, heißt das nicht, dass die Gegenmittel falsch sind.',
 'Die Gegenmittel sind aus Beobachtungen abgeleitet und Teil von Gottmans Therapieprogramm; ihre Wirkung für sich genommen ist weniger gut untersucht als die Reiter selbst. Sie setzen eine Regulationsfähigkeit voraus, die im akuten Trigger fehlen kann.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 30),

('flooding', 'beziehungswissenschaft', 'Gottman', 'Flooding: wenn der Körper überflutet ist',
 'Bei starker körperlicher Erregung, etwa deutlich erhöhtem Puls, ist ein konstruktives Gespräch kaum noch möglich. Empfohlen wird eine bewusste Pause von mindestens etwa 20 Minuten, in der man nicht innerlich weiterstreitet, mit einer klaren Ansage, wann man zurückkommt.',
 'Mitten in einer Diskussion merkst du Herzklopfen, Hitze und Tunnelblick. Du sagst "Ich brauche zwanzig Minuten, dann reden wir weiter", gehst eine Runde und lenkst dich bewusst ab.',
 'Erklärt, warum Gespräche auf dem Höhepunkt scheitern, egal wie gut die Argumente sind. Die Pause ist kein Mauern, solange sie angekündigt und zeitlich begrenzt ist. Genau das ist der Kern des Skills "Der physische Ausstieg".',
 'Die rund 20 Minuten sind ein Richtwert aus Gottmans Beobachtungen, keine feste Grenze. Bei traumabedingter Übererregung kann die Beruhigung deutlich länger dauern. Die Pause wirkt nur, wenn die andere Seite sie auch zulässt.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 40),

('reparaturversuche', 'beziehungswissenschaft', 'Gottman', 'Reparaturversuche',
 'Kleine Gesten oder Sätze, die eine Eskalation abbremsen: Humor, eine Berührung, ein "Lass uns kurz anhalten". Für den Verlauf entscheidend ist weniger, ob jemand es versucht, als ob der Versuch angenommen wird.',
 'Mitten im Streit sagt jemand: "Okay, das kam härter raus als gemeint." Die andere Person atmet durch, und der Ton wird ruhiger.',
 'Bei hoher Grundanspannung werden Reparaturversuche oft nicht erkannt oder sogar als Angriff gelesen. Das ist ein Signal dafür, wie hoch die Anspannung ist, kein Beweis für fehlende Liebe. Es hilft, in ruhigen Phasen gemeinsam festzulegen, woran man einen Reparaturversuch erkennt, etwa an einem Codewort.',
 'Wie gut Reparaturversuche ankommen, hängt stark vom allgemeinen Wohlwollen in der Beziehung ab. In angespannten Phasen ist ihre Wirkung begrenzt, egal wie geschickt sie formuliert sind.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 50),

('nachbesprechung-streit', 'beziehungswissenschaft', 'Gottman', 'Nachbesprechung eines Streits',
 'Ein strukturiertes Gespräch in einer ruhigen Phase, in dem beide nach demselben Ablauf reden: eigene Gefühle, eigene Wahrnehmung ohne die andere zu widerlegen, was einen getriggert hat (auch alte Themen), der eigene Anteil und was man nächstes Mal anders machen möchte.',
 'Zwei Tage nach einem Streit setzt ihr euch bewusst hin. Jede Person erzählt ihre Sicht, die andere hört zu und fasst zusammen, ohne zu korrigieren. Erst danach geht es um den eigenen Anteil.',
 'Das Kernstück für die Stufe "Danach". Weil beide dasselbe Schema durchlaufen, ist es ein gemeinsames Ritual und keine Anklage, was Scham senken kann. Den Ablauf am besten in einer guten Phase vereinbaren, nicht erst nach dem nächsten Streit vorschlagen.',
 'Setzt voraus, dass beide ausreichend reguliert sind und zuhören können, ohne sich angegriffen zu fühlen. Die Übung stammt aus der Gottman-Paartherapie; zur Wirkung außerhalb dieses Rahmens gibt es wenig eigene Forschung.',
 'Gottman Institute: Übung zur Nachbesprechung eines Streits ("Aftermath of a Fight or Regrettable Incident")', 60),

('sanfter-einstieg', 'beziehungswissenschaft', 'Gottman', 'Der sanfte Gesprächseinstieg',
 'Wie ein Gespräch beginnt, sagt stark voraus, wie es endet. Ein sanfter Einstieg beschreibt eine Beobachtung, ein Gefühl und einen Wunsch, statt mit einem Vorwurf zu starten. Das ähnelt den vier Schritten der Gewaltfreien Kommunikation nach Rosenberg.',
 '"Mir ist aufgefallen, dass wir diese Woche kaum Zeit zu zweit hatten. Das macht mich traurig. Hast du Lust auf einen Abend am Wochenende?" statt "Du hast ja nie Zeit für mich."',
 'Ein sanfter Einstieg nimmt der anderen Person einen Anlass, sich angegriffen zu fühlen. Er garantiert aber nicht, dass er auch so gehört wird, wenn die Grundanspannung schon hoch ist.',
 'Die Vorhersagekraft des Einstiegs stammt aus Laborstudien mit kurzen Konfliktgesprächen. Ob sie sich auf Beziehungen mit starker emotionaler Dysregulation übertragen lässt, ist nicht untersucht.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 70),

('zuwendungsangebote', 'beziehungswissenschaft', 'Gottman', 'Zuwendungsangebote und Hinwendung',
 'Im Alltag machen Partner:innen ständig kleine Angebote um Aufmerksamkeit: ein Kommentar, eine Frage, ein Blick. Stabile Paare reagieren darauf überwiegend zugewandt. So entsteht mit der Zeit eine Art emotionales Bankkonto, von dem man in Konflikten zehren kann.',
 '"Schau mal, der Vogel am Fenster." Zugewandt ist ein kurzer Blick und ein "Oh, schön". Abgewandt wäre, gar nicht zu reagieren.',
 'In angespannten Beziehungen gehen viele Angebote in beide Richtungen unter, oft weil beide im Alarmmodus sind. Bewusst auf kleine Angebote zu reagieren ist eine der wenigen Maßnahmen, die auch einseitig etwas bewirken kann. Grenzen ersetzt sie nicht.',
 'Das emotionale Bankkonto ist eine Metapher, keine messbare Größe. Die Befunde zu Zuwendungsangeboten stammen überwiegend aus Gottmans eigener Forschung mit frisch verheirateten Paaren.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 80),

('verhaeltnis-5-zu-1', 'beziehungswissenschaft', 'Gottman', 'Das Verhältnis 5:1',
 'In stabilen Beziehungen kommen im Konflikt auf eine negative Interaktion etwa fünf positive: Interesse, Zustimmung, Humor, Zärtlichkeit. Das Negative verschwindet nicht, es wird aber ausgeglichen.',
 'Ein Paar streitet über Geld, lacht zwischendurch über sich selbst, nickt einander zu und sagt auch mal "Da hast du recht".',
 'Als Richtgröße für die eigene Beobachtung nützlich, etwa beim Blick in dein Log. Es ist aber keine Zielvorgabe, die eine Person allein erfüllen kann: Mehr Freundlichkeit von deiner Seite gleicht fortgesetzte Abwertung nicht aus.',
 'Die Zahl stammt aus Gottmans eigenen Studien und wird oft stark vereinfacht wiedergegeben. Sie beschreibt einen Durchschnitt stabiler Paare, keine Schwelle, ab der eine Beziehung sicher funktioniert.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 90),

('loesbare-dauerhafte-probleme', 'beziehungswissenschaft', 'Gottman', 'Lösbare und dauerhafte Probleme',
 'Ein Großteil der Konflikte in Beziehungen sind Dauerthemen, die aus unterschiedlichen Persönlichkeiten und Bedürfnissen entstehen. Sie lassen sich nicht lösen, nur im Gespräch halten. Lösbar sind vor allem konkrete Sachfragen.',
 'Eine Person braucht mehr Ordnung, die andere mehr Spontaneität. Das verschwindet nie ganz, aber man kann gut oder schlecht darüber reden.',
 'Hilft zu unterscheiden, wo Lösungssuche sinnvoll ist (Termine, Aufgaben, Sachentscheidungen) und wo es um den Umgang geht statt um eine Lösung. Wer ein Dauerthema immer wieder lösen will, erlebt jedes Gespräch als Scheitern.',
 'Die Aufteilung beruht auf Gottmans Beobachtungen und wird oft mit einer festen Prozentzahl zitiert, die nicht unabhängig bestätigt ist. Symptome einer Erkrankung sind außerdem kein bloßer Persönlichkeitsunterschied und gehören in die Behandlung, nicht nur ins Paargespräch.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 100),

('einfluss-annehmen', 'beziehungswissenschaft', 'Gottman', 'Einfluss annehmen',
 'Die Bereitschaft, sich von Wünschen und Sichtweisen des Partners oder der Partnerin beeinflussen zu lassen, ist ein Stabilitätsfaktor. Beziehungen, in denen eine Seite jeden Einfluss abwehrt, sind deutlich instabiler.',
 '"Du hast recht, lass es uns so machen, wie du vorgeschlagen hast." Oder zumindest: "Guter Punkt, darüber denke ich nach."',
 'Einfluss annehmen gilt für beide Seiten, auch für dich. Wenn deine Vorschläge grundsätzlich abgelehnt werden, beschreibt das Muster "Beratungsresistenz" diese Seite. Einfluss annehmen heißt nicht, jede Forderung zu erfüllen.',
 'Der Befund stammt vor allem aus einer Studie mit heterosexuellen, frisch verheirateten Paaren und bezog sich dort auf die Männer. Wie gut er auf andere Konstellationen übertragbar ist, ist weniger klar.',
 'John M. Gottman & Nan Silver: Die 7 Geheimnisse der glücklichen Ehe', 110),

('watzlawick-einfuehrung', 'kommunikation', 'Watzlawick', 'Einführung: Paul Watzlawick',
 'Paul Watzlawick gehörte zur Palo-Alto-Gruppe, die Kommunikation systemisch betrachtet hat: nicht als Botschaft einer einzelnen Person, sondern als Kreislauf zwischen Menschen. Bekannt sind vor allem seine fünf Axiome der Kommunikation.',
 'Statt zu fragen, wer schuld ist, fragt der systemische Blick, welches Muster zwischen zwei Menschen immer wieder abläuft.',
 'Hilft, aus der Schuldfrage auszusteigen und das Muster selbst anzuschauen. Das nimmt dir nicht das Recht auf Grenzen, macht aber verständlicher, warum gut gemeinte Reaktionen einen Kreislauf manchmal verstärken.',
 'Ein theoretisches Modell, keine empirisch geprüfte Methode. Es beschreibt, wie Kommunikation funktioniert, und liefert selbst keine Anleitung, wie man sie verbessert.',
 'Watzlawick, Beavin & Jackson: Menschliche Kommunikation; populär: Paul Watzlawick: Anleitung zum Unglücklichsein', 10),

('axiom-nicht-nicht-kommunizieren', 'kommunikation', 'Watzlawick', 'Man kann nicht nicht kommunizieren',
 'Jedes Verhalten in Gegenwart anderer sendet eine Botschaft, auch Schweigen, ein Gesichtsausdruck oder Rückzug. Neutrales Nicht-Kommunizieren gibt es nicht.',
 'Jemand antwortet auf eine Nachricht nicht. Die andere Person liest trotzdem etwas hinein: Ärger, Desinteresse oder einfach Stress.',
 'Erklärt, warum ein Gesichtsausdruck oder ein nicht abgehobenes Telefon zur Aussage wird, die heftige Reaktionen auslösen kann. Und warum Mauern immer auch etwas mitteilt, selbst wenn es als Schutz gemeint ist. Eine kurze Ansage wie "Ich brauche Ruhe, ich melde mich um acht" macht die Botschaft eindeutiger.',
 'Axiom heißt hier Grundannahme, nicht bewiesene Tatsache. Das Modell sagt nicht, wie eine Botschaft gedeutet wird; das hängt stark von der Verfassung des Gegenübers ab.',
 'Watzlawick, Beavin & Jackson: Menschliche Kommunikation', 20),

('axiom-inhalt-beziehung', 'kommunikation', 'Watzlawick', 'Inhalts- und Beziehungsebene',
 'Jede Nachricht hat eine Sachebene und eine Beziehungsebene. Die Beziehungsebene bestimmt, wie der Inhalt verstanden wird.',
 '"Die Handtücher liegen schon wieder am Boden." Sachlich eine Feststellung, auf der Beziehungsebene kann es heißen: "Du nimmst keine Rücksicht auf mich."',
 'Der Kern vieler Missverständnisse: Eine Person spricht auf der Sachebene, etwa über den Putzplan, die andere hört die Beziehungsebene und antwortet darauf. Es hilft, die Beziehungsebene direkt anzusprechen, statt den Inhalt immer weiter zu präzisieren.',
 'Die Trennung der Ebenen ist ein Denkmodell; im echten Gespräch vermischen sie sich. Das Modell erklärt Missverständnisse, verhindert sie aber nicht von selbst.',
 'Watzlawick, Beavin & Jackson: Menschliche Kommunikation', 30),

('axiom-interpunktion', 'kommunikation', 'Watzlawick', 'Interpunktion: Wer hat angefangen?',
 'In einem Kreislauf setzt jede Seite den Anfang an eine andere Stelle. "Ich ziehe mich zurück, weil du angreifst" und "Ich greife an, weil du dich zurückziehst" beschreiben dieselbe Schleife.',
 'Beide sind überzeugt, nur auf die andere Person zu reagieren, und können dafür jeweils gute Beispiele nennen.',
 'Erklärt den Kreislauf aus Scannen und Kontrolle auf der einen und Mauern auf der anderen Seite. Die Frage "Wer hat angefangen?" ist nicht lösbar. Hilfreicher ist die Frage, an welcher Stelle du selbst aussteigen kannst.',
 'Das Modell beschreibt Kreisläufe, nicht Verantwortung. Dass beide beteiligt sind, heißt weder, dass beide gleich viel beitragen, noch dass Grenzüberschreitungen gerechtfertigt sind.',
 'Watzlawick, Beavin & Jackson: Menschliche Kommunikation', 40),

('axiom-digital-analog', 'kommunikation', 'Watzlawick', 'Digitale und analoge Kommunikation',
 'Menschen kommunizieren mit Worten (digital) und mit Tonfall, Mimik und Gestik (analog). Beziehungsbotschaften laufen vor allem analog und sind oft mehrdeutig.',
 '"Passt schon" mit einem Lächeln bedeutet etwas anderes als "Passt schon" mit verschränkten Armen.',
 'Deshalb gewinnt die eigene Mimik gegen die eigenen Worte: Ein genervter Blick wiegt schwerer als ein ruhiger Satz. Wer stark auf Bedrohung achtet, liest analoge Signale besonders schnell und besonders negativ.',
 'Digital und analog sind hier anders gemeint als in der Technik und deshalb leicht missverständlich. Das Modell ist beschreibend und hat keine eigene Messmethode.',
 'Watzlawick, Beavin & Jackson: Menschliche Kommunikation', 50),

('axiom-symmetrisch-komplementaer', 'kommunikation', 'Watzlawick', 'Symmetrische und komplementäre Muster',
 'Interaktionen beruhen entweder auf Gleichheit (beide tun dasselbe, etwa beide werden lauter) oder auf Ergänzung (eine Person führt, die andere folgt; eine kontrolliert, die andere zieht sich zurück).',
 'Symmetrisch: Jeder will das letzte Wort. Komplementär: Eine Person plant alles, die andere lässt planen.',
 'Starre komplementäre Muster wie Kontrolle und Rückzug verfestigen sich, weil jede Seite die andere in ihrer Rolle bestätigt. Symmetrische Muster eskalieren eher schnell. Beides zu erkennen hilft, bewusst aus der eigenen Rolle auszusteigen.',
 'Eine grobe Einteilung; reale Beziehungen wechseln zwischen beiden Formen. Das Modell sagt nicht, welches Muster gesund ist.',
 'Watzlawick, Beavin & Jackson: Menschliche Kommunikation', 60),

('doppelbindung', 'kommunikation', 'Watzlawick', 'Doppelbindung (Double Bind)',
 'Ein Konzept aus dem Umfeld der Palo-Alto-Gruppe um Gregory Bateson: Eine Person erhält widersprüchliche Botschaften, kann den Widerspruch nicht ansprechen und sich der Situation auch nicht entziehen. Jede Reaktion ist dann falsch.',
 '"Sei doch mal spontan!" Wer darauf spontan reagiert, folgt einer Aufforderung und ist damit gerade nicht spontan.',
 'Beschreibt das Gefühl, dass jede Reaktion im Nachhinein zum Vorwurf wird. Hilfreich ist, den Widerspruch für dich zu erkennen, nach eigenen Werten zu handeln und nicht nach der einen richtigen Antwort zu suchen. Siehe die Muster "Double-Bind" und "Instanz ohne Gesetzbuch".',
 'Das Konzept wurde ursprünglich als Erklärung für Schizophrenie vorgeschlagen; diese Annahme gilt heute als widerlegt. Als Beschreibung widersprüchlicher Kommunikation ist es weiterhin nützlich, aber kein Diagnoseinstrument.',
 'Bateson, Jackson, Haley & Weakland (1956): Toward a Theory of Schizophrenia', 70),

('rosenberg-einfuehrung', 'kommunikation', 'Rosenberg', 'Einführung: Marshall Rosenberg',
 'Marshall Rosenberg hat die Gewaltfreie Kommunikation (GFK) entwickelt. Grundidee: Hinter jedem Vorwurf und jeder Forderung steht ein unerfülltes Bedürfnis. Wer das ausspricht, statt zu urteilen, macht Verständigung wahrscheinlicher.',
 'Statt "Du bist so unzuverlässig" sagt man, was man beobachtet hat, wie es einem damit geht und was man sich wünscht.',
 'Gibt eine Struktur, um in ruhigen Momenten klarer zu sprechen und hinter Vorwürfen das Bedürfnis zu hören. Im akuten Trigger ist sie kaum anwendbar; dafür sind die Skills der Stufen Mitte und Spät gedacht.',
 'Es gibt Studien zur Wirksamkeit, sie sind aber methodisch meist schwach (kleine Gruppen, oft ohne Kontrollgruppe). GFK wirkt am besten, wenn beide sie anwenden, und kann als Technik manipulativ wirken, wenn sie nicht echt gemeint ist.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 10),

('gfk-vier-schritte', 'kommunikation', 'Rosenberg', 'Die vier Schritte',
 'Beobachtung ohne Bewertung, dann das eigene Gefühl, das Bedürfnis dahinter und zuletzt eine konkrete, erfüllbare Bitte.',
 '"Du bist heute zweimal später gekommen als ausgemacht (Beobachtung). Ich war unruhig (Gefühl), weil mir Verlässlichkeit wichtig ist (Bedürfnis). Kannst du mir kurz schreiben, wenn es später wird? (Bitte)"',
 'Hilft vor allem der eigenen Klarheit: Wer vorher weiß, was er beobachtet, fühlt und braucht, rutscht seltener in Vorwürfe. Die Schritte müssen nicht wörtlich gesprochen werden; zu formelhaft wirkt es schnell künstlich.',
 'Ein Gesprächsmodell, dessen Wirksamkeit vor allem in kleinen, wenig kontrollierten Studien untersucht wurde. In hoher Anspannung ist die Struktur kaum abrufbar.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 20),

('beobachtung-bewertung', 'kommunikation', 'Rosenberg', 'Beobachtung statt Bewertung',
 'Eine Beobachtung beschreibt, was konkret passiert ist, eine Bewertung fasst es in ein Urteil. "Du machst nie etwas im Haushalt" ist Bewertung, "Gestern und heute ist das Geschirr stehen geblieben" ist Beobachtung.',
 'Wörter wie "immer", "nie" und "typisch" oder Eigenschaften wie "faul" zeigen meist eine Bewertung an.',
 'Hilft nicht nur beim eigenen Sprechen, sondern auch beim Zuhören: Verallgemeinerungen der anderen Person lassen sich als Bewertung erkennen, ohne dass du dich gegen jedes "nie" rechtfertigen musst.',
 'Völlig bewertungsfreie Sprache gibt es kaum. Die Unterscheidung ist ein Hilfsmittel, kein Maßstab für richtiges Sprechen.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 30),

('gefuehle-pseudogefuehle', 'kommunikation', 'Rosenberg', 'Gefühle und Pseudo-Gefühle',
 'Manche Sätze klingen nach Gefühl, beschreiben aber eine Deutung über die andere Person: "Ich fühle mich übergangen" heißt eigentlich "Du hast mich übergangen". Echte Gefühle beschreiben den eigenen Zustand: traurig, erschöpft, verletzt, ängstlich.',
 '"Ich fühle mich manipuliert" enthält einen Vorwurf. "Ich bin verunsichert und wütend" beschreibt, was in mir los ist.',
 'Pseudo-Gefühle kommen als Anklage an und lösen schnell Rechtfertigung aus, in beide Richtungen. Das echte Gefühl dahinter zu benennen ist verletzlicher, aber schwerer anzugreifen.',
 'Die Grenze zwischen Gefühl und Deutung ist nicht immer scharf. Rosenbergs Gefühlslisten sind eine praktische Orientierung, keine psychologische Klassifikation.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 40),

('bitte-forderung', 'kommunikation', 'Rosenberg', 'Bitte oder Forderung',
 'Eine Bitte lässt ein Nein zu. Eine Forderung erkennt man daran, was nach einem Nein passiert: Vorwurf, Strafe oder Rückzug. Dieselben Worte können beides sein.',
 '"Kannst du heute einkaufen?" ist eine Bitte, wenn "Heute nicht" in Ordnung ist. Folgt darauf eisiges Schweigen, war es eine Forderung.',
 'Hilft, ein Muster aus immer neuen Forderungen und Bestrafung bei Nichterfüllung als solches zu erkennen. Und es lädt ein, die eigenen Bitten ehrlich zu prüfen: Kann ich mit einem Nein leben?',
 'Nicht jede Forderung ist problematisch; es gibt berechtigte Erwartungen und Grenzen. Die Unterscheidung beschreibt die Haltung hinter einem Satz, nicht ob er berechtigt ist.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 50),

('empathisch-zuhoeren', 'kommunikation', 'Rosenberg', 'Empathisch zuhören',
 'Hinter einem Vorwurf ein unerfülltes Bedürfnis hören, statt sich gegen den Vorwurf zu verteidigen. "Du kümmerst dich nie um mich" kann heißen: Ich möchte gesehen werden, ich brauche Entlastung.',
 'Statt "Das stimmt doch gar nicht" fragt man: "Du wünschst dir gerade mehr Unterstützung von mir?"',
 'Entspricht dem Skill "Erst die Angst spiegeln, dann die Fakten". Empathie heißt aber nicht, die Deutung zu übernehmen: Du kannst das Bedürfnis hören, ohne dem Vorwurf zuzustimmen.',
 'Im akuten Trigger wird selbst gut gemeinte Empathie oft als Belehrung oder Technik erlebt. Dauerhaft einseitiges empathisches Zuhören ohne Gegenseitigkeit kann erschöpfen.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 60),

('giraffe-und-wolf', 'kommunikation', 'Rosenberg', 'Giraffe und Wolf',
 'Rosenberg nutzt zwei Bilder: Die Giraffe steht für eine verbindende Sprache mit Herz und Weitblick, der Wolf für eine urteilende, beschuldigende Sprache.',
 'Wolf: "Du bist so egoistisch." Giraffe: "Ich bin enttäuscht, weil mir gemeinsame Zeit wichtig ist."',
 'Die Bilder helfen, die eigene Sprache ohne Selbstabwertung zu beobachten, denn jeder hat Wolfsmomente. Es geht nicht darum, die andere Person als Wolf abzustempeln.',
 'Eine Alltagsmetapher, kein Modell mit eigener Forschung. Wer sie als Etikett gegen andere verwendet, spricht damit selbst Wolf.',
 'Marshall B. Rosenberg: Gewaltfreie Kommunikation', 70);

-- Verknüpfungen zu Muster- und Skill-Karten
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'vier-reiter' AND p.slug = 'du-botschaften';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'vier-reiter' AND p.slug = 'schweigen-als-kommunikation';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'flooding' AND p.slug = 'amygdala-hijack';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'flooding' AND p.slug = 'fenster-der-toleranz';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'nachbesprechung-streit' AND p.slug = 'rueckblick-analyse';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'loesbare-dauerhafte-probleme' AND p.slug = 'zuhoeren-statt-loesen';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'einfluss-annehmen' AND p.slug = 'beratungsresistenz-partner';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-nicht-nicht-kommunizieren' AND p.slug = 'schweigen-als-kommunikation';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-inhalt-beziehung' AND p.slug = 'ueberbringer-wird-zum-feind';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-inhalt-beziehung' AND p.slug = 'vorwurf-als-frage';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-interpunktion' AND p.slug = 'eskalationsspirale';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-interpunktion' AND p.slug = 'hypervigilanz';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-digital-analog' AND p.slug = 'emotionale-ansteckung';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'axiom-symmetrisch-komplementaer' AND p.slug = 'eskalationsspirale';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'doppelbindung' AND p.slug = 'double-bind';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'doppelbindung' AND p.slug = 'instanz-ohne-gesetzbuch';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'beobachtung-bewertung' AND p.slug = 'du-botschaften';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'gefuehle-pseudogefuehle' AND p.slug = 'sekundaere-emotionen';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'bitte-forderung' AND p.slug = 'instanz-ohne-gesetzbuch';
INSERT INTO theory_patterns (theory_id, pattern_id)
SELECT t.id, p.id FROM theory t, patterns p WHERE t.slug = 'empathisch-zuhoeren' AND p.slug = 'gefuehl-validieren-nicht-realitaet';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'vier-reiter' AND s.slug = 'gelbe-karte';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'vier-reiter' AND s.slug = 'rote-karte';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'gegenmittel-reiter' AND s.slug = 'beduerfnis-benennen';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'gegenmittel-reiter' AND s.slug = 'kurze-pause-im-raum';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'gegenmittel-reiter' AND s.slug = 'validieren-und-grenze-ein-satz';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'flooding' AND s.slug = 'physischer-ausstieg';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'flooding' AND s.slug = 'kurze-pause-im-raum';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'reparaturversuche' AND s.slug = 'stimmungsbruch-humor';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'reparaturversuche' AND s.slug = 'reframe-frage';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'reparaturversuche' AND s.slug = 'vereinbartes-codewort';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'nachbesprechung-streit' AND s.slug = 'timing-loesungsgespraeche';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'sanfter-einstieg' AND s.slug = 'beduerfnis-benennen';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'loesbare-dauerhafte-probleme' AND s.slug = 'timing-loesungsgespraeche';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'gfk-vier-schritte' AND s.slug = 'beduerfnis-benennen';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'empathisch-zuhoeren' AND s.slug = 'angst-spiegeln-dann-fakten';
INSERT INTO theory_skills (theory_id, skill_id)
SELECT t.id, s.id FROM theory t, skills s WHERE t.slug = 'empathisch-zuhoeren' AND s.slug = 'bedarfsfrage-statt-rechtfertigung';
