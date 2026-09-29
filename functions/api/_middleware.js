import { istAngemeldet, unauthorized } from "../_lib.js";

// Läuft vor jeder Anfrage an /api/*. Damit kann keine neue API-Datei aus
// Versehen ohne Anmeldeprüfung online gehen.
const OFFEN = new Set(["/api/auth"]);

export async function onRequest(context) {
  const { pathname } = new URL(context.request.url);

  let response;
  try {
    response =
      OFFEN.has(pathname) || (await istAngemeldet(context.request, context.env))
        ? await context.next()
        : unauthorized();
  } catch (e) {
    // Unerwartete Fehler (z.B. kaputtes JSON im Request, Datenbankfehler)
    // als lesbares JSON statt als leere 500-Seite zurückgeben.
    console.error(`${context.request.method} ${pathname}:`, e);
    response = Response.json({ error: "Serverfehler" }, { status: 500 });
  }

  // Persönliche Daten nie in Browser- oder Proxy-Caches ablegen.
  response = new Response(response.body, response);
  response.headers.set("Cache-Control", "no-store");
  return response;
}
