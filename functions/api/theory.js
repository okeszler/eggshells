import { istAngemeldet, unauthorized } from "../_lib.js";

function splitSlugs(raw) {
  return raw ? raw.split(",") : [];
}

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const url = new URL(context.request.url);
  const section = url.searchParams.get("section");
  const author = url.searchParams.get("author");

  const conditions = [];
  const binds = [];
  if (section) {
    conditions.push("t.section = ?");
    binds.push(section);
  }
  if (author) {
    conditions.push("t.author = ?");
    binds.push(author);
  }

  const query = `
    SELECT t.*,
      GROUP_CONCAT(DISTINCT p.slug) AS pattern_slugs,
      GROUP_CONCAT(DISTINCT s.slug) AS skill_slugs
    FROM theory t
    LEFT JOIN theory_patterns tp ON tp.theory_id = t.id
    LEFT JOIN patterns p ON p.id = tp.pattern_id
    LEFT JOIN theory_skills ts ON ts.theory_id = t.id
    LEFT JOIN skills s ON s.id = ts.skill_id
    ${conditions.length ? `WHERE ${conditions.join(" AND ")}` : ""}
    GROUP BY t.id
    ORDER BY CASE t.section WHEN 'beziehungswissenschaft' THEN 1 WHEN 'kommunikation' THEN 2 END,
             CASE t.author WHEN 'Gottman' THEN 1 WHEN 'Watzlawick' THEN 2 WHEN 'Rosenberg' THEN 3 END,
             t.sort_order ASC
  `;

  const { results } = await DB.prepare(query).bind(...binds).all();
  return Response.json(
    results.map((t) => ({
      ...t,
      pattern_slugs: splitSlugs(t.pattern_slugs),
      skill_slugs: splitSlugs(t.skill_slugs),
    }))
  );
}
