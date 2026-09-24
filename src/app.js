const ICONS = {
  verstehen: '<path d="M4 19.5V5a2 2 0 0 1 2-2h13v16H6a2 2 0 0 0-2 2 2 2 0 0 0 2 2h13"/>',
  skills: '<path d="M4 5h16v11H10l-5 4v-4H4z"/><path d="M8 9.5h8M8 12.5h5"/>',
  log: '<path d="M6 3h9l4 4v14H6z"/><path d="M9 11h7M9 15h7M9 19h4"/>',
  selfcare: '<path d="M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0 1 12 7a4.3 4.3 0 0 1 7.5 2.8C19.5 15.4 12 20 12 20z"/>',
  krise: '<circle cx="12" cy="12" r="9"/><path d="M12 7.5v6"/><path d="M12 16.5v.01"/>',
};

const TABS = [
  { id: "verstehen", label: "Verstehen", title: "Verstehen" },
  { id: "skills", label: "Skills", title: "Skills" },
  { id: "log", label: "Log", title: "Log" },
  { id: "selfcare", label: "Fürsorge", title: "Selbstfürsorge" },
  { id: "krise", label: "Krise", title: "Krisenplan" },
];

// Unterbereiche des Tabs "Verstehen"
const VERSTEHEN_VIEWS = [
  { id: "wissen", title: "Wissen" },
  { id: "theorie", title: "Theorie" },
  { id: "forschung", title: "Forschung" },
];

const MOODS = [1, 2, 3, 4, 5];
const MOOD_EMOJI = { 1: "😞", 2: "😕", 3: "😐", 4: "🙂", 5: "😄" };
const SELFCARE_PRESETS = ["Gym", "Spaziergang", "Freund:in angerufen", "Musik", "Ruhepause", "Journaling"];

let state = {
  tab: "verstehen",
  verstehenView: "wissen",
  wissenChapter: null,
  theory: [],
  theoryByPattern: {},
  theoryBySkill: {},
  theorieSection: null,
  skillStage: "frueh",
  logPatternsOpen: false,
  research: [],
  researchByPattern: {},
  researchBySkill: {},
  forschungCategory: null,
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

// ---------- Animation helpers ----------
// Fancy but polite: wraps re-renders in a View Transition where the browser
// supports it (cross-fades old/new screen), and gets out of the way entirely
// when the OS says to reduce motion. Plain render() is used only for the
// very first paint, where there is nothing yet to transition from.
function prefersReducedMotion() {
  return window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
}

// Gibt ein Promise zurück, das auflöst, sobald der neue Inhalt im DOM steht.
// Wichtig für alles, was danach ein Element sucht: Bei View Transitions läuft
// render() nicht sofort, sondern erst nach dem Schnappschuss des alten Stands.
function rerender() {
  if (typeof document.startViewTransition === "function" && !prefersReducedMotion()) {
    return document.startViewTransition(() => render()).updateCallbackDone;
  }
  render();
  return Promise.resolve();
}

function scrollToAndHighlight(id) {
  const el = document.getElementById(id);
  if (!el) return;
  el.scrollIntoView({ behavior: prefersReducedMotion() ? "auto" : "smooth", block: "start" });
  el.classList.add("highlight");
  setTimeout(() => el.classList.remove("highlight"), 1600);
}

// Staggered entrance for card lists: capped so a long list (50+ Wissen-Karten)
// doesn't take seconds to finish cascading in.
function staggerStyle(i) {
  return ` style="animation-delay:${Math.min(i, 10) * 28}ms"`;
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
    input.classList.remove("shake");
    void input.offsetWidth; // Reflow erzwingen, damit die Animation bei wiederholtem Fehler neu startet
    input.classList.add("shake");
  }
}

// ---------- Data loading ----------

