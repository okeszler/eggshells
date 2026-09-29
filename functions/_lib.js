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

// Vergleich in konstanter Zeit, damit die Antwortzeit nichts darüber verrät,
// wie viele Zeichen schon stimmen.
export function sicherGleich(a, b) {
  if (typeof a !== "string" || typeof b !== "string") return false;
  let diff = a.length ^ b.length;
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    diff |= (a.charCodeAt(i) || 0) ^ (b.charCodeAt(i) || 0);
  }
  return diff === 0;
}

// Token = expiryTimestamp.signature
export async function erstelleAuthToken(secret, gueltigTageAb = 30) {
  if (!secret) throw new Error("COOKIE_SECRET fehlt");
  const ablauf = Date.now() + gueltigTageAb * 24 * 60 * 60 * 1000;
  const sig = await hmac(secret, String(ablauf));
  return `${ablauf}.${sig}`;
}

export async function pruefeAuthToken(secret, token) {
  // Ohne Secret würde mit dem Text "undefined" signiert, und jedes Token
  // wäre fälschbar. Dann lieber niemanden reinlassen.
  if (!secret || !token) return false;
  const [ablaufStr, sig] = token.split(".");
  if (!ablaufStr || !sig) return false;
  const ablauf = Number(ablaufStr);
  if (!Number.isFinite(ablauf) || ablauf < Date.now()) return false;
  const erwartet = await hmac(secret, ablaufStr);
  return sicherGleich(erwartet, sig);
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
