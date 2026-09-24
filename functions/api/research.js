import { istAngemeldet, unauthorized } from "../_lib.js";

function parseUrls(raw) {
  try {
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
  } catch {
    // Fallback: eine URL pro Zeile
  }
  return String(raw || "").split("\n").map((s) => s.trim()).filter(Boolean);
}

function splitSlugs(raw) {
  return raw ? raw.split(",") : [];
}

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const url = new URL(context.request.url);
  const patternSlug = url.searchParams.get("pattern");
  const skillSlug = url.searchParams.get("skill");

  const conditions = [];
  const binds = [];
  if (patternSlug) {
    conditions.push(
      `r.id IN (SELECT rp.research_id FROM research_patterns rp JOIN patterns p ON p.id = rp.pattern_id WHERE p.slug = ?)`
    );
    binds.push(patternSlug);
  }
  if (skillSlug) {
    conditions.push(
      `r.id IN (SELECT rs.research_id FROM research_skills rs JOIN skills s ON s.id = rs.skill_id WHERE s.slug = ?)`
    );
    binds.push(skillSlug);
  }

  const query = `
    SELECT r.*,
      GROUP_CONCAT(DISTINCT p.slug) AS pattern_slugs,
      GROUP_CONCAT(DISTINCT s.slug) AS skill_slugs
    FROM research r
    LEFT JOIN research_patterns rp ON rp.research_id = r.id
    LEFT JOIN patterns p ON p.id = rp.pattern_id
    LEFT JOIN research_skills rs ON rs.research_id = r.id
    LEFT JOIN skills s ON s.id = rs.skill_id
    ${conditions.length ? `WHERE ${conditions.join(" AND ")}` : ""}
    GROUP BY r.id
    ORDER BY r.category, r.sort_order ASC
  `;

  const { results } = await DB.prepare(query).bind(...binds).all();
  return Response.json(
    results.map((r) => ({
      ...r,
      source_url: parseUrls(r.source_url),
      pattern_slugs: splitSlugs(r.pattern_slugs),
      skill_slugs: splitSlugs(r.skill_slugs),
    }))
  );
}