async function loadAll() {
  const [patterns, skills, research, theory, entries, selfcare, crisis] = await Promise.all([
    api("/api/patterns").then((r) => r.json()),
    // Skills/Research separat abfangen: Fehlt die Tabelle noch (Migration nicht
    // eingespielt), soll nur der jeweilige Tab leer bleiben statt die ganze App
    // zu blockieren.
    api("/api/skills").then((r) => (r.ok ? r.json() : [])).catch(() => []),
    api("/api/research").then((r) => (r.ok ? r.json() : [])).catch(() => []),
    api("/api/theory").then((r) => (r.ok ? r.json() : [])).catch(() => []),
    api("/api/entries").then((r) => r.json()),
    api("/api/selfcare").then((r) => r.json()),
    api("/api/crisis").then((r) => r.json()),
  ]);
  state.patterns = patterns;
  state.skills = skills;
  state.research = research;
  state.researchByPattern = {};
  state.researchBySkill = {};
  research.forEach((r) => {
    r.pattern_slugs.forEach((slug) => {
      (state.researchByPattern[slug] ??= []).push({ slug: r.slug, title: r.title });
    });
    r.skill_slugs.forEach((slug) => {
      (state.researchBySkill[slug] ??= []).push({ slug: r.slug, title: r.title });
    });
  });
  state.theory = theory;
  state.theoryByPattern = {};
  state.theoryBySkill = {};
  theory.forEach((t) => {
    t.pattern_slugs.forEach((slug) => {
      (state.theoryByPattern[slug] ??= []).push({ slug: t.slug, title: t.title });
    });
    t.skill_slugs.forEach((slug) => {
      (state.theoryBySkill[slug] ??= []).push({ slug: t.slug, title: t.title });
    });
  });
  state.entries = entries;
  state.selfcare = selfcare;
  state.crisis = crisis;
  rerender();
}

// ---------- Wissen ----------

const CHAPTERS = [
  { title: "Beziehungsmuster", categories: ["Borderline", "Kommunikation", "Emotionsregulation", "Beziehungszyklus", "Abwehrmechanismus"] },
  { title: "Trauma & Bindung", categories: ["Trauma-Wissenschaft", "Bindungstheorie"] },
  { title: "DBT & Skills", categories: ["DBT-Basics", "Skill für Partner", "Skill für Betroffene"] },
  { title: "Selbstfürsorge", categories: ["Selbstfürsorge"] },
];

function crossRefs(researchHits = [], theoryHits = []) {
  if (!researchHits.length && !theoryHits.length) return "";
  return `
    <div class="research-hint">
      ${theoryHits
        .map((t) => `<button type="button" onclick="jumpToTheory('${t.slug}')">📚 Theorie: ${escapeHtml(t.title)}</button>`)
        .join("")}
      ${researchHits
        .map((r) => `<button type="button" onclick="jumpToResearch('${r.slug}')">🔬 Belegt durch: ${escapeHtml(r.title)}</button>`)
        .join("")}
    </div>
  `;
}

