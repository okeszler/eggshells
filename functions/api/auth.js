import { erstelleAuthToken, sicherGleich } from "../_lib.js";

// Begrenzung der Fehlversuche: pro IP 5 in 15 Minuten, insgesamt 20 pro Stunde.
// Die globale Grenze greift auch, wenn jemand die IP wechselt.
const IP_LIMIT = 5;
const IP_WINDOW = 15 * 60;
const GLOBAL_LIMIT = 20;
const GLOBAL_WINDOW = 60 * 60;

// Gibt zurück, wie viele Sekunden noch gewartet werden muss (0 = frei).
async function wartezeit(DB, ip, jetzt) {
  await DB.prepare("DELETE FROM auth_attempts WHERE attempted_at < ?").bind(jetzt - GLOBAL_WINDOW).run();

  const proIp = await DB.prepare(
    "SELECT COUNT(*) AS n, MIN(attempted_at) AS erster FROM auth_attempts WHERE ip = ? AND attempted_at >= ?"
  ).bind(ip, jetzt - IP_WINDOW).first();
  if (proIp.n >= IP_LIMIT) return proIp.erster + IP_WINDOW - jetzt;

  const gesamt = await DB.prepare(
    "SELECT COUNT(*) AS n, MIN(attempted_at) AS erster FROM auth_attempts WHERE attempted_at >= ?"
  ).bind(jetzt - GLOBAL_WINDOW).first();
  if (gesamt.n >= GLOBAL_LIMIT) return gesamt.erster + GLOBAL_WINDOW - jetzt;

  return 0;
}

export async function onRequestPost({ request, env }) {
  if (!env.APP_PIN || !env.COOKIE_SECRET) {
    return Response.json({ ok: false, error: "Server nicht vollständig eingerichtet" }, { status: 500 });
  }

  let body;
  try {
    body = await request.json();
  } catch {
    return Response.json({ ok: false, error: "Ungültige Anfrage" }, { status: 400 });
  }

  const { DB } = env;
  const ip = request.headers.get("CF-Connecting-IP") || "unbekannt";
  const jetzt = Math.floor(Date.now() / 1000);

  // Solange Migration 0016 fehlt, gibt es die Tabelle noch nicht. Dann ohne
  // Begrenzung weiter, damit man sich nicht aussperrt.
  let begrenzungAktiv = true;
  try {
    const warten = await wartezeit(DB, ip, jetzt);
    if (warten > 0) {
      const minuten = Math.max(1, Math.ceil(warten / 60));
      return Response.json(
        { ok: false, error: `Zu viele Fehlversuche. Bitte in ${minuten} ${minuten === 1 ? "Minute" : "Minuten"} nochmal versuchen.` },
        { status: 429, headers: { "Retry-After": String(warten) } }
      );
    }
  } catch (e) {
    console.error("PIN-Begrenzung nicht verfügbar:", e);
    begrenzungAktiv = false;
  }

  const eingabe = String(body.pin || "").trim();
  if (!eingabe || !sicherGleich(eingabe, env.APP_PIN)) {
    if (begrenzungAktiv) {
      await DB.prepare("INSERT INTO auth_attempts (ip, attempted_at) VALUES (?, ?)").bind(ip, jetzt).run();
    }
    return Response.json({ ok: false, error: "Falscher PIN" }, { status: 401 });
  }

  if (begrenzungAktiv) {
    await DB.prepare("DELETE FROM auth_attempts WHERE ip = ?").bind(ip).run();
  }

  const token = await erstelleAuthToken(env.COOKIE_SECRET, 30);
  const cookie = `auth=${encodeURIComponent(token)}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=${30 * 24 * 60 * 60}`;

  return new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: { "Content-Type": "application/json", "Set-Cookie": cookie },
  });
}
