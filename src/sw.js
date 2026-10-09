// Oberfläche: "online zuerst". Jede erfolgreiche Antwort aktualisiert den
// Offline-Stand, deshalb kommt ein neues Deployment sofort an, ohne dass der
// Cache-Name hochgezählt werden muss. Die Versionsnummer dient nur noch dazu,
// alte Caches beim Aktivieren aufzuräumen.
const CACHE_NAME = 'eggshells-shell-v17';
const SHELL_FILES = [
  './',
  './index.html',
  './style.css',
  './app.js',
  './manifest.json',
  './icon-192.png',
  './icon-512.png',
  './favicon-32.png',
  './apple-touch-icon.png',
  './fonts/outfit.woff2',
  './img/ostsee-tag.webp',
  './img/ostsee-nacht.webp',
];

// Bei sehr langsamem Netz nicht ewig warten, sondern nach ein paar Sekunden
// den gespeicherten Stand zeigen.
const NETWORK_TIMEOUT_MS = 4000;

self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) { return cache.addAll(SHELL_FILES); })
  );
  self.skipWaiting();
});

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(keys.filter(function (k) { return k !== CACHE_NAME; }).map(function (k) { return caches.delete(k); }));
    })
  );
  self.clients.claim();
});

function fromCache(request) {
  return caches.match(request).then(function (cached) {
    // Unbekannte Seite offline: die App-Oberfläche ausliefern
    return cached || (request.mode === 'navigate' ? caches.match('./index.html') : undefined);
  });
}

// API-Aufrufe (/api/...) bewusst NICHT hier cachen: Daten und Auth-Status
// sollen live sein. Den Offline-Stand von Krisenplan und Skills hält app.js.
self.addEventListener('fetch', function (event) {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || url.origin !== self.location.origin || url.pathname.startsWith('/api/')) return;

  event.respondWith(new Promise(function (resolve) {
    let settled = false;
    const finish = function (response) {
      if (settled) return;
      if (response) { settled = true; resolve(response); }
    };

    const timer = setTimeout(function () { fromCache(request).then(finish); }, NETWORK_TIMEOUT_MS);

    fetch(request).then(function (response) {
      clearTimeout(timer);
      if (response.ok) {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(function (cache) { cache.put(request, copy); });
      }
      finish(response);
    }).catch(function () {
      clearTimeout(timer);
      fromCache(request).then(function (cached) {
        finish(cached || new Response('Offline', { status: 503, statusText: 'Offline' }));
      });
    });
  }));
});
