import { istAngemeldet, unauthorized } from "../_lib.js";

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
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

export async function onRequestPost(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const body = await context.request.json();
  const { occurred_at, note, mood_before, mood_after, pattern_ids } = body;

  if (!occurred_at) {
    return Response.json({ error: "occurred_at fehlt" }, { status: 400 });
  }

  const { meta } = await DB.prepare(
    `INSERT INTO entries (occurred_at, note, mood_before, mood_after)
     VALUES (?, ?, ?, ?)`
  ).bind(occurred_at, note ?? null, mood_before ?? null, mood_after ?? null).run();

  const entryId = meta.last_row_id;

  if (Array.isArray(pattern_ids)) {
    for (const pid of pattern_ids) {
      await DB.prepare(
        "INSERT INTO entry_patterns (entry_id, pattern_id) VALUES (?, ?)"
      ).bind(entryId, pid).run();
    }
  }

  return Response.json({ id: entryId }, { status: 201 });
}

export async function onRequestDelete(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const id = new URL(context.request.url).searchParams.get("id");
  if (!id) return Response.json({ error: "id fehlt" }, { status: 400 });
  await DB.prepare("DELETE FROM entries WHERE id = ?").bind(id).run();
  return Response.json({ ok: true });
}
