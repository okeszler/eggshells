-- Einmalig in der D1-Konsole ausführen, BEVOR die GitHub Action
-- .github/workflows/migrations.yml zum ersten Mal läuft.
-- Trägt die bisher von Hand eingespielten Migrationen 0001–0016 in die
-- Tabelle ein, in der wrangler festhält, was schon gelaufen ist. Sonst würde
-- die Action versuchen, alles noch einmal einzuspielen.
-- Mehrfach ausführen schadet nicht.
CREATE TABLE IF NOT EXISTS auth_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ip TEXT NOT NULL,
  attempted_at INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_auth_attempts_time ON auth_attempts (attempted_at);

CREATE TABLE IF NOT EXISTS d1_migrations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE,
  applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

INSERT OR IGNORE INTO d1_migrations (name) VALUES
  ('0001_init.sql'),
  ('0002_seed_patterns.sql'),
  ('0003_add_skill_cards.sql'),
  ('0004_trauma_science_cards.sql'),
  ('0005_split_skills_by_audience.sql'),
  ('0006_emotionsregulation_cards.sql'),
  ('0007_skills.sql'),
  ('0008_more_skills.sql'),
  ('0009_expand_thin_categories.sql'),
  ('0010_ptbs_symptoms.sql'),
  ('0011_research.sql'),
  ('0012_more_patterns_skills.sql'),
  ('0013_theory.sql'),
  ('0014_danach_skills.sql'),
  ('0015_love_languages.sql'),
  ('0016_auth_attempts.sql');
