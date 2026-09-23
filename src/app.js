const TABS = [
  { id: "wissen", label: "Wissen" },
  { id: "skills", label: "Skills" },
  { id: "log", label: "Log" },
  { id: "selfcare", label: "Selbstfürsorge" },
  { id: "krise", label: "Krise" },
];

const MOODS = [1, 2, 3, 4, 5];
const MOOD_EMOJI = { 1: "😞", 2: "😕", 3: "😐", 4: "🙂", 5: "😄" };
const SELFCARE_PRESETS = ["Gym", "Spaziergang", "Freund:in angerufen", "Musik", "Ruhepause", "Journaling"];

let state = {
  tab: "wissen",
  patterns: [],
  skills: [],
  entries: [],
  selfcare: [],
  crisis: { steps: [], contacts: [] },
  logForm: { occurred_at: nowLocal(), note: "", mood_before: null, mood_after: null, pattern_ids: [] },
  selfcareForm: { date: todayLocal(), action: SELFCARE_PRESETS[0], note: "" },
  crisisEdit: false,
};

function todayLocal() {
  const d = new Date();
  d.setMinutes(d.getMinutes() - d.getTimezoneOffset());
  return d.toISOString().slice(0, 10);
}

function nowLocal() {
  const d = new Date();
  d.setMinutes(d.getMinutes() - d.getTimezoneOffset());
  return d.toISOString().slice(0, 16);
}

function escapeHtml(str) {
  return String(str ?? "").replace(/[&<>"']/g, (c) => (
    { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]
  ));
}

async function api(path, options) {
  const res = await fetch(path, {
    ...options,
    headers: { "Content-Type": "application/json", ...(options?.headers || {}) },
  });
  if (res.status === 401) {
    showPinScreen();
    throw new Error("unauthorized");
  }
  return res;
}

// ---------- Auth ----------

function showPinScreen() {
  document.getElementById("pin-screen").classList.remove("hidden");
  document.getElementById("app").classList.add("hidden");
}

function hidePinScreen() {
  document.getElementById("pin-screen").classList.add("hidden");
  document.getElementById("app").classList.remove("hidden");
}

async function submitPin() {
  const input = document.getElementById("pin-input");
  const errorEl = document.getElementById("pin-error");
  const res = await fetch("/api/auth", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ pin: input.value }),
  });
  if (res.ok) {
    errorEl.textContent = "";
    input.value = "";
    hidePinScreen();
    boot();
  } else {
    errorEl.textContent = "Falscher PIN, bitte nochmal.";
  }
}

// ---------- Data loading ----------

async function loadAll() {
  const [patterns, skills, entries, selfcare, crisis] = await Promise.all([
    api("/api/patterns").then((r) => r.json()),
    api("/api/skills").then((r) => r.json()),
    api("/api/entries").then((r) => r.json()),
    api("/api/selfcare").then((r) => r.json()),
    api("/api/crisis").then((r) => r.json()),
  ]);
  state.patterns = patterns;
  state.skills = skills;
  state.entries = entries;
  state.selfcare = selfcare;
  state.crisis = crisis;
  render();
}

// ---------- Wissen ----------

const CHAPTERS = [
  { title: "Beziehungsmuster", categories: ["Borderline", "Kommunikation", "Emotionsregulation", "Beziehungszyklus", "Abwehrmechanismus"] },
  { title: "Trauma & Bindung", categories: ["Trauma-Wissenschaft", "Bindungstheorie"] },
  { title: "DBT & Skills", categories: ["DBT-Basics", "Skill für Partner", "Skill für Betroffene"] },
  { title: "Selbstfürsorge", categories: ["Selbstfürsorge"] },
];

function patternCard(p) {
  return `
    <div class="card">
      <span class="category">${escapeHtml(p.category)}</span>
      <h3>${escapeHtml(p.title)}</h3>
      <p class="summary">${escapeHtml(p.summary)}</p>
      <details>
        <summary>Details ansehen</summary>
        <div class="detail-block"><strong>Woran erkennen</strong>${escapeHtml(p.recognize)}</div>
        <div class="detail-block"><strong>Was hilft</strong>${escapeHtml(p.helps)}</div>
        <div class="detail-block"><strong>Was nicht hilft</strong>${escapeHtml(p.avoid)}</div>
      </details>
    </div>
  `;
}

