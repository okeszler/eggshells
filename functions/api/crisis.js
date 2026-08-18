import { istAngemeldet, unauthorized } from "../_lib.js";

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const steps = await DB.prepare(
    "SELECT * FROM crisis_steps ORDER BY sort_order ASC"
  ).all();
  const contacts = await DB.prepare(
    "SELECT * FROM crisis_contacts ORDER BY sort_order ASC"
  ).all();
  return Response.json({ steps: steps.results, contacts: contacts.results });
}

export async function onRequestPost(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const body = await context.request.json();
  const { kind } = body;

  if (kind === "step") {
    const { title, description } = body;
    if (!title) return Response.json({ error: "title fehlt" }, { status: 400 });
    const { results } = await DB.prepare(
      "SELECT COALESCE(MAX(sort_order), 0) AS max FROM crisis_steps"
    ).all();
    const nextOrder = (results[0]?.max ?? 0) + 1;
    const { meta } = await DB.prepare(
      "INSERT INTO crisis_steps (sort_order, title, description) VALUES (?, ?, ?)"
    ).bind(nextOrder, title, description ?? "").run();
    return Response.json({ id: meta.last_row_id }, { status: 201 });
  }

  if (kind === "contact") {
    const { label, value } = body;
    if (!label || !value) return Response.json({ error: "label/value fehlt" }, { status: 400 });
    const { results } = await DB.prepare(
      "SELECT COALESCE(MAX(sort_order), 0) AS max FROM crisis_contacts"
    ).all();
    const nextOrder = (results[0]?.max ?? 0) + 1;
    const { meta } = await DB.prepare(
      "INSERT INTO crisis_contacts (label, value, sort_order) VALUES (?, ?, ?)"
    ).bind(label, value, nextOrder).run();
    return Response.json({ id: meta.last_row_id }, { status: 201 });
  }

  return Response.json({ error: "kind muss 'step' oder 'contact' sein" }, { status: 400 });
}

export async function onRequestDelete(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const url = new URL(context.request.url);
  const kind = url.searchParams.get("kind");
  const id = url.searchParams.get("id");
  if (!id || !["step", "contact"].includes(kind)) {
    return Response.json({ error: "kind/id fehlt" }, { status: 400 });
  }
  const table = kind === "step" ? "crisis_steps" : "crisis_contacts";
  await DB.prepare(`DELETE FROM ${table} WHERE id = ?`).bind(id).run();
  return Response.json({ ok: true });
}
