import { istAngemeldet, unauthorized } from "../_lib.js";

export async function onRequestGet(context) {
  if (!(await istAngemeldet(context.request, context.env))) return unauthorized();
  const { DB } = context.env;
  const { results } = await DB.prepare(
    "SELECT * FROM patterns ORDER BY sort_order ASC"
  ).all();
  return Response.json(results);
}
