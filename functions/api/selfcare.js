import { istAngemeldet, unauthorized } from "../_lib.js";

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const { results } = await DB.prepare(
    "SELECT * FROM selfcare_actions ORDER BY date DESC, id DESC"
  ).all();
  return Response.json(results);
}

export async function onRequestPost(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const body = await context.request.json();
  const { date, action, note } = body;

  if (!date || !action) {
    return Response.json({ error: "date/action fehlt" }, { status: 400 });
  }

  const { meta } = await DB.prepare(
    "INSERT INTO selfcare_actions (date, action, note) VALUES (?, ?, ?)"
  ).bind(date, action, note ?? null).run();

  return Response.json({ id: meta.last_row_id }, { status: 201 });
}

export async function onRequestDelete(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const id = new URL(context.request.url).searchParams.get("id");
  if (!id) return Response.json({ error: "id fehlt" }, { status: 400 });
  await DB.prepare("DELETE FROM selfcare_actions WHERE id = ?").bind(id).run();
  return Response.json({ ok: true });
}
