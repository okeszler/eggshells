-- Wissen & Mustererkennung (aktueller Fokus)
CREATE TABLE patterns (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  slug TEXT UNIQUE NOT NULL,
  category TEXT NOT NULL,          -- z.B. 'Splitting', 'Double-Bind', 'Projektion'
  title TEXT NOT NULL,
  summary TEXT NOT NULL,           -- Kurzbeschreibung, 1-2 Sätze
  recognize TEXT NOT NULL,         -- woran man es erkennt
  helps TEXT NOT NULL,             -- was hilft
  avoid TEXT NOT NULL,             -- was nicht hilft
  sort_order INTEGER DEFAULT 0
);

-- Reflexions-Log: Vorfälle mit Musterzuordnung
CREATE TABLE entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  occurred_at TEXT NOT NULL,       -- ISO datetime
  note TEXT,
  mood_before INTEGER,             -- 1-5
  mood_after INTEGER,              -- 1-5
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE entry_patterns (
  entry_id INTEGER NOT NULL REFERENCES entries(id) ON DELETE CASCADE,
  pattern_id INTEGER NOT NULL REFERENCES patterns(id),
  PRIMARY KEY (entry_id, pattern_id)
);

-- Vorbereitet für spätere Phase: Selbstfürsorge
CREATE TABLE selfcare_actions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date TEXT NOT NULL,              -- ISO date
  action TEXT NOT NULL,            -- z.B. 'Gym', 'Spaziergang', 'Freund angerufen'
  note TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Vorbereitet für spätere Phase: Krisenmodus
CREATE TABLE crisis_steps (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sort_order INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE crisis_contacts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  label TEXT NOT NULL,             -- z.B. 'Therapeut', 'Guter Freund'
  value TEXT NOT NULL,             -- Telefonnummer o.ä.
  sort_order INTEGER DEFAULT 0
);