function patternCard(p, i = 0) {
  return `
    <div class="card"${staggerStyle(i)}>
      <span class="category">${escapeHtml(p.category)}</span>
      <h3>${escapeHtml(p.title)}</h3>
      <p class="summary">${escapeHtml(p.summary)}</p>
      <details>
        <summary>Details ansehen</summary>
        <div class="detail-block"><strong>Woran erkennen</strong>${escapeHtml(p.recognize)}</div>
        <div class="detail-block"><strong>Was hilft</strong>${escapeHtml(p.helps)}</div>
        <div class="detail-block"><strong>Was nicht hilft</strong>${escapeHtml(p.avoid)}</div>
      </details>
      ${crossRefs(state.researchByPattern[p.slug], state.theoryByPattern[p.slug])}
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

  const covered = new Set(CHAPTERS.flatMap((c) => c.categories));
  const leftoverCategories = Object.keys(byCategory).filter((c) => !covered.has(c));
  const chapters = leftoverCategories.length
    ? [...CHAPTERS, { title: "Weiteres", categories: leftoverCategories }]
    : CHAPTERS;
  const withCards = chapters
    .map((chapter) => ({ ...chapter, cards: chapter.categories.flatMap((c) => byCategory[c] || []) }))
    .filter((chapter) => chapter.cards.length);

  const active = state.wissenChapter;
  const filter = `
    <div class="filter-chips">
      <button class="filter-chip ${active ? "" : "selected"}" onclick="setWissenChapter(null)">Alle <span>${state.patterns.length}</span></button>
      ${withCards
        .map(
          (c) => `<button class="filter-chip ${active === c.title ? "selected" : ""}" onclick="setWissenChapter('${escapeHtml(c.title)}')">${escapeHtml(c.title)} <span>${c.cards.length}</span></button>`
        )
        .join("")}
    </div>
  `;

  const visible = active ? withCards.filter((c) => c.title === active) : withCards;
  return (
    filter +
    visible
      .map((chapter) => `<h2 class="chapter-title">${escapeHtml(chapter.title)}</h2>${chapter.cards.map((p, i) => patternCard(p, i)).join("")}`)
      .join("")
  );
}

// ---------- Theorie ----------

const THEORY_SECTIONS = [
  { id: "beziehungswissenschaft", title: "Beziehungswissenschaft", authors: ["Gottman"] },
  { id: "kommunikation", title: "Kommunikation", authors: ["Watzlawick", "Rosenberg"] },
];

const AUTHOR_NAMES = {
  Gottman: "John Gottman",
  Watzlawick: "Paul Watzlawick",
  Rosenberg: "Marshall Rosenberg",
};

function theoryCard(t, i = 0) {
  return `
    <div class="card theory-card" id="theory-${escapeHtml(t.slug)}"${staggerStyle(i)}>
      <h3>${escapeHtml(t.title)}</h3>
      <p class="summary">${escapeHtml(t.core)}</p>
      <details>
        <summary>Im Alltag &amp; in unserer Dynamik</summary>
        <div class="detail-block"><strong>Im Alltag</strong>${escapeHtml(t.everyday)}</div>
        <div class="detail-block"><strong>In unserer Dynamik</strong>${escapeHtml(t.in_context)}</div>
      </details>
      <div class="detail-block limitations"><strong>Grenzen</strong>${escapeHtml(t.limits)}</div>
      ${t.reference ? `<p class="reference">${escapeHtml(t.reference)}</p>` : ""}
    </div>
  `;
}

function renderTheorie() {
  if (!state.theory.length) return `<div class="placeholder">Lädt Theorie…</div>`;

  const groups = THEORY_SECTIONS.map((sec) => ({
    ...sec,
    byAuthor: sec.authors
      .map((a) => ({ author: a, items: state.theory.filter((t) => t.section === sec.id && t.author === a) }))
      .filter((g) => g.items.length),
  })).filter((sec) => sec.byAuthor.length);

  const active = state.theorieSection;
  const count = (sec) => sec.byAuthor.reduce((n, g) => n + g.items.length, 0);
  const filter = `
    <div class="filter-chips">
      <button class="filter-chip ${active ? "" : "selected"}" onclick="setTheorieSection(null)">Alle <span>${state.theory.length}</span></button>
      ${groups
        .map(
          (sec) => `<button class="filter-chip ${active === sec.id ? "selected" : ""}" onclick="setTheorieSection('${sec.id}')">${escapeHtml(sec.title)} <span>${count(sec)}</span></button>`
        )
        .join("")}
    </div>
  `;

  const visible = active ? groups.filter((sec) => sec.id === active) : groups;
  return (
    filter +
    visible
      .map(
        (sec) =>
          `<h2 class="chapter-title">${escapeHtml(sec.title)}</h2>` +
          sec.byAuthor
            .map(
              (g) =>
                `<h3 class="author-title">${escapeHtml(AUTHOR_NAMES[g.author] || g.author)}</h3>` +
                g.items.map((t, i) => theoryCard(t, i)).join("")
            )
            .join("")
      )
      .join("")
  );
}

// ---------- Verstehen (Wissen / Theorie / Forschung) ----------

function renderVerstehen() {
  const view = VERSTEHEN_VIEWS.find((v) => v.id === state.verstehenView) || VERSTEHEN_VIEWS[0];
  const inner = { wissen: renderWissen, theorie: renderTheorie, forschung: renderForschung }[view.id]();
  return `
    <div class="stage-switch view-switch" role="tablist">
      ${VERSTEHEN_VIEWS.map(
        (v) => `<button role="tab" class="stage-btn view-btn ${v.id === view.id ? "selected" : ""}" onclick="setVerstehenView('${v.id}')">${escapeHtml(v.title)}</button>`
      ).join("")}
    </div>
    ${inner}
  `;
}

// ---------- Forschung ----------

const RESEARCH_CATEGORIES = [
  { id: "programm", title: "Programme" },
  { id: "modell", title: "Modelle" },
  { id: "ptbs", title: "PTBS-spezifisch" },
  { id: "literatur", title: "Literatur" },
  { id: "anlaufstelle", title: "Anlaufstellen" },
];

const EVIDENCE_META = {
  RCT: { label: "RCT", cls: "rct" },
  "mehrere Studien": { label: "Mehrere Studien", cls: "mehrere" },
  "Theorie/Modell": { label: "Modell", cls: "modell" },
  Ratgeber: { label: "Ratgeber", cls: "ratgeber" },
  Angebot: { label: "Angebot", cls: "angebot" },
};

function evidenceBadge(level) {
  const meta = EVIDENCE_META[level] || { label: level, cls: "modell" };
  return `<span class="evidence-badge evidence-${meta.cls}">${escapeHtml(meta.label)}</span>`;
}

function researchCard(r, i = 0) {
  const sources = r.source_url || [];
  return `
    <div class="card research-card" id="research-${escapeHtml(r.slug)}"${staggerStyle(i)}>
      <div class="entry-head">
        <span class="category">${escapeHtml(RESEARCH_CATEGORIES.find((c) => c.id === r.category)?.title || r.category)}</span>
        ${evidenceBadge(r.evidence_level)}
      </div>
      <h3>${escapeHtml(r.title)}</h3>
      <p class="summary">${escapeHtml(r.key_insight)}</p>
      <div class="detail-block"><strong>Relevanz für mich</strong>${escapeHtml(r.relevance)}</div>
      <div class="detail-block limitations"><strong>Einschränkungen</strong>${escapeHtml(r.limitations)}</div>
      ${
        sources.length
          ? `<div class="source-links">${sources
              .map((u, i) => `<a href="${escapeHtml(u)}" target="_blank" rel="noopener">Quelle${sources.length > 1 ? ` ${i + 1}` : ""} ↗</a>`)
              .join("")}</div>`
          : ""
      }
    </div>
  `;
}

function renderForschung() {
  if (!state.research.length) return `<div class="placeholder">Lädt Forschung…</div>`;

  const byCategory = {};
  state.research.forEach((r) => {
    (byCategory[r.category] ??= []).push(r);
  });
  const groups = RESEARCH_CATEGORIES.map((c) => ({ ...c, items: byCategory[c.id] || [] })).filter((g) => g.items.length);

  const active = state.forschungCategory;
  const filter = `
    <div class="filter-chips">
      <button class="filter-chip ${active ? "" : "selected"}" onclick="setForschungCategory(null)">Alle <span>${state.research.length}</span></button>
      ${groups
        .map(
          (g) => `<button class="filter-chip ${active === g.id ? "selected" : ""}" onclick="setForschungCategory('${g.id}')">${escapeHtml(g.title)} <span>${g.items.length}</span></button>`
        )
        .join("")}
    </div>
  `;

  const visible = active ? groups.filter((g) => g.id === active) : groups;
  return (
    filter +
    visible
      .map((g) => `<h2 class="chapter-title">${escapeHtml(g.title)}</h2>${g.items.map((r, i) => researchCard(r, i)).join("")}`)
      .join("")
  );
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
  {
    id: "danach",
    title: "Danach",
    intro: "Wenn sich die Lage beruhigt hat: Nachsorge, Reparatur und der richtige Zeitpunkt für Sachthemen.",
  },
];

function skillCard(s, i = 0) {
  return `
    <div class="card skill-card stage-${s.stage} skill-${escapeHtml(s.slug)}"${staggerStyle(i)}>
      <h3>${escapeHtml(s.title)}</h3>
      <ul class="phrases">
        ${s.example_phrases.map((ph) => `<li>${escapeHtml(ph)}</li>`).join("")}
      </ul>
      ${s.callout ? `<div class="skill-callout">${escapeHtml(s.callout)}</div>` : ""}
      <p class="summary">${escapeHtml(s.description)}</p>
      <details>
        <summary>Wann hilft's, wann nicht?</summary>
        <div class="detail-block"><strong>Funktioniert, wenn</strong>${escapeHtml(s.works_when)}</div>
        <div class="detail-block"><strong>Funktioniert nicht, wenn</strong>${escapeHtml(s.fails_when)}</div>
      </details>
      ${crossRefs(state.researchBySkill[s.slug], state.theoryBySkill[s.slug])}
    </div>
  `;
}

function renderSkills() {
  if (!state.skills.length) return `<div class="placeholder">Lädt Skills…</div>`;

  const stage = STAGES.find((st) => st.id === state.skillStage) || STAGES[0];
  const cards = state.skills.filter((s) => s.stage === stage.id);
  return `
    <div class="stage-switch" role="tablist">
      ${STAGES.map(
        (st) => `<button role="tab" class="stage-btn stage-${st.id} ${st.id === stage.id ? "selected" : ""}" onclick="setSkillStage('${st.id}')">${escapeHtml(st.title)}</button>`
      ).join("")}
    </div>
    <p class="stage-intro">${escapeHtml(stage.intro)}</p>
    ${
      stage.note
        ? `<div class="stage-note">${escapeHtml(stage.note)} <button class="link-btn" onclick="setTab('krise')">Zum Krisenplan →</button></div>`
        : ""
    }
    ${cards.map((s, i) => skillCard(s, i)).join("")}
  `;
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

function patternPicker() {
  const selected = state.logForm.pattern_ids;
  const groups = CHAPTERS.map((c) => ({
    title: c.title,
    items: state.patterns.filter((p) => c.categories.includes(p.category)),
  })).filter((g) => g.items.length);
  return `
    <details class="pattern-picker" ${state.logPatternsOpen ? "open" : ""} ontoggle="setLogPatternsOpen(this.open)">
      <summary>Muster zuordnen${selected.length ? ` <span class="count">${selected.length} ausgewählt</span>` : ""}</summary>
      ${groups
        .map(
          (g) => `
        <div class="picker-group">${escapeHtml(g.title)}</div>
        <div class="preset-grid">
          ${g.items
            .map(
              (p) => `<button type="button" class="preset-btn ${selected.includes(p.id) ? "selected" : ""}" onclick="togglePattern(${p.id})">${escapeHtml(p.title)}</button>`
            )
            .join("")}
        </div>
      `
        )
        .join("")}
    </details>
  `;
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

      ${state.patterns.length ? `<label class="field-label">Erkannte Muster</label>${patternPicker()}` : ""}

      <button class="primary-btn" onclick="submitEntry()">Eintrag speichern</button>
    </div>
  `;
}