function renderWissen() {
  if (!state.patterns.length) return `<div class="placeholder">Lädt Muster…</div>`;

  const byCategory = {};
  state.patterns.forEach((p) => {
    if (!byCategory[p.category]) byCategory[p.category] = [];
    byCategory[p.category].push(p);
  });

  const covered = new Set();
  let html = "";
  CHAPTERS.forEach((chapter) => {
    const cards = chapter.categories.flatMap((c) => byCategory[c] || []);
    chapter.categories.forEach((c) => covered.add(c));
    if (!cards.length) return;
    html += `<h2 class="chapter-title">${escapeHtml(chapter.title)}</h2>`;
    html += cards.map(patternCard).join("");
  });

  const leftoverCategories = Object.keys(byCategory).filter((c) => !covered.has(c));
  if (leftoverCategories.length) {
    const leftoverCards = leftoverCategories.flatMap((c) => byCategory[c]);
    html += `<h2 class="chapter-title">Weiteres</h2>`;
    html += leftoverCards.map(patternCard).join("");
  }

  return html;
}

// ---------- Skills ----------

const STAGES = [
  { id: "frueh", title: "Früh", intro: "Rechtzeitig bemerkt: aus dem Automatismus aussteigen, bevor es richtig losgeht." },
  { id: "mitte", title: "Mitte", intro: "Der Streit läuft schon: benennen, was passiert, ohne neue Angriffsfläche zu bieten." },
  {
    id: "spaet",
    title: "Spät",
    intro: "Worte erreichen nichts mehr: Die Situation verlassen ist jetzt die beste Option.",
    note: "Kurz rausgehen ist kein Beziehungsende. Es ist eine Pause für euch beide, keine Entscheidung über die Beziehung.",
  },
];

function skillCard(s) {
  return `
    <div class="card">
      <h3>${escapeHtml(s.title)}</h3>
      <p class="summary">${escapeHtml(s.description)}</p>
      <ul class="phrases">
        ${s.example_phrases.map((ph) => `<li>${escapeHtml(ph)}</li>`).join("")}
      </ul>
      <details>
        <summary>Wann hilft's, wann nicht?</summary>
        <div class="detail-block"><strong>Funktioniert, wenn</strong>${escapeHtml(s.works_when)}</div>
        <div class="detail-block"><strong>Funktioniert nicht, wenn</strong>${escapeHtml(s.fails_when)}</div>
      </details>
    </div>
  `;
}

function renderSkills() {
  if (!state.skills.length) return `<div class="placeholder">Lädt Skills…</div>`;

  return STAGES.map((stage) => {
    const cards = state.skills.filter((s) => s.stage === stage.id);
    if (!cards.length) return "";
    return `
      <h2 class="chapter-title">${escapeHtml(stage.title)}</h2>
      <p class="stage-intro">${escapeHtml(stage.intro)}</p>
      ${stage.note ? `<div class="stage-note">${escapeHtml(stage.note)}</div>` : ""}
      ${cards.map(skillCard).join("")}
    `;
  }).join("");
}

// ---------- Log ----------

function moodPicker(field, value) {
  return `
    <div class="mood-picker">
      ${MOODS.map(
        (m) => `<button type="button" class="mood-btn ${value === m ? "selected" : ""}" onclick="setMood('${field}', ${m})">${MOOD_EMOJI[m]}</button>`
      ).join("")}
    </div>
  `;
}

function patternCheckboxes() {
  return state.patterns
    .map(
      (p) => `
      <label class="pattern-check">
        <input type="checkbox" ${state.logForm.pattern_ids.includes(p.id) ? "checked" : ""} onchange="togglePattern(${p.id})" />
        ${escapeHtml(p.title)}
      </label>
    `
    )
    .join("");
}

