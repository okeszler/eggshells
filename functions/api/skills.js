import { istAngemeldet, unauthorized } from "../_lib.js";

function parsePhrases(raw) {
  try {
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
  } catch {
    // Fallback: ein Satz pro Zeile
  }
  return String(raw || "").split("\n").map((s) => s.trim()).filter(Boolean);
}

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const { results } = await DB.prepare(
    `SELECT * FROM skills
     ORDER BY CASE stage WHEN 'frueh' THEN 1 WHEN 'mitte' THEN 2 WHEN 'spaet' THEN 3 WHEN 'danach' THEN 4 END,
              sort_order ASC`
  ).all();
  return Response.json(results.map((s) => ({ ...s, example_phrases: parsePhrases(s.example_phrases) })));
}
