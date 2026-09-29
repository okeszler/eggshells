// Anmeldung prüft functions/api/_middleware.js für alle Routen.

export async function onRequestGet(context) {
  const { DB } = context.env;
  const { results } = await DB.prepare(
    "SELECT * FROM patterns ORDER BY sort_order ASC"
  ).all();
  return Response.json(results);
}