function renderLogForm() {
  return `
    <div class="card form-card">
      <h3>Neuer Eintrag</h3>
      <label class="field-label">Zeitpunkt</label>
      <input type="datetime-local" value="${state.logForm.occurred_at}" onchange="updateLogField('occurred_at', this.value)" />

      <label class="field-label">Notiz</label>
      <textarea rows="3" placeholder="Was ist passiert?" onchange="updateLogField('note', this.value)">${escapeHtml(state.logForm.note)}</textarea>

      <label class="field-label">Stimmung vorher</label>
      ${moodPicker("mood_before", state.logForm.mood_before)}

      <label class="field-label">Stimmung nachher</label>
      ${moodPicker("mood_after", state.logForm.mood_after)}

      ${state.patterns.length ? `<label class="field-label">Erkannte Muster</label><div class="pattern-checks">${patternCheckboxes()}</div>` : ""}

      <button class="primary-btn" onclick="submitEntry()">Eintrag speichern</button>
    </div>
  `;
}

function entryCard(e) {
  const slugs = (e.pattern_slugs || "").split(",").filter(Boolean);
  const titles = slugs.map((s) => state.patterns.find((p) => p.slug === s)?.title).filter(Boolean);
  return `
    <div class="card entry-card">
      <div class="entry-head">
        <span class="entry-date">${formatDateTime(e.occurred_at)}</span>
        <button class="delete-btn" onclick="deleteEntry(${e.id})">✕</button>
      </div>
      ${e.mood_before || e.mood_after ? `<div class="mood-line">${e.mood_before ? MOOD_EMOJI[e.mood_before] : "—"} → ${e.mood_after ? MOOD_EMOJI[e.mood_after] : "—"}</div>` : ""}
      ${e.note ? `<p class="entry-note">${escapeHtml(e.note)}</p>` : ""}
      ${titles.length ? `<div class="chips">${titles.map((t) => `<span class="chip">${escapeHtml(t)}</span>`).join("")}</div>` : ""}
    </div>
  `;
}