function entryCard(e, i = 0) {
  const slugs = (e.pattern_slugs || "").split(",").filter(Boolean);
  const titles = slugs.map((s) => state.patterns.find((p) => p.slug === s)?.title).filter(Boolean);
  return `
    <div class="card entry-card"${staggerStyle(i)}>
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

function formatDate(isoDate) {
  const [y, m, d] = String(isoDate).split("-");
  return y && m && d ? `${d}.${m}.${y}` : isoDate;
}

function formatDateTime(iso) {
  const d = new Date(iso);
  if (isNaN(d)) return iso;
  return d.toLocaleString("de-AT", { day: "2-digit", month: "2-digit", year: "numeric", hour: "2-digit", minute: "2-digit" });
}

function renderLog() {
  return `
    ${renderLogForm()}
    ${state.entries.length ? state.entries.map((e, i) => entryCard(e, i)).join("") : `<div class="placeholder">Noch keine Einträge.</div>`}
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

function selfcareCard(s, i = 0) {
  return `
    <div class="card entry-card"${staggerStyle(i)}>
      <div class="entry-head">
        <span class="entry-date">${formatDate(s.date)}</span>
        <button class="delete-btn" onclick="deleteSelfcare(${s.id})">✕</button>
      </div>
      <p class="entry-note"><strong>${escapeHtml(s.action)}</strong>${s.note ? " — " + escapeHtml(s.note) : ""}</p>
    </div>
  `;
}

function renderSelfcare() {
  return `
    ${renderSelfcareForm()}
    ${state.selfcare.length ? state.selfcare.map((s, i) => selfcareCard(s, i)).join("") : `<div class="placeholder">Noch keine Einträge.</div>`}
  `;
}

// ---------- Krise ----------

function isPhone(v) {
  return /^[+\d][\d\s()\/-]{2,}$/.test(v.trim());
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

function setForschungCategory(id) {
  state.forschungCategory = id;
  rerender();
  window.scrollTo(0, 0);
}
window.setForschungCategory = setForschungCategory;

function jumpToResearch(slug) {
  state.tab = "verstehen";
  state.verstehenView = "forschung";
  state.forschungCategory = null;
  rerender().then(() => scrollToAndHighlight("research-" + slug));
}
window.jumpToResearch = jumpToResearch;

function jumpToTheory(slug) {
  state.tab = "verstehen";
  state.verstehenView = "theorie";
  state.theorieSection = null;
  rerender().then(() => scrollToAndHighlight("theory-" + slug));
}
window.jumpToTheory = jumpToTheory;

function setVerstehenView(id) {
  state.verstehenView = id;
  rerender();
  window.scrollTo(0, 0);
}
window.setVerstehenView = setVerstehenView;

function setTheorieSection(id) {
  state.theorieSection = id;
  rerender();
  window.scrollTo(0, 0);
}
window.setTheorieSection = setTheorieSection;

function setWissenChapter(title) {
  state.wissenChapter = title;
  rerender();
  window.scrollTo(0, 0);
}
window.setWissenChapter = setWissenChapter;

function setSkillStage(id) {
  state.skillStage = id;
  rerender();
  window.scrollTo(0, 0);
}
window.setSkillStage = setSkillStage;

function setLogPatternsOpen(open) {
  state.logPatternsOpen = open;
}
window.setLogPatternsOpen = setLogPatternsOpen;

function setMood(field, value) {
  state.logForm[field] = state.logForm[field] === value ? null : value;
  rerender();
}
window.setMood = setMood;

function togglePattern(id) {
  const ids = state.logForm.pattern_ids;
  const idx = ids.indexOf(id);
  if (idx === -1) ids.push(id);
  else ids.splice(idx, 1);
  rerender();
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
  rerender();
}
window.submitEntry = submitEntry;

async function deleteEntry(id) {
  await api(`/api/entries?id=${id}`, { method: "DELETE" });
  state.entries = state.entries.filter((e) => e.id !== id);
  rerender();
}
window.deleteEntry = deleteEntry;

function updateSelfcareField(field, value) {
  state.selfcareForm[field] = value;
  rerender();
}
window.updateSelfcareField = updateSelfcareField;

async function submitSelfcare() {
  const { date, action, note } = state.selfcareForm;
  if (!date || !action) return;
  await api("/api/selfcare", { method: "POST", body: JSON.stringify({ date, action, note }) });
  state.selfcareForm = { date: todayLocal(), action: SELFCARE_PRESETS[0], note: "" };
  state.selfcare = await api("/api/selfcare").then((r) => r.json());
  rerender();
}
window.submitSelfcare = submitSelfcare;

async function deleteSelfcare(id) {
  await api(`/api/selfcare?id=${id}`, { method: "DELETE" });
  state.selfcare = state.selfcare.filter((s) => s.id !== id);
  rerender();
}
window.deleteSelfcare = deleteSelfcare;

function toggleCrisisEdit() {
  state.crisisEdit = !state.crisisEdit;
  rerender();
}
window.toggleCrisisEdit = toggleCrisisEdit;

async function submitCrisisStep() {
  const title = document.getElementById("new-step-title").value.trim();
  const description = document.getElementById("new-step-desc").value.trim();
  if (!title) return;
  await api("/api/crisis", { method: "POST", body: JSON.stringify({ kind: "step", title, description }) });
  state.crisis = await api("/api/crisis").then((r) => r.json());
  rerender();
}
window.submitCrisisStep = submitCrisisStep;

async function submitCrisisContact() {
  const label = document.getElementById("new-contact-label").value.trim();
  const value = document.getElementById("new-contact-value").value.trim();
  if (!label || !value) return;
  await api("/api/crisis", { method: "POST", body: JSON.stringify({ kind: "contact", label, value }) });
  state.crisis = await api("/api/crisis").then((r) => r.json());
  rerender();
}
window.submitCrisisContact = submitCrisisContact;

async function deleteCrisisItem(kind, id) {
  await api(`/api/crisis?kind=${kind}&id=${id}`, { method: "DELETE" });
  state.crisis = await api("/api/crisis").then((r) => r.json());
  rerender();
}
window.deleteCrisisItem = deleteCrisisItem;

// ---------- Shell ----------

function renderTabs() {
  const justSwitched = state.tab !== state._lastRenderedTab;
  return `
    <nav class="tabs">
      ${TABS.map(
        (t) => `
        <button class="tab-${t.id} ${state.tab === t.id ? "active" : ""}" onclick="setTab('${t.id}')" aria-label="${escapeHtml(t.title)}">
          <svg class="${state.tab === t.id && justSwitched ? "just-activated" : ""}" viewBox="0 0 24 24" aria-hidden="true">${ICONS[t.id]}</svg>
          <span>${t.label}</span>
        </button>
      `
      ).join("")}
    </nav>
  `;
}

function render() {
  const content = {
    verstehen: renderVerstehen,
    skills: renderSkills,
    log: renderLog,
    selfcare: renderSelfcare,
    krise: renderKrise,
  }[state.tab]();

  document.getElementById("app").innerHTML = `
    <header class="topbar">
      <span class="brand">eggshells</span>
      <h1>${escapeHtml(TABS.find((t) => t.id === state.tab).title)}</h1>
    </header>
    ${content}
    ${renderTabs()}
  `;
  state._lastRenderedTab = state.tab;
}

function setTab(id) {
  state.tab = id;
  rerender();
  window.scrollTo(0, 0);
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
