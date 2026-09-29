// Anmeldung prüft functions/api/_middleware.js für alle Routen.

export async function onRequestGet(context) {
  const { DB } = context.env;
  const { results } = await DB.prepare(
    `SELECT e.*, GROUP_CONCAT(p.slug) AS pattern_slugs
     FROM entries e
     LEFT JOIN entry_patterns ep ON ep.entry_id = e.id
     LEFT JOIN patterns p ON p.id = ep.pattern_id
     GROUP BY e.id
     ORDER BY e.occurred_at DESC`
  ).all();
  return Response.json(results);
}

const LANGUAGES = ["worte", "zeit", "geschenke", "hilfe", "koerper"];

export async function onRequestPost(context) {
  const { DB } = context.env;
  const body = await context.request.json();
  const { occurred_at, note, mood_before, mood_after, pattern_ids, missing_languages } = body;

  if (!occurred_at) {
    return Response.json({ error: "occurred_at fehlt" }, { status: 400 });
  }

  const missing = Array.isArray(missing_languages) ? missing_languages.filter((l) => LANGUAGES.includes(l)) : [];
  const patternIds = Array.isArray(pattern_ids) ? [...new Set(pattern_ids.map(Number).filter(Number.isInteger))] : [];

  // Eintrag und Musterzuordnungen in einer Transaktion: entweder alles oder
  // nichts, damit kein halber Eintrag stehen bleibt.
  const results = await DB.batch([
    DB.prepare(
      `INSERT INTO entries (occurred_at, note, mood_before, mood_after, missing_languages)
       VALUES (?, ?, ?, ?, ?)`
    ).bind(occurred_at, note ?? null, mood_before ?? null, mood_after ?? null, missing.length ? JSON.stringify(missing) : null),
    ...patternIds.map((pid) =>
      DB.prepare(
        "INSERT INTO entry_patterns (entry_id, pattern_id) VALUES ((SELECT MAX(id) FROM entries), ?)"
      ).bind(pid)
    ),
  ]);

  return Response.json({ id: results[0].meta.last_row_id }, { status: 201 });
}

export async function onRequestDelete(context) {
  const { DB } = context.env;
  const id = new URL(context.request.url).searchParams.get("id");
  if (!id) return Response.json({ error: "id fehlt" }, { status: 400 });
  await DB.prepare("DELETE FROM entries WHERE id = ?").bind(id).run();
  return Response.json({ ok: true });
}
