import { erstelleAuthToken } from "../_lib.js";

export async function onRequestPost({ request, env }) {
  let body;
  try {
    body = await request.json();
  } catch {
    return Response.json({ ok: false, error: "Ungültige Anfrage" }, { status: 400 });
  }

  const eingabe = String(body.pin || "").trim();
  if (!eingabe || eingabe !== env.APP_PIN) {
    return Response.json({ ok: false, error: "Falscher PIN" }, { status: 401 });
  }

  const token = await erstelleAuthToken(env.COOKIE_SECRET, 30);
  const cookie = `auth=${encodeURIComponent(token)}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=${30 * 24 * 60 * 60}`;

  return new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: { "Content-Type": "application/json", "Set-Cookie": cookie },
  });
}
