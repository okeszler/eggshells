-- Fehlgeschlagene PIN-Versuche, damit /api/auth die Zahl der Versuche
-- begrenzen kann (pro IP und insgesamt). Einträge älter als eine Stunde
-- räumt /api/auth selbst wieder weg.
CREATE TABLE auth_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ip TEXT NOT NULL,
  attempted_at INTEGER NOT NULL   -- Unix-Zeit in Sekunden
);

CREATE INDEX idx_auth_attempts_time ON auth_attempts (attempted_at);