function formatDateTime(iso) {
  const d = new Date(iso);
  if (isNaN(d)) return iso;
  return d.toLocaleString("de-AT", { day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit" });
}

function renderLog() {
  return `
    ${renderLogForm()}
    ${state.entries.length ? state.entries.map(entryCard).join("") : `<div class="placeholder">Noch keine Einträge.</div>`}
  `;
}

// ---------- Selfcare ----------

function renderSelfcareForm() {
  const isCustom = !SELFCARE_PRESETS.includes(state.selfcareForm.action);
  return `
    <div class="card form-card">
      <h3>Selbstfürsorge eintragen</h3>
      <label class="field-label">Datum</label>
      <input type="date" value="${state.selfcareForm.date}" onchange="updateSelfcareField('date', this.value)" />

      <label class="field-label">Aktion</label>
      <div class="preset-grid">
        ${SELFCARE_PRESETS.map(
          (p) => `<button type="button" class="preset-btn ${state.selfcareForm.action === p ? "selected" : ""}" onclick="updateSelfcareField('action', '${p.replace(/'/g, "\\'")}')">${escapeHtml(p)}</button>`
        ).join("")}
        <button type="button" class="preset-btn ${isCustom ? "selected" : ""}" onclick="updateSelfcareField('action', '')">Sonstiges</button>
      </div>
      ${isCustom ? `<input type="text" placeholder="Eigene Aktion" value="${escapeHtml(state.selfcareForm.action)}" onchange="updateSelfcareField('action', this.value)" />` : ""}

      <label class="field-label">Notiz (optional)</label>
      <textarea rows="2" onchange="updateSelfcareField('note', this.value)">${escapeHtml(state.selfcareForm.note)}</textarea>

      <button class="primary-btn" onclick="submitSelfcare()">Eintragen</button>
    </div>
  `;
}

function selfcareCard(s) {
  return `
    <div class="card entry-card">
      <div class="entry-head">
        <span class="entry-date">${s.date}</span>
        <button class="delete-btn" onclick="deleteSelfcare(${s.id})">✕</button>
      </div>
      <p class="entry-note"><strong>${escapeHtml(s.action)}</strong>${s.note ? " — " + escapeHtml(s.note) : ""}</p>
    </div>
  `;
}

function renderSelfcare() {
  return `
    ${renderSelfcareForm()}
    ${state.selfcare.length ? state.selfcare.map(selfcareCard).join("") : `<div class="placeholder">Noch keine Einträge.</div>`}
  `;
}

// ---------- Krise ----------

function isPhone(v) {
  return /^[+\d][\d\s()-]{3,}$/.test(v.trim());
}

function renderKrise() {
  const { steps, contacts } = state.crisis;
  return `
    <div class="crisis-toggle">
      <button class="link-btn" onclick="toggleCrisisEdit()">${state.crisisEdit ? "Fertig" : "Bearbeiten"}</button>
    </div>

    <h2 class="section-title">Schritte</h2>
    ${
      steps.length
        ? steps
            .map(
              (s, i) => `
        <div class="card crisis-step">
          <div class="entry-head">
            <span class="step-num">${i + 1}</span>
            ${state.crisisEdit ? `<button class="delete-btn" onclick="deleteCrisisItem('step', ${s.id})">✕</button>` : ""}
          </div>
          <h3>${escapeHtml(s.title)}</h3>
          ${s.description ? `<p class="summary">${escapeHtml(s.description)}</p>` : ""}
        </div>
      `
            )
            .join("")
        : `<div class="placeholder">Noch keine Schritte hinterlegt.</div>`
    }
    ${state.crisisEdit ? renderCrisisStepForm() : ""}

    <h2 class="section-title">Kontakte</h2>
    ${
      contacts.length
        ? contacts
            .map(
              (c) => `
        <div class="card crisis-contact">
          <div class="entry-head">
            <div>
              <strong>${escapeHtml(c.label)}</strong><br/>
              ${isPhone(c.value) ? `<a class="contact-link" href="tel:${escapeHtml(c.value.replace(/\s/g, ""))}">${escapeHtml(c.value)}</a>` : `<span>${escapeHtml(c.value)}</span>`}
            </div>
            ${state.crisisEdit ? `<button class="delete-btn" onclick="deleteCrisisItem('contact', ${c.id})">✕</button>` : ""}
          </div>
        </div>
      `
            )
            .join("")
        : `<div class="placeholder">Noch keine Kontakte hinterlegt.</div>`
    }
    ${state.crisisEdit ? renderCrisisContactForm() : ""}
  `;
}

function renderCrisisStepForm() {
  return `
    <div class="card form-card">
      <h3>Neuer Schritt</h3>
      <input id="new-step-title" type="text" placeholder="Titel" />
      <textarea id="new-step-desc" rows="2" placeholder="Beschreibung (optional)"></textarea>
      <button class="primary-btn" onclick="submitCrisisStep()">Hinzufügen</button>
    </div>
  `;
}

function renderCrisisContactForm() {
  return `
    <div class="card form-card">
      <h3>Neuer Kontakt</h3>
      <input id="new-contact-label" type="text" placeholder="Bezeichnung (z.B. Therapeut:in)" />
      <input id="new-contact-value" type="text" placeholder="Telefonnummer oder Info" />
      <button class="primary-btn" onclick="submitCrisisContact()">Hinzufügen</button>
    </div>
  `;
}

// ---------- Actions ----------

function setMood(field, value) {
  state.logForm[field] = state.logForm[field] === value ? null : value;
  render();
}
window.setMood = setMood;

function togglePattern(id) {
  const ids = state.logForm.pattern_ids;
  const idx = ids.indexOf(id);
  if (idx === -1) ids.push(id);
  else ids.splice(idx, 1);
  render();
}
window.togglePattern = togglePattern;

function updateLogField(field, value) {
  state.logForm[field] = value;
}
window.updateLogField = updateLogField;

async function submitEntry() {
  const { occurred_at, note, mood_before, mood_after, pattern_ids } = state.logForm;
  if (!occurred_at) return;
  await api("/api/entries", {
    method: "POST",
    body: JSON.stringify({ occurred_at, note, mood_before, mood_after, pattern_ids }),
  });
  state.logForm = { occurred_at: nowLocal(), note: "", mood_before: null, mood_after: null, pattern_ids: [] };
  state.entries = await api("/api/entries").then((r) => r.json());
  render();
}
window.submitEntry = submitEntry;

async function deleteEntry(id) {
  await api(`/api/entries?id=${id}`, { method: "DELETE" });
  state.entries = state.entries.filter((e) => e.id !== id);
  render();
}
window.deleteEntry = deleteEntry;

function updateSelfcareField(field, value) {
  state.selfcareForm[field] = value;
  render();
}
window.updateSelfcareField = updateSelfcareField;

async function submitSelfcare() {
  const { date, action, note } = state.selfcareForm;
  if (!date || !action) return;
  await api("/api/selfcare", { method: "POST", body: JSON.stringify({ date, action, note }) });
  state.selfcareForm = { date: todayLocal(), action: SELFCARE_PRESETS[0], note: "" };
  state.selfcare = await api("/api/selfcare").then((r) => r.json());
  render();
}
window.submitSelfcare = submitSelfcare;

async function deleteSelfcare(id) {
  await api(`/api/selfcare?id=${id}`, { method: "DELETE" });
  state.selfcare = state.selfcare.filter((s) => s.id !== id);
  render();
}
window.deleteSelfcare = deleteSelfcare;

function toggleCrisisEdit() {
  state.crisisEdit = !state.crisisEdit;
  render();
}
window.toggleCrisisEdit = toggleCrisisEdit;

async function submitCrisisStep() {
  const title = document.getElementById("new-step-title").value.trim();
  const description = document.getElementById("new-step-desc").value.trim();
  if (!title) return;
  await api("/api/crisis", { method: "POST", body: JSON.stringify({ kind: "step", title, description }) });
  state.crisis = await api("/api/crisis").then((r) => r.json());
  render();
}
window.submitCrisisStep = submitCrisisStep;

async function submitCrisisContact() {
  const label = document.getElementById("new-contact-label").value.trim();
  const value = document.getElementById("new-contact-value").value.trim();
  if (!label || !value) return;
  await api("/api/crisis", { method: "POST", body: JSON.stringify({ kind: "contact", label, value }) });
  state.crisis = await api("/api/crisis").then((r) => r.json());
  render();
}
window.submitCrisisContact = submitCrisisContact;

async function deleteCrisisItem(kind, id) {
  await api(`/api/crisis?kind=${kind}&id=${id}`, { method: "DELETE" });
  state.crisis = await api("/api/crisis").then((r) => r.json());
  render();
}
window.deleteCrisisItem = deleteCrisisItem;

// ---------- Shell ----------

function renderTabs() {
  return `
    <nav class="tabs">
      ${TABS.map(
        (t) => `
        <button class="${state.tab === t.id ? "active" : ""}" onclick="setTab('${t.id}')">${t.label}</button>
      `
      ).join("")}
    </nav>
  `;
}

function render() {
  const content = {
    wissen: renderWissen,
    skills: renderSkills,
    log: renderLog,
    selfcare: renderSelfcare,
    krise: renderKrise,
  }[state.tab]();

  document.getElementById("app").innerHTML = `
    <header>
      <h1>eggshells</h1>
      <p>Wissen, Skills und Selbstfürsorge für Beziehungen mit PTBS/BPD-Dynamik</p>
    </header>
    ${content}
    ${renderTabs()}
  `;
}

function setTab(id) {
  state.tab = id;
  render();
}
window.setTab = setTab;

async function boot() {
  render();
  try {
    await loadAll();
    hidePinScreen();
  } catch {
    // 401 already handled via api() -> showPinScreen()
  }
}

document.getElementById("pin-submit").addEventListener("click", submitPin);
document.getElementById("pin-input").addEventListener("keydown", (e) => {
  if (e.key === "Enter") submitPin();
});

if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js").catch(() => {});
  });
}

boot();
