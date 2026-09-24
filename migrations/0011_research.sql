-- Forschungs-Bereich: evidenzbasierte Grundlagen für Angehörige/Partner:innen
-- von Menschen mit BPD/PTBS. Verankert die Muster- und Skills-Karten in
-- Literatur und Studien, mit ausdrücklichem Fokus auf Einschränkungen der
-- Evidenzlage. Inhalte in eigenen Worten zusammengefasst, keine wörtlichen
-- Zitate aus den Quellen. (Ursprünglich als 0004 geplant, aber 0004 ist
-- bereits durch die Trauma-Wissenschaft-Karten belegt - daher 0011.)

CREATE TABLE research (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('programm', 'modell', 'literatur', 'ptbs', 'anlaufstelle')),
  key_insight TEXT NOT NULL,          -- Kernaussage, 1-2 Sätze
  evidence_level TEXT NOT NULL CHECK (evidence_level IN ('RCT', 'mehrere Studien', 'Theorie/Modell', 'Ratgeber', 'Angebot')),
  relevance TEXT NOT NULL,            -- was das konkret für Partner:innen bedeutet
  limitations TEXT NOT NULL,          -- Pflichtfeld: Einschränkungen/Kritik
  source_url TEXT NOT NULL DEFAULT '[]',  -- JSON-Array von URLs (Konvention wie example_phrases bei skills)
  sort_order INTEGER DEFAULT 0
);

-- Verknüpft Forschungskarten mit Muster- bzw. Skill-Karten, für
-- "Belegt durch: ..."-Hinweise in den Tabs Wissen und Skills.
CREATE TABLE research_patterns (
  research_id INTEGER NOT NULL REFERENCES research(id) ON DELETE CASCADE,
  pattern_id INTEGER NOT NULL REFERENCES patterns(id) ON DELETE CASCADE,
  PRIMARY KEY (research_id, pattern_id)
);

CREATE TABLE research_skills (
  research_id INTEGER NOT NULL REFERENCES research(id) ON DELETE CASCADE,
  skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  PRIMARY KEY (research_id, skill_id)
);

INSERT INTO research (slug, title, category, key_insight, evidence_level, relevance, limitations, source_url, sort_order) VALUES

('family-connections', 'Family Connections', 'programm',
 'Ein zwölfwöchiges, DBT-basiertes Kursprogramm für Angehörige von Menschen mit Borderline-Persönlichkeitsstörung (Fruzzetti & Hoffman, NEA-BPD): Wissen über die Störung, eigene Bewältigungsskills, Familienskills und ein Unterstützungsnetz aus anderen Angehörigen.',
 'RCT',
 'Die derzeit am besten belegte Angehörigen-Intervention überhaupt: eine randomisiert-kontrollierte Studie zeigt weniger Belastung und Trauer sowie mehr erlebte Handlungsfähigkeit bei den Teilnehmenden, die Effekte blieben auch nach rund sechs Monaten stabil. Der Dreiklang aus Wissen, Skills und Austausch mit anderen Angehörigen ist genau das Prinzip, an dem sich diese App orientiert.',
 'Die Studien wurden überwiegend mit gemischten Angehörigengruppen und Eltern durchgeführt, partnerspezifische Daten sind noch dünn. Das Programm ersetzt keine eigene Therapie.',
 '["https://onlinelibrary.wiley.com/doi/10.1111/famp.13089", "https://pubmed.ncbi.nlm.nih.gov/16013747/"]', 1),

('transaktionsmodell', 'Das Transaktionsmodell nach Fruzzetti', 'modell',
 'Emotionale Dysregulation und invalidierende Reaktionen verstärken sich in einem Kreislauf gegenseitig: ein ungenau ausgedrücktes Gefühl wird leichter missverstanden oder invalidiert, die Invalidierung verstärkt wiederum die Dysregulation.',
 'Theorie/Modell',
 'Erklärt einen sehr alltäglichen Ablauf: die andere Person eskaliert, man selbst wird sachlich-kühl, das wird als Abwertung erlebt, die Eskalation nimmt zu. Zwei Ansatzpunkte laut Modell: den eigenen Ausdruck präzisieren und das Gefühl der anderen Person validieren, auch ohne ihrer Einschätzung der Situation zuzustimmen.',
 'Ein erklärendes Modell, keine Schuldzuweisung an eine der beiden Seiten. Es beschreibt einen Mechanismus, ist aber kein Beleg für die Ursache im Einzelfall.',
 '["https://www.cambridge.org/core/services/aop-cambridge-core/content/view/7FEA82D90CC933149596D93E6CDD2260/S0954579405050479a.pdf/family-interaction-and-the-development-of-borderline-personality-disorder-a-transactional-model.pdf"]', 2),

('validierung-und-grenzen', 'Validieren und gleichzeitig Grenzen halten', 'modell',
 'Ein Gefühl anzuerkennen und gleichzeitig eine Grenze zu halten schließen sich nicht aus - dialektisches Denken lehnt das Entweder-oder ab.',
 'Theorie/Modell',
 'Eine reine Grenzaussage wirkt vermutlich verlässlicher, wenn ihr ein kurzer validierender Satz vorausgeht, etwa "Ich sehe, dass dich das gerade aufwühlt, aber so rede ich nicht mit dir." Beides gilt gleichzeitig, nicht als Kompromiss zwischen zwei Positionen.',
 'Validieren heißt nicht, einer verzerrten Darstellung der Realität zuzustimmen, und ist keine Entschuldigung für etwas, das man nicht getan hat.',
 '[]', 3),

