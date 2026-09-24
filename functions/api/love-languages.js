import { istAngemeldet, unauthorized } from "../_lib.js";

const PERSONS = ["ich", "partner"];
const LANGUAGES = ["worte", "zeit", "geschenke", "hilfe", "koerper"];

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const { results } = await DB.prepare(
    "SELECT person, language, rank, note, updated_at FROM love_language_profile ORDER BY person, rank"
  ).all();
  return Response.json(results);
}

// Body: { person: "ich" | "partner", items: [{ language, note }, ...] }
// Die Reihenfolge der items ist die Rangfolge (erstes Element = Platz 1).
export async function onRequestPut(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const { person, items } = await context.request.json();

  if (!PERSONS.includes(person)) {
    return Response.json({ error: "person ungültig" }, { status: 400 });
  }
  const languages = Array.isArray(items) ? items.map((i) => i?.language) : [];
  if (languages.length !== LANGUAGES.length || !LANGUAGES.every((l) => languages.includes(l))) {
    return Response.json({ error: "Es müssen alle fünf Sprachen genau einmal vorkommen" }, { status: 400 });
  }

  const stmt = DB.prepare(
    `INSERT INTO love_language_profile (person, language, rank, note, updated_at)
     VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
     ON CONFLICT (person, language) DO UPDATE SET
       rank = excluded.rank, note = excluded.note, updated_at = CURRENT_TIMESTAMP`
  );
  await DB.batch(
    items.map((item, i) => stmt.bind(person, item.language, i + 1, String(item.note ?? "").trim() || null))
  );
  return Response.json({ ok: true });
}
