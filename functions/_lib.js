// Kleine Helfer für signierte, zustandslose Auth-Cookies (kein Sessions-Table nötig).

const encoder = new TextEncoder();

async function hmac(secret, message) {
  const key = await crypto.subtle.importKey(
    "raw", encoder.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, ["sign"]
  );
  const sig = await crypto.subtle.sign("HMAC", key, encoder.encode(message));
  return btoa(String.fromCharCode(...new Uint8Array(sig)))
    .replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

// Token = expiryTimestamp.signature
export async function erstelleAuthToken(secret, gueltigTageAb = 30) {
  const ablauf = Date.now() + gueltigTageAb * 24 * 60 * 60 * 1000;
  const sig = await hmac(secret, String(ablauf));
  return `${ablauf}.${sig}`;
}

export async function pruefeAuthToken(secret, token) {
  if (!token) return false;
  const [ablaufStr, sig] = token.split(".");
  if (!ablaufStr || !sig) return false;
  const ablauf = Number(ablaufStr);
  if (!Number.isFinite(ablauf) || ablauf < Date.now()) return false;
  const erwartet = await hmac(secret, ablaufStr);
  return erwartet === sig;
}

export function leseCookie(request, name) {
  const cookieHeader = request.headers.get("Cookie") || "";
  const match = cookieHeader.match(new RegExp(`(?:^|;\\s*)${name}=([^;]+)`));
  return match ? decodeURIComponent(match[1]) : null;
}

export async function istAngemeldet(request, env) {
  const token = leseCookie(request, "auth");
  return pruefeAuthToken(env.COOKIE_SECRET, token);
}

export function unauthorized() {
  return Response.json({ error: "Nicht angemeldet" }, { status: 401 });
}