('stop-walking-on-eggshells', 'Stop Walking on Eggshells', 'literatur',
 'Ein Standardwerk für Angehörige von Menschen mit BPD (Mason & Kreger), mit praktischen Kapiteln zu Grenzen, Validierung und eigenem Schutz - Namensgeber dieser App.',
 'Ratgeber',
 '2024 erschien mit "Stop Walking on Eggshells for Partners" (Eddy & Kreger) eine Ausgabe, die direkt auf die Partner-Rolle zugeschnitten ist statt auf Angehörige allgemein.',
 'Ein Ratgeber, keine Studie - die Empfehlungen stammen aus klinischer Erfahrung, nicht aus kontrollierten Untersuchungen. Von manchen Betroffenen wird das Buch als einseitig oder invalidierend kritisiert. Als Gegengewicht mit der Innensicht lohnt sich Kreismans "I Hate You - Don''t Leave Me".',
 '[]', 4),

('cbct-ptbs', 'Kognitiv-behaviorale Paartherapie für PTBS (CBCT)', 'ptbs',
 'Ein von Monson und Fredman entwickeltes, manualisiertes Paartherapie-Format, das PTBS-Symptome und die Beziehung gleichzeitig behandelt.',
 'RCT',
 'Randomisiert-kontrollierte Studien zeigen große Effekte auf die PTBS-Symptomatik der betroffenen Person - einer der wenigen evidenzbasierten Wege, den Partner bzw. die Partnerin aktiv in die Behandlung einzubinden, statt außen vor zu bleiben.',
 'Wichtiger Befund derselben Studien: die psychische Belastung der Partner:innen selbst verbesserte sich im Schnitt nicht signifikant. Die Therapie der betroffenen Person ersetzt keine eigene Unterstützung.',
 '["https://pubmed.ncbi.nlm.nih.gov/22893167/", "https://pubmed.ncbi.nlm.nih.gov/24706354/"]', 5),

('rolle-partner-nicht-therapeut', 'Die eigene Rolle: Partner:in, nicht Therapeut:in', 'literatur',
 'Die Rolle im Alltag ist die eines unterstützenden Angehörigen, nicht die einer Behandlungsperson - eigene Therapie oder eine Angehörigengruppe wird in der Literatur ausdrücklich empfohlen, nicht nur als Notlösung.',
 'Ratgeber',
 'Ein Hinweis aus einer Sekundärquelle, als solcher gekennzeichnet: Viele Betroffene verbessern sich über Jahre hinweg deutlich, spezialisierte Therapie wie DBT beschleunigt diesen Verlauf. Das nimmt Druck von der Vorstellung, selbst "die Lösung" sein zu müssen.',
 'Sekundärquelle (Ratgeberportal), keine Primärstudie - als grobe Orientierung zu verstehen, nicht als individuelle Prognose.',
 '["https://checkpsy.at/ratgeber/borderline-persoenlichkeitsstoerung"]', 6),

('hpe-oesterreich', 'HPE Österreich: Selbsthilfe für Angehörige', 'anlaufstelle',
 'Selbsthilfegruppen für Angehörige von Menschen mit Persönlichkeitsstörung/Borderline, außerdem eine eigene Gruppe für Partner:innen psychisch erkrankter Menschen (Einträge in Wien gefunden).',
 'Angebot',
 'Austausch mit Menschen in einer ähnlichen Situation ist einer der drei tragenden Bestandteile von Family Connections (siehe dort) - und hier niedrigschwellig, ohne Wartezeit auf einen Kursplatz.',
 'Ein Angebot in Oberösterreich ist noch nicht verifiziert - offen zu prüfen, ob es dort eine vergleichbare Gruppe gibt.',
 '["https://sozialinfo.wien.at/content/de/10/InstitutionDetail.do?it_1=2098114"]', 7);

-- Verknüpfungen zu bestehenden Muster- und Skill-Karten
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'transaktionsmodell' AND p.slug = 'eskalationsspirale';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'transaktionsmodell' AND p.slug = 'du-botschaften';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'cbct-ptbs' AND p.slug = 'co-regulation';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'cbct-ptbs' AND p.slug = 'emotionale-flashbacks';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'rolle-partner-nicht-therapeut' AND p.slug = 'sekundaere-traumatisierung';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'rolle-partner-nicht-therapeut' AND p.slug = 'koabhaengigkeit';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'stop-walking-on-eggshells' AND p.slug = 'splitting';
INSERT INTO research_patterns (research_id, pattern_id)
SELECT r.id, p.id FROM research r, patterns p WHERE r.slug = 'stop-walking-on-eggshells' AND p.slug = 'angst-vor-verlassenwerden';

INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'transaktionsmodell' AND s.slug = 'meta-benennung';
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'validierung-und-grenzen' AND s.slug = 'kaputte-schallplatte';
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'validierung-und-grenzen' AND s.slug = 'meta-benennung';
INSERT INTO research_skills (research_id, skill_id)
SELECT r.id, s.id FROM research r, skills s WHERE r.slug = 'rolle-partner-nicht-therapeut' AND s.slug = 'notfallkontakt';
